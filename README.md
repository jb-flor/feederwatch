## FeederWatch Dataset Cleaning and Analysis 1988-2020

The Cornell FeederWatch Project is a large-scale November-April survey containing information about winter birds recorded across North America. It is published by the Cornell Ornithology Lab and the Birds Canada organization, and presents observations submitted by civillian participants, which helps gauge winter bird abundance and range. The records are used in several ornithological studies to help track trends in topics such as distribution, population, and appearance. The currently published dataset spans from 1988-2024, and contains over 34-millions rows of observations from over 100 species of birds that winter in North America. 

## Project Overview

An end-to-end data analysis project covering the FeederWatch observation 
records from 1988-2020 — from raw data cleaning in MySQL through statistical trend analysis 
and machine learning in Python.


## Key Findings Examples

- **House Sparrow** leads in total birds counted (16M+) despite Dark-eyed 
  Junco having the highest checklist appearances (2.09M), indicating House 
  Sparrows appear in larger flocks when observed
- **Dark-eyed Junco, Mourning Dove, and House Finch** round out the top 5 
  most observed species by total bird count across the full dataset
- Year-over-year linear regression across all 1,048 species identified 
  statistically significant long-term population trends (p < 0.05) in 
  multiple species
- Seasonal heatmap analysis confirms expected winter residency patterns for 
  top feeder species, with peak activity concentrated in December–February

## Dataset
Source: https://feederwatch.org/explore/raw-dataset-requests/

Size: 34,079,426 records, 1,048 species

<ins>Featured Tables:</ins>
 - `observations` — all bird count records (primary table, 34M rows)
  - `sites` — feeder location metadata (loc_id, latitude, longitude, state)
  - `species` — species reference table (species_code, scientific name, common name)
  - `species_yearly_summary` — pre-aggregated yearly totals per species (performance layer)

## Project Structure

### bird_cleaning.sql
Cleans and deduplicates the raw dataset across 3 relational tables:
- Duplicate removal via swap-table strategy
- Index creation on high-frequency join and filter columns
- Pre-aggregated `species_yearly_summary` table for query performance

### year-over-year-trends.sql
Year-over-year species population trend analysis using SQL window functions:
- `LAG()` to compare each year's average count against the prior year
- Percentage change calculation per species per year
- Filtered to species with 30+ checklists for statistical reliability

### seasonal-diversity-trends.sql
Two analyses covering seasonal patterns and geographic diversity:
- Monthly average abundance per species using `RANK()` to identify peak, 
  arrival, and departure months
- Site-level species richness scoring using `DENSE_RANK()` within each 
  state/province

### BirdJupyter.ipynb
End-to-end Python analysis pipeline built on top of the cleaned MySQL data:
- **Database connection** via SQLAlchemy
- **Visualization** — top 10 species subplot grid and interactive species 
  dropdowns for both trend lines and seasonal heatmaps (ipywidgets, 
  Matplotlib, Seaborn)
- **Statistical analysis** — linear regression (scipy) across all 1,048 
  species to surface significant long-term population trends
- **Machine learning** — logistic regression to predict species occurrence 
  from environmental features; K-Means clustering to group feeder sites by 
  bird community composition


## Technologies

| Category | Tools |
|---|---|
| Database | MySQL 8.0, SQLTools (VSCode) |
| Languages | SQL, Python |
| Python Libraries | pandas, Matplotlib, Seaborn, ipywidgets, SQLAlchemy, scipy, scikit-learn |
| Environment | Anaconda (birdSQLPy), Jupyter Notebook, VSCode |


## How to Reproduce

1. Download the raw FeederWatch dataset from the link above
2. Set up a local MySQL database and import the raw tables 
   (observations, sites, species)
3. Run `bird_cleaning.sql` to clean and deduplicate the data
4. Run `year-over-year-trends.sql` and `seasonal-diversity-trends.sql` 
   for SQL-based analysis
5. Open `BirdJupyter.ipynb` in Jupyter, update the SQLAlchemy connection 
   string with your credentials, and run all cells

## Results Examples

## Results

### Population Trends
![Top 10 Feeder Species](https://github.com/jb-flor/feederwatch/blob/main/results/trend%20charts/top%2010%20feeder%20species%20trendlines.png)
![House Sparrow Population Trendline](https://github.com/jb-flor/feederwatch/blob/main/results/trend%20charts/housesparrow%20pop%20trend%20line.png?raw=true)

### Seasonal Activity
![Top 10 Feeder Species Seasonal Heatmap](https://github.com/jb-flor/feederwatch/blob/main/results/trend%20charts/seasonal%20heatmap%20for%20top%2010%20feeder%20species.png)

### Regression Analysis
![House Sparrow Regression Line](https://github.com/jb-flor/feederwatch/blob/main/results/trend%20charts/lin.%20regression%20house%20sparrow.png)

