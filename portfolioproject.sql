Select *
from portfolioproject..coviddeaths
order by 3,4

Select *
from portfolioproject..covidvaccinations
order by 3,4


-----Select Data to use for the portfolioproject---

Select location, date, total_cases, new_cases, total_deaths, population 
from portfolioproject..CovidDeaths
order by 1,2

---Looking at Total Cases vs Total Deaths---
----Likelihood of dying if you contact covid in your country--

Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage 
from portfolioproject..CovidDeaths
order by 1,2
----Likelihood of dying if you contact covid in USA
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage 
from portfolioproject..CovidDeaths
where location like '%states%'
order by 1,2

----Looking at Total Cases vs population---
-----shows what percentage of population got covid---

Select location, date,population, total_cases, (total_cases/population)*100 as TotalCasepercentage 
from portfolioproject..CovidDeaths
where location like '%states%'
order by 1,2

Select location, date,population, total_cases, (total_cases/population)*100 as TotalCasepercentage 
from portfolioproject..CovidDeaths
where location like '%united kingdom%'
order by 1,2

---Looking at countries with highest infection Rate compared to population

Select location,population, MAX(total_cases) as highestInfectionCount, Max((total_cases/population))*100 as PercentpopulationInfected 
from portfolioproject..CovidDeaths
where continent is not null
group by location, population
order by 4 desc

---showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount 
from portfolioproject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

----LET BREAK THINGS DOWN BY CONTINENT
----continent with highestdeath count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
from portfolioproject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount 
from portfolioproject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

---Global Numbers

select date, SUM(new_cases) as totalcases, SUM(new_deaths) as totaldeaths,SUM(new_deaths)/SUM(new_cases)*100 as deathpercentage
from portfolioproject..coviddeaths
where new_cases <>0  
group by date
order by 1,2 

select SUM(new_cases) as total_cases, SUM(new_deaths) as totaldeaths,SUM(new_deaths)/SUM(new_cases)*100 as deathpercentage
from portfolioproject..coviddeaths
where new_cases <>0  
--group by date
order by 1,2 

---Looking at Total population vs vaccination
select *
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

---USE CTE 
with popvsVac (Continent, Location, Date, Population,New_vaccinatins, RollingpeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
	)
	select *, (RollingpeopleVaccinated/Population)*100
	from popvsVac

	----TEMP TABLE 
	drop table if exists #PercentpopulationVaccinated
	Create Table #PercentpopulationVaccinated
	(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	population numeric,
	New_Vaccinations numeric,
	RollingpeopleVaccinated numeric
	)
  
  insert into #PercentpopulationVaccinated
	 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	--where dea.continent is not null
	--order by 2,3

	select *, (RollingpeopleVaccinated/Population)*100
	from #PercentpopulationVaccinated



---creating view

Create view percentofpopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3

	select*
	from percentpopulationVaccinated






