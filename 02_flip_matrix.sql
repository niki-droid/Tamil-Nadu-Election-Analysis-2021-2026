-- Query: Party Transition Matrix (Flip Matrix)
-- Purpose: Identify which constituencies changed winning party between 2021 and 2026
--          Labels each constituency as Held (same party) or Flipped (different party)
--          Groups by party pair to show exact seat flow (e.g. DMK → TVK: 65 seats)
-- Used in: (changed_constituencies) of Power BI dashboard


SELECT 
    w21.party AS party_2021,
    w26.party AS party_2026,
    CASE 
        WHEN w21.party = w26.party THEN 'Held'
        ELSE 'Flipped'
    END AS status,
    COUNT(*) AS constituencies
FROM winner_2021 w21
JOIN winner_2026 w26 
    ON w21.ac_number = w26.ac_number
GROUP BY w21.party, w26.party, status
ORDER BY constituencies DESC;