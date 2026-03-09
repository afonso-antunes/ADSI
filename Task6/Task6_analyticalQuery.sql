-- Dirty Read
-- (2)
-- fazer primeiro este bloco quando nao se deu commit na outra window
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO

SELECT locality, AVG(price) AS average_new_property_price
FROM ShortPricePaidData2025
GROUP BY locality
ORDER BY average_new_property_price DESC
---

-- Solucionar Dirty Read
-- (5)
-- fazer este bloco quando se deu commit na outra window e SELECT @@TRANCOUNT está igual a 0
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

SELECT locality, AVG(price) AS average_new_property_price
FROM ShortPricePaidData2025
GROUP BY locality
ORDER BY average_new_property_price DESC
---

-- Non-Repeatable Read
-- (1)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRANSACTION;

SELECT @@TRANCOUNT;  -- deve dar 1

SELECT AVG(price) AS avg_price_before_update
FROM ShortPricePaidData2025
WHERE locality = 'KILMERSDON';
-- correr (1) ate aqui

-- (3)
-- correr desde o SELECT AVG() ate ao commit
COMMIT;

-- Uma transação lê uma linha duas vezes e obtém valores diferentes porque outra transação modificou essa linha entre as duas leituras.

-- solucionar Non-repeatable read
-- (4)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION;

SELECT AVG(price) AS avg_price_before_update
FROM ShortPricePaidData2025
WHERE locality = 'KILMERSDON';

-- parar aqui e tentar correr o UPDATE na outra janela
-- correr com o commit e verificar que o valor é igual
COMMIT;
-- o commit vai desbloquear o update do outro lado
