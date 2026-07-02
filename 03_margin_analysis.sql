

-- Query: Margin of Victory Analysis
-- Purpose: Calculate winning margin % for each flipped constituency in 2026
--          Margin = (winner votes - second place votes) / total votes * 100
--          Categorises each seat as Close (<5%), Moderate (5-15%), Decisive (>15%)
--          Filtered to flipped constituencies only (163 seats)
-- Used in: (Margin_Analysis) of Power BI dashboard

SELECT 
    w21.ac_number,
    w21.party AS party_2021,
    w26.party AS party_2026,
    CASE 
        WHEN w21.party = w26.party THEN 'Held'
        ELSE 'Flipped'
    END AS status,
    MAX(c26.votes) AS winner_votes,
    (SELECT MAX(c2.votes) 
     FROM clean_2026 c2 
     WHERE c2.ac_number = w21.ac_number 
     AND c2.votes < MAX(c26.votes)) AS second_votes,
    SUM(c26.votes) AS total_votes,
    ROUND(
        (MAX(c26.votes) - 
            (SELECT MAX(c2.votes) 
             FROM clean_2026 c2 
             WHERE c2.ac_number = w21.ac_number 
             AND c2.votes < MAX(c26.votes))
        ) / SUM(c26.votes) * 100, 2
    ) AS margin_pct,
    CASE 
        WHEN margin_pct < 5 THEN 'Close (<5%)'
        WHEN margin_pct < 15 THEN 'Moderate (5-15%)'
        ELSE 'Decisive (>15%)'
    END AS margin_category
FROM winner_2021 w21
JOIN winner_2026 w26 ON w21.ac_number = w26.ac_number
JOIN clean_2026 c26 ON w21.ac_number = c26.ac_number
WHERE w21.party != w26.party
GROUP BY w21.ac_number, w21.party, w26.party
ORDER BY margin_pct DESC;

