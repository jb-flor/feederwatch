-- @conn MySQL Local
CREATE DATABASE IF NOT EXISTS birdmigration;
USE birdmigration;

-- table creation for species, sites, and observations
CREATE TABLE IF NOT EXISTS species (
    species_code VARCHAR(10) PRIMARY KEY, 
    alt_full_spp VARCHAR(10),
    n_locations INT,
    scientific_name VARCHAR(100),
    american_english_name VARCHAR(100),
    taxonomy_version INT,
    taxonomic_sort_order INT
    );

CREATE TABLE IF NOT EXISTS sites (
    loc_id                        VARCHAR(20),
    latitude                      DECIMAL(9,6),
    longitude                     DECIMAL(9,6),
    proj_period_id                VARCHAR(20),
    yard_type_pavement            TINYINT,
    yard_type_garden              TINYINT,
    yard_type_landsca             TINYINT,
    yard_type_woods               TINYINT,
    yard_type_desert              TINYINT,
    hab_dcid_woods                TINYINT,
    hab_evgr_woods                TINYINT,
    hab_mixed_woods               TINYINT,
    hab_orchard                   TINYINT,
    hab_park                      TINYINT,
    hab_water_fresh               TINYINT,
    hab_water_salt                TINYINT,
    hab_residential               TINYINT,
    hab_industrial                TINYINT,
    hab_agricultural              TINYINT,
    hab_desert_scrub              TINYINT,
    hab_young_woods               TINYINT,
    hab_swamp                     TINYINT,
    hab_marsh                     TINYINT,
    evgr_trees_atleast            INT,
    evgr_shrbs_atleast            INT,
    dcid_trees_atleast            INT,
    dcid_shrbs_atleast            INT,
    fru_trees_atleast             INT,
    cacti_atleast                 INT,
    brsh_piles_atleast            INT,
    water_srcs_atleast            INT,
    bird_baths_atleast            INT,
    nearby_feeders                TINYINT,
    squirrels                     TINYINT,
    cats                          TINYINT,
    dogs                          TINYINT,
    humans                        TINYINT,
    housing_density               INT,
    fed_yr_round                  TINYINT,
    fed_in_jan                    TINYINT,
    fed_in_feb                    TINYINT,
    fed_in_mar                    TINYINT,
    fed_in_apr                    TINYINT,
    fed_in_may                    TINYINT,
    fed_in_jun                    TINYINT,
    fed_in_jul                    TINYINT,
    fed_in_aug                    TINYINT,
    fed_in_sep                    TINYINT,
    fed_in_oct                    TINYINT,
    fed_in_nov                    TINYINT,
    fed_in_dec                    TINYINT,
    numfeeders_suet               INT,
    numfeeders_ground             INT,
    numfeeders_hanging            INT,
    numfeeders_platfrm            INT,
    numfeeders_humming            INT,
    numfeeders_water              INT,
    numfeeders_thistle            INT,
    numfeeders_fruit              INT,
    numfeeders_hopper             INT,
    numfeeders_tube               INT,
    numfeeders_other              INT,
    population_atleast            INT,
    count_area_size_sq_m_atleast  DECIMAL(15,2),
    create_dt                     VARCHAR(20),
    supp_food                     TINYINT,
    PRIMARY KEY (loc_id, proj_period_id)
);

CREATE TABLE IF NOT EXISTS observations (
    obs_id              VARCHAR(20) PRIMARY KEY,
    loc_id              VARCHAR(20),
    latitude            DECIMAL(9,6),
    longitude           DECIMAL(9,6),
    subnational1_code   VARCHAR(20),
    entry_technique     VARCHAR(50),
    sub_id              VARCHAR(20),
    obs_date            DATE,
    proj_period_id      VARCHAR(20),
    species_code        VARCHAR(10),
    alt_full_spp_code   VARCHAR(10),
    how_many            INT,
    plus_code           TINYINT,
    valid               TINYINT,
    reviewed            TINYINT,
    day1_am             TINYINT,
    day1_pm             TINYINT,
    day2_am             TINYINT,
    day2_pm             TINYINT,
    effort_hrs_atleast  DECIMAL(6,2),
    snow_dep_atleast    INT,
    data_entry_method   VARCHAR(50),
    FOREIGN KEY (species_code) REFERENCES species(species_code)
);

