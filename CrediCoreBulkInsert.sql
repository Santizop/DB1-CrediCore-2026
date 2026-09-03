use CrediCore

CREATE TABLE #CreditosTemp
(
    IdCliente INT,
    IdVehiculo INT,
    MontoOtorgado DECIMAL(18,2),
    TasaInteres DECIMAL(10,2)
);

BULK INSERT #CreditosTemp
FROM '/var/opt/mssql/data/Creditos2k.txt'
WITH
(
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

INSERT INTO Operaciones.Creditos
(
    IdCliente,
    IdVehiculo,
    MontoOtorgado,
    TasaInteres
)
SELECT
    IdCliente,
    IdVehiculo,
    MontoOtorgado,
    TasaInteres
FROM #CreditosTemp;

use CrediCore;
SELECT TOP 10 * FROM Operaciones.Creditos;
SELECT * FROM Operaciones.Creditos;