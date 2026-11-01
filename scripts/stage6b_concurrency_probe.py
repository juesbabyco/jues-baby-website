#!/usr/bin/env python3
"""Jue's Baby Co. Stage 6B: genuine overlapping PostgreSQL-session probe.

PRIVATE FICTIONAL FIXTURES ONLY. No checkout, production stock, PII or payments.
Requires psycopg 3 and a JUE-ONLY database URL from an environment variable.
Never pass credentials in command-line arguments, GitHub, screenshots or chat.

Exit 0: both concurrency scenarios independently verified.
Exit 1: a database invariant failed.
Exit 2: incomplete evidence (no actual overlap, different sessions absent).
Exit 3: preflight / credentials / dependency problem.
"""
from __future__ import annotations

import argparse
import json
import os
import secrets
import sys
import threading
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone

PROJECT_REF = "izeezajdiawiaweffbrh"
ENV_VAR = "JUES_STAGE6B_DATABASE_URL"
FUNCTION = "jues_stage6b.reserve_fixture"
SCHEMA = "jues_stage6b"


def verdict_for(scenario: str, results: list[dict], stock: dict, orders: list[dict]) -> tuple[str, list[str]]:
    """Pure offline-verifiable assertion logic; no network access."""
    problems: list[str] = []
    if len(results) != 2 or any("error_type" in x for x in results):
        return "INCONCLUSIVE", ["Neither two successful database responses nor full timing evidence is present"]

    if any(not isinstance(x.get("backend_pid"), int) for x in results):
        return "INCONCLUSIVE", ["Missing PostgreSQL backend PID(s)"]
    if results[0]["backend_pid"] == results[1]["backend_pid"]:
        return "INCONCLUSIVE", ["Both calls used the same PostgreSQL backend PID"]

    try:
        start = [datetime.fromisoformat(r["started_at"]) for r in results]
        end = [datetime.fromisoformat(r["completed_at"]) for r in results]
        overlap = max(start) < min(end)
    except (KeyError, TypeError, ValueError):
        return "INCONCLUSIVE", ["Missing or invalid database timestamps"]

    if not overlap:
        return "INCONCLUSIVE", ["Database function execution windows did not overlap"]

    if not stock or stock.get("on_hand") != 1 or stock.get("reserved") != 1 or len(orders) != 1:
        problems.append("Final stock/order invariant: expected on_hand=1, reserved=1, exactly one order")

    codes = sorted(r.get("result_code", "") for r in results)
    ids = [r.get("fixture_order_id") for r in results]
    if scenario == "different_keys":
        if codes != ["OUT_OF_STOCK", "RESERVED"]:
            problems.append("Expected exactly one RESERVED and one OUT_OF_STOCK")
        if sum(x is not None for x in ids) != 1:
            problems.append("Expected exactly one newly created order ID")
        if sum(bool(x.get("accepted")) for x in results) != 1:
            problems.append("Expected exactly one accepted reservation")
    elif scenario == "same_key":
        if codes != ["REPLAYED", "RESERVED"]:
            problems.append("Expected one RESERVED and one REPLAYED")
        if ids[0] is None or ids[0] != ids[1]:
            problems.append("Matching request keys must return the same order ID")
        if any(not x.get("accepted") for x in results):
            problems.append("Same-key replay should be accepted")
    else:
        problems.append("Unknown probe scenario")

    if problems:
        return "FAIL", problems
    return "PASS", ["Two independent backend sessions overlapped; persisted stock and order invariants hold"]


