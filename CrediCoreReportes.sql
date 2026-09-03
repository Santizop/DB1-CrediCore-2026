USE CrediCore;

SELECT
	Estado,
	SUM(MontoOtorgado) AS TotalCapitalPrestado,
	AVG(TasaInteres) AS PromedioIntereses
FROM Operaciones.Creditos
GROUP BY Estado;

SELECT
	v.Marca,
	COUNT(c.IdVehiculo) AS PrestamosOtorgados
FROM Operaciones.Creditos c
INNER JOIN Garantias.Vehiculos v ON c.IdVehiculo = v.IdVehiculo
GROUP BY v.Marca
HAVING COUNT(c.IdVehiculo) > 50;

SELECT 'Presto Mayor Capital' AS TipoReport, * FROM Operaciones.Creditos
WHERE MontoOtorgado = (SELECT MAX(MontoOtorgado) FROM Operaciones.Creditos)

SELECT 'Prestamo Menor Capital' AS TipoReporte, * FROM Operaciones.Creditos
WHERE MontoOtorgado = (SELECT MIN(MontoOtorgado) FROM Operaciones.Creditos)