-- data import
LOAD DATA INFILE 'C:/Users/jacob/OneDrive/Desktop/Datasets/FeederWatch Cornell Datasets/PFW_spp_translation_table_May2024.csv'
INTO TABLE species
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(species_code, alt_full_spp, n_locations, scientific_name, 
american_english_name, taxonomy_version, taxonomic_sort_order);

LOAD DATA INFILE 'C:/Users/jacob/OneDrive/Desktop/Datasets/FeederWatch Cornell Datasets/PFW_count_site_data_public_May2024.csv'
INTO TABLE sites
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loc_id, @lat, @lng, proj_period_id,
 @yp, @yg, @yl, @yw, @yd,
 @hw, @he, @hm, @ho, @hp, @hwf, @hws, @hr, @hi, @ha, @hds, @hyw, @hsw, @hma,
 @et, @es, @dt, @ds, @ft, @ca, @bp, @ws, @bb,
 @nf, @sq, @ca2, @do, @hu,
 @hd,
 @fyr, @fj, @ff, @fm, @fa, @fmy, @fjn, @fjl, @fau, @fse, @foc, @fnv, @fdc,
 @nfs, @nfg, @nfh, @nfp, @nfhu, @nfw, @nft, @nffr, @nfho, @nftu, @nfo,
 @pop, @csm, @cdt, @sf)
