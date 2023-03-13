select *
from NetflixPortfolioProject..NetflixSubscriptionFee



--Identify the top 5 countries with the largest Netflix library size:

SELECT DISTINCT TOP 5 [Total Library Size], Country

FROM NetflixPortfolioProject..NetflixSubscriptionFee

ORDER BY [Total Library Size]DESC

--Czechia has the largest Netflix Library size


--Calculate the total number of TV shows and movies in Netflix's library

SELECT SUM("No# of TV Shows") AS total_tv_shows,
		SUM("No# of Movies") AS total_movies

FROM NetflixPortfolioProject..NetflixSubscriptionFee;

--total number of tv shows 228732, total movies 116705



--Calculate the average cost per month for each subscription plan by country

SELECT Country, AVG("Cost Per Month - Basic ($)") AS avg_cost_basic,
		AVG("Cost Per Month - Standard ($)") AS avg_cost_standard,
		AVG("Cost Per Month - Premium ($)") AS avg_cost_premium

FROM NetflixPortfolioProject..NetflixSubscriptionFee
GROUP BY Country
ORDER BY Country



--find the consolidated total cost per month (basic+standard+premium) and store it as a separate column

WITH CTE_totalpremium as
(
SELECT Country, SUM("Cost Per Month - Basic ($)") + SUM("Cost Per Month - Standard ($)") + SUM("Cost Per Month - Premium ($)")
		AS totalpremium

FROM NetflixPortfolioProject..NetflixSubscriptionFee
group by Country
)
select *
from CTE_totalpremium


--Find the minimum total library size and the maximum total subscription cost for each country.

SELECT Country, MIN([Total Library Size]) as library_size, 
       (SELECT MAX(subquery.sum_cost) 
        FROM (SELECT Country, SUM([Cost Per Month - Basic ($)]) + SUM([Cost Per Month - Standard ($)]) + SUM([Cost Per Month - Premium ($)]) as sum_cost 
              FROM NetflixPortfolioProject.dbo.NetflixSubscriptionFee
              GROUP BY Country) subquery
        WHERE subquery.Country = main.Country) as total_subscription_cost
FROM NetflixPortfolioProject.dbo.NetflixSubscriptionFee main
GROUP BY Country
ORDER BY Country


--Finding the country that has the lowest total library size and the highest cost per month

SELECT 
	TOP 1 Country, [Total Library Size], [Cost Per Month - Basic ($)] + [Cost Per Month - Standard ($)] + [Cost Per Month - Premium ($)] as total_subscription_cost
FROM NetflixPortfolioProject.dbo.NetflixSubscriptionFee
ORDER BY [Total Library Size], total_subscription_cost DESC
