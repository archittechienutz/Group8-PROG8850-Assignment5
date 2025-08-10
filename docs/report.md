# PROG8850 Assignment 5 — Indexing & Query Performance (Group 8)

## Environment
- Platform: GitHub Codespaces
- DB: MySQL 9.x (InnoDB)
- Dataset: Olist Brazilian E-Commerce (~100k orders)

## Schema & Loads
- Created DB `olist` and tables (customers, sellers, geolocation, orders, order_items, order_payments, order_reviews, products, translations).
- Loaded CSVs with `LOCAL INFILE`.

## Baseline Timings (no FULLTEXT)
```
Q1_big_payments: 0.0040s
Q2_orders_2017: 0.0107s
Q3_sum_by_type: 0.2950s
Q4_join_freight_gt_50: 0.0168s
Q5_review_like_entrega: 0.0616s
```

## After Indexing Timings (B-Tree + FULLTEXT)
```
Q1_big_payments: 0.0040s
Q2_orders_2017: 0.0098s
Q3_sum_by_type: 0.2667s
Q4_join_freight_gt_50: 0.0170s
Q5a_review_like_entrega: 0.0672s
Q5b_review_match_entrega: 0.0021s
Q6_match_boolean_entrega_atraso: 0.0034s
```

### Observations
- LIKE search vs FULLTEXT:
  - `Q5a LIKE '%entrega%'` scans many rows.
  - `Q5b MATCH AGAINST('entrega')` uses FULLTEXT and is **much faster**.
- Scalar filters improved by B-Tree indexes:
  - `payment_value >= 200` uses `idx_payments_value`.
  - `order_purchase_timestamp` range uses `idx_orders_purchase_ts`.
- Join on `order_items.freight_value > 50` uses `idx_items_freight`.

## EXPLAIN Highlights
- **Q1** after: `type=range`, `key=idx_payments_value`, fewer rows examined.
- **Q2** after: `type=range`, `key=idx_orders_purchase_ts`.
- **Q4** after: `i` uses `idx_items_freight`, `o` uses `PRIMARY (eq_ref)`.
- **Q5b** FULLTEXT: "Select tables optimized away" (engine resolves via FT index).

Raw plans saved under `results/`:
- baseline_explain_Q*.txt, after_explain_Q*.txt (+ JSON variants)

## Stakeholders & Goals
- **Support/Ops:** find delayed/high-freight orders quickly (Q4) → faster incident triage.
- **Finance:** totals by payment type, find high-value payments (Q1, Q3) → faster reporting.
- **CX/QA:** mine reviews for delivery issues (Q5b/Q6) → faster text analytics.

## What to Submit
- Scripts: `sql/*.sql`, `bench/bench.py`
- Results: `results/*`
- Screenshots: `docs/screenshots/*`
- This report: `docs/report.md`
