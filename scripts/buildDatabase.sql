USE master;
GO

-- Checking and removing (if exist) database named 'DWH'
-- Warning!! it will delete the entire database objects if 'DWH' was found
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DWH')
BEGIN
	ALTER DATABASE DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE DWH;
END
GO

-- Creating database DWH
CREATE DATABASE DWH
GO
USE DWH
GO

-- Creating 3 schema for layers
CREATE SCHEMA bronze
GO

CREATE SCHEMA silver
GO

CREATE SCHEMA gold
