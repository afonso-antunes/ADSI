--DROP TABLE IF EXISTS PartitionedPricePaidData2025;

--DROP PARTITION SCHEME CountyPartitionScheme;

--DROP PARTITION FUNCTION CountyPartitionFunction;

SELECT locality, AVG(price) AS average_new_property_price
FROM ShortPricePaidData2025
WHERE town = 'London'
AND Old_New = 'Y'
GROUP BY locality
ORDER BY average_new_property_price DESC;
-- Sem indexes:
-- Estimated Subtree Cost = 12.4505
-- Table Scan

CREATE NONCLUSTERED INDEX idx_town_oldnew
ON ShortPricePaidData2025 (Town, Old_New);
-- Estimated Subtree Cost = 5.77163
-- index seek NonClustered
DROP INDEX idx_town_oldnew
ON ShortPricePaidData2025;

CREATE NONCLUSTERED INDEX idx_query_optimization
ON ShortPricePaidData2025 (Town, Old_New)
INCLUDE (Locality, Price);
-- Estimated Subtree Cost = 0.0763251
-- index seek NonClustered
DROP INDEX idx_query_optimization
ON ShortPricePaidData2025;

CREATE NONCLUSTERED INDEX idx_locality_price
ON ShortPricePaidData2025 (Locality, Price);
-- Estimated Subtree Cost = 12.456
-- Table scan
-- Ou seja o index com estas variaveis nao ajuda e o SQL Server faz table scan
DROP INDEX idx_locality_price
ON ShortPricePaidData2025;
