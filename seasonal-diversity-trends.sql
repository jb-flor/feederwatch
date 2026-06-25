--monthly aggregation, finding monthly averages within observations table
SELECT 
    MONTH(o.obs_date) AS obs_month,
    o.species_code,
    sp.american_english_name,
    ROUND(AVG(o.how_many), 2) AS avg_monthly_count,
    COUNT(DISTINCT o.sub_id) AS checklist_count
FROM observations o 
JOIN species sp ON o.species_code = sp.species_code
GROUP BY MONTH(o.obs_date), o.species_code, sp.american_english_name
ORDER BY o.species_code, obs_month;

-- RANK() for scoring the months each species occurs in
SELECT 
    obs_month,
    species_code,
    american_english_name,
    avg_monthly_count,
    checklist_count,
    RANK() OVER (
        PARTITION BY species_code
        ORDER BY avg_monthly_count DESC
        ) AS month_rank
    FROM (
        SELECT 
            MONTH(o.obs_date) AS obs_month,
            o.species_code,
            sp.american_english_name,
            ROUND(AVG(o.how_many), 2) AS avg_monthly_count,
            COUNT(DISTINCT o.sub_id) AS checklist_count
        FROM observations o
        JOIN species sp ON o.species_code = sp.species_code
        GROUP BY MONTH(o.obs_date), o.species_code, sp.american_english_name
        ) AS monthly_avg
        ORDER BY species_code, obs_month;

-- filter for getting peak month per species
SELECT * FROM (
    SELECT 
        obs_month,
        species_code,
        american_english_name,
        avg_monthly_count,
        checklist_count,
     RANK() OVER ( 
        PARTITION BY species_code
        ORDER BY avg_monthly_count DESC
    ) AS month_rank
    FROM (
        SELECT
            MONTH(o.obs_date) AS obs_month,
            o.species_code,
            sp.american_english_name,
            ROUND(AVG(o.how_many), 2) AS avg_monthly_count,
            COUNT(DISTINCT o.sub_id) AS checklist_count
        FROM observations o 
        JOIN species sp ON o.species_code = sp.species_code
        GROUP BY MONTH(o.obs_date), o.species_code, sp.american_english_name
    ) AS monthly_avg
) AS ranked WHERE
month_rank = 1 AND checklist_count >= 30
ORDER BY american_english_name;

-- top 3 months per species: arrival, peak, and departure
SELECT * FROM (
    SELECT 
        obs_month,
        species_code,
        american_english_name,
        avg_monthly_count,
        checklist_count,
        RANK() OVER ( 
            PARTITION BY species_code
            ORDER BY avg_monthly_count DESC
        ) AS month_rank
    FROM (
        SELECT
            MONTH(o.obs_date) AS obs_month,
            o.species_code, 
            sp.american_english_name,
            ROUND(AVG(o.how_many), 2) AS avg_monthly_count,
            COUNT(DISTINCT o.sub_id)  AS checklist_count
        FROM observations o 
        JOIN species sp ON o.species_code = sp.species_code
        GROUP BY MONTH(o.obs_date), o.species_code, sp.american_english_name
    ) AS monthly_avg
) AS ranked
WHERE month_rank <= 3 AND checklist_count >= 30
ORDER BY american_english_name, month_rank;

-- species richness per site, bird biodiversity patterns
SELECT
    o.loc_id,
    o.subnational1_code,
    COUNT(DISTINCT o.species_code) AS species_richness,
    COUNT(DISTINCT o.sub_id) AS total_checklists
FROM observations o 
GROUP BY o.loc_id, o.subnational1_code
HAVING COUNT(DISTINCT o.sub_id) >= 10 
ORDER BY species_richness DESC;

SELECT
    loc_id,
    subnational1_code,
    species_richness,
    total_checklists,
    RANK() OVER (
        PARTITION BY subnational1_code
        ORDER BY species_richness DESC
    ) AS rank_within_state
FROM (
    SELECT
        o.loc_id,
        o.subnational1_code,
        COUNT(DISTINCT o.species_code) AS species_richness,
        COUNT(DISTINCT o.sub_id) AS total_checklists
    FROM observations o 
    GROUP BY o.loc_id, o.subnational1_code
    HAVING COUNT(DISTINCT o.sub_id) >= 10
    ) AS site_diversity
ORDER BY subnational1_code, rank_within_state;

-- finding the top site per state, does not skip ties in the species_richness count
SELECT * 
FROM (
    SELECT
        loc_id,
        subnational1_code,
        species_richness,
        total_checklists,
        DENSE_RANK() OVER (
            PARTITION BY subnational1_code
            ORDER BY species_richness DESC
        ) AS rank_within_state
    FROM (
        SELECT
        o.loc_id,
        o.subnational1_code,
        COUNT(DISTINCT o.species_code) AS species_richness,
        COUNT(DISTINCT o.sub_id) AS total_checklists
    FROM observations o 
    GROUP BY o.loc_id, o.subnational1_code
    HAVING COUNT(DISTINCT o.sub_id) >= 10
    ) AS site_diversity
) AS ranked
WHERE rank_within_state = 1
ORDER BY subnational1_code; 
