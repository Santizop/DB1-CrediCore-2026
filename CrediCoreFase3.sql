USE CrediCore

ALTER TABLE Operaciones.Creditos
ADD CONSTRAINT Fk_Creditos_Clientes
FOREIGN KEY (IdCliente)
REFERENCES Operaciones.Clientes (IdCliente);

ALTER TABLE Operaciones.Creditos
ADD CONSTRAINT Fk_Creditos_Vehiculos
FOREIGN KEY (IdVehiculo)
REFERENCES Garantias.Vehiculos (IdVehiculo);

DELETE FROM Operaciones.Clientes
WHERE IdCliente = 10

SELECT 
    c.PrimerNombre,
    c.PrimerApellido,
    c.Telefono,
    v.Marca,
    v.NumPlaca,
    cr.MontoOtorgado,
    cr.Estado
FROM Operaciones.Creditos cr
INNER JOIN Garantias.Vehiculos v ON cr.IdVehiculo = v.IdVehiculo
INNER JOIN Operaciones.Clientes c ON cr.IdCliente = c.IdCliente;

SELECT
	C.PrimerNombre,
	C.PrimerApellido,
	C.Telefono
FROM Operaciones.Clientes C
LEFT JOIN Operaciones.Creditos Cr ON C.IdCliente = Cr.IdCliente
WHERE Cr.IdCredito IS NULL;

SELECT
	C.PrimerNombre,
	C.PrimerApellido,
	Cr.MontoOtorgado
FROM Operaciones.Creditos Cr
INNER JOIN Operaciones.Clientes C ON Cr.IdCliente = C.IdCliente
WHERE Cr.MontoOtorgado > (SELECT AVG(MontoOtorgado) FROM Operaciones.Creditos) 

SELECT
	C.PrimerNombre,
	C.PrimerApellido,
	Cr.IdCredito
FROM Operaciones.Creditos Cr
INNER JOIN Operaciones.Clientes C ON Cr.IdCliente = C.IdCliente
WHERE Cr.IdVehiculo IN (SELECT IdVehiculo FROM Garantias.Vehiculos WHERE AnioVehiculo <= 2011)