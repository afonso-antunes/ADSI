WITH p24 AS (
	SELECT DISTINCT 
		county, 
		PAON, 
		street, 
		[Town/City] as city
	FROM PricePaidData2024
),
p25 AS (
	SELECT DISTINCT 
	county,
	PAON,
	street,
	[Town/City] as city
	FROM PricePaidData2025
)
SELECT 
	p24.county,
	COUNT(*) AS properties_sold_both_years
FROM p24 
JOIN p25
	ON p24.county = p25.county
		AND p24.PAON = p25.PAON
		AND p24.street = p25.street
		AND p24.city = p25.city
GROUP BY p24.county;
-- stream aggregate
-- merge join
-- table scan
-- Estimated Subtree Cost = 112.109


SELECT 
	p24.county,
	COUNT(*) AS properties_sold_both_years
FROM (
	SELECT  
		county, 
		PAON, 
		street, 
		[Town/City] as city
	FROM PricePaidData2024
) AS p24
JOIN (
	SELECT
		county,
		PAON,
		street,
		[Town/City] as city
	FROM PricePaidData2025
) AS p25
ON p24.county = p25.county
		AND p24.PAON = p25.PAON
		AND p24.street = p25.street
		AND p24.city = p25.city
GROUP BY p24.county;
-- Estimated Subtree Cost = 132.135
-- pior


SELECT 
    p24.county,
    COUNT(*) AS properties_sold_both_years
FROM (
    SELECT DISTINCT 
        county,
        PAON,
        street,
        [Town/City] AS city
    FROM PricePaidData2024
) AS p24
WHERE EXISTS (
    SELECT *
    FROM PricePaidData2025 p25
    WHERE p25.county = p24.county
      AND p25.PAON = p24.PAON
      AND p25.street = p24.street
      AND p25.[Town/City] = p24.city
)
GROUP BY p24.county;
-- Estimated Subtree Cost = 111.351
-- melhor

SELECT 
    p24.county,
    COUNT(*) AS properties_sold_both_years
FROM (
    SELECT 
        county,
        PAON,
        street,
        [Town/City] AS city
    FROM PricePaidData2024
    GROUP BY county, PAON, street, [Town/City]
) p24
JOIN (
    SELECT 
        county,
        PAON,
        street,
        [Town/City] AS city
    FROM PricePaidData2025
    GROUP BY county, PAON, street, [Town/City]
) p25
ON p24.county = p25.county
	AND p24.PAON = p25.PAON
	AND p24.street = p25.street
	AND p24.city = p25.city
GROUP BY p24.county;
-- Estimated Subtree Cost = 112.109

SELECT 
    county,
    COUNT(*) AS properties_sold_both_years
FROM (
    SELECT DISTINCT 
        p24.county,
        p24.PAON,
        p24.street,
        p24.[Town/City]
    FROM PricePaidData2024 p24
    JOIN PricePaidData2025 p25
      ON p24.county = p25.county
     AND p24.PAON = p25.PAON
     AND p24.street = p25.street
     AND p24.[Town/City] = p25.[Town/City]
) t
GROUP BY county;
-- Estimated Subtree Cost = 164.778
-- é mais rapida a correr mas pior em subtree cost

SELECT county, COUNT(*) AS properties_sold_both_years
FROM (
    SELECT county, PAON, street, [Town/City], COUNT(*) AS c
    FROM (
        SELECT county, PAON, street, [Town/City]
        FROM PricePaidData2024

        UNION ALL

        SELECT county, PAON, street, [Town/City]
        FROM PricePaidData2025
    ) t
    GROUP BY county, PAON, street, [Town/City]
    HAVING COUNT(*) = 2
) x
GROUP BY county;
-- Estimated Subtree Cost = 112.72


SELECT 
    p24.county,
    COUNT(*) AS properties_sold_both_years
FROM (
    SELECT DISTINCT 
        county,
        HASHBYTES('SHA1', county + PAON + street + [Town/City]) AS property_hash
    FROM PricePaidData2024
) p24
JOIN (
    SELECT DISTINCT 
        county,
        HASHBYTES('SHA1', county + PAON + street + [Town/City]) AS property_hash
    FROM PricePaidData2025
) p25
ON p24.property_hash = p25.property_hash
GROUP BY p24.county;
-- Estimated Subtree Cost = 5092.37 lol



SELECT 
	A.county,
	COUNT(*) AS properties_sold_both_years
FROM (
	SELECT  
		county, 
		PAON, 
		street, 
		[Town/City] as city
	FROM PricePaidData2024

	INTERSECT

	SELECT
		county,
		PAON,
		street,
		[Town/City] as city
	FROM PricePaidData2025
) as A
GROUP BY A.county;
-- Estimated Subtree Cost = 111.351
-- melhor

--A query utilizando o operador INTERSECT apresenta uma pequena redução no Estimated Subtree Cost, passando de 112 para 111. 
--Embora a melhoria seja reduzida, a nova versão simplifica a estrutura da query, eliminando a necessidade de duas operações DISTINCT, de um JOIN explícito e dois CTEs. 
--A melhoria limitada ocorre porque o maior custo da execução está associado à leitura completa das tabelas (Table Scan), que são relativamente grandes.
--Assim, mesmo com a reescrita da query, o SQL Server continua a ter de ler a maioria dos dados, o que mantém o custo estimado global bastante semelhante
-- Para reduzir o tempo seria necessário a criação de um index