SET
    latitude                     = NULLIF(NULLIF(TRIM(@lat),  ''), 'NA'),
    longitude                    = NULLIF(NULLIF(TRIM(@lng),  ''), 'NA'),
    yard_type_pavement           = NULLIF(NULLIF(TRIM(@yp),   ''), 'NA'),
    yard_type_garden             = NULLIF(NULLIF(TRIM(@yg),   ''), 'NA'),
    yard_type_landsca            = NULLIF(NULLIF(TRIM(@yl),   ''), 'NA'),
    yard_type_woods              = NULLIF(NULLIF(TRIM(@yw),   ''), 'NA'),
    yard_type_desert             = NULLIF(NULLIF(TRIM(@yd),   ''), 'NA'),
    hab_dcid_woods               = NULLIF(NULLIF(TRIM(@hw),   ''), 'NA'),
    hab_evgr_woods               = NULLIF(NULLIF(TRIM(@he),   ''), 'NA'),
    hab_mixed_woods              = NULLIF(NULLIF(TRIM(@hm),   ''), 'NA'),
    hab_orchard                  = NULLIF(NULLIF(TRIM(@ho),   ''), 'NA'),
    hab_park                     = NULLIF(NULLIF(TRIM(@hp),   ''), 'NA'),
    hab_water_fresh              = NULLIF(NULLIF(TRIM(@hwf),  ''), 'NA'),
    hab_water_salt               = NULLIF(NULLIF(TRIM(@hws),  ''), 'NA'),
    hab_residential              = NULLIF(NULLIF(TRIM(@hr),   ''), 'NA'),
    hab_industrial               = NULLIF(NULLIF(TRIM(@hi),   ''), 'NA'),
    hab_agricultural             = NULLIF(NULLIF(TRIM(@ha),   ''), 'NA'),
    hab_desert_scrub             = NULLIF(NULLIF(TRIM(@hds),  ''), 'NA'),
    hab_young_woods              = NULLIF(NULLIF(TRIM(@hyw),  ''), 'NA'),
    hab_swamp                    = NULLIF(NULLIF(TRIM(@hsw),  ''), 'NA'),
    hab_marsh                    = NULLIF(NULLIF(TRIM(@hma),  ''), 'NA'),
    evgr_trees_atleast           = NULLIF(NULLIF(TRIM(@et),   ''), 'NA'),
    evgr_shrbs_atleast           = NULLIF(NULLIF(TRIM(@es),   ''), 'NA'),
    dcid_trees_atleast           = NULLIF(NULLIF(TRIM(@dt),   ''), 'NA'),
    dcid_shrbs_atleast           = NULLIF(NULLIF(TRIM(@ds),   ''), 'NA'),
    fru_trees_atleast            = NULLIF(NULLIF(TRIM(@ft),   ''), 'NA'),
    cacti_atleast                = NULLIF(NULLIF(TRIM(@ca),   ''), 'NA'),
    brsh_piles_atleast           = NULLIF(NULLIF(TRIM(@bp),   ''), 'NA'),
    water_srcs_atleast           = NULLIF(NULLIF(TRIM(@ws),   ''), 'NA'),
    bird_baths_atleast           = NULLIF(NULLIF(TRIM(@bb),   ''), 'NA'),
    nearby_feeders               = NULLIF(NULLIF(TRIM(@nf),   ''), 'NA'),
    squirrels                    = NULLIF(NULLIF(TRIM(@sq),   ''), 'NA'),
    cats                         = NULLIF(NULLIF(TRIM(@ca2),  ''), 'NA'),
    dogs                         = NULLIF(NULLIF(TRIM(@do),   ''), 'NA'),
    humans                       = NULLIF(NULLIF(TRIM(@hu),   ''), 'NA'),
    housing_density              = NULLIF(NULLIF(TRIM(@hd),   ''), 'NA'),
    fed_yr_round                 = NULLIF(NULLIF(TRIM(@fyr),  ''), 'NA'),
    fed_in_jan                   = NULLIF(NULLIF(TRIM(@fj),   ''), 'NA'),
    fed_in_feb                   = NULLIF(NULLIF(TRIM(@ff),   ''), 'NA'),
    fed_in_mar                   = NULLIF(NULLIF(TRIM(@fm),   ''), 'NA'),
    fed_in_apr                   = NULLIF(NULLIF(TRIM(@fa),   ''), 'NA'),
    fed_in_may                   = NULLIF(NULLIF(TRIM(@fmy),  ''), 'NA'),
    fed_in_jun                   = NULLIF(NULLIF(TRIM(@fjn),  ''), 'NA'),
    fed_in_jul                   = NULLIF(NULLIF(TRIM(@fjl),  ''), 'NA'),
    fed_in_aug                   = NULLIF(NULLIF(TRIM(@fau),  ''), 'NA'),
    fed_in_sep                   = NULLIF(NULLIF(TRIM(@fse),  ''), 'NA'),
    fed_in_oct                   = NULLIF(NULLIF(TRIM(@foc),  ''), 'NA'),
    fed_in_nov                   = NULLIF(NULLIF(TRIM(@fnv),  ''), 'NA'),
    fed_in_dec                   = NULLIF(NULLIF(TRIM(@fdc),  ''), 'NA'),
    numfeeders_suet              = NULLIF(NULLIF(TRIM(@nfs),  ''), 'NA'),
    numfeeders_ground            = NULLIF(NULLIF(TRIM(@nfg),  ''), 'NA'),
    numfeeders_hanging           = NULLIF(NULLIF(TRIM(@nfh),  ''), 'NA'),
    numfeeders_platfrm           = NULLIF(NULLIF(TRIM(@nfp),  ''), 'NA'),
    numfeeders_humming           = NULLIF(NULLIF(TRIM(@nfhu), ''), 'NA'),
    numfeeders_water             = NULLIF(NULLIF(TRIM(@nfw),  ''), 'NA'),
    numfeeders_thistle           = NULLIF(NULLIF(TRIM(@nft),  ''), 'NA'),
    numfeeders_fruit             = NULLIF(NULLIF(TRIM(@nffr), ''), 'NA'),
    numfeeders_hopper            = NULLIF(NULLIF(TRIM(@nfho), ''), 'NA'),
    numfeeders_tube              = NULLIF(NULLIF(TRIM(@nftu), ''), 'NA'),
    numfeeders_other             = NULLIF(NULLIF(TRIM(@nfo),  ''), 'NA'),
    population_atleast           = NULLIF(NULLIF(TRIM(@pop),  ''), 'NA'),
    count_area_size_sq_m_atleast = NULLIF(NULLIF(TRIM(@csm),  ''), 'NA'),
    create_dt                    = NULLIF(NULLIF(TRIM(@cdt),  ''), 'NA'),
    supp_food                    = NULLIF(NULLIF(TRIM(@sf),   ''), 'NA');
    
-- file import
SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/Users/jacob/OneDrive/Desktop/Datasets/FeederWatch Cornell Datasets/PFW_all_1988_1995_May2024_Public.csv'
IGNORE INTO TABLE observations
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loc_id, @lat, @lng, subnational1_code, entry_technique,
 sub_id, obs_id, @month, @day, @year, proj_period_id,
 species_code, @alt, @how, @plus, @valid, @reviewed,
 @d1am, @d1pm, @d2am, @d2pm,
 @effort, @snow, @dem)
