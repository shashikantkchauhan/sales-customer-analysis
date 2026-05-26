use AdventureWorks2025

--Task 1: Total Sales by Product

select 
  p.ProductID,p.Name,SUM(sod.LineTotal) [TOTAL SALE] 
from 
  Sales.SalesOrderDetail as sod
join Production.Product as p on sod.ProductID = p.ProductID group by p.ProductID,p.name


--Task 2: Total Orders by Customer

select c.CustomerID, COUNT(sod.SalesOrderID) [total orders] from Sales.SalesOrderHeader as sod
join Sales.Customer as c on sod.CustomerID = c.CustomerID group by c.CustomerID

--Task 3: Total Sales by Year

select YEAR(OrderDate),sum(soh.SalesOrderID) [total sales ]from Sales.SalesOrderHeader as soh group by YEAR(OrderDate)


--Task 4: Sales by Product Category

select pc.Name [cateogory name] ,count(p.ProductID)[total sale] from Sales.SalesOrderDetail as sod 
join Production.Product as p on sod.ProductID = p.ProductID

join Production.ProductSubcategory as psc on p.ProductSubcategoryID = psc.ProductCategoryID

join Production.ProductCategory as pc on psc.ProductCategoryID = pc.ProductCategoryID 

group by pc.Name


--Task 5: Top Customers by Revenue

select top 10 c.CustomerID, (p.FirstName + ' ' + p.LastName) [full name], sum(soh.SalesOrderID) [total sales] from Sales.SalesOrderHeader as soh 
join Sales.Customer as c on soh.CustomerID = c.CustomerID 

join Sales.SalesPerson as sp on c.TerritoryID = sp.TerritoryID

join Person.Person as p on sp.BusinessEntityID = p.BusinessEntityID

group by c.CustomerID, (p.FirstName + ' ' + p.LastName)


--Task 6: Sales by Territory

select st.Name , sum(st.TerritoryID) [total sales] from Sales.SalesOrderHeader as soh
join Sales.SalesTerritory as st on soh.TerritoryID = st.TerritoryID group by st.Name,st.TerritoryID



--Task 7: Category Contribution Analysis

select pc.Name, sum(sod.LineTotal) from Sales.SalesOrderDetail sod 
join Production.Product as p on sod.ProductID = p.ProductID

join Production.ProductSubcategory as psc on p.ProductSubcategoryID = psc.ProductSubcategoryID

join Production.ProductCategory as pc on psc.ProductCategoryID = pc.ProductCategoryID group by pc.Name 


--Task 8: Best Selling Product per Category

select CategoryName, ProductName ,Totalsales from (
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY CategoryName 
           ORDER BY TotalSales DESC
       ) AS rn
FROM (
    SELECT 
        pc.Name AS CategoryName,
        p.Name AS ProductName,
        SUM(sod.LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail sod 
    JOIN Production.Product p 
        ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc 
        ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc 
        ON psc.ProductCategoryID = pc.ProductCategoryID 
    GROUP BY pc.Name, p.Name
) AS ProductSales 
) ranked
where rn =1 
order by CategoryName;


--Task 9: Monthly Sales Trend

SELECT 
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(TotalDue) AS MonthlySales
FROM Sales.SalesOrderHeader
GROUP BY 
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY 
    SalesYear,
    SalesMonth;

--Task 10: Year-over-Year Growth

SELECT 
  YEAR(OrderDate) AS SalesYear,
  SUM(TotalDue) AS YearlySales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY SalesYear;

--Task 11: Top 10 Customers
SELECT TOP 10
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c
    ON soh.CustomerID = c.CustomerID
JOIN Person.Person p
    ON c.PersonID = p.BusinessEntityID
GROUP BY 
    c.CustomerID,
    p.FirstName,
    p.LastName
ORDER BY TotalSales DESC;

