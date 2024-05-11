-- Database used is named ProX,Should be replaced with the database you choose to place the table in.

use proX

select location, population,date,new_cases,total_cases,total_deaths from CovidDeaths --order by 3,1;

--1. SHOWS THE POSSIBILITY OF DYING FROM COVID IF INFECTED (TOTAL CASES VS TOTAL DEATHS)
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_percentage 
from CovidDeaths 
where 
location like '%zambia%' and
continent is not null


--2. SHOWS HOW MANY PEOPLE GOT INFECTED (TOATAL CASES VS TOTAL POPULATION)
select location, population,total_cases,
(total_cases/population)*100 as Infection_rate,date from CovidDeaths
where continent is not null and location
LIKE '%zambia%'


--3. SHOWS THE COUNTRY WITH HIGHEST INFECTION CASES 
select location,max(total_cases) as 'Highest Case Count',
max((total_cases/population))*100 as 'Infection %' from CovidDeaths
where continent is not null
Group by location,population
order by [Infection %] desc

--4. SHOWS THE COUNTRY WITH THE HIGHEST DEATHS COUNT
select location,sum(CAST(total_deaths AS INT)) as HighestDeathCount
 from CovidDeaths
 where continent is not null
 and location not in ('World', 'European Union', 'International')
Group by location
order by [HighestDeathCount] desc

--5. GLOBAL STATS ON DEATHS FROM NEW CASES
select SUM(new_cases) as TotalnewCases,SUM(CAST(new_deaths AS INT)) as TotalnewDeaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS 'Global Death Percentage', date
from CovidDeaths
where continent is not null
GROUP BY date
order by 4,2 asc

--6. NUMBER OF PEOPLE VACCINATED PER COUNTRY USING CTE TABLE.

with VacPOP (continent,location,population,date,new_vaccs,Vacci_RollCount)
as
(
select d.continent,d.location,d.population, d.date,v.new_vaccinations,
sum(convert (int,v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as Vaccine_RollCount
from CovidDeaths as d
join CovidVaccinations as v on d.location=v.location and d.date=v.date
where d.continent is not null
--order by 2,3
)
select *,(vacci_rollcount/population)*100 as PercentageVaccinated from VacPOP
order by 2,6 asc











