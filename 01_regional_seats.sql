
-- Query: Regional Seats Distribution
-- Purpose: Count seats won by each party per region for 2021 and 2026
-- Used in: (party_performance) of Power BI dashboard

Query 1 — Regional Seats (Tab 1)

SELECT region, party, '2021' AS year, COUNT(*) AS seats
FROM winner_2021
GROUP BY region, party

UNION ALL

SELECT region, party, '2026' AS year, COUNT(*) AS seats
FROM winner_2026
GROUP BY region, party
ORDER BY region, year, seats DESC;