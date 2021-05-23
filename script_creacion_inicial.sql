USE GD1C2021;
GO

-- Eliminacion de objetos preexistentes

IF OBJECT_ID('SPARK.CIUDAD','U') IS NOT NULL
  DROP TABLE SPARK.CIUDAD;

IF OBJECT_ID('SPARK.SUCURSAL','U') IS NOT NULL
  DROP TABLE SPARK.SUCURSAL;

IF OBJECT_ID('SPARK.CLIENTE','U') IS NOT NULL
  DROP TABLE SPARK.CLIENTE;

IF OBJECT_ID('SPARK.FACTURA','U') IS NOT NULL
  DROP TABLE SPARK.FACTURA;

IF OBJECT_ID('SPARK.DETALLE_FACTURA','U') IS NOT NULL
  DROP TABLE SPARK.DETALLE_FACTURA;

IF OBJECT_ID('SPARK.COMPRA','U') IS NOT NULL
  DROP TABLE SPARK.COMPRA;

IF OBJECT_ID('SPARK.ITEM_COMPRA','U') IS NOT NULL
  DROP TABLE SPARK.ITEM_COMPRA;

IF OBJECT_ID('SPARK.PRODUCTO','U') IS NOT NULL
  DROP TABLE SPARK.PRODUCTO;

IF OBJECT_ID('SPARK.PC','U') IS NOT NULL
  DROP TABLE SPARK.PC;

IF OBJECT_ID('SPARK.ACCESORIO','U') IS NOT NULL
  DROP TABLE SPARK.ACCESORIO;

IF OBJECT_ID('SPARK.MICROPROCESADOR','U') IS NOT NULL
  DROP TABLE SPARK.MICROPROCESADOR;

IF OBJECT_ID('SPARK.PLACA_VIDEO','U') IS NOT NULL
  DROP TABLE SPARK.PLACA_VIDEO;

IF OBJECT_ID('SPARK.DISCO_RIGIDO','U') IS NOT NULL
  DROP TABLE SPARK.DISCO_RIGIDO;

IF OBJECT_ID('SPARK.MEMORIA_RAM','U') IS NOT NULL
  DROP TABLE SPARK.MEMORIA_RAM;

IF EXISTS (SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'SPARK')
  DROP SCHEMA SPARK

GO

-- Creacion del esquema

CREATE SCHEMA SPARK;
GO

-- Creacion de las tablas

CREATE TABLE SPARK.CIUDAD (
CIUDAD_ID INT IDENTITY(1,1) PRIMARY KEY,
CIUDAD NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.DISCO_RIGIDO (
DISCO_ID NVARCHAR(255) PRIMARY KEY,
DISCO_TIPO NVARCHAR(255) NOT NULL,
DISCO_CAPACIDAD NVARCHAR(255) NOT NULL,
DISCO_VELOCIDAD NVARCHAR(255) NOT NULL,
DISCO_FABRICANTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.MEMORIA_RAM (
MEMORIA_ID NVARCHAR(255) PRIMARY KEY,
MEMORIA_TIPO NVARCHAR(255) NOT NULL,
MEMORIA_CAPACIDAD NVARCHAR(255) NOT NULL,
MEMORIA_VELOCIDAD NVARCHAR(255) NOT NULL,
MEMORIA_FABRICANTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.MICROPROCESADOR (
MICRO_ID NVARCHAR(255) PRIMARY KEY,
MICRO_CACHE NVARCHAR(255) NOT NULL,
MICRO_CANT_HILOS NVARCHAR(255) NOT NULL,
MICRO_VELOCIDAD NVARCHAR(255) NOT NULL,
MICRO_FABRICANTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.PLACA_VIDEO (
PLACA_ID NVARCHAR(255) PRIMARY KEY,
PLACA_MODELO NVARCHAR(255) NOT NULL,
PLACA_VELOCIDAD NVARCHAR(255) NOT NULL,
PLACA_CAPACIDAD NVARCHAR(255) NOT NULL,
PLACA_FABRICANTE NVARCHAR(255) NOT NULL);





-- Migracion

-- CIUDAD

INSERT SPARK.CIUDAD
SELECT DISTINCT CIUDAD FROM gd_esquema.Maestra;

-- DISCO_RIGIDO

INSERT SPARK.DISCO_RIGIDO
SELECT DISTINCT DISCO_RIGIDO_CODIGO,
DISCO_RIGIDO_TIPO,
DISCO_RIGIDO_CAPACIDAD,
DISCO_RIGIDO_VELOCIDAD,
DISCO_RIGIDO_FABRICANTE
FROM gd_esquema.Maestra
WHERE DISCO_RIGIDO_CODIGO IS NOT NULL;

-- MEMORIA_RAM

INSERT SPARK.MEMORIA_RAM
SELECT DISTINCT MEMORIA_RAM_CODIGO,
MEMORIA_RAM_TIPO,
MEMORIA_RAM_CAPACIDAD,
MEMORIA_RAM_VELOCIDAD,
MEMORIA_RAM_FABRICANTE
FROM gd_esquema.Maestra
WHERE MEMORIA_RAM_CODIGO IS NOT NULL;

-- MICROPROCESADOR

INSERT SPARK.MICROPROCESADOR
SELECT DISTINCT MICROPROCESADOR_CODIGO,
MICROPROCESADOR_CACHE ,
MICROPROCESADOR_CANT_HILOS ,
MICROPROCESADOR_VELOCIDAD ,
MICROPROCESADOR_FABRICANTE
FROM gd_esquema.Maestra
WHERE MICROPROCESADOR_CODIGO IS NOT NULL;

-- PLACA_VIDEO

INSERT SPARK.PLACA_VIDEO
SELECT DISTINCT PLACA_VIDEO_CHIPSET,
PLACA_VIDEO_MODELO,
PLACA_VIDEO_VELOCIDAD,
PLACA_VIDEO_CAPACIDAD,
PLACA_VIDEO_FABRICANTE
FROM gd_esquema.Maestra
WHERE PLACA_VIDEO_CHIPSET IS NOT NULL;
