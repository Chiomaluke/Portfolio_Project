Select location, date, total_cases, new_cases, total_deaths, population
From Portfolio..Covid_deaths
order by 1, 2

--Converting Data types
SELECT CAST (total_deaths AS INT) 
FROM Portfolio..Covid_deaths

SELECT CONVERT (INT, total_cases)
FROM Portfolio..Covid_deaths

--Looking at Total cases Vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolio..Covid_deaths
order by 1, 2

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From Portfolio..Covid_deaths
---where location = 'Nigeria'
Group by Location, Population
--order by 1, 2

--Showing the countries wuth the highest death count per population
Select Location, Population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/population))*100 as PercentPopulationDead
From Portfolio..Covid_deaths
---where location = 'Nigeria'
Group by Location, Population
order by 1, 2

--Breaking things down by continents
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio..Covid_deaths
Where continent is not null
---where location = 'Nigeria'
Group by continent
order by TotalDeathCount desc
--order by 1, 2

Select date, SUM(new_cases) as TotalDailyNewCases, SUM (cast(new_deaths as int)) as TotalDailyDeaths
From Portfolio..Covid_deaths
Where continent is not null
---where location = 'Nigeria'
Group by date



SELECT *
FROM Portfolio..Covid_deaths dea
Join Portfolio..Covid_vaccinations vac
On dea.location = vac.location
and dea.date = vac.date

With PopvsVac (Continent, Location, Date, Populatiton, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
FROM Portfolio..Covid_deaths dea
Join Portfolio..Covid_vaccinations vac
On dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
Order by 2,3
)

Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeoplevaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
FROM Portfolio..Covid_deaths dea
Join Portfolio..Covid_vaccinations vac
On dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
Order by 2,3
)













