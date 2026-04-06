# Milestone 1 Grade

| Criterion | Score | Max |
|-----------|------:|----:|
| Data Quality Audit | 3 | 3 |
| Query Depth & Correctness | 2 | 3 |
| Business Reasoning & README | 3 | 3 |
| Git Practices | 2 | 3 |
| Code Walkthrough | 3 | 3 |
| **Total** | **13** | **15** |

## Data Quality Audit (3/3)
`data_quality.sql` is thorough and systematic. It covers all five expected areas: row counts per table (using a CTE with UNION ALL across all 9 tables), NULL rates for key columns (order_id, customer_id, product_id, seller_id), orphaned foreign keys (LEFT JOIN pattern across orders/customers/order_items/products/sellers), date range coverage and gaps (using `generate_series` to detect missing days), and duplicate detection across 5 tables including order_reviews. The file uses 7 CTEs and executes correctly. Comments demonstrate understanding of why each check matters.

## Query Depth & Correctness (2/3)
Four analysis files exist (excluding data_quality), satisfying the minimum count requirement. All four queries are logically correct and produce meaningful output — however, they fail to execute as submitted because `#` is used for comments throughout, and DuckDB requires `--` style comments. The queries work correctly once comment lines are stripped, confirming the SQL logic itself is sound. CTE usage is strong: `seller_score.sql` has 6 CTEs, `cohort_retention.sql` has 4, `ABC_inv_classification.sql` has 3, and `Delivery_analysis_geo.sql` has 2. Window functions appear in `ABC_inv_classification.sql` (cumulative SUM OVER) and `seller_score.sql` (RANK OVER with multiple orderings and a composite score). Joins, aggregation, CASE expressions, and DATE_DIFF are used throughout. Score is 2 rather than 3 solely because the files do not execute as-submitted due to the comment syntax error — a fixable but real issue.

## Business Reasoning & README (3/3)
The README is well-structured and substantive. Each analysis question is clearly stated and tied to a concrete business motivation. The student explains their approach, discusses alternatives considered, reports specific numeric findings, and identifies limitations for every sub-question. Notable examples: the seller scorecard section explains why rank-averaging was chosen over weighted scoring (weights require stakeholder input) and why raw metric averaging fails (incompatible scales); the ABC classification section explains choosing revenue over units sold; the delivery section explains the north/south divide finding and notes the inability to separate seller vs. carrier delay. The student also acknowledges their own missteps (e.g., not investigating geolocation tables earlier). This is a coherent, reflective narrative that goes well beyond a file listing.

## Git Practices (2/3)
60 commits across the project showing consistent, incremental work throughout development. Many commits have meaningful messages describing what was done (e.g., "Orphaned foreign keys and used the product_id, order_id, seller_id, and customer_id columns," "Coded for date range by finding start date and end date for orders," "Create & Identify Purchase"). The logical progression from initial commit through individual feature development is visible. However, the README was updated in 11 consecutive commits with identical messages ("Update README.md") with no indication of what changed, and some messages are vague ("Debugging," "COmmit," "Fixed code"). A few unnecessary merge commits from redundant pushes also appear. Overall demonstrates good habits with room for more descriptive messages on README iterations.
