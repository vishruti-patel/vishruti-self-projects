from dataclasses import dataclass, asdict
from typing import Any, Dict, List, Optional
import pandas as pd
from datetime import datetime, timedelta

"""
This module defines resuble, column-level and dataset-level data quality checks.  
Each check returns a standardized 'checResult' object so that runnner script can aggregate results and build a JSON report.
"""

@dataclass
class CheckResult:                   #Standard result object returned by every data quality check.
    name: str
    passed: bool
    severity: str  # e.g. "ERROR" or "WARN"
    details: str
    failed_rows_count: Optional[int] = None

    def to_dict(self) -> Dict[str, Any]:                #converts dataclass into dict for JSON response/serialization.
        return asdict(self)


def check_required_columns(df: pd.DataFrame, required_cols: List[str]) -> CheckResult:      #check all required cols exists in dataframe.
    missing = [c for c in required_cols if c not in df.columns]
    #if any req col is missing - fail the check
    if missing:                     
        return CheckResult(
            name="required_columns",
            passed=False,
            severity="ERROR",
            details=f"Missing required columns: {missing}",
            failed_rows_count=None,
        )
    
    #all req cols present - pass
    return CheckResult(
        name="required_columns",
        passed=True,
        severity="INFO",
        details="All required columns present.",
        failed_rows_count=None,
    )


def check_not_null(df: pd.DataFrame, column: str) -> CheckResult:                           #check for no-null values
    null_count = df[column].isna().sum()
    if null_count > 0:
        return CheckResult(
            name=f"not_null:{column}",
            passed=False,
            severity="ERROR",
            details=f"Column '{column}' has {null_count} null values.",
            failed_rows_count=int(null_count),
        )
    return CheckResult(
        name=f"not_null:{column}",
        passed=True,
        severity="INFO",
        details=f"Column '{column}' has no nulls.",
        failed_rows_count=0,
    )


def check_unique(df: pd.DataFrame, column: str) -> CheckResult:                         #check unique(no dups). mainly used for primary keys
    dup_count = df.duplicated(subset=[column]).sum()
    if dup_count > 0:
        return CheckResult(
            name=f"unique:{column}",
            passed=False,
            severity="ERROR",
            details=f"Column '{column}' has {dup_count} duplicate values.",
            failed_rows_count=int(dup_count),
        )
    return CheckResult(
        name=f"unique:{column}",
            passed=True,
            severity="INFO",
            details=f"Column '{column}' is unique.",
            failed_rows_count=0,
        )


def check_allowed_values(df: pd.DataFrame, column: str, allowed: List[Any]) -> CheckResult:
    invalid_mask = ~df[column].isin(allowed)
    invalid_count = invalid_mask.sum()
    if invalid_count > 0:
        invalid_examples = df.loc[invalid_mask, column].dropna().unique()[:5]
        return CheckResult(
            name=f"allowed_values:{column}",
            passed=False,
            severity="ERROR",
            details=f"Column '{column}' has {invalid_count} values outside {allowed}. "
                    f"Examples: {list(invalid_examples)}",
            failed_rows_count=int(invalid_count),
        )
    return CheckResult(
        name=f"allowed_values:{column}",
        passed=True,
        severity="INFO",
        details=f"All values in '{column}' are within allowed set.",
        failed_rows_count=0,
    )


def check_range(
    df: pd.DataFrame,
    column: str,
    min_value: Optional[float] = None,
    max_value: Optional[float] = None,
) -> CheckResult:
    series = df[column]
    mask = pd.Series([False] * len(series))

    if min_value is not None:
        mask |= series < min_value
    if max_value is not None:
        mask |= series > max_value

    invalid_count = mask.sum()
    if invalid_count > 0:
        examples = series[mask].head(5).tolist()
        return CheckResult(
            name=f"range:{column}",
            passed=False,
            severity="ERROR",
            details=f"Column '{column}' has {invalid_count} values outside "
                    f"[{min_value}, {max_value}]. Examples: {examples}",
            failed_rows_count=int(invalid_count),
        )
    return CheckResult(
        name=f"range:{column}",
        passed=True,
        severity="INFO",
        details=f"All values in '{column}' are within range [{min_value}, {max_value}].",
        failed_rows_count=0,
    )


def check_datetime_parseable(df: pd.DataFrame, column: str, fmt: str) -> CheckResult:
    try:
        parsed = pd.to_datetime(df[column], format=fmt, errors="coerce")
    except Exception as e:
        return CheckResult(
            name=f"datetime_parseable:{column}",
            passed=False,
            severity="ERROR",
            details=f"Failed to parse column '{column}' with format '{fmt}': {e}",
            failed_rows_count=len(df),
        )

    invalid_mask = parsed.isna()
    invalid_count = invalid_mask.sum()
    if invalid_count > 0:
        examples = df.loc[invalid_mask, column].head(5).tolist()
        return CheckResult(
            name=f"datetime_parseable:{column}",
            passed=False,
            severity="ERROR",
            details=f"Column '{column}' has {invalid_count} invalid datetime values "
                    f"for format '{fmt}'. Examples: {examples}",
            failed_rows_count=int(invalid_count),
        )
    return CheckResult(
        name=f"datetime_parseable:{column}",
        passed=True,
        severity="INFO",
        details=f"All values in '{column}' are parseable as datetime with '{fmt}'.",
        failed_rows_count=0,
    )


def check_freshness(df: pd.DataFrame, column: str, max_age_days: int) -> CheckResult:
    # Assumes column is already parseable; we can be defensive and convert.
    parsed = pd.to_datetime(df[column], errors="coerce")
    max_ts = parsed.max()
    if pd.isna(max_ts):
        return CheckResult(
            name=f"freshness:{column}",
            passed=False,
            severity="ERROR",
            details=f"Could not determine max timestamp in '{column}'.",
            failed_rows_count=len(df),
        )

    now = datetime.now()
    age = now - max_ts
    if age > timedelta(days=max_age_days):
        return CheckResult(
            name=f"freshness:{column}",
            passed=False,
            severity="WARN",
            details=f"Max '{column}' timestamp is {age.days} days old "
                    f"(limit: {max_age_days} days).",
            failed_rows_count=None,
        )
    return CheckResult(
        name=f"freshness:{column}",
        passed=True,
        severity="INFO",
        details=f"Max '{column}' timestamp is within {max_age_days} days.",
        failed_rows_count=None,
    )
