# Milestone 1 Grade

| Criterion | Score | Max |
|-----------|------:|----:|
| Data Quality Audit | 3 | 3 |
| Query Depth & Correctness | 3 | 3 |
| Business Reasoning & README | 3 | 3 |
| Git Practices | 3 | 3 |
| Code Walkthrough | 3 | 3 |
| **Total** | **15** | **15** |

## Data Quality Audit (3/3)

`data_quality.sql` is comprehensive and systematic. It covers all major audit dimensions:
- **Row counts** (Q1): All 9 tables unioned into a single summary table.
- **NULL rates** (Q2): Four key ID columns (order_id, customer_id, product_id, seller_id) checked across 7 tables using `CASE WHEN` and `ROUND`, with 0-fill where columns don't apply.
- **Orphaned FKs** (Q3): All four key ID columns checked via `LEFT JOIN` across the relevant table pairs.
- **Date range & gaps** (Q4/Q5): Basic range with `MIN`/`MAX`, then a sophisticated gap-detection query using `GENERATE_SERIES`, `ROW_NUMBER()`, and gap-grouping arithmetic. Correctly identifies a 61-day gap.
- **Duplicates** (Q6): Three key ID columns checked with `HAVING COUNT(*) > 1`, results unified via `UNION ALL` with `COALESCE` for NULL-safety.

One minor syntax error: the plain `SELECT` in Q4 is missing a trailing semicolon, which causes Q5's `WITH dateBounds AS (...)` to be parsed as a continuation and fail. All other queries (Q1, Q2, Q3, Q6) execute cleanly. The audit logic itself is correct and well-structured throughout.

## Query Depth & Correctness (3/3)

All four analytical SQL files execute successfully against the student's `olist.duckdb`. Each uses multiple CTEs, joins across several tables, and at least one window function.

- **`cohort_retention_analysis.sql`** — 4 CTEs (`resolved_customers`, `first_orders`, `subsequent_orders`, `cohort_activity`). Uses `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)`, LEFT JOIN, `DATE_TRUNC`, `DATEDIFF`, and `CASE WHEN` retention flags. Well-constructed cohort logic.
- **`abc_inventory_classification.sql`** — 3 CTEs (`product_revenue`, `revenue_with_totals`, `classified`). Uses `SUM() OVER ()` for grand totals and running totals, LEFT JOINs to attach category names. Clean A/B/C tiering logic.
- **`seller_performance_scorecard.sql`** — 6 CTEs (`seller_revenue`, `seller_delivery`, `seller_reviews`, `seller_cancellations`, `combined_metrics`, `normalized`). Uses `DENSE_RANK() OVER ()`, min-max normalization via `MIN/MAX OVER ()`, COALESCE, and a weighted composite score formula. Most technically complex file in the submission.
- **`delivery_time_analysis_by_geo.sql`** — 3 CTEs (`delivery_times`, `corridor_metrics`, `corridor_rates`). Uses `RANK() OVER ()` twice (best/worst corridors), `DATEDIFF`, and CASE WHEN aggregation across 4 joined tables.

Every file has 3+ CTEs (seller scorecard has 6), uses window functions, multi-table joins, and aggregation. All produce correct, meaningful output.

## Business Reasoning & README (3/3)

The README is exceptionally detailed and well-organized. Each of the five SQL files is explained with:
- A clear business question being answered.
- A step-by-step description of the approach and each CTE.
- Explanation of technique choices (e.g., why LEFT JOIN for orphaned keys, why location concatenation for deduplication, why the gap-grouping arithmetic works).
- Honest acknowledgment of limitations and AI assistance (gap detection query).
- Findings discussed inline (e.g., noting the 61-day gap, explaining what the cohort rates mean, describing the ABC tier logic).

The business applications chosen (cohort retention, seller scorecard, ABC classification, geographic delivery analysis) are specific, actionable, and cover distinct aspects of e-commerce operations. The README reads as a coherent analytical narrative rather than a file list.

## Git Practices (3/3)

71 commits across the project lifecycle. The commit history shows genuine incremental development: starting with an initial data quality commit, building each query incrementally, fixing bugs, refining comments, updating the README alongside code changes, and handling merges from collaborative push/pull cycles. Commit messages are descriptive and often explain what was attempted and why (e.g., "Changed to unique customer id for duplicates", "Figured out how to look at the missing days..."). A few messages are vague ("small comment", "WAR IS OVER") but these are minor exceptions in an otherwise exemplary commit history.
