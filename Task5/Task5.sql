--1
WITH p24 AS (
	SELECT DISTINCT 
		county, 
		PAON, 
		street, 
		town
	FROM ShortPricePaidData2024
),
p25 AS (
	SELECT DISTINCT 
	county,
	PAON,
	street,
	town
	FROM ShortPricePaidData2025
)
SELECT 
	p24.county,
	COUNT(*) AS properties_sold_both_years
FROM p24 
JOIN p25
	ON p24.county = p25.county
		AND p24.PAON = p25.PAON
		AND p24.street = p25.street
		AND p24.town = p25.town
GROUP BY p24.county;
-- stream aggregate
-- merge join
-- table scan
-- Estimated Subtree Cost = 107.28

--2
SELECT 
	p24.county,
	COUNT(*) AS properties_sold_both_years
FROM (
	SELECT  
		county, 
		PAON, 
		street, 
		town 
	FROM ShortPricePaidData2024
) AS p24
JOIN (
	SELECT
		county,
		PAON,
		street,
		town 
	FROM ShortPricePaidData2025
) AS p25
ON p24.county = p25.county
		AND p24.PAON = p25.PAON
		AND p24.street = p25.street
		AND p24.town = p25.town
GROUP BY p24.county;
-- Estimated Subtree Cost = 76.0139


--3
SELECT 
    p24.county,
    COUNT(*) AS properties_sold_both_years
FROM (
    SELECT DISTINCT 
        county,
        PAON,
        street,
        town 
    FROM ShortPricePaidData2024
) AS p24
WHERE EXISTS (
    SELECT *
    FROM ShortPricePaidData2025 p25
    WHERE p25.county = p24.county
      AND p25.PAON = p24.PAON
      AND p25.street = p24.street
      AND p25.town = p24.town
)
GROUP BY p24.county;
-- Estimated Subtree Cost = 106.522

--4
SELECT 
    p24.county,
    COUNT(*) AS properties_sold_both_years
FROM (
    SELECT 
        county,
        PAON,
        street,
        town 
    FROM ShortPricePaidData2024
    GROUP BY county, PAON, street, town
) p24
JOIN (
    SELECT 
        county,
        PAON,
        street,
        town 
    FROM ShortPricePaidData2025
    GROUP BY county, PAON, street, town
) p25
ON p24.county = p25.county
	AND p24.PAON = p25.PAON
	AND p24.street = p25.street
	AND p24.town = p25.town
GROUP BY p24.county;
-- Estimated Subtree Cost = 107.28


--5
SELECT 
    county,
    COUNT(*) AS properties_sold_both_years
FROM (
    SELECT DISTINCT 
        p24.county,
        p24.PAON,
        p24.street,
        p24.town
    FROM ShortPricePaidData2024 p24
    JOIN ShortPricePaidData2025 p25
      ON p24.county = p25.county
     AND p24.PAON = p25.PAON
     AND p24.street = p25.street
     AND p24.town = p25.town
) t
GROUP BY county;
-- Estimated Subtree Cost = 108.66


--6
SELECT county, COUNT(*) AS properties_sold_both_years
FROM (
    SELECT county, PAON, street, town, COUNT(*) AS c
    FROM (
        SELECT county, PAON, street, town
        FROM ShortPricePaidData2024

        UNION ALL

        SELECT county, PAON, street, town
        FROM ShortPricePaidData2025
    ) t
    GROUP BY county, PAON, street, town
    HAVING COUNT(*) = 2
) x
GROUP BY county;
-- Estimated Subtree Cost = 107.891


--7
SELECT 
    p24.county,
    COUNT(*) AS properties_sold_both_years
FROM (
    SELECT DISTINCT 
        county,
        HASHBYTES('SHA1', county + PAON + street + town) AS property_hash
    FROM ShortPricePaidData2024
) p24
JOIN (
    SELECT DISTINCT 
        county,
        HASHBYTES('SHA1', county + PAON + street + town) AS property_hash
    FROM ShortPricePaidData2025
) p25
ON p24.property_hash = p25.property_hash
GROUP BY p24.county;
-- Estimated Subtree Cost = 5092.37 lol


--8
SELECT 
	A.county,
	COUNT(*) AS properties_sold_both_years
FROM (
	SELECT  
		county, 
		PAON, 
		street, 
		town 
	FROM ShortPricePaidData2024

	INTERSECT

	SELECT
		county,
		PAON,
		street,
		town 
	FROM ShortPricePaidData2025
) as A
GROUP BY A.county;
-- Estimated Subtree Cost = 106.522
-- melhor

--A query utilizando o operador INTERSECT apresenta uma pequena redução no Estimated Subtree Cost, passando de 112 para 111. 
--Embora a melhoria seja reduzida, a nova versão simplifica a estrutura da query, eliminando a necessidade de duas operações DISTINCT, de um JOIN explícito e dois CTEs. 
--A melhoria limitada ocorre porque o maior custo da execução está associado à leitura completa das tabelas (Table Scan), que são relativamente grandes.
--Assim, mesmo com a reescrita da query, o SQL Server continua a ter de ler a maioria dos dados, o que mantém o custo estimado global bastante semelhante
-- Para reduzir o tempo seria necessário a criação de um index