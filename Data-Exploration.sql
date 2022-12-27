/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

--Selecting data that i'm going to use

Select location,date,population,total_cases,new_cases,total_deaths
From `portfolio-project2022.covid_data.covidDeaths`
order by 1,2

--Looking at total cases vs total deaths

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercent
From `portfolio-project2022.covid_data.covidDeaths`
where location="India"
order by 1,2

--Looking at total cases Vs population

Select location,max(total_cases) as max_cases,population,max((total_cases/population))*100 as covidPercentage
From `portfolio-project2022.covid_data.covidDeaths`
-- where location="India"
group by location,population
order by max_cases desc

--Showing countries with highest death count per population

Select location,max(cast(total_deaths as int)) as totalDeaths
From `portfolio-project2022.covid_data.covidDeaths`
where continent is not null
group by location
order by totalDeaths desc

--Showing the continents with highest deaths

Select continent,max(cast(total_deaths as int)) as TotalDeaths
From `portfolio-project2022.covid_data.covidDeaths`
where continent is not null
group by continent
order by TotalDeaths desc

--Total cases & deaths by date, either globally or country specific

Select date,
  sum(new_cases) as total_cases,
  sum(new_deaths) as total_deaths
From `portfolio-project2022.covid_data.covidDeaths`
where location="India"
-- where continent is not null
group by date
order by 1,2


--Joining both the tables
--rolling count of total vaccinations

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.date) as rolling_total
From `portfolio-project2022.covid_data.covidDeaths` dea
  Join `portfolio-project2022.covid_data.covidVaccination` vac
    on dea.location=vac.location 
    and dea.date=vac.date 
where vac.new_vaccinations is not null
order by 2,3


-- Creating a temp table

With PopvsVac 
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.date) as Rolling_total
From `portfolio-project2022.covid_data.covidDeaths` dea 
Join `portfolio-project2022.covid_data.covidVaccination` vac
	On dea.location = vac.location
	and dea.date = vac.date
where vac.new_vaccinations is not null 
)
Select *, (rolling_total/Population)*10000
From PopvsVac




--Creating view to store data for later use

Create view `portfolio-project2022.covid_data.populationvaccinated` as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.date) as rolling_total
From `portfolio-project2022.covid_data.covidDeaths` dea
Join `portfolio-project2022.covid_data.covidVaccination` vac
  on dea.location=vac.location 
  and dea.date=vac.date 
where dea.continent is not null

Select *,(rolling_total/population)*100 as percent_vaccinated
From `portfolio-project2022.covid_data.populationvaccinated`
--where new_vaccinations is not null;

