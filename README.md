# Group 8 — PROG8850 Assignment 5

MySQL + Python benchmarking with the Olist e-commerce dataset.

## Quick start (Codespaces)
1. Bring up services  
   `ansible-playbook up.yml`
2. Connect to MySQL  
   `mysql -h 127.0.0.1 -u root -p  # Secret5555`
3. Load data  
   `mysql --local-infile=1 -h 127.0.0.1 -u root -p < sql/01_schema.sql`  
   `mysql --local-infile=1 -h 127.0.0.1 -u root -p < sql/02_load.sql`
4. Run benchmarks  
   `python3 bench/bench.py | tee results/baseline_times.txt`  
   (after creating indexes and FULLTEXT)  
   `python3 bench/bench.py | tee results/after_index_times.txt`
5. EXPLAIN plans are saved in `results/`.

## Files
- `sql/01_schema.sql` — tables
- `sql/02_load.sql` — CSV loaders
- `sql/03_baseline_queries.sql` — sample queries
- `bench/bench.py` — timing script
- `docs/report.md` — findings & who benefits
- `results/` — timings & EXPLAIN outputs

## Notes
- FULLTEXT on reviews accelerates text search (`MATCH ... AGAINST`) vs `LIKE`.
- B-tree indexes on scalar fields (payment value, purchase timestamp, freight) reduce scanned rows.
