/*
COVID-19 Data Exploration Project
Author: [Your Name]
Date: [Current Date]

Skills used: Joins, CTE's, Temp Tables, Window Functions, 
             Aggregate Functions, Creating Views, Converting Data Types
*/


USE Covid19_Portfolio;

-- 1. Global Numbers for Overall Dashboard
CREATE VIEW GlobalCovidStats AS
SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_deaths, 
    ROUND(SUM(CAST(new_deaths AS FLOAT)) / SUM(new_cases)*100, 2) AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL;

-- 2. Total Deaths by Continent
CREATE VIEW DeathsByContinent AS
SELECT 
    continent, 
    SUM(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent;

-- 3. Infection Rates by Country
CREATE VIEW InfectionRatesByCountry AS
SELECT 
    Location, 
    Population, 
    MAX(total_cases) AS HighestInfectionCount,  
    ROUND(MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)))*100, 2) AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY Location, Population;

-- 4. Vaccination Progress by Country
CREATE VIEW VaccinationProgress AS
SELECT 
    dea.location,
    MAX(dea.population) AS TotalPopulation,
    MAX(CAST(vac.total_vaccinations AS BIGINT)) AS TotalVaccinations,
    MAX(CAST(vac.people_fully_vaccinated AS BIGINT)) AS FullyVaccinatedCount,
    ROUND(MAX(CAST(vac.people_fully_vaccinated AS FLOAT)) / MAX(dea.population) * 100, 2) AS PercentFullyVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.location;

-- 5. Daily Infection Progression
CREATE VIEW DailyInfectionProgression AS
SELECT 
    Location, 
    date, 
    total_cases,
    population,
    ROUND((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))*100, 2) AS PercentPopulationInfected
FROM CovidDeaths
WHERE continent IS NOT NULL;