def run_probe(conninfo: str, scenario: str, token: str, psycopg) -> dict:
    """Prepare a new one-unit fictional SKU, then race two independent DB connections."""
    prefix = "D" if scenario == "different_keys" else "I"
    sku = f"S6B-PROBE_{prefix}_{token}"
    key_base = f"S6B-PROBE_{prefix}_{token}_REQUEST"
    keys = [key_base + "_A", key_base + ("_B" if scenario == "different_keys" else "_A")]

    # Only private fake test stock is ever inserted; never reset existing fixtures.
    with psycopg.connect(conninfo, autocommit=True, connect_timeout=12) as control:
        control.execute(
            """INSERT INTO jues_stage6b.fixture_variants
               (sku,size_label,on_hand,reserved,price_cents)
               VALUES (%s,'FICTIONAL independent-session race item',1,0,100)
               ON CONFLICT(sku) DO NOTHING""",
            (sku,),
        )
        count = control.execute(
            "SELECT on_hand,reserved FROM jues_stage6b.fixture_variants WHERE sku=%s",
            (sku,),
        ).fetchone()
        if tuple(count) != (1, 0):
            raise ValueError("Probe SKU already exists with different stock; refusing to reset it")

    barrier = threading.Barrier(3)

    def worker(key: str) -> dict:
        try:
            # Different client connections must receive different backend PIDs while overlapping.
            with psycopg.connect(conninfo, autocommit=True, connect_timeout=12) as conn:
                conn.execute("SET statement_timeout='20000ms'")
                barrier.wait(timeout=15)
                row = conn.execute(
                    """SELECT accepted,result_code,fixture_order_id,backend_pid,
                              started_at,completed_at,resulting_on_hand,resulting_reserved
                       FROM jues_stage6b.reserve_fixture(%s,%s,1,1800)""",
                    (key, sku),
                ).fetchone()
                return {
                    "accepted": row[0],
                    "result_code": row[1],
                    "fixture_order_id": row[2],
                    "backend_pid": row[3],
                    "started_at": row[4].isoformat(),
                    "completed_at": row[5].isoformat(),
                    "resulting_on_hand": row[6],
                    "resulting_reserved": row[7],
                }
        except threading.BrokenBarrierError:
            return {"error_type": "BarrierTimeout"}
        except Exception as exc:
            # Never expose a connection URI, host, username or other secrets.
            return {"error_type": type(exc).__name__}

    with ThreadPoolExecutor(max_workers=2) as pool:
        futures = [pool.submit(worker, key) for key in keys]
        try:
            barrier.wait(timeout=15)  # Both clients have connected; release concurrently.
        except threading.BrokenBarrierError:
            pass
        results = [f.result() for f in futures]

    with psycopg.connect(conninfo, autocommit=True, connect_timeout=12) as control:
        row = control.execute(
            "SELECT on_hand,reserved FROM jues_stage6b.fixture_variants WHERE sku=%s",
            (sku,),
        ).fetchone()
        stock = {"on_hand": row[0], "reserved": row[1]} if row else {}
        order_rows = control.execute(
            "SELECT id,request_key,sku,qty FROM jues_stage6b.fixture_orders WHERE sku=%s ORDER BY id",
            (sku,),
        ).fetchall()
        orders = [
            {"id": r[0], "request_key": r[1], "sku": r[2], "qty": r[3]}
            for r in order_rows
        ]

    verdict, notes = verdict_for(scenario, results, stock, orders)
    return {
        "scenario": scenario,
        "fixture_sku": sku,
        "verdict": verdict,
        "notes": notes,
        "responses": results,
        "stock": stock,
        "orders": orders,
    }


def preflight(conninfo: str, psycopg) -> None:
    with psycopg.connect(conninfo, autocommit=True, connect_timeout=12) as conn:
        # Marker AND restricted lab objects; fail shut if connecting to another project.
        matched = conn.execute(
            "SELECT count(*) FROM jues_internal.project_registry WHERE project_key='JUES_BABY_CO'"
        ).fetchone()[0]
        if matched != 1:
            raise ValueError("Jue's Baby Co. project marker not found")
        if conn.execute(
            "SELECT to_regclass('jues_stage6b.fixture_variants') IS NOT NULL"
        ).fetchone()[0] is not True:
            raise ValueError("Jue private Stage 6B fixture schema not found")
        banned = conn.execute(
            """SELECT
                 has_schema_privilege('anon','jues_stage6b','USAGE'),
                 has_schema_privilege('authenticated','jues_stage6b','USAGE'),
                 has_function_privilege('anon',
                   'jues_stage6b.reserve_fixture(text,text,integer,integer)','EXECUTE'),
                 has_function_privilege('authenticated',
                   'jues_stage6b.reserve_fixture(text,text,integer,integer)','EXECUTE')"""
        ).fetchone()
        if any(banned):
            raise ValueError("Private test access was expanded unexpectedly: STOP")


