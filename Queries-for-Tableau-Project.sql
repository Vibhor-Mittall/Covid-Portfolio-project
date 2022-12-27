/*

Queries used for creating tables for visualisaton

*/

-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From `portfolio-project2022.covid_data.covidDeaths`
where continent is not null 
--Group By date
order by 1,2



-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From `portfolio-project2022.covid_data.covidDeaths`
where continent is null
and location not in ('World', 'European Union', 'International')
and location not like '%income%'
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From `portfolio-project2022.covid_data.covidDeaths`
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From `portfolio-project2022.covid_data.covidDeaths`
Group by Location, Population, date
order by PercentPopulationInfected desc

-- Final Tableau Dashboard 
--https://public.tableau.com/app/profile/vibhor.mittal2077/viz/Covid19-PortfolioDashboard/Dashboard1