SET
    obs_date           = STR_TO_DATE(CONCAT(@year, '-', @month, '-', @day), '%Y-%m-%d'),
    latitude           = NULLIF(NULLIF(TRIM(@lat),      ''), 'NA'),
    longitude          = NULLIF(NULLIF(TRIM(@lng),      ''), 'NA'),
    how_many           = NULLIF(NULLIF(TRIM(@how),      ''), 'NA'),
    plus_code          = NULLIF(NULLIF(TRIM(@plus),     ''), 'NA'),
    valid              = NULLIF(NULLIF(TRIM(@valid),    ''), 'NA'),
    reviewed           = NULLIF(NULLIF(TRIM(@reviewed), ''), 'NA'),
    day1_am            = NULLIF(NULLIF(TRIM(@d1am),     ''), 'NA'),
    day1_pm            = NULLIF(NULLIF(TRIM(@d1pm),     ''), 'NA'),
    day2_am            = NULLIF(NULLIF(TRIM(@d2am),     ''), 'NA'),
    day2_pm            = NULLIF(NULLIF(TRIM(@d2pm),     ''), 'NA'),
    alt_full_spp_code  = NULLIF(NULLIF(TRIM(@alt),      ''), 'NA'),
    effort_hrs_atleast = NULLIF(NULLIF(TRIM(@effort),   ''), 'NA'),
    snow_dep_atleast   = NULLIF(NULLIF(TRIM(@snow),     ''), 'NA'),
    data_entry_method  = NULLIF(NULLIF(TRIM(@dem),      ''), 'NA');

LOAD DATA INFILE 'C:/Users/jacob/OneDrive/Desktop/Datasets/FeederWatch Cornell Datasets/PFW_all_1996_2000_May2024_Public.csv'
IGNORE INTO TABLE observations
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loc_id, @lat, @lng, subnational1_code, entry_technique,
 sub_id, obs_id, @month, @day, @year, proj_period_id,
 species_code, @alt, @how, @plus, @valid, @reviewed,
 @d1am, @d1pm, @d2am, @d2pm,
 @effort, @snow, @dem)
SET
    obs_date           = STR_TO_DATE(CONCAT(@year, '-', @month, '-', @day), '%Y-%m-%d'),
    latitude           = NULLIF(NULLIF(TRIM(@lat),      ''), 'NA'),
    longitude          = NULLIF(NULLIF(TRIM(@lng),      ''), 'NA'),
    how_many           = NULLIF(NULLIF(TRIM(@how),      ''), 'NA'),
    plus_code          = NULLIF(NULLIF(TRIM(@plus),     ''), 'NA'),
    valid              = NULLIF(NULLIF(TRIM(@valid),    ''), 'NA'),
    reviewed           = NULLIF(NULLIF(TRIM(@reviewed), ''), 'NA'),
    day1_am            = NULLIF(NULLIF(TRIM(@d1am),     ''), 'NA'),
    day1_pm            = NULLIF(NULLIF(TRIM(@d1pm),     ''), 'NA'),
    day2_am            = NULLIF(NULLIF(TRIM(@d2am),     ''), 'NA'),
    day2_pm            = NULLIF(NULLIF(TRIM(@d2pm),     ''), 'NA'),
    alt_full_spp_code  = NULLIF(NULLIF(TRIM(@alt),      ''), 'NA'),
    effort_hrs_atleast = NULLIF(NULLIF(TRIM(@effort),   ''), 'NA'),
    snow_dep_atleast   = NULLIF(NULLIF(TRIM(@snow),     ''), 'NA'),
    data_entry_method  = NULLIF(NULLIF(TRIM(@dem),      ''), 'NA');

LOAD DATA INFILE 'C:/Users/jacob/OneDrive/Desktop/Datasets/FeederWatch Cornell Datasets/PFW_all_2001_2005_May2024_Public.csv'
IGNORE INTO TABLE observations
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loc_id, @lat, @lng, subnational1_code, entry_technique,
 sub_id, obs_id, @month, @day, @year, proj_period_id,
 species_code, @alt, @how, @plus, @valid, @reviewed,
 @d1am, @d1pm, @d2am, @d2pm,
 @effort, @snow, @dem)
