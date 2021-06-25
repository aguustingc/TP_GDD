USE GD1C2021;
GO

-- Eliminacion de objetos preexistentes

IF OBJECT_ID('SPARK.DETALLE_FACTURA','U') IS NOT NULL
  DROP TABLE SPARK.DETALLE_FACTURA;

IF OBJECT_ID('SPARK.FACTURA','U') IS NOT NULL
  DROP TABLE SPARK.FACTURA;

IF OBJECT_ID('SPARK.ITEM_COMPRA','U') IS NOT NULL
  DROP TABLE SPARK.ITEM_COMPRA;

IF OBJECT_ID('SPARK.COMPRA','U') IS NOT NULL
  DROP TABLE SPARK.COMPRA;

IF OBJECT_ID('SPARK.CLIENTE','U') IS NOT NULL
  DROP TABLE SPARK.CLIENTE;

IF OBJECT_ID('SPARK.SUCURSAL','U') IS NOT NULL
  DROP TABLE SPARK.SUCURSAL;

IF OBJECT_ID('SPARK.CIUDAD','U') IS NOT NULL
  DROP TABLE SPARK.CIUDAD;

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
CIUDAD_NOMBRE NVARCHAR(255) NOT NULL);


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
MICRO_CANT_HILOS DECIMAL(18,0) NOT NULL,
MICRO_VELOCIDAD NVARCHAR(255) NOT NULL,
MICRO_FABRICANTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.PLACA_VIDEO (
PLACA_ID NVARCHAR(50) PRIMARY KEY,
PLACA_MODELO NVARCHAR(50) NOT NULL,
PLACA_VELOCIDAD NVARCHAR(255) NOT NULL,
PLACA_CAPACIDAD NVARCHAR(255) NOT NULL,
PLACA_FABRICANTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.CLIENTE (
CLIENTE_ID INT IDENTITY(1,1) PRIMARY KEY,
CLIENTE_DNI DECIMAL(18,0), 
CLIENTE_APELLIDO NVARCHAR(255) NOT NULL, 
CLIENTE_NOMBRE NVARCHAR(255) NOT NULL, 
CLIENTE_DIRECCION NVARCHAR(255) NOT NULL, 
CLIENTE_FECHA_NACIMIENTO DATETIME2(3) NOT NULL, 
CLIENTE_MAIL NVARCHAR(255) NOT NULL, 
CLIENTE_TELEFONO INT NOT NULL);

CREATE TABLE SPARK.SUCURSAL (
SUCURSAL_ID INT IDENTITY(1,1) PRIMARY KEY,
SUCURSAL_CIUDAD INT NOT NULL FOREIGN KEY REFERENCES SPARK.CIUDAD(CIUDAD_ID),
SUCURSAL_DIR NVARCHAR(255) NOT NULL,
SUCURSAL_MAIL NVARCHAR(255) NOT NULL,
SUCURSAL_TELEFONO DECIMAL(18,0) NOT NULL);

CREATE TABLE SPARK.COMPRA (
COMPRA_ID NVARCHAR(255) PRIMARY KEY,
COMPRA_SUCURSAL INT NOT NULL FOREIGN KEY REFERENCES SPARK.SUCURSAL(SUCURSAL_ID),
COMPRA_FECHA NVARCHAR(255) NOT NULL,
COMPRA_IMPORTE NVARCHAR(255) NOT NULL);
CREATE TABLE SPARK.ACCESORIO(
ACCESORIO_ID NVARCHAR(255) PRIMARY KEY,
ACCESORIO_DESCRIPCION NVARCHAR(255) NOT NULL
)

CREATE TABLE SPARK.PC(
PC_ID NVARCHAR(255) PRIMARY KEY,
PC_MICRO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.MICROPROCESADOR(MICRO_ID),
PC_PLACA NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES SPARK.PLACA_VIDEO(PLACA_ID),
PC_DISCO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.DISCO_RIGIDO(DISCO_ID),
PC_MEMORIA NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.MEMORIA_RAM(MEMORIA_ID),
PC_ALTO DECIMAL(18,2) NOT NULL,
PC_ANCHO DECIMAL(18,2) NOT NULL,
PC_PROFUNDIDAD DECIMAL(18,2) NOT NULL);

CREATE TABLE SPARK.PRODUCTO (
PRODUCTO_ID NVARCHAR(255) PRIMARY KEY,
PRODUCTO_PRECIO	DECIMAL(18,2) NOT NULL);


CREATE TABLE SPARK.ITEM_COMPRA (
ITEM_ID INT IDENTITY (1,1) PRIMARY KEY,
ITEM_NUMERO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.COMPRA(COMPRA_ID),
ITEM_SUCURSAL INT NOT NULL FOREIGN KEY REFERENCES SPARK.SUCURSAL(SUCURSAL_ID),
ITEM_CODIGO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.PRODUCTO(PRODUCTO_ID),
ITEM_PRECIO NVARCHAR(255) NOT NULL,
ITEM_CANTIDAD NVARCHAR(255) NOT NULL
);

CREATE TABLE SPARK.FACTURA (
FACTURA_ID NVARCHAR(255) PRIMARY KEY,
FACTURA_SUCURSAL INT NOT NULL FOREIGN KEY REFERENCES SPARK.SUCURSAL(SUCURSAL_ID),
FACTURA_CLIENTE INT NOT NULL FOREIGN KEY REFERENCES SPARK.CLIENTE(CLIENTE_ID),
FACTURA_FECHA NVARCHAR(255) NOT NULL,
FACTURA_IMPORTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.DETALLE_FACTURA (
DETALLE_ID INT IDENTITY (1,1) PRIMARY KEY,
DETALLE_NUMERO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.FACTURA(FACTURA_ID),
DETALLE_SUCURSAL INT NOT NULL FOREIGN KEY REFERENCES SPARK.SUCURSAL(SUCURSAL_ID),
DETALLE_CODIGO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.PRODUCTO(PRODUCTO_ID),
DETALLE_CANTIDAD NVARCHAR(255) NOT NULL,
DETALLE_PRECIO NVARCHAR(255) NOT NULL);


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

-- SUCURSAL

INSERT SPARK.SUCURSAL (SUCURSAL_CIUDAD, SUCURSAL_DIR,  SUCURSAL_MAIL, SUCURSAL_TELEFONO)
SELECT DISTINCT CIUDAD_ID,
SUCURSAL_DIR,
SUCURSAL_MAIL, 
SUCURSAL_TEL
FROM gd_esquema.Maestra M
JOIN SPARK.CIUDAD C
ON M.CIUDAD = C.CIUDAD_NOMBRE;

-- COMPRA

INSERT SPARK.COMPRA
SELECT DISTINCT COMPRA_NUMERO, 
SUCURSAL_ID, 
COMPRA_FECHA, 
SUM((COMPRA_PRECIO * COMPRA_CANTIDAD)) AS COMPRA_IMPORTE
FROM gd_esquema.Maestra M
JOIN SPARK.SUCURSAL S
ON M.SUCURSAL_DIR = S.SUCURSAL_DIR
WHERE COMPRA_NUMERO IS NOT NULL
GROUP BY COMPRA_NUMERO, SUCURSAL_ID, COMPRA_FECHA;

--ACCESORIO

INSERT SPARK.ACCESORIO
SELECT DISTINCT ACCESORIO_CODIGO,
AC_DESCRIPCION
FROM gd_esquema.Maestra
WHERE ACCESORIO_CODIGO IS NOT NULL;

-- PC
INSERT SPARK.PC
SELECT DISTINCT PC_CODIGO,
MICROPROCESADOR_CODIGO,
PLACA_VIDEO_CHIPSET,
DISCO_RIGIDO_CODIGO,
MEMORIA_RAM_CODIGO,
PC_ALTO,
PC_ANCHO,
PC_PROFUNDIDAD
FROM gd_esquema.Maestra
WHERE PC_CODIGO IS NOT NULL

-- CLIENTE

INSERT SPARK.CLIENTE
SELECT DISTINCT CLIENTE_DNI, 
CLIENTE_APELLIDO, 
CLIENTE_NOMBRE, 
CLIENTE_DIRECCION, 
CLIENTE_FECHA_NACIMIENTO, 
CLIENTE_MAIL, 
CLIENTE_TELEFONO
FROM gd_esquema.Maestra
WHERE CLIENTE_DNI IS NOT NULL;


-- PRODUCTO

INSERT SPARK.PRODUCTO
SELECT PC_ID AS PRODUCTO_ID, COMPRA_PRECIO
FROM SPARK.PC
JOIN gd_esquema.Maestra
ON PC_ID = PC_CODIGO
WHERE COMPRA_NUMERO IS NOT NULL
UNION
SELECT ACCESORIO_ID, COMPRA_PRECIO
FROM SPARK.ACCESORIO
JOIN gd_esquema.Maestra
ON ACCESORIO_ID = ACCESORIO_CODIGO
WHERE COMPRA_NUMERO IS NOT NULL;

-- ITEM_COMPRA

INSERT SPARK.ITEM_COMPRA
SELECT COMPRA_NUMERO, SUCURSAL_ID, PC_CODIGO AS PRODUCTO_CODIGO, COMPRA_PRECIO, COMPRA_CANTIDAD
FROM gd_esquema.Maestra M
JOIN SPARK.SUCURSAL S
ON M.SUCURSAL_DIR = S.SUCURSAL_DIR
WHERE COMPRA_NUMERO IS NOT NULL
AND PC_CODIGO IS NOT NULL
UNION ALL
SELECT COMPRA_NUMERO, SUCURSAL_ID, CONVERT(NVARCHAR(50), ACCESORIO_CODIGO), COMPRA_PRECIO, COMPRA_CANTIDAD
FROM gd_esquema.Maestra M
JOIN SPARK.SUCURSAL S
ON M.SUCURSAL_DIR = S.SUCURSAL_DIR
WHERE COMPRA_NUMERO IS NOT NULL
AND ACCESORIO_CODIGO IS NOT NULL;

-- FACTURA

INSERT SPARK.FACTURA
SELECT FACTURA_NUMERO, 
SUCURSAL_ID, 
CLIENTE_ID, 
FACTURA_FECHA, 
SUM((P.PRODUCTO_PRECIO  * 1.2)) AS FACTURA_IMPORTE
FROM gd_esquema.Maestra M
JOIN SPARK.SUCURSAL S
ON M.SUCURSAL_DIR = S.SUCURSAL_DIR
JOIN SPARK.CLIENTE C
ON M.CLIENTE_DNI = C.CLIENTE_DNI AND M.CLIENTE_APELLIDO = C.CLIENTE_APELLIDO AND M.CLIENTE_NOMBRE = C.CLIENTE_NOMBRE
JOIN SPARK.PRODUCTO P
ON M.PC_CODIGO = P.PRODUCTO_ID OR CAST(M.ACCESORIO_CODIGO AS NVARCHAR(255)) = P.PRODUCTO_ID
GROUP BY FACTURA_NUMERO, SUCURSAL_ID, CLIENTE_ID, FACTURA_FECHA

-- DETALLE_FACTURA

INSERT SPARK.DETALLE_FACTURA
SELECT FACTURA_NUMERO, SUCURSAL_ID, 
CAST(ACCESORIO_CODIGO AS NVARCHAR(255)) AS DETALLE_CODIGO, COUNT(*) AS CANTIDAD, (P.PRODUCTO_PRECIO  * 1.2) AS DETALLE_IMPORTE
FROM gd_esquema.Maestra M
JOIN SPARK.SUCURSAL S
ON M.SUCURSAL_DIR = S.SUCURSAL_DIR
JOIN SPARK.CLIENTE C
ON M.CLIENTE_DNI = C.CLIENTE_DNI AND M.CLIENTE_APELLIDO = C.CLIENTE_APELLIDO
JOIN SPARK.PRODUCTO P
ON CAST(M.ACCESORIO_CODIGO AS NVARCHAR(255)) = P.PRODUCTO_ID
WHERE ACCESORIO_CODIGO IS NOT NULL
GROUP BY FACTURA_NUMERO, ACCESORIO_CODIGO, SUCURSAL_ID, P.PRODUCTO_PRECIO
UNION ALL
SELECT FACTURA_NUMERO, SUCURSAL_ID, 
PC_CODIGO AS DETALLE_CODIGO, COUNT(*) AS CANTIDAD, (P.PRODUCTO_PRECIO  * 1.2) AS DETALLE_IMPORTE
FROM gd_esquema.Maestra M
JOIN SPARK.SUCURSAL S
ON M.SUCURSAL_DIR = S.SUCURSAL_DIR
JOIN SPARK.CLIENTE C
ON M.CLIENTE_DNI = C.CLIENTE_DNI AND M.CLIENTE_APELLIDO = C.CLIENTE_APELLIDO
JOIN SPARK.PRODUCTO P
ON M.PC_CODIGO = P.PRODUCTO_ID
WHERE PC_CODIGO IS NOT NULL
GROUP BY FACTURA_NUMERO, PC_CODIGO, SUCURSAL_ID, P.PRODUCTO_PRECIO