def self_test() -> bool:
    """Validate the pure verdict logic without DB credentials or network."""
    good = [
        {"accepted": True, "result_code": "RESERVED", "fixture_order_id": 12,
         "backend_pid": 101, "started_at": "2026-11-01T15:00:00+00:00",
         "completed_at": "2026-11-01T15:00:02+00:00"},
        {"accepted": False, "result_code": "OUT_OF_STOCK", "fixture_order_id": None,
         "backend_pid": 102, "started_at": "2026-11-01T15:00:01+00:00",
         "completed_at": "2026-11-01T15:00:03+00:00"},
    ]
    stock = {"on_hand": 1, "reserved": 1}
    orders = [{"id": 12}]
    same = [dict(good[0]), dict(good[1])]
    same[1].update({"accepted": True, "result_code": "REPLAYED", "fixture_order_id": 12})
    separated = [dict(good[0]), dict(good[1])]
    separated[1].update({"started_at": "2026-11-01T15:00:04+00:00",
                         "completed_at": "2026-11-01T15:00:05+00:00"})
    failed = {"on_hand": 1, "reserved": 2}
    cases = [
        ("distinct last-unit race", verdict_for("different_keys", good, stock, orders)[0], "PASS"),
        ("same-key contention", verdict_for("same_key", same, stock, orders)[0], "PASS"),
        ("sequential timing must not pass", verdict_for("different_keys", separated, stock, orders)[0], "INCONCLUSIVE"),
        ("oversold stock must fail", verdict_for("different_keys", good, failed, orders)[0], "FAIL"),
    ]
    for label, actual, expected in cases:
        print(("PASS" if actual == expected else "FAIL") + ": " + label)
    return all(actual == expected for _, actual, expected in cases)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--execute", action="store_true", help="Run two genuine private database race scenarios")
    parser.add_argument("--self-test", action="store_true", help="Run four offline verdict checks; no connection or credentials")
    args = parser.parse_args()
    if args.self_test:
        return 0 if self_test() else 1
    if not args.execute:
        print("DRY RUN. To execute, use --execute after setting the JUE-ONLY database URL in the environment.")
        print("No database access, real orders, stock or payment actions occurred.")
        return 0

    conninfo = os.environ.get(ENV_VAR, "").strip()
    if not conninfo:
        print(f"BLOCKED: {ENV_VAR} not set. Do not post credentials in ChatGPT or GitHub.")
        return 3
    try:
        import psycopg  # optional and only required for live run
    except ImportError:
        print("BLOCKED: psycopg 3 not installed. Install locally: py -m pip install 'psycopg[binary]>=3,<4'")
        return 3

    try:
        preflight(conninfo, psycopg)
        token = secrets.token_hex(5).upper()
        reports = [
            run_probe(conninfo, "different_keys", token, psycopg),
            run_probe(conninfo, "same_key", token, psycopg),
        ]
    except Exception as exc:
        print(f"BLOCKED: {type(exc).__name__}. Private test stopped; check Jue database access locally.")
        return 3

    # Exclude database connection strings, authentication material, addresses and user metadata.
    report = {
        "project_ref": PROJECT_REF,
        "generated_utc": datetime.now(timezone.utc).isoformat(),
        "type": "FICTIONAL_PRIVATE_DB_SESSION_RACE",
        "reports": reports,
        "overall": "PASS" if all(x["verdict"] == "PASS" for x in reports)
                   else "FAIL" if any(x["verdict"] == "FAIL" for x in reports)
                   else "INCONCLUSIVE",
    }
    print(json.dumps(report, indent=2, default=str))
    return {"PASS": 0, "FAIL": 1, "INCONCLUSIVE": 2}[report["overall"]]


if __name__ == "__main__":
    sys.exit(main())
