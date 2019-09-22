
CREATE FUNCTION dbo.ufn_DBBackupDate ( @dbname varchar(50) )
RETURNS varchar(10)
AS
BEGIN
 DECLARE @budate varchar(10)
 SELECT @budate = 
 ISNULL(Convert(char(10), MAX(backup_finish_date), 101), 'Never') 
 FROM master.dbo.sysdatabases B 
    LEFT OUTER JOIN msdb.dbo.backupset A 
    ON A.database_name = B.name 
    AND A.type = 'D' 
 WHERE B.Name = @dbname
 RETURN (@budate)
END
GO

/*
CREATE FUNCTION dbo.NichtSichtbar ( @dbname varchar(50) )
RETURNS varchar(10)
AS
BEGIN
 DECLARE @budate varchar(10)
 SELECT @budate = 
 ISNULL(Convert(char(10), MAX(backup_finish_date), 101), 'Never') 
 FROM master.dbo.sysdatabases B 
    LEFT OUTER JOIN msdb.dbo.backupset A 
    ON A.database_name = B.name 
    AND A.type = 'D' 
 WHERE B.Name = @dbname
 RETURN (@budate)
END
GO
*/
