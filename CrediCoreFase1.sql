-- Creacion de la base de datos
CREATE DATABASE CrediCore;

USE CrediCore;

-- Esquemas para mejor administracion
CREATE SCHEMA Operaciones;
CREATE SCHEMA Garantias;

-- Tabla de los clientes
CREATE TABLE Operaciones.Clientes (
	IdCliente INT IDENTITY(1,1) PRIMARY KEY,
	PrimerNombre NVARCHAR(50) NOT NULL,
	SegundoNombre NVARCHAR(50) NULL,
	PrimerApellido NVARCHAR(50) NOT NULL,
	SegundoApellido NVARCHAR(50) NULL,
	FechaNacimiento DATE  NOT NULL,
	DPI VARCHAR(13) NOT NULL UNIQUE,
	Telefono VARCHAR(20) NULL,
	Correo VARCHAR(100) NULL UNIQUE
		CHECK(Correo is NULL OR Correo LIKE '%_@_%._%'), -- Le puse una expresion regular para verificar que se este escribiendo un correo
	FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
	Estado VARCHAR(20) NOT NULL DEFAULT('Activo')
);

-- Tabla de Vehiculos como garantia
CREATE TABLE Garantias.Vehiculos (
	IdVehiculo INT IDENTITY(1,1) PRIMARY KEY,
	Marca VARCHAR(50) NOT NULL,
	Modelo VARCHAR(100) NOT NULL,
	Color VARCHAR(50) NOT NULL,
	NumTitulo VARCHAR(50) NOT NULL,
	AnioVehiculo INT NOT NULL CHECK(AnioVehiculo >= 2011),
	NumPlaca Varchar(20) NOT NULL UNIQUE
);

-- Ultima tabal del script Creditos
CREATE TABLE Operaciones.Creditos (
	IdCredito INT IDENTITY(1,1) PRIMARY KEY,
	IdCliente INT NOT NULL,
	IdVehiculo INT NOT NULL,
	MontoOtorgado DECIMAL(18,2) NOT NULL CHECK(MontoOtorgado >= 1000),
	TasaInteres DECIMAL(5,2) NOT NULL CHECK (TasaInteres >= 0),
	Estado VARCHAR(20) NOT NULL DEFAULT('Activo'),
	FechaDesembolso DATETIME NOT NULL DEFAULT GETDATE()
);
