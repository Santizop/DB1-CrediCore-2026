USE CrediCore;

-- Me di cuenta que en la tabla creditos solo tengo el MontoOtorgado mas no una columna que lleve el saldo actual,
-- Por eso la modificacion a la tabla para poder tener el view.

ALTER TABLE Operaciones.Creditos
ADD SaldoActual DECIMAL(18,2);

UPDATE Operaciones.Creditos
SET SaldoActual = MontoOtorgado

SELECT * FROM Operaciones.Creditos;

CREATE VIEW VW_AtencionAlCliente AS
SELECT
	C.PrimerNombre + ' ' + C.PrimerApellido AS NombreCompleto,
	Cr.IdCredito AS NumeroCredito,
	V.Marca AS MarcaVehiculo,
	Cr.Estado AS EstadoDeCredito,
	Cr.SaldoActual AS SaldoActual
FROM Operaciones.Creditos Cr
INNER JOIN Operaciones.Clientes C ON Cr.IdCliente = C.IdCliente
INNER JOIN Garantias.Vehiculos V ON Cr.IdVehiculo = V.IdVehiculo;

CREATE TABLE Operaciones.HistorialPagos(
	IdPago INT IDENTITY(1, 1) PRIMARY KEY,
	IdCredito INT NOT NULL,
	MontoAbono DECIMAL(18,2) NOT NULL CHECK(MontoAbono > 0),
	FechaPago DATETIME NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY (IdCredito) REFERENCES Operaciones.Creditos(IdCredito)
);

CREATE PROCEDURE SP_ProcesarPago
	@IdCredito INT,
	@MontoAbono DECIMAL(18,2)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SaldoExistente DECIMAL(18,2);
	
	BEGIN TRY
		BEGIN TRANSACTION;
	
		SELECT @SaldoExistente = SaldoActual
		FROM Operaciones.Creditos
		WHERE IdCredito = @IdCredito;
		
		IF @SaldoExistente IS NULL
		BEGIN
			RAISERROR('El credito especificado no existe', 16, 1);
		END
		
		IF @MontoAbono > @SaldoExistente
		BEGIN
			RAISERROR('El monto abonado excede el saldo actual del credito', 16 ,1);
		END
		
		INSERT INTO Operaciones.HistorialPagos(IdCredito, MontoAbono)
		VALUES (@IdCredito, @MontoAbono);
		
		UPDATE Operaciones.Creditos
		SET SaldoActual = SaldoActual - @MontoAbono
		WHERE IdCredito = @IdCredito;
		
		COMMIT TRANSACTION;
		PRINT 'Pago procesado exitosamente';
	
	END TRY
	BEGIN CATCH
	
		IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;

        THROW;
		
	END CATCH
END

CREATE TABLE Operaciones.Logs_Creditos(
	IdLog INT IDENTITY(1,1) PRIMARY KEY,
	Accion VARCHAR(50) NOT NULL,
	ValorAnterior DECIMAL(18,2) NOT NULL,
	ValorNuevo DECIMAL(18,2) NOT NULL,
	FechaHora DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TRIGGER Operaciones.TR_Auditoria_Creditos
ON Operaciones.Creditos
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Operaciones.Logs_Creditos (Accion, ValorAnterior, ValorNuevo)
	SELECT
		'Modificacion manual de TasaInteres',
		d.TasaInteres,
		i.TasaInteres
	FROM inserted i
	INNER JOIN deleted d ON i.IdCredito = d.IdCredito
	WHERE i.TasaInteres <> d.TasaInteres;
END

SELECT * FROM VW_AtencionAlCliente

EXEC SP_ProcesarPago
	@IdCredito = 2,
	@MontoAbono = 20000.00;

SELECT IdCredito, MontoOtorgado, SaldoActual
FROM Operaciones.Creditos
WHERE IdCredito = 2

SELECT * FROM Operaciones.HistorialPagos

SELECT TasaInteres FROM Operaciones.Creditos WHERE IdCredito = 4;

UPDATE Operaciones.Creditos SET TasaInteres = 15.00 WHERE IdCredito = 4;

SELECT * FROM Operaciones.Logs_Creditos;
