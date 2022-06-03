select * from dbo.coviddealth$
where continent is not null
order by 3,4

select * from dbo.covidvaccinee$
order by 3,4

select location,date, total_cases , new_cases,total_deaths, population from dbo.coviddealth$
where continent is not null
order by 1,2

--total cases vs total dealth

select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as dealthpercentage from dbo.coviddealth$
where location like '%states%'
and continent is not null
order by 1,2

--total cases vs population
--percentages of people with covid

select location,date, total_cases,population, (total_cases/population)*100 as percentpopulationinfected  from dbo.coviddealth$
--where location like '%states%'
where continent is not null
order by 1,2

--countries with the highest infection rate compared to population

select location,population ,max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentpopulationinfected  from dbo.coviddealth$
--where location like '%states%'
where continent is not null
group by location,population
order by 4 desc

--coumtries with the highest dealth count per population

select location,max(cast(total_deaths as int)) as totaldealthcount from dbo.coviddealth$
--where location like '%states%'
where continent is not null
group by location
order by 2 desc

--grouping by continent

select location,max(cast(total_deaths as int)) as totaldealthcount from dbo.coviddealth$
--where location like '%states%'
where continent is null
group by location
order by 2 desc

--continent with the highest dealth count per population

select continent,max(cast(total_deaths as int)) as totaldealthcount from dbo.coviddealth$
--where location like '%states%'
where continent is not null
group by continent
order by 2 desc

--global numbers
select sum(cast(new_deaths as int)) as totaldeaths,sum(new_cases) as totalcases, sum(cast(new_deaths as int)) / sum(new_cases)*100 as deathspercentages
from dbo.coviddealth$
where continent is not null
--group by date
order by 1,2

--total population vs vaccination using CTE

with popvsvac (continent , location ,date ,population , new_vaccination,rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as bigint))
over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from dbo.coviddealth$ dea
join dbo.covidvaccinee$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(rollingpeoplevaccinated/population)*100
from popvsvac

--Temp table


create table percentpopulationvaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population bigint,
new_vaccination bigint,
Rollingpeoplevaccinated bigint,
)
insert into percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as bigint))
over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
from dbo.coviddealth$ dea
join dbo.covidvaccinee$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
select *,(rollingpeoplevaccinated/population)*100
from percentpopulationvaccinated

drop table percentpopulationvaccinated

--creating view to store data for visualization

create view percentpopulationvaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as bigint))
over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
from dbo.coviddealth$ dea
join dbo.covidvaccinee$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

drop table 