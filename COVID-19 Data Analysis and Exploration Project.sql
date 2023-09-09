select *
from PortfolioProject ..CovidDeaths

select count(distinct(location))
from PortfolioProject..CovidDeaths

--SELECT THE DATA THAT WE ARE USING
Select location, date, total_cases, new_cases, total_deaths, Population
from PortfolioProject..CovidDeaths

--LOOKING AT TOTAL CASES VS TOTAL DEATHS
--How many deaths do they have for their entire cases.
--showing likelyhood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths,
(cast (total_deaths as float)/CAST(total_cases as FLOAT))*100 as Deathpercentage
from PortfolioProject..CovidDeaths
where location ='india'
order by Deathpercentage desc

--LOOKING AT TOTAL CASES VS POPULATION
--(WHAT PERCENY POPULATION GOT COVID)
Select location, date, population, total_cases,
(total_cases/population)*100 as Deathpercentage
from PortfolioProject..CovidDeaths
where location ='india'

--coutries with highes infection rate cmpared to population

Select location, population, Max(total_cases) as HighestInfected, 
Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
group by location, population
order by PercentPopulationInfected


--Showing Countries with highest death count per population
Select location, Max(cast(Total_deaths as int))as Totaldeathcount 
from PortfolioProject..CovidDeaths
group by location
order by Totaldeathcount desc


--CONTINENTS

Select (Continent),population, Max(total_cases) as HighestInfected, 
Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
group by continent,population
order by PercentPopulationInfected

Select location ,population, Max(total_cases) as HighestInfected, 
Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is null
group by location,population
order by PercentPopulationInfected


--GLOBAL NUMBERS

Select Sum(new_cases) as total_cases,
Sum(new_deaths) as total_deaths
from PortfolioProject..CovidDeaths
where continent is not null
order by 1, 2

--JOINING COVID DEATHS AND COVID VACCINATIONS

Select *
From PortfolioProject..CovidDeaths dea
join
PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
 and dea.date = vac.date

--Looking at Total Population  vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
join
PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
 and dea.date = vac.date


--ROLLING PEROPLE VACCINATED

SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(int, vac.new_vaccinations))
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)AS Rollingpeoplevaccinated
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac 
    ON dea.location = vac.location 
    AND dea.date = vac.date
	where dea.continent is not null
	order by 2, 3

--USE CTE 
with popvsvac(continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)as
(
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(bigint,vac.new_vaccinations))
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)AS Rollingpeoplevaccinated
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac 
    ON dea.location = vac.location 
    AND dea.date = vac.date
	where dea.continent is not null
	)
	select *,
	(RollingPEopleVaccinated/population)*100
	from popvsvac


--TEMP TABLES

DROP TABLE IF EXISTS #percentpopulationvaccinated;
CREATE TABLE #percentpopulationvaccinated (
    continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccinated numeric
);

INSERT INTO #percentpopulationvaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(bigint, vac.new_vaccinations))
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rollingpeoplevaccinated
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac 
    ON dea.location = vac.location 
    AND dea.date = vac.date;

SELECT *
--(RollingpeopleVaccinated/population)*100
FROM #percentpopulationvaccinated

















