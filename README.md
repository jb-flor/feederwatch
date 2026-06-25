<ins>FeederWatch Dataset Cleaning and Analysis 1988-2020</ins>

<ins>Overview:</ins>

The Cornell FeederWatch Project is a large-scale November-April survey containing information about winter birds recorded across North America. It is published by the Cornell Ornithology Lab and the Birds Canada organization, and presents observations submitted by civillian participants, which helps gauge winter bird abundance and range. The records are used in several ornithological studies to help track trends in topics such as distribution, population, appearance, etc. The currently published dataset spans from 1988-2024, and contains over 34-millions rows of observations from over 100 species of birds that winter in North America. This project focuses on cleaning the data from 1988-2020, preparing it for a general analysis of trends, such as year-over-year and seasonal diversity changes. 

<ins>Key Findings:</ins>


<ins>Dataset Source:</ins> https://feederwatch.org/explore/raw-dataset-requests/

<ins>Size:</ins> 34,079,426 records, 1,048 species

<ins>Featured Tables:</ins>

Observations - main table filled with all the records

Sites - location information (location id, longitude, latitude, etc.)

Species - species information (species id code, scientific name, american english name, etc.)

Species Yearly Summary - yearly summary of each species

<ins>Project Structure:</ins>

bird-cleaning.sql: file containing the code that cleans the records of duplicates, null values that impede analysis, and random characters

seasonal-diversity-trends.sql: file containing the code that presents seasonal diversity trends such as monthly average abundance, and species richness per area

year-over-year-trends.sql: file containing the code that presents yearly trends such as percent change per species, migratory patterns, and peak months for observation

<ins>Technologies/Language:</ins> MySQL (language), VSCode (editor), SQLTools (extension)




