-- Criar tabelas de staging
DROP TABLE IF EXISTS PricePaidData2025; -- se ja existir tabela
CREATE TABLE PricePaidData2025 (
    [Transaction unique identifier] VARCHAR(255),
    [Price] VARCHAR(50),
    [Date of Transfer] VARCHAR(50),
    [Postcode] VARCHAR(50),
    [Property Type] VARCHAR(10),
    [Old/New] VARCHAR(10),
    [Duration] VARCHAR(10),
    [PAON] VARCHAR(255),
    [SAON] VARCHAR(255),
    [Street] VARCHAR(255),
    [Locality] VARCHAR(255),
    [Town/City] VARCHAR(255),
    [District] VARCHAR(255),
    [County] VARCHAR(255),
    [PPD Category Type] VARCHAR(10),
    [Record Status] VARCHAR(10)
);

DROP TABLE IF EXISTS PricePaidData2024;
CREATE TABLE PricePaidData2024 (
    [Transaction unique identifier] VARCHAR(255),
    [Price] VARCHAR(50),
    [Date of Transfer] VARCHAR(50),
    [Postcode] VARCHAR(50),
    [Property Type] VARCHAR(10),
    [Old/New] VARCHAR(10),
    [Duration] VARCHAR(10),
    [PAON] VARCHAR(255),
    [SAON] VARCHAR(255),
    [Street] VARCHAR(255),
    [Locality] VARCHAR(255),
    [Town/City] VARCHAR(255),
    [District] VARCHAR(255),
    [County] VARCHAR(255),
    [PPD Category Type] VARCHAR(10),
    [Record Status] VARCHAR(10)
);

-- dar insert aos dados na tabela de staging
BULK INSERT PricePaidData2025
FROM 'C:\data\pp-2025.csv'
WITH (
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0A'
);

BULK INSERT PricePaidData2024
FROM 'C:\data\pp-2024.csv'
WITH (
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0A'
);

-- criar tabelas short
DROP TABLE IF EXISTS ShortPricePaidData2025;
CREATE TABLE ShortPricePaidData2025 (
    [Transaction unique identifier] VARCHAR(50),
    [Price] BIGINT,
    [Date of Transfer] DATE,
    [Postcode] VARCHAR(10),
    [Property Type] CHAR(1),
    [Old_New] CHAR(1),
    [PAON] VARCHAR(100),
    [Street] VARCHAR(150),
    [Locality] VARCHAR(100),
    [Town] VARCHAR(100),
    [District] VARCHAR(100),
    [County] VARCHAR(100)
);


DROP TABLE IF EXISTS ShortPricePaidData2024;
CREATE TABLE ShortPricePaidData2024 (
    [Transaction unique identifier] VARCHAR(50),
    [Price] BIGINT,
    [Date of Transfer] DATE,
    [Postcode] VARCHAR(10),
    [Property Type] CHAR(1),
    [Old_New] CHAR(1),
    [PAON] VARCHAR(100),
    [Street] VARCHAR(150),
    [Locality] VARCHAR(100),
    [Town] VARCHAR(100),
    [District] VARCHAR(100),
    [County] VARCHAR(100)
);

-- inserir os dados
INSERT INTO ShortPricePaidData2025
SELECT
    [Transaction unique identifier],
    [Price],
    [Date of Transfer],
    [Postcode],
    [Property Type],
    [Old/New] AS [Old_New],
    [PAON],
    [Street],
    [Locality],
    [Town/City] AS [Town],
    [District],
    [County]
FROM PricePaidData2025;

INSERT INTO ShortPricePaidData2024
SELECT
    [Transaction unique identifier],
    [Price],
    [Date of Transfer],
    [Postcode],
    [Property Type],
    [Old/New] AS [Old_New],
    [PAON],
    [Street],
    [Locality],
    [Town/City] AS [Town],
    [District],
    [County]
FROM PricePaidData2024;

-- ver numero de linhas (tuplos)
SELECT FORMAT(COUNT(*), 'N0') AS [2025RowCount] FROM ShortPricePaidData2025
SELECT FORMAT(COUNT(*), 'N0') AS [2024RowCount]FROM ShortPricePaidData2024

SELECT TOP 100 * FROM ShortPricePaidData2025
SELECT TOP 100 * FROM ShortPricePaidData2024
