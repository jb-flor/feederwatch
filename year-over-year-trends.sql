-- indexing summary table
CREATE INDEX idx_summary_table ON species_yearly_summary (obs_year);
CREATE INDEX idx_summary_species ON species_yearly_summary (species_code);

-- verification of rows and dates
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT species_code) AS unique_species,
    COUNT(DISTINCT obs_year) AS years_covered,
    MIN(obs_year) AS earliest_year,
    MAX(obs_year) AS latest_year
FROM species_yearly_summary;

-- yearly aggregation
SELECT
    s.obs_year,
    s.species_code,
    sp.american_english_name,
    s.avg_per_checklist,
    s.checklist_count
FROM species_yearly_summary s 
JOIN species sp ON s.species_code = sp.species_code
ORDER BY s.species_code, s.obs_year;

-- LAG() for comparisons
SELECT 
    obs_year,
    species_code,
    american_english_name,
    avg_per_checklist,
    checklist_count,
    LAG(avg_per_checklist) OVER (
        PARTITION BY species_code
        ORDER BY obs_year
    ) AS prev_year_avg
    FROM (
        SELECT
            s.obs_year, s.species_code,
            sp.american_english_name,
            s.avg_per_checklist, s.checklist_count
        FROM species_yearly_summary s JOIN species sp
        ON s.species_code = sp.species_code
    ) AS base
ORDER BY species_code, obs_year;

-- percent change
SELECT 
    obs_year,
    species_code,
    american_english_name,
    avg_per_checklist,
    checklist_count,
    prev_year_avg,
    ROUND(avg_per_checklist - prev_year_avg, 2) 
    AS yoy_change,
    ROUND(((avg_per_checklist - prev_year_avg)/ prev_year_avg) * 100, 1)
    AS pct_change
FROM (
    SELECT
    obs_year,
    species_code,
    american_english_name,
    avg_per_checklist,
    checklist_count,
    LAG(avg_per_checklist) OVER (
        PARTITION BY species_code
        ORDER BY obs_year
    ) AS prev_year_avg
FROM (
    SELECT
        s.obs_year,
        s.species_code,
        sp.american_english_name,
        s.avg_per_checklist,
        s.checklist_count
    FROM species_yearly_summary s  
    JOIN species sp ON s.species_code = sp.species_code
    ) AS base
) AS with_lag
WHERE prev_year_avg IS NOT NULL AND checklist_count >= 30
ORDER BY obs_year, pct_change DESC;

-- migratory trends, months where a species arrives, departs, and peaks
SELECT 
    obs_month,
    species_code,
    american_english_name,
    avg_monthly_count,
    RANK() OVER (
        PARTITION BY species_code
        ORDER BY avg_monthly_count DESC
        ) AS month_rank
    FROM (
        SELECT month(o.obs_date) AS obs_month,
        o.species_code,
        sp.american_english_name,
        ROUND(AVG(o.how_many), 2) AS avg_monthly_count
    FROM observations o
    JOIN species sp ON o.species_code = sp.species_code
    GROUP BY MONTH(o.obs_date), o.species_code, sp.american_english_name
    ) AS monthly_avg
    ORDER BY species_code, obs_month;

-- peak month per species
SELECT * FROM
    (SELECT
    obs_month,
    species_code,
    american_english_name,
    avg_monthly_count,
    RANK() OVER (
        PARTITION BY species_code
        ORDER BY avg_monthly_count DESC
        ) AS MONTH_rank
    FROM (
        SELECT
            MONTH(o.obs_date) AS 
            obs_month,
            o.species_code,
            sp.american_english_name,
            ROUND(AVG(o.how_many), 2) AS avg_monthly_count
        FROM observations o 
        JOIN species sp ON o.species_code = sp.species_code
        GROUP BY MONTH(o.obs_date), o.species_code, sp.american_english_name
            ) AS monthly_avg
    ) AS ranked
    WHERE month_rank = 1
    ORDER BY american_english_name;

    -- unique species observed
    SELECT 
        o.loc_id,
        o.subnational1_code,
        COUNT(DISTINCT o.species_code) AS species_richness,
        COUNT(DISTINCT o.sub_id) AS total_checklists,
        RANK() OVER (
            PARTITION BY o.subnational1_code
            ORDER BY COUNT(DISTINCT o.species_code) DESC
        ) AS rank_within_state
    FROM observations o 
    GROUP BY o.loc_id, o.subnational1_code
    HAVING COUNT(DISTINCT o.sub_id) >= 10
    ORDER BY o.subnational1_code, rank_within_state; 
