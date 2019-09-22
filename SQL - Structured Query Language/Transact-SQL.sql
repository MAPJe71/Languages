USE AdventureWorks;
GO
IF OBJECT_ID ( 'HumanResources.usp_GetAllEmployees', 'P' ) IS NOT NULL 
    DROP PROCEDURE HumanResources.usp_GetAllEmployees;
GO
CREATE PROCEDURE HumanResources.usp_GetAllEmployees
AS
    SELECT LastName, FirstName, JobTitle, Department
    FROM HumanResources.vEmployeeDepartment;
GO


EXECUTE HumanResources.usp_GetAllEmployees;
GO
-- Or
EXEC HumanResources.usp_GetAllEmployees;
GO
-- Or, if this procedure is the first statement within a batch:
HumanResources.usp_GetAllEmployees;




USE AdventureWorks;
GO
IF OBJECT_ID ( 'HumanResources.usp_GetEmployees', 'P' ) IS NOT NULL 
    DROP PROCEDURE HumanResources.usp_GetEmployees;
GO
CREATE PROCEDURE HumanResources.usp_GetEmployees 
    @lastname varchar(40), 
    @firstname varchar(20) 
AS 
    SELECT LastName, FirstName, JobTitle, Department
    FROM HumanResources.vEmployeeDepartment
    WHERE FirstName = @firstname AND LastName = @lastname;
GO

L'exécution de la procédure stockée usp_GetEmployees peut s'effectuer de plusieurs manières :

EXECUTE HumanResources.usp_GetEmployees 'Ackerman', 'Pilar';
-- Or
EXEC HumanResources.usp_GetEmployees @lastname = 'Ackerman', @firstname = 'Pilar';
GO
-- Or
EXECUTE HumanResources.usp_GetEmployees @firstname = 'Pilar', @lastname = 'Ackerman';
GO
-- Or, if this procedure is the first statement within a batch:
HumanResources.usp_GetEmployees 'Ackerman', 'Pilar';

USE AdventureWorks;
GO
IF OBJECT_ID ( 'HumanResources.usp_GetEmployees2', 'P' ) IS NOT NULL 
    DROP PROCEDURE HumanResources.usp_GetEmployees2;
GO
CREATE PROCEDURE HumanResources.usp_GetEmployees2 
    @lastname varchar(40) = 'D%', 
    @firstname varchar(20) = '%'
AS 
    SELECT LastName, FirstName, JobTitle, Department
    FROM HumanResources.vEmployeeDepartment
    WHERE FirstName LIKE @firstname 
        AND LastName LIKE @lastname;
GO


EXECUTE HumanResources.usp_GetEmployees2;
-- Or
EXECUTE HumanResources.usp_GetEmployees2 'Wi%';
-- Or
EXECUTE HumanResources.usp_GetEmployees2 @firstname = '%';
-- Or
EXECUTE HumanResources.usp_GetEmployees2 '[CK]ars[OE]n';
-- Or
EXECUTE HumanResources.usp_GetEmployees2 'Hesse', 'Stefen';
-- Or
EXECUTE HumanResources.usp_GetEmployees2 'H%', 'S%';



USE AdventureWorks;
GO
IF OBJECT_ID ( 'Production.usp_GetList', 'P' ) IS NOT NULL 
    DROP PROCEDURE Production.usp_GetList;
GO
CREATE PROCEDURE Production.usp_GetList @product varchar(40) 
    , @maxprice money 
    , @compareprice money OUTPUT
    , @listprice money OUT
AS
    SELECT p.name AS Product, p.ListPrice AS 'List Price'
    FROM Production.Product p
    JOIN Production.ProductSubcategory s 
      ON p.ProductSubcategoryID = s.ProductSubcategoryID
    WHERE s.name LIKE @product AND p.ListPrice < @maxprice;
-- Populate the output variable @listprice.
SET @listprice = (SELECT MAX(p.ListPrice)
        FROM Production.Product p
        JOIN  Production.ProductSubcategory s 
          ON p.ProductSubcategoryID = s.ProductSubcategoryID
        WHERE s.name LIKE @product AND p.ListPrice < @maxprice);
-- Populate the output variable @compareprice.
SET @compareprice = @maxprice;
GO


DECLARE @compareprice money, @cost money 
EXECUTE Production.usp_GetList '%Bikes%', 700, 
    @compareprice OUT, 
    @cost OUTPUT