SET
    obs_date           = STR_TO_DATE(CONCAT(@year, '-', @month, '-', @day), '%Y-%m-%d'),
    latitude           = NULLIF(NULLIF(TRIM(@lat),      ''), 'NA'),
    longitude          = NULLIF(NULLIF(TRIM(@lng),      ''), 'NA'),
    how_many           = NULLIF(NULLIF(TRIM(@how),      ''), 'NA'),
    plus_code          = NULLIF(NULLIF(TRIM(@plus),     ''), 'NA'),
    valid              = NULLIF(NULLIF(TRIM(@valid),    ''), 'NA'),
    reviewed           = NULLIF(NULLIF(TRIM(@reviewed), ''), 'NA'),
    day1_am            = NULLIF(NULLIF(TRIM(@d1am),     ''), 'NA'),
    day1_pm            = NULLIF(NULLIF(TRIM(@d1pm),     ''), 'NA'),
    day2_am            = NULLIF(NULLIF(TRIM(@d2am),     ''), 'NA'),
    day2_pm            = NULLIF(NULLIF(TRIM(@d2pm),     ''), 'NA'),
    alt_full_spp_code  = NULLIF(NULLIF(TRIM(@alt),      ''), 'NA'),
    effort_hrs_atleast = NULLIF(NULLIF(TRIM(@effort),   ''), 'NA'),
    snow_dep_atleast   = NULLIF(NULLIF(TRIM(@snow),     ''), 'NA'),
    data_entry_method  = NULLIF(NULLIF(TRIM(@dem),      ''), 'NA');

LOAD DATA INFILE 'C:/Users/jacob/OneDrive/Desktop/Datasets/FeederWatch Cornell Datasets/PFW_all_2006_2010_May2024_Public.csv'
IGNORE INTO TABLE observations
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loc_id, @lat, @lng, subnational1_code, entry_technique,
 sub_id, obs_id, @month, @day, @year, proj_period_id,
 species_code, @alt, @how, @plus, @valid, @reviewed,
 @d1am, @d1pm, @d2am, @d2pm,
 @effort, @snow, @dem)
SET
    obs_date           = STR_TO_DATE(CONCAT(@year, '-', @month, '-', @day), '%Y-%m-%d'),
    latitude           = NULLIF(NULLIF(TRIM(@lat),      ''), 'NA'),
    longitude          = NULLIF(NULLIF(TRIM(@lng),      ''), 'NA'),
    how_many           = NULLIF(NULLIF(TRIM(@how),      ''), 'NA'),
    plus_code          = NULLIF(NULLIF(TRIM(@plus),     ''), 'NA'),
    valid              = NULLIF(NULLIF(TRIM(@valid),    ''), 'NA'),
    reviewed           = NULLIF(NULLIF(TRIM(@reviewed), ''), 'NA'),
    day1_am            = NULLIF(NULLIF(TRIM(@d1am),     ''), 'NA'),
    day1_pm            = NULLIF(NULLIF(TRIM(@d1pm),     ''), 'NA'),
    day2_am            = NULLIF(NULLIF(TRIM(@d2am),     ''), 'NA'),
    day2_pm            = NULLIF(NULLIF(TRIM(@d2pm),     ''), 'NA'),
    alt_full_spp_code  = NULLIF(NULLIF(TRIM(@alt),      ''), 'NA'),
    effort_hrs_atleast = NULLIF(NULLIF(TRIM(@effort),   ''), 'NA'),
    snow_dep_atleast   = NULLIF(NULLIF(TRIM(@snow),     ''), 'NA'),
    data_entry_method  = NULLIF(NULLIF(TRIM(@dem),      ''), 'NA');

LOAD DATA INFILE 'C:/Users/jacob/OneDrive/Desktop/Datasets/FeederWatch Cornell Datasets/PFW_all_2011_2015_May2024_Public.csv'
IGNORE INTO TABLE observations
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loc_id, @lat, @lng, subnational1_code, entry_technique,
 sub_id, obs_id, @month, @day, @year, proj_period_id,
 species_code, @alt, @how, @plus, @valid, @reviewed,
 @d1am, @d1pm, @d2am, @d2pm,
 @effort, @snow, @dem)
SET
    obs_date           = STR_TO_DATE(CONCAT(@year, '-', @month, '-', @day), '%Y-%m-%d'),
    latitude           = NULLIF(NULLIF(TRIM(@lat),      ''), 'NA'),
    longitude          = NULLIF(NULLIF(TRIM(@lng),      ''), 'NA'),
    how_many           = NULLIF(NULLIF(TRIM(@how),      ''), 'NA'),
    plus_code          = NULLIF(NULLIF(TRIM(@plus),     ''), 'NA'),
    valid              = NULLIF(NULLIF(TRIM(@valid),    ''), 'NA'),
    reviewed           = NULLIF(NULLIF(TRIM(@reviewed), ''), 'NA'),
    day1_am            = NULLIF(NULLIF(TRIM(@d1am),     ''), 'NA'),
    day1_pm            = NULLIF(NULLIF(TRIM(@d1pm),     ''), 'NA'),
    day2_am            = NULLIF(NULLIF(TRIM(@d2am),     ''), 'NA'),
    day2_pm            = NULLIF(NULLIF(TRIM(@d2pm),     ''), 'NA'),
    alt_full_spp_code  = NULLIF(NULLIF(TRIM(@alt),      ''), 'NA'),
    effort_hrs_atleast = NULLIF(NULLIF(TRIM(@effort),   ''), 'NA'),
    snow_dep_atleast   = NULLIF(NULLIF(TRIM(@snow),     ''), 'NA'),
    data_entry_method  = NULLIF(NULLIF(TRIM(@dem),      ''), 'NA');

LOAD DATA INFILE 'C:/Users/jacob/OneDrive/Desktop/Datasets/FeederWatch Cornell Datasets/PFW_all_2016_2020_May2024_Public.csv'
IGNORE INTO TABLE observations
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loc_id, @lat, @lng, subnational1_code, entry_technique,
 sub_id, obs_id, @month, @day, @year, proj_period_id,
 species_code, @alt, @how, @plus, @valid, @reviewed,
 @d1am, @d1pm, @d2am, @d2pm,
 @effort, @snow, @dem)
SET
    obs_date           = STR_TO_DATE(CONCAT(@year, '-', @month, '-', @day), '%Y-%m-%d'),
    latitude           = NULLIF(NULLIF(TRIM(@lat),      ''), 'NA'),
    longitude          = NULLIF(NULLIF(TRIM(@lng),      ''), 'NA'),
    how_many           = NULLIF(NULLIF(TRIM(@how),      ''), 'NA'),
    plus_code          = NULLIF(NULLIF(TRIM(@plus),     ''), 'NA'),
    valid              = NULLIF(NULLIF(TRIM(@valid),    ''), 'NA'),
    reviewed           = NULLIF(NULLIF(TRIM(@reviewed), ''), 'NA'),
    day1_am            = NULLIF(NULLIF(TRIM(@d1am),     ''), 'NA'),
    day1_pm            = NULLIF(NULLIF(TRIM(@d1pm),     ''), 'NA'),
    day2_am            = NULLIF(NULLIF(TRIM(@d2am),     ''), 'NA'),
    day2_pm            = NULLIF(NULLIF(TRIM(@d2pm),     ''), 'NA'),
    alt_full_spp_code  = NULLIF(NULLIF(TRIM(@alt),      ''), 'NA'),
    effort_hrs_atleast = NULLIF(NULLIF(TRIM(@effort),   ''), 'NA'),
    snow_dep_atleast   = NULLIF(NULLIF(TRIM(@snow),     ''), 'NA'),
    data_entry_method  = NULLIF(NULLIF(TRIM(@dem),      ''), 'NA');

SET FOREIGN_KEY_CHECKS = 1;

--check if tables have expected row count
SELECT 'species' AS tbl, COUNT(*) AS rows_count FROM species
UNION ALL
SELECT 'sites', COUNT(*) FROM sites
UNION ALL
SELECT 'observations', COUNT(*) FROM observations;

SELECT MIN(obs_date) AS earliest, MAX(obs_date) AS latest FROM observations;

SELECT 
COUNT(DISTINCT loc_id) AS distinct_sites,
COUNT(DISTINCT species_code) AS distinct_species,
COUNT(DISTINCT sub_id) AS distinct_checklists
FROM observations;

--fixing "XX"
SELECT COUNT(*) AS xx_obs_count
FROM observations
WHERE subnational1_code = 'XX';

ALTER TABLE observations ADD COLUMN location_valid TINYINT
DEFAULT 1;

UPDATE observations
SET location_valid = 0
WHERE subnational1_code = 'XX'
    OR latitude IS NULL
    OR longitude IS NULL
    OR latitude NOT BETWEEN -90 AND 90
    OR longitude NOT BETWEEN -180 and 180;

SELECT location_valid, COUNT(*) AS count
FROM observations GROUP BY location_valid;

-- interpretation
SELECT valid, reviewed,
    COUNT(*) AS obs_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM observations
GROUP BY valid, reviewed
ORDER BY valid DESC, reviewed;

-- label
ALTER TABLE observations ADD COLUMN quality_status VARCHAR(30);

