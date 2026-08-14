# SQL Scripts Library

A collection of production-quality SQL Server scripts covering CTEs, stored procedures, query optimization, indexing, and window functions — written from real enterprise pharma experience.

Each script includes comments explaining **what** it does and **why** it matters.

---

## Contents

### 01_CTEs
| File | Description |
|---|---|
| `recursive_cte.sql` | Employee hierarchy tree using recursive CTE |
| `cte_vs_subquery.sql` | Side-by-side comparison — CTE vs subquery |
| `multi_cte_example.sql` | Chaining multiple CTEs for vendor compliance reporting |

### 02_StoredProcedures
| File | Description |
|---|---|
| `sp_vendor_search.sql` | Optional parameter filtering with safe LIKE search |
| `sp_paginated_results.sql` | Server-side pagination using OFFSET...FETCH |
| `sp_audit_log.sql` | Audit log insert with TRY...CATCH error handling |

### 03_QueryOptimization
| File | Description |
|---|---|
| `before_after_index.sql` | Full scan vs index seek — before and after |
| `avoid_select_star.sql` | Why SELECT * hurts performance and how to fix it |
| `sargable_vs_nonsargable.sql` | Function on column = no index. Rewrites that fix it |

### 04_Indexing
| File | Description |
|---|---|
| `clustered_vs_nonclustered.sql` | Difference, when to use each, usage stats query |
| `composite_index_example.sql` | Column order strategy for multi-column indexes |
| `index_usage_check.sql` | Find unused, missing, and fragmented indexes |

### 05_WindowFunctions
| File | Description |
|---|---|
| `row_number_example.sql` | Latest record per group — replaces correlated subquery |
| `rank_vs_dense_rank.sql` | ROW_NUMBER vs RANK vs DENSE_RANK with real examples |
| `running_total.sql` | Running total and 3-month moving average |

---

## Domain Context

Scripts are modelled around a **pharma manufacturing ERP** — vendors, audits, compliance tracking — reflecting real-world enterprise use cases.

---

## Author

**Khyati Jain** — .NET Developer | C# | ASP.NET MVC | SQL Server  
[LinkedIn](https://www.linkedin.com/in/khyati~jain/) · [GitHub](https://github.com/khyatijain28)