IF @cost <= @compareprice 
BEGIN
    PRINT 'These products can be purchased for less than 
    $'+RTRIM(CAST(@compareprice AS varchar(20)))+'.'
END
ELSE
    PRINT 'The prices for all products in this category exceed 
    $'+ RTRIM(CAST(@compareprice AS varchar(20)))+'.'


    
    

USE AdventureWorks;
GO
IF OBJECT_ID ( 'dbo.usp_product_by_vendor', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_product_by_vendor;
GO
CREATE PROCEDURE dbo.usp_product_by_vendor @name varchar(30) = '%'
WITH RECOMPILE
AS
    SELECT v.Name AS 'Vendor name', p.Name AS 'Product name'
    FROM Purchasing.Vendor v 
    JOIN Purchasing.ProductVendor pv 
      ON v.VendorID = pv.VendorID 
    JOIN Production.Product p 
      ON pv.ProductID = p.ProductID
    WHERE v.Name LIKE @name;
GO



USE AdventureWorks;
GO
IF OBJECT_ID ( 'HumanResources.usp_encrypt_this', 'P' ) IS NOT NULL 
    DROP PROCEDURE HumanResources.usp_encrypt_this;
GO
CREATE PROCEDURE HumanResources.usp_encrypt_this
WITH ENCRYPTION
AS
    SELECT EmployeeID, Title, NationalIDNumber, VacationHours, SickLeaveHours 
    FROM HumanResources.Employee;
GO






USE AdventureWorks;
GO
SELECT definition FROM sys.sql_modules
WHERE object_id = OBJECT_ID('HumanResources.usp_encrypt_this');






USE AdventureWorks;
GO
IF OBJECT_ID ( 'dbo.usp_proc1', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_proc1;
GO
CREATE PROCEDURE dbo.usp_proc1
AS
    SELECT column1, column2 FROM table_does_not_exist
GO

Pour vérifier si la procédure stockée est bien créée, lancez la requête suivante :

USE AdventureWorks;
GO
SELECT definition
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('dbo.usp_proc1');




USE AdventureWorks;
GO
IF OBJECT_ID ( 'Purchasing.usp_vendor_info_all', 'P' ) IS NOT NULL 
    DROP PROCEDURE Purchasing.usp_vendor_info_all;
GO
CREATE PROCEDURE Purchasing.usp_vendor_info_all
WITH EXECUTE AS CALLER
AS
    SELECT v.Name AS Vendor, p.Name AS 'Product name', 
      v.CreditRating AS 'Credit Rating', 
      v.ActiveFlag AS Availability
    FROM Purchasing.Vendor v 
    INNER JOIN Purchasing.ProductVendor pv
      ON v.VendorID = pv.VendorID 
    INNER JOIN Production.Product p
      ON pv.ProductID = p.ProductID 
    ORDER BY v.Name ASC;
GO





CREATE ASSEMBLY HandlingLOBUsingCLR FROM '\\MachineName\HandlingLOBUsingCLR\bin\Debug\HandlingLOBUsingCLR.dll';
GO
CREATE PROCEDURE dbo.GetPhotoFromDB
(
    @ProductPhotoID int,
    @CurrentDirectory nvarchar(1024),
    @FileName nvarchar(1024)
)
AS EXTERNAL NAME HandlingLOBUsingCLR.LargeObjectBinary.GetPhotoFromDB;
GO




USE AdventureWorks;
GO
IF OBJECT_ID ( 'dbo.currency_cursor', 'P' ) IS NOT NULL
    DROP PROCEDURE dbo.currency_cursor;
GO
CREATE PROCEDURE dbo.currency_cursor 
    @currency_cursor CURSOR VARYING OUTPUT
AS
    SET @currency_cursor = CURSOR
    FORWARD_ONLY STATIC FOR
      SELECT CurrencyCode, Name
      FROM Sales.Currency;
    OPEN @currency_cursor;
GO




USE AdventureWorks;
GO
DECLARE @MyCursor CURSOR;
EXEC dbo.currency_cursor @currency_cursor = @MyCursor OUTPUT;
WHILE (@@FETCH_STATUS = 0)
BEGIN;
     FETCH NEXT FROM @MyCursor;
END;
CLOSE @MyCursor;
DEALLOCATE @MyCursor;
GO