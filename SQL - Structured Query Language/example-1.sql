CREATE TABLE dbo.InvoiceExport (
	 InvoiceExportID					INT	IDENTITY(1,1)	PRIMARY KEY
	,ServiceID							INT
	,ExportType							VARCHAR(255)
	,AccountCodeMileage					SMALLINT
	,AccountCodeDebtor					VARCHAR(255)
	,RunToDate							DATETIME2
	,Amount								DECIMAL(9,2)
	,ChargeType							VARCHAR(255)
	,CreatedDate						DATETIME2
	,SourceSystemID				 		INT
	,SourceKey				 			VARCHAR(255)
	,SourceDate					 		DATETIME2
)
GO

--Comment Line
CREATE TABLE dbo.Organisation (
	 OrganisationID				 		INT	IDENTITY(1,1)	PRIMARY KEY
	,OrganisationType			 		VARCHAR(255)
	,SourceSystemID				 		INT
	,SourceKey				 			VARCHAR(255)
	,SourceDate					 		DATETIME2
)
GO

/*
Comment Block
Comment Block
*/
CREATE TABLE dbo.Patient (	
	 PatientID					 		INT	IDENTITY(1,1)	PRIMARY KEY
	,PersonID					 		INT
	,HealthSystemNumberType	 			VARCHAR(255)
	,HealthSystemNumber			 		INT
	,HealthSystemNumberTraceID	 		INT
	,RegistrationDate			 		DATETIME2
	,DeathWithMCNPresent		 		VARCHAR(255)
	,IsCancer					 		BIT
	,Height						 		VARCHAR(50)
	,GPTitle					 		VARCHAR(255)
	,SourceSystemID				 		INT
	,SourceKey				 			VARCHAR(255)
	,SourceDate					 		DATETIME2
)
GO
