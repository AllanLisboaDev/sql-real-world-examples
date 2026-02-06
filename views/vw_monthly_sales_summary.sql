CREATE VIEW dbo.vw_monthly_sales_summary
AS
/*
    This view provides a monthly sales summary per customer.
    It is intended for reporting and analytical purposes.
*/

SELECT
    c.CustomerId,
    c.CustomerName,
    YEAR(o.OrderDate)  AS SalesYear,
    MONTH(o.OrderDate) AS SalesMonth,
    COUNT(o.OrderId)   AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSalesAmount
FROM Orders o
INNER JOIN Customers c
    ON c.CustomerId = o.CustomerId
WHERE o.Status = 'COMPLETED'
  AND o.TotalAmount > 0
GROUP BY
    c.CustomerId,
    c.CustomerName,
    YEAR(o.OrderDate),
    MONTH(o.OrderDate);
GO

-- Suggested index: Orders(OrderDate, Status) INCLUDE (TotalAmount, CustomerId)
