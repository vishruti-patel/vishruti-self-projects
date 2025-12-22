
"""
Entry point for running data quality checks on the "orders" dataset.

This script:
1. Loads data quality rules from a YAML config.
2. Loads the CSV dataset into a pandas DataFrame.
3. Applies a collection of reusable checks from `checks.py`.
4. Aggregates results into a JSON report.
5. Prints a human-readable summary to the console.
6. Exits with code 0 (PASS) or 1 (FAIL) for CI/CD integration.
"""


import json
from pathlib import Path
from typing import Any, Dict, List

import pandas as pd
import yaml

from checks import (
    CheckResult,
    check_required_columns,
    check_not_null,
    check_unique,
    check_allowed_values,
    check_range,
    check_datetime_parseable,
    check_freshness,
)

#load the yaml config
def load_config(path: str) -> Dict[str, Any]:
    with open(path, "r") as f:
        return yaml.safe_load(f)


#run all config data quality checks
def run_checks_for_orders(config_path: str = "dq_orders.yml") -> Dict[str, Any]:
    config = load_config(config_path)
    dataset_cfg = config["dataset"]
    columns_cfg = config["columns"]

    data_path = Path(dataset_cfg["path"])
    df = pd.read_csv(data_path)

    results: List[CheckResult] = []

    # 1) Required columns
    required_cols = [col for col, rules in columns_cfg.items() if rules.get("required", False)]
    results.append(check_required_columns(df, required_cols))

    # 2) Column-level checks
    for col_name, rules in columns_cfg.items():
        if col_name not in df.columns:
            # already handled by required_columns; skip further checks
            continue

        if rules.get("required", False):
            results.append(check_not_null(df, col_name))

        if rules.get("unique", False):
            results.append(check_unique(df, col_name))

        # Allowed values
        allowed = rules.get("allowed_values")
        if allowed:
            results.append(check_allowed_values(df, col_name, allowed))

        # Range checks
        checks_cfg = rules.get("checks", {})
        if "min" in checks_cfg or "max" in checks_cfg:
            results.append(
                check_range(
                    df,
                    col_name,
                    min_value=checks_cfg.get("min"),
                    max_value=checks_cfg.get("max"),
                )
            )

        # Datetime parse check
        if rules.get("type") == "datetime":
            fmt = rules.get("format")
            if fmt:
                results.append(check_datetime_parseable(df, col_name, fmt))

    # 3) Freshness (dataset-level)
    freshness_cfg = dataset_cfg.get("freshness")
    if freshness_cfg:
        col = freshness_cfg["column"]
        max_age = freshness_cfg["max_age_days"]
        if col in df.columns:
            results.append(check_freshness(df, col, max_age))

    # Aggregate overall status
    has_error = any((not r.passed) and r.severity == "ERROR" for r in results)

    report = {
        "dataset": dataset_cfg["name"],
        "path": dataset_cfg["path"],
        "overall_status": "FAIL" if has_error else "PASS",
        "results": [r.to_dict() for r in results],
    }

    return report


def main():
    report = run_checks_for_orders()
    outputs_dir = Path("outputs")
    outputs_dir.mkdir(exist_ok=True)

    report_path = outputs_dir / "dq_report_orders.json"
    with open(report_path, "w") as f:
        json.dump(report, f, indent=2)

    print(f"Data quality report written to {report_path}")
    print(f"Overall status: {report['overall_status']}")

    print("\nCheck results:")
    for r in report["results"]:
        status_icon = "✅" if r["passed"] else "❌"
        print(f"  {status_icon} {r['name']} "
              f"(severity={r['severity']}, failed_rows={r['failed_rows_count']})")


    # exit code for CI/CD
    import sys

    if report["overall_status"] == "FAIL":
        sys.exit(1)
    else:
        sys.exit(0)


if __name__ == "__main__":
    main()