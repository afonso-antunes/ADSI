SELECT distinct county FROM ShortPricePaidData2025

-- divide em 4 particoes com counties a comecar com A-G numa particao e por ai adiante
CREATE PARTITION FUNCTION CountyPartitionFunction (VARCHAR(100))
AS RANGE LEFT FOR VALUES ('G','M','S');

-- Criar Schema
CREATE PARTITION SCHEME CountyPartitionScheme
AS PARTITION CountyPartitionFunction
ALL TO ([PRIMARY]);

-- criar a tabela de particoes atraves do schema
CREATE TABLE PartitionedPricePaidData2025 (
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
)
ON CountyPartitionScheme([County]);

--inserir os dados
INSERT INTO PartitionedPricePaidData2025
SELECT *
FROM ShortPricePaidData2025;

-- mostrar quantos registos estao em cada particao
SELECT 
    $PARTITION.CountyPartitionFunction(County) AS PartitionNumber,
    COUNT(*) AS NumberOfRecords
FROM PartitionedPricePaidData2025
GROUP BY $PARTITION.CountyPartitionFunction(County)
ORDER BY PartitionNumber;