UPDATE observations
SET quality_status = CASE
    WHEN valid = 1 AND reviewed = 0 THEN 'Accepted'
    WHEN valid = 1 AND reviewed = 1 THEN 'Expert Approved'
    WHEN valid = 0 AND reviewed = 1 THEN 'Unconfirmed'
    WHEN valid = 0 AND reviewed = 0 THEN 'Pending Review'
    ELSE 'Unknown'
END;

-- distribution of quality
SELECT quality_status, COUNT(*) AS obs_count
FROM observations
GROUP BY quality_status
ORDER BY obs_count DESC;

CREATE VIEW observations_clean AS
SELECT * FROM observations
WHERE quality_status IN ('Accepted', 'Expert Approved')
AND location_valid = 1;

------ plus_code flag obs count
SELECT plus_code,
COUNT(*) AS obs_count,
AVG(how_many) AS avg_how_many,
MAX(how_many) AS max_how_many
FROM observations
GROUP BY plus_code;

-- add flag
ALTER TABLE observations ADD COLUMN
count_is_minimum TINYINT DEFAULT 0;

UPDATE observations
SET count_is_minimum = 1
WHERE plus_code = 1;

-- species triggering plus_code
SELECT sp.american_english_name,
COUNT(*) AS plus_code_obs,
ROUND(AVG(o.how_many), 1) AS avg_reported_count
FROM observations o
JOIN species sp ON o.species_code = sp.species_code
WHERE o.plus_code = 1
GROUP BY sp.american_english_name
ORDER BY plus_code_obs DESC
LIMIT 20;

---- taxonomy observations
SELECT COUNT(*) AS subspecies_obs
FROM observations
WHERE alt_full_spp_code IS NOT NULL;

SELECT 
species_code, alt_full_spp_code,
COUNT(*) AS obs_count FROM
observations WHERE alt_full_spp_code IS NOT NULL
GROUP BY species_code, alt_full_spp_code
ORDER BY obs_count DESC
LIMIT 20;

-- add spec column
ALTER TABLE observations ADD COLUMN
resolved_species_code VARCHAR(10);

UPDATE observations
SET resolved_species_code = CASE 
    WHEN alt_full_spp_code IS NOT NULL THEN
    alt_full_spp_code  
    ELSE  species_code
END;

-- confirm resolved codes exist in species ref table
SELECT COUNT(*) AS unresolved
FROM observations o 
LEFT JOIN species sp ON o.resolved_species_code = sp.species_code
WHERE sp.species_code IS NULL;

--- count column
SELECT
    MIN(how_many) AS min_count,
    MAX(how_many) AS max_count,
    AVG(how_many) AS avg_count,
    SUM(how_many IS NULL) AS null_count,
    SUM(how_many = 0) AS zero_count,
    SUM(how_many < 0) AS negative_count
FROM observations;

SELECT
o.obs_id,
sp.american_english_name,
o.how_many,
o.plus_code,
o.obs_date,
o.subnational1_code
FROM observations o 
JOIN species sp ON o.species_code = sp.species_code
WHERE o.how_many > 10000
ORDER BY o.how_many DESC
LIMIT 20;

-- invalid flags
UPDATE observations
SET quality_status = 'Invalid - Negative Count'
WHERE how_many < 0;

-- NULL effort values
SELECT
    SUM(effort_hrs_atleast IS NULL) AS null_effort_hrs,
    SUM(day1_am IS NULL)            AS null_day1_am,
    SUM(day1_pm IS NULL)            AS null_day1_pm,
    SUM(day2_am IS NULL)            AS null_day2_am,
    SUM(day2_pm IS NULL)            AS null_day2_pm
FROM observations;

ALTER TABLE observations ADD COLUMN effort_halfdays TINYINT;

UPDATE observations
SET effort_halfdays = COALESCE(day1_am, 0)
                    + COALESCE(day1_pm, 0)
                    + COALESCE(day2_am, 0)
                    + COALESCE(day2_pm, 0);

-- zero effort observations
SELECT COUNT(*) AS zero_effort_obs
FROM observations
WHERE effort_halfdays = 0
AND effort_hrs_atleast = 0;

SELECT data_entry_method, COUNT(*) AS count_obs
FROM observations
GROUP BY data_entry_method
ORDER BY count_obs DESC;

-- Check for duplicate obs_ids
SELECT obs_id, COUNT(*) AS occurrences 
FROM observations
GROUP BY obs_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 20;

