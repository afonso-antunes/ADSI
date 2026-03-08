SELECT 
	p24.district,
	p24.avg_price AS avg_2024,
	p25.avg_price AS avg_2025
FROM ( 
	SELECT 
		district, 
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2024
	GROUP BY district
) p24
JOIN ( 
	SELECT 
		district,
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2025
	GROUP BY district
) p25
ON p24.district = p25.district
WHERE p25.avg_price > p24.avg_price;
-- Default:
-- Estimated Subtree Cost = 36.2393
-- Merge Join
-- Hash Aggregate


--HASH JOIN
--LOOP JOIN
--MERGE JOIN
--HASH GROUP
--ORDER GROUP

SELECT 
	p24.district,
	p24.avg_price AS avg_2024,
	p25.avg_price AS avg_2025
FROM ( 
	SELECT 
		district, 
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2024
	GROUP BY district
) p24
JOIN ( 
	SELECT 
		district,
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2025
	GROUP BY district
) p25
ON p24.district = p25.district
WHERE p25.avg_price > p24.avg_price
OPTION (HASH JOIN, HASH GROUP);
-- Estimated Subtree Cost = 36.2413
-- hash Join
-- Hash Aggregate

SELECT 
	p24.district,
	p24.avg_price AS avg_2024,
	p25.avg_price AS avg_2025
FROM ( 
	SELECT 
		district, 
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2024
	GROUP BY district
) p24
JOIN ( 
	SELECT 
		district,
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2025
	GROUP BY district
) p25
ON p24.district = p25.district
WHERE p25.avg_price > p24.avg_price
OPTION (HASH JOIN, ORDER GROUP);
-- Estimated Subtree Cost = 183.478
-- hash Join
-- Stream Aggregate

SELECT 
	p24.district,
	p24.avg_price AS avg_2024,
	p25.avg_price AS avg_2025
FROM ( 
	SELECT 
		district, 
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2024
	GROUP BY district
) p24
JOIN ( 
	SELECT 
		district,
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2025
	GROUP BY district
) p25
ON p24.district = p25.district
WHERE p25.avg_price > p24.avg_price
OPTION (LOOP JOIN, HASH GROUP);
-- Estimated Subtree Cost = 39.3675
-- Nested loops
-- Hash Match


SELECT 
	p24.district,
	p24.avg_price AS avg_2024,
	p25.avg_price AS avg_2025
FROM ( 
	SELECT 
		district, 
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2024
	GROUP BY district
) p24
JOIN ( 
	SELECT 
		district,
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2025
	GROUP BY district
) p25
ON p24.district = p25.district
WHERE p25.avg_price > p24.avg_price
OPTION (LOOP JOIN, ORDER GROUP);
-- Estimated Subtree Cost = 183.979
-- Nested loops
-- stream aggregate


SELECT 
	p24.district,
	p24.avg_price AS avg_2024,
	p25.avg_price AS avg_2025
FROM ( 
	SELECT 
		district, 
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2024
	GROUP BY district
) p24
JOIN ( 
	SELECT 
		district,
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2025
	GROUP BY district
) p25
ON p24.district = p25.district
WHERE p25.avg_price > p24.avg_price
OPTION (MERGE JOIN, HASH GROUP);
-- Estimated Subtree Cost = 36.2393
-- Merge join
-- hash match


SELECT 
	p24.district,
	p24.avg_price AS avg_2024,
	p25.avg_price AS avg_2025
FROM ( 
	SELECT 
		district, 
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2024
	GROUP BY district
) p24
JOIN ( 
	SELECT 
		district,
		AVG(CAST(price AS BIGINT)) AS avg_price
	FROM PricePaidData2025
	GROUP BY district
) p25
ON p24.district = p25.district
WHERE p25.avg_price > p24.avg_price
OPTION (MERGE JOIN, ORDER GROUP);
-- Estimated Subtree Cost = 183.433
-- Merge join
-- stream aggregate
