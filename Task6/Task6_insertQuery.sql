--Dirty Read
-- (1)
BEGIN TRANSACTION;
INSERT INTO ShortPricePaidData2025
(
	[Transaction unique identifier],
	Price,
	[Date of Transfer],
	Postcode,
	[Property Type],
	Old_New,
	PAON,
	Street,
	Locality,
	Town,
	District,
	County
)
VALUES
(
	'test_transaction',
	99999999999,
	'1999-01-01',
	'TEST',
	'D',
	'Y',
	'123',
	'TestStreet',
	'TestLocality',
	'Barreiro',
	'TestDistrict',
	'TestCounty'
)


-- (3)
-- nao fazer commit da primeira vez (correr so ate ao final do INSERT)
COMMIT;
-- (4)
-- se este select nao estiver a 0 entao continuar a fazer commit
SELECT @@TRANCOUNT;


-- (6)
-- apagar os registos de teste
DELETE
FROM ShortPricePaidData2025
WHERE [Transaction unique identifier] LIKE 'test%';


-- Non-Repeatable Read
-- (2) & (5)
SELECT @@TRANCOUNT; -- deve dar 0
UPDATE ShortPricePaidData2025
SET price = price + 10000
WHERE locality = 'KILMERSDON';
-- Nota se for a execucao (5) vai ficar bloqueada o que é suposto

