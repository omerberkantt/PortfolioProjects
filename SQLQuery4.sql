select * 
from PortfolioProject1..coviddeaths
where continent is not null
order by 3,4

--Select * 
--From PortfolioProject1..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject1..coviddeaths
where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject1..coviddeaths
Where location like '%turkey%' and 
continent is not null
order by 1,2


--Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select location, date,total_cases ,population, 
(CONVERT(float, (total_deaths)) / NULLIF(CONVERT(float, population), 0)) * 100 as PercentPopulationInfected
from PortfolioProject1..CovidDeaths
where continent is not null
--Where location like '%turkey%' 
order by 1,2


--Looking at countries with Highest Infection count compared to Population

Select location,population, max(total_cases) as HighestInfectionCount,
MAX(CAST(total_cases as float)/population) * 100 as PercentPopulationInfected
from PortfolioProject1..CovidDeaths
where continent is not null
--Where location like '%turkey%' 
group by population,location
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population


Select location, MAX(cast(total_deaths as float)) as TotalDeathCount
from PortfolioProject1..CovidDeaths
--Where location like '%turkey%' 
where continent is not null
group by location
order by TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(cast(total_deaths as float)) as TotalDeathCount
from PortfolioProject1..CovidDeaths
--Where location like '%turkey%' 
where continent is not null
group by continent
order by TotalDeathCount desc


-- Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as float)) as TotalDeathCount
from PortfolioProject1..CovidDeaths
--Where location like '%turkey%' 
where continent is not null
group by continent
order by TotalDeathCount desc 

-- GLOBAL NUMBERS

Select  sum(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths AS float)) as total_deaths, 
SUM(cast(new_deaths AS float))/sum(cast(new_cases as float))*100 AS Deathpercentage
from PortfolioProject1..coviddeaths 
--Where location like '%turkey%' and 
where continent is not null
--Group by date
order by 1,2 


 -- Looking at Total Population vs Vaccinations

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(float,vac.new_vaccinations)) OVER (Partition by  dea.location order by dea.location, dea.date)
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From PortfolioProject1..coviddeaths dea
 join PortfolioProject1..CovidVaccinations vac
	On dea.location = location
	and dea.date = date
where dea.continent is not null  
order by 2,3 

--USE CTE 

With PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as 
(
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(float,vac.new_vaccinations)) OVER (Partition by  dea.location order by dea.location, dea.date)
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From PortfolioProject1..coviddeaths dea
 join PortfolioProject1..CovidVaccinations vac
	On dea.location = location
	and dea.date = date
where dea.continent is not null  
--order by 2,3 
)

Select * , (RollingPeopleVaccinated/population)*100
From PopvsVac 



-- TEMP TABLE 

Drop Table if exists #PercentPopulationVaccination
Create Table #PercentPopulationVaccination
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccination
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(float,vac.new_vaccinations)) OVER (Partition by  dea.location order by dea.location, dea.date)
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From PortfolioProject1..coviddeaths dea
 join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null  
--order by 2,3 

Select * , (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccination



--Creating View to store data for later visulizations

Create View PercentPopulationVaccinated as 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(float,vac.new_vaccinations)) OVER (Partition by  dea.location order by dea.location, dea.date)
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From PortfolioProject1..coviddeaths dea
 join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null  
--order by 2,3 


Select * 
From #PercentPopulationVaccination