-- Check for duplicate species within the same checklist
SELECT sub_id, species_code, COUNT(*) AS dupes
FROM observations
GROUP BY sub_id, species_code
HAVING COUNT(*) > 1
ORDER BY dupes DESC
LIMIT 20;

CREATE TABLE observations_deduped AS
SELECT o.*
FROM observations o
INNER JOIN (
    SELECT MIN(obs_id) AS obs_id
    FROM observations
    GROUP BY sub_id, species_code
) AS keep_ids ON o.obs_id = keep_ids.obs_id;

SELECT COUNT(*) AS original_count FROM observations;
SELECT COUNT(*) AS deduped_count  FROM observations_deduped;

DROP TABLE observations;
RENAME TABLE observations_deduped TO observations;

SELECT obs_id, COUNT(*) AS occurrences 
FROM observations
GROUP BY obs_id
HAVING COUNT(*) > 1;

SELECT sub_id, species_code, COUNT(*) AS dupes
FROM observations
GROUP BY sub_id, species_code
HAVING COUNT(*) > 1;

-- zero-filling
SELECT 
    COUNT(DISTINCT sub_id) AS
    total_checklists,
    COUNT(DISTINCT species_code) AS
    total_species,
    COUNT(*) AS actual_obs_rows
    FROM observations;

-- ex. for given species
-- run each individually 
CREATE INDEX idx_obs_date    ON observations (obs_date);
CREATE INDEX idx_loc         ON observations (loc_id);
CREATE INDEX idx_sub_id      ON observations (sub_id);        -- added, needed for JOIN
CREATE INDEX idx_subnational ON observations (subnational1_code);

-- zero_filled ex
CREATE TABLE zero_filled_example AS
SELECT
    c.sub_id,
    c.loc_id,
    c.obs_date,
    c.subnational1_code,
    sp.species_code,
    sp.american_english_name,
    COALESCE(o.how_many, 0)           AS how_many,
    COALESCE(o.plus_code, 0)          AS plus_code,
    COALESCE(o.effort_hrs_atleast, 0) AS effort_hrs_atleast
FROM (
    SELECT DISTINCT sub_id, loc_id, obs_date, subnational1_code
    FROM observations
) c
CROSS JOIN (
    SELECT species_code, american_english_name
    FROM species
    WHERE species_code = 'houspa'
) sp
LEFT JOIN observations o
    ON c.sub_id = o.sub_id
    AND o.species_code = sp.species_code;

-- summary
SELECT
    COUNT(*)                     AS total_rows,
    COUNT(DISTINCT sub_id)       AS total_checklists,
    COUNT(DISTINCT species_code) AS total_species,
    MIN(YEAR(obs_date))          AS earliest_year,
    MAX(YEAR(obs_date))          AS latest_year
FROM observations;

-- record by year
SELECT YEAR(obs_date) AS yr, COUNT(*) AS records
FROM observations
GROUP BY yr
ORDER BY yr;

-- most observed species
SELECT
    sp.american_english_name,
    COUNT(*)        AS total_obs,
    SUM(o.how_many) AS total_birds
FROM observations o
JOIN species sp ON o.species_code = sp.species_code
WHERE o.obs_date BETWEEN '2010-01-01' AND '2020-12-31'
GROUP BY sp.american_english_name
ORDER BY total_birds DESC
LIMIT 10;

-- aggregate summary table 
CREATE TABLE species_yearly_summary AS
SELECT
    YEAR(obs_date)           AS obs_year,
    species_code,
    COUNT(*)                 AS total_obs,
    SUM(how_many)            AS total_birds,
    COUNT(DISTINCT sub_id)   AS checklist_count,
    ROUND(AVG(how_many),2) AS avg_per_checklist 
FROM observations
GROUP BY YEAR(obs_date), species_code;

-- summary 10
SELECT
    sp.american_english_name,
    SUM(s.total_obs)   AS total_obs,
    SUM(s.total_birds) AS total_birds
FROM species_yearly_summary s
JOIN species sp ON s.species_code = sp.species_code
GROUP BY sp.american_english_name
ORDER BY total_birds DESC
LIMIT 10;

-- record count
SELECT
    COUNT(*)                     AS total_rows,
    COUNT(DISTINCT sub_id)       AS total_checklists,
    COUNT(DISTINCT species_code) AS total_species,
    MIN(YEAR(obs_date))          AS earliest_year,
    MAX(YEAR(obs_date))          AS latest_year
FROM observations
WHERE YEAR(obs_date) BETWEEN 1985 AND 2020;
