USE GD1C2021;
GO

-- Eliminacion de objetos preexistentes

IF OBJECT_ID('SPARK.BI_FACT_COMPRA_PC','U') IS NOT NULL
  DROP TABLE SPARK.BI_FACT_COMPRA_PC;
  
IF OBJECT_ID('SPARK.BI_FACT_COMPRA_ACCESORIO','U') IS NOT NULL
  DROP TABLE SPARK.BI_FACT_COMPRA_ACCESORIO;

IF OBJECT_ID('SPARK.BI_FACT_VENTA_PC','U') IS NOT NULL
  DROP TABLE SPARK.BI_FACT_VENTA_PC;

IF OBJECT_ID('SPARK.BI_FACT_VENTA_ACCESORIO','U') IS NOT NULL
  DROP TABLE SPARK.BI_FACT_VENTA_ACCESORIO;

IF OBJECT_ID('SPARK.BI_DIM_CLIENTE','U') IS NOT NULL
  DROP TABLE SPARK.BI_DIM_CLIENTE;

IF OBJECT_ID('SPARK.BI_DIM_TIEMPO','U') IS NOT NULL
  DROP TABLE SPARK.BI_DIM_TIEMPO;

IF OBJECT_ID ('SPARK.GetAge', 'FN') IS NOT NULL  
    DROP FUNCTION SPARK.getAge;

IF OBJECT_ID ('SPARK.StockMaxAnio', 'FN') IS NOT NULL  
    DROP FUNCTION SPARK.StockMaxAnio;

IF OBJECT_ID('SPARK.BI_DIM_SUCURSAL','U') IS NOT NULL
  DROP TABLE SPARK.BI_DIM_SUCURSAL;

IF OBJECT_ID('SPARK.BI_DIM_PC','U') IS NOT NULL
  DROP TABLE SPARK.BI_DIM_PC;

IF OBJECT_ID('SPARK.BI_DIM_ACCESORIO','U') IS NOT NULL
  DROP TABLE SPARK.BI_DIM_ACCESORIO;

IF OBJECT_ID('SPARK.BI_DIM_MICROPROCESADOR','U') IS NOT NULL
  DROP TABLE SPARK.BI_DIM_MICROPROCESADOR;

IF OBJECT_ID('SPARK.BI_DIM_PLACA_VIDEO','U') IS NOT NULL
  DROP TABLE SPARK.BI_DIM_PLACA_VIDEO;

IF OBJECT_ID('SPARK.BI_DIM_DISCO_RIGIDO','U') IS NOT NULL
  DROP TABLE SPARK.BI_DIM_DISCO_RIGIDO;

IF OBJECT_ID('SPARK.BI_DIM_MEMORIA_RAM','U') IS NOT NULL
  DROP TABLE SPARK.BI_DIM_MEMORIA_RAM;

IF OBJECT_ID('SPARK.TIEMPO_PROMEDIO_PC','V') IS NOT NULL
  DROP VIEW SPARK.TIEMPO_PROMEDIO_PC;

IF OBJECT_ID('SPARK.PRECIO_PROMEDIO_PC','V') IS NOT NULL
  DROP VIEW SPARK.PRECIO_PROMEDIO_PC;

IF OBJECT_ID('SPARK.CANTIDAD_VENTAS_COMPRAS_PC','V') IS NOT NULL
  DROP VIEW SPARK.CANTIDAD_VENTAS_COMPRAS_PC;

IF OBJECT_ID('SPARK.GANANCIAS_PC','V') IS NOT NULL
  DROP VIEW SPARK.GANANCIAS_PC;

IF OBJECT_ID('SPARK.PRECIO_PROMEDIO_ACCESORIO','V') IS NOT NULL
  DROP VIEW SPARK.PRECIO_PROMEDIO_ACCESORIO;

IF OBJECT_ID('SPARK.GANANCIAS_ACCESORIO','V') IS NOT NULL
  DROP VIEW SPARK.GANANCIAS_ACCESORIO;

IF OBJECT_ID('SPARK.TIEMPO_PROMEDIO_ACCESORIO','V') IS NOT NULL
  DROP VIEW SPARK.TIEMPO_PROMEDIO_ACCESORIO;

IF OBJECT_ID('SPARK.MAX_STOCK_ACCESORIO','V') IS NOT NULL
  DROP VIEW SPARK.MAX_STOCK_ACCESORIO;

GO


-- Funciones

CREATE FUNCTION SPARK.GetAge(@FechaNacimiento nvarchar(255), @FechaCompra nvarchar(255))
RETURNS decimal(3,0)
AS
BEGIN
	DECLARE @Edad decimal(3,0)
	SELECT @Edad = CONVERT(INT, SUBSTRING(@FechaCompra, 1, 4)) - CONVERT(INT, SUBSTRING(@FechaNacimiento, 1, 4))

	RETURN @Edad
END;

GO

-- Creacion de las tablas

ALTER TABLE SPARK.CLIENTE
ADD CLIENTE_SEXO char(1);
GO

CREATE TABLE SPARK.BI_DIM_CLIENTE (
CLIENTE_ID INT PRIMARY KEY,
CLIENTE_RANGO_EDAD NVARCHAR(255) NOT NULL,
CLIENTE_SEXO CHAR(1) NOT NULL);


CREATE TABLE SPARK.BI_DIM_TIEMPO (
TIEMPO_ID INT IDENTITY(1,1) PRIMARY KEY,
TIEMPO_FECHA DATE NOT NULL,
TIEMPO_ANIO INT NOT NULL,
TIEMPO_MES INT NOT NULL);

CREATE TABLE SPARK.BI_DIM_SUCURSAL (
SUCURSAL_ID INT PRIMARY KEY,
SUCURSAL_DIR NVARCHAR(255) NOT NULL,
SUCURSAL_MAIL NVARCHAR(255) NOT NULL,
SUCURSAL_TELEFONO DECIMAL(18,0) NOT NULL);

CREATE TABLE SPARK.BI_DIM_DISCO_RIGIDO (
DISCO_ID NVARCHAR(255) PRIMARY KEY,
DISCO_TIPO NVARCHAR(255) NOT NULL,
DISCO_CAPACIDAD NVARCHAR(255) NOT NULL,
DISCO_VELOCIDAD NVARCHAR(255) NOT NULL,
DISCO_FABRICANTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.BI_DIM_MEMORIA_RAM (
MEMORIA_ID NVARCHAR(255) PRIMARY KEY,
MEMORIA_TIPO NVARCHAR(255) NOT NULL,
MEMORIA_CAPACIDAD NVARCHAR(255) NOT NULL,
MEMORIA_VELOCIDAD NVARCHAR(255) NOT NULL,
MEMORIA_FABRICANTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.BI_DIM_MICROPROCESADOR (
MICRO_ID NVARCHAR(255) PRIMARY KEY,
MICRO_CACHE NVARCHAR(255) NOT NULL,
MICRO_CANT_HILOS DECIMAL(18,0) NOT NULL,
MICRO_VELOCIDAD NVARCHAR(255) NOT NULL,
MICRO_FABRICANTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.BI_DIM_PLACA_VIDEO (
PLACA_ID NVARCHAR(255) PRIMARY KEY,
PLACA_MODELO NVARCHAR(255) NOT NULL,
PLACA_VELOCIDAD NVARCHAR(255) NOT NULL,
PLACA_CAPACIDAD NVARCHAR(255) NOT NULL,
PLACA_FABRICANTE NVARCHAR(255) NOT NULL);

CREATE TABLE SPARK.BI_DIM_PC(
PC_ID NVARCHAR(255) PRIMARY KEY);

CREATE TABLE SPARK.BI_DIM_ACCESORIO(
ACCESORIO_ID NVARCHAR(255) PRIMARY KEY,
ACCESORIO_DESCRIPCION NVARCHAR(255) NOT NULL);


CREATE TABLE SPARK.BI_FACT_COMPRA_ACCESORIO(
COMPRA_ACCESORIO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_ACCESORIO(ACCESORIO_ID),
COMPRA_SUCURSAL INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_SUCURSAL(SUCURSAL_ID),
COMPRA_TIEMPO INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_TIEMPO(TIEMPO_ID),
COMPRA_CANTIDAD_COMPRADA INT NOT NULL,
COMPRA_PRECIO_PROMEDIO DECIMAL(12,2) NOT NULL,
COMPRA_IMPORTE_TOTAL DECIMAL(12,2) NOT NULL);

CREATE TABLE SPARK.BI_FACT_VENTA_ACCESORIO(
VENTA_ACCESORIO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_ACCESORIO(ACCESORIO_ID),
VENTA_CLIENTE INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_CLIENTE(CLIENTE_ID),
VENTA_SUCURSAL INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_SUCURSAL(SUCURSAL_ID),
VENTA_TIEMPO INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_TIEMPO(TIEMPO_ID),
VENTA_CANTIDAD_VENDIDA INT NOT NULL,
VENTA_PRECIO_PROMEDIO DECIMAL(12,2) NOT NULL,
VENTA_IMPORTE_TOTAL DECIMAL(12,2) NOT NULL);

CREATE TABLE SPARK.BI_FACT_COMPRA_PC(
COMPRA_PC NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_PC(PC_ID),
COMPRA_MEMORIA_RAM NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_MEMORIA_RAM(MEMORIA_ID),
COMPRA_DISCO_RIGIDO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_DISCO_RIGIDO(DISCO_ID),
COMPRA_PLACA_VIDEO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_PLACA_VIDEO(PLACA_ID),
COMPRA_MICROPROCESADOR NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_MICROPROCESADOR(MICRO_ID),
COMPRA_SUCURSAL INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_SUCURSAL(SUCURSAL_ID),
COMPRA_TIEMPO INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_TIEMPO(TIEMPO_ID),
COMPRA_CANTIDAD_COMPRADA INT NOT NULL,
COMPRA_PRECIO_PROMEDIO DECIMAL(12,2) NOT NULL,
COMPRA_IMPORTE_TOTAL DECIMAL(12,2) NOT NULL);

CREATE TABLE SPARK.BI_FACT_VENTA_PC(
VENTA_PC NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_PC(PC_ID),
VENTA_MEMORIA_RAM NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_MEMORIA_RAM(MEMORIA_ID),
VENTA_DISCO_RIGIDO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_DISCO_RIGIDO(DISCO_ID),
VENTA_PLACA_VIDEO NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_PLACA_VIDEO(PLACA_ID),
VENTA_MICROPROCESADOR NVARCHAR(255) NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_MICROPROCESADOR(MICRO_ID),
VENTA_CLIENTE INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_CLIENTE(CLIENTE_ID),
VENTA_SUCURSAL INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_SUCURSAL(SUCURSAL_ID),
VENTA_TIEMPO INT NOT NULL FOREIGN KEY REFERENCES SPARK.BI_DIM_TIEMPO(TIEMPO_ID),
VENTA_CANTIDAD_VENDIDA INT NOT NULL,
VENTA_PRECIO_PROMEDIO DECIMAL(12,2) NOT NULL,
VENTA_IMPORTE_TOTAL DECIMAL(12,2) NOT NULL);

GO

-- Funciones
CREATE FUNCTION SPARK.StockMaxAnio(@Sucursal INT, @Anio INT)
RETURNS INT
AS 
BEGIN
    DECLARE @StockMax INT

	SELECT TOP 1 @StockMax = (SELECT (ISNULL(SUM(COMPRA_CANTIDAD_COMPRADA),0) -
									  (SELECT ISNULL(SUM(VENTA_CANTIDAD_VENDIDA),0)
									   FROM SPARK.BI_FACT_VENTA_ACCESORIO FV
									   INNER JOIN SPARK.BI_DIM_TIEMPO TI2 ON VENTA_TIEMPO = TIEMPO_ID
									   WHERE FV.VENTA_SUCURSAL = @SUCURSAL
									   AND TI2.TIEMPO_ANIO = @Anio
									   AND TI2.TIEMPO_MES = TI3.TIEMPO_MES))
    FROM SPARK.BI_FACT_COMPRA_ACCESORIO FC
	INNER JOIN SPARK.BI_DIM_TIEMPO TI1 ON COMPRA_TIEMPO = TIEMPO_ID
    WHERE FC.COMPRA_SUCURSAL = @SUCURSAL
    )
    FROM SPARK.BI_FACT_COMPRA_ACCESORIO FC2
	INNER JOIN SPARK.BI_DIM_TIEMPO TI3 ON COMPRA_TIEMPO = TIEMPO_ID
    GROUP BY TI3.TIEMPO_MES

    RETURN @StockMax
END 
GO


-- Migracion

-- BI_DIM_CLIENTE


UPDATE SPARK.CLIENTE SET CLIENTE_SEXO = (SELECT CASE 
	WHEN RAND(CAST(NEWID() as varbinary)) >= 0.5 THEN 'M'
	ELSE 'F'
	END)
GO

INSERT SPARK.BI_DIM_CLIENTE (CLIENTE_ID, CLIENTE_RANGO_EDAD, CLIENTE_SEXO)
VALUES (1, '[18-30]', 'M'),
	   (2, '[31-50]', 'M'),
	   (3, '[>50]', 'M'),
	   (4, '[18-30]', 'F'),
	   (5, '[31-50]', 'F'),
	   (6, '[>50]', 'F');


-- BI_DIM_TIEMPO (SE CREA LA BI_DIM_TIEMPO MEDIANTE UN STORED PROCEDURE PARA AUTOMATIZAR EL INSERT DE FECHAS ANIO Y MES)

INSERT SPARK.BI_DIM_TIEMPO
SELECT CONVERT(DATE, COMPRA_FECHA) AS FECHA,
	   CONVERT(INT, SUBSTRING(COMPRA_FECHA,1,4)) AS ANIO,
	   CONVERT(INT, SUBSTRING(COMPRA_FECHA,6,2)) AS MES
FROM SPARK.COMPRA
UNION
SELECT CONVERT(DATE, FACTURA_FECHA) AS FECHA,
	   CONVERT(INT, SUBSTRING(FACTURA_FECHA,1,4)) AS ANIO,
	   CONVERT(INT, SUBSTRING(FACTURA_FECHA,6,2)) AS MES
FROM SPARK.FACTURA

-- BI_DIM_SUCURSAL

INSERT SPARK.BI_DIM_SUCURSAL
SELECT SUCURSAL_ID,
	   SUCURSAL_DIR,
	   SUCURSAL_MAIL,
	   SUCURSAL_TELEFONO
FROM SPARK.SUCURSAL

-- BI_DIM_DISCO_RIGIDO

INSERT SPARK.BI_DIM_DISCO_RIGIDO
SELECT DISCO_ID,
	   DISCO_TIPO,
	   DISCO_CAPACIDAD,
	   DISCO_VELOCIDAD,
	   DISCO_FABRICANTE
FROM SPARK.DISCO_RIGIDO

-- BI_DIM_MEMORIA_RAM

INSERT SPARK.BI_DIM_MEMORIA_RAM
SELECT MEMORIA_ID,
	   MEMORIA_TIPO,
	   MEMORIA_CAPACIDAD,
	   MEMORIA_VELOCIDAD,
	   MEMORIA_FABRICANTE
FROM SPARK.MEMORIA_RAM

-- BI_DIM_MICROPROCESADOR 

INSERT SPARK.BI_DIM_MICROPROCESADOR
SELECT MICRO_ID,
	   MICRO_CACHE,
	   MICRO_CANT_HILOS,
	   MICRO_VELOCIDAD,
	   MICRO_FABRICANTE
FROM SPARK.MICROPROCESADOR

-- BI_DIM_PLACA_VIDEO

INSERT SPARK.BI_DIM_PLACA_VIDEO
SELECT PLACA_ID,
	   PLACA_MODELO,
	   PLACA_VELOCIDAD,
	   PLACA_CAPACIDAD,
	   PLACA_FABRICANTE
FROM SPARK.PLACA_VIDEO

-- BI_DIM_PC

INSERT SPARK.BI_DIM_PC
SELECT PC_ID
FROM SPARK.PC

-- BI_DIM_ACCESORIO

INSERT SPARK.BI_DIM_ACCESORIO
SELECT ACCESORIO_ID,
	   ACCESORIO_DESCRIPCION
FROM SPARK.ACCESORIO



-- BI_FACT_COMPRA_ACCESORIO

INSERT SPARK.BI_FACT_COMPRA_ACCESORIO
SELECT acc.ACCESORIO_ID, suc.SUCURSAL_ID, tiB.TIEMPO_ID, SUM(CONVERT(INT,icomp.ITEM_CANTIDAD)), AVG(icomp.ITEM_CANTIDAD*prod.PRODUCTO_PRECIO),SUM(icomp.ITEM_CANTIDAD*prod.PRODUCTO_PRECIO)
FROM SPARK.ITEM_COMPRA icomp INNER JOIN SPARK.COMPRA comp ON (comp.COMPRA_ID = icomp.ITEM_NUMERO)
						     INNER JOIN SPARK.SUCURSAL suc ON (comp.COMPRA_SUCURSAL = suc.SUCURSAL_ID)
						     INNER JOIN SPARK.PRODUCTO prod ON (prod.PRODUCTO_ID = icomp.ITEM_CODIGO)
							 INNER JOIN SPARK.BI_DIM_ACCESORIO acc ON (prod.PRODUCTO_ID = acc.ACCESORIO_ID)
					         INNER JOIN SPARK.BI_DIM_TIEMPO tiB ON (tiB.TIEMPO_FECHA = CONVERT(DATE, comp.COMPRA_FECHA))
GROUP BY acc.ACCESORIO_ID, suc.SUCURSAL_ID, tiB.TIEMPO_ID							


-- BI_FACT_VENTA_ACCESORIO

INSERT SPARK.BI_FACT_VENTA_ACCESORIO
SELECT acc.ACCESORIO_ID, cliB.CLIENTE_ID, suc.SUCURSAL_ID, ti.TIEMPO_ID, SUM(CONVERT(INT,dfac.DETALLE_CANTIDAD)), AVG(CONVERT(FLOAT,dfac.DETALLE_CANTIDAD)* CONVERT(FLOAT,dfac.DETALLE_PRECIO)),SUM(CONVERT(FLOAT,dfac.DETALLE_CANTIDAD)* CONVERT(FLOAT,dfac.DETALLE_PRECIO))
FROM SPARK.DETALLE_FACTURA dfac INNER JOIN SPARK.FACTURA fac ON (dfac.DETALLE_NUMERO = fac.FACTURA_ID)
							    INNER JOIN SPARK.SUCURSAL suc ON (fac.FACTURA_SUCURSAL = suc.SUCURSAL_ID)
								INNER JOIN SPARK.CLIENTE cli ON (fac.FACTURA_CLIENTE = cli.CLIENTE_ID)
								INNER JOIN SPARK.PRODUCTO prod ON (dfac.DETALLE_CODIGO = prod.PRODUCTO_ID)
								INNER JOIN SPARK.BI_DIM_ACCESORIO acc ON (prod.PRODUCTO_ID = acc.ACCESORIO_ID)
								INNER JOIN SPARK.BI_DIM_TIEMPO ti ON (fac.FACTURA_FECHA = CONVERT(DATE, ti.TIEMPO_FECHA))
								INNER JOIN SPARK.BI_DIM_CLIENTE cliB ON ((CASE
																			WHEN SPARK.GetAge(cli.CLIENTE_FECHA_NACIMIENTO, fac.FACTURA_FECHA) BETWEEN 18 AND 30 THEN '[18-30]'
																			WHEN SPARK.GetAge(cli.CLIENTE_FECHA_NACIMIENTO, fac.FACTURA_FECHA) BETWEEN 31 AND 50 THEN '[31-50]'
																			ELSE '[>50]' END) = cliB.CLIENTE_RANGO_EDAD
																			AND cli.CLIENTE_SEXO = cliB.CLIENTE_SEXO)

GROUP BY acc.ACCESORIO_ID, cliB.CLIENTE_ID, suc.SUCURSAL_ID, ti.TIEMPO_ID
-- BI_FACT_COMPRA_PC

INSERT SPARK.BI_FACT_COMPRA_PC
SELECT pc.PC_ID, pc.PC_MEMORIA, pc.PC_DISCO, pc.PC_PLACA, pc.PC_MICRO, suc.SUCURSAL_ID, tiB.TIEMPO_ID,SUM(CONVERT(INT,icomp.ITEM_CANTIDAD)), AVG(icomp.ITEM_CANTIDAD*prod.PRODUCTO_PRECIO), SUM(icomp.ITEM_CANTIDAD*prod.PRODUCTO_PRECIO)
FROM SPARK.ITEM_COMPRA icomp INNER JOIN SPARK.COMPRA comp ON (comp.COMPRA_ID = icomp.ITEM_NUMERO)
						     INNER JOIN SPARK.SUCURSAL suc ON (comp.COMPRA_SUCURSAL = suc.SUCURSAL_ID)
						     INNER JOIN SPARK.PRODUCTO prod ON (prod.PRODUCTO_ID = icomp.ITEM_CODIGO)
							 INNER JOIN SPARK.PC pc ON (prod.PRODUCTO_ID = pc.PC_ID)
					         INNER JOIN SPARK.BI_DIM_TIEMPO tiB ON (tiB.TIEMPO_FECHA = CONVERT(DATE, comp.COMPRA_FECHA))
GROUP BY pc.PC_ID, pc.PC_MEMORIA, pc.PC_DISCO, pc.PC_PLACA, pc.PC_MICRO, suc.SUCURSAL_ID, tiB.TIEMPO_ID

-- BI_FACT_VENTA_PC

INSERT SPARK.BI_FACT_VENTA_PC
SELECT pc.PC_ID, pc.PC_MEMORIA, pc.PC_DISCO, pc.PC_PLACA, pc.PC_MICRO, cliB.CLIENTE_ID, suc.SUCURSAL_ID, ti.TIEMPO_ID,SUM(CONVERT(INT,dfac.DETALLE_CANTIDAD)), AVG(CONVERT(FLOAT,dfac.DETALLE_CANTIDAD)* CONVERT(FLOAT,dfac.DETALLE_PRECIO)),SUM(CONVERT(FLOAT,dfac.DETALLE_CANTIDAD)* CONVERT(FLOAT,dfac.DETALLE_PRECIO))
FROM SPARK.DETALLE_FACTURA dfac INNER JOIN SPARK.FACTURA fac ON (dfac.DETALLE_NUMERO = fac.FACTURA_ID)
							    INNER JOIN SPARK.SUCURSAL suc ON (fac.FACTURA_SUCURSAL = suc.SUCURSAL_ID)
								INNER JOIN SPARK.CLIENTE cli ON (fac.FACTURA_CLIENTE = cli.CLIENTE_ID)
								INNER JOIN SPARK.PRODUCTO prod ON (dfac.DETALLE_CODIGO = prod.PRODUCTO_ID)
								INNER JOIN SPARK.PC pc ON (prod.PRODUCTO_ID = pc.PC_ID)
								INNER JOIN SPARK.BI_DIM_PC pcB ON (pc.PC_ID = pcB.PC_ID)
								INNER JOIN SPARK.BI_DIM_DISCO_RIGIDO dr ON (pc.PC_DISCO = dr.DISCO_ID)
								INNER JOIN SPARK.BI_DIM_MICROPROCESADOR mp ON (pc.PC_MICRO = mp.MICRO_ID)
								INNER JOIN SPARK.BI_DIM_MEMORIA_RAM mr ON (pc.PC_MEMORIA = mr.MEMORIA_ID)
								INNER JOIN SPARK.BI_DIM_PLACA_VIDEO pv ON (pc.PC_PLACA = pv.PLACA_ID)
								INNER JOIN SPARK.BI_DIM_TIEMPO ti ON (fac.FACTURA_FECHA = CONVERT(DATE, ti.TIEMPO_FECHA))
								INNER JOIN SPARK.BI_DIM_CLIENTE cliB ON ((CASE
																			WHEN SPARK.GetAge(cli.CLIENTE_FECHA_NACIMIENTO, fac.FACTURA_FECHA) BETWEEN 18 AND 30 THEN '[18-30]'
																			WHEN SPARK.GetAge(cli.CLIENTE_FECHA_NACIMIENTO, fac.FACTURA_FECHA) BETWEEN 31 AND 50 THEN '[31-50]'
																			ELSE '[>50]' END) = cliB.CLIENTE_RANGO_EDAD
																			AND cli.CLIENTE_SEXO = cliB.CLIENTE_SEXO)
GROUP BY pc.PC_ID, pc.PC_MEMORIA, pc.PC_DISCO, pc.PC_PLACA, pc.PC_MICRO, cliB.CLIENTE_ID, suc.SUCURSAL_ID, ti.TIEMPO_ID
GO

-- Vistas


--                                          ------------ PC ------------

-- Promedio de tiempo en stock de cada modelo de Pc.
CREATE VIEW SPARK.TIEMPO_PROMEDIO_PC AS(
SELECT FC.COMPRA_PC AS ACCESORIO, (
            (SELECT AVG(TIEMPO_ANIO * 12 + TIEMPO_MES)
            FROM SPARK.BI_FACT_VENTA_PC FV
			INNER JOIN SPARK.BI_DIM_TIEMPO ON VENTA_TIEMPO = TIEMPO_ID
            WHERE FC.COMPRA_PC=FV.VENTA_PC) -
											(SELECT AVG(TIEMPO_ANIO * 12 + TIEMPO_MES)
                                             FROM SPARK.BI_FACT_COMPRA_PC FC2
											 INNER JOIN SPARK.BI_DIM_TIEMPO ON COMPRA_TIEMPO = TIEMPO_ID
                                             WHERE FC2.COMPRA_PC=FC.COMPRA_PC
                                             )) AS TIEMPO_PROMEDIO_STOCK_EN_MESES
            FROM SPARK.BI_FACT_COMPRA_PC FC
            GROUP BY FC.COMPRA_PC)
GO


-- Precio promedio de PCs, vendidos y comprados.
CREATE VIEW SPARK.PRECIO_PROMEDIO_PC AS(
SELECT COMPRA_PC AS ACCESORIO, AVG(COMPRA_PRECIO_PROMEDIO) AS PRECIO_PROMEDIO_COMPRA,
	   (SELECT AVG(VENTA_PRECIO_PROMEDIO)
	    FROM SPARK.BI_FACT_VENTA_PC
		WHERE VENTA_PC=COMPRA_PC) AS PRECIO_PROMEDIO_VENTA
FROM SPARK.BI_FACT_COMPRA_PC
GROUP BY COMPRA_PC)

GO

-- Cantidad de PCs, vendidos y comprados x sucursal y mes
CREATE VIEW SPARK.CANTIDAD_VENTAS_COMPRAS_PC AS(
SELECT COMPRA_PC AS PC, COMPRA_SUCURSAL AS SUCURSAL, ti.TIEMPO_MES AS MES, SUM(COMPRA_CANTIDAD_COMPRADA) AS CANTIDAD_COMPRA,
	   (SELECT SUM(VENTA_CANTIDAD_VENDIDA)
	    FROM SPARK.BI_FACT_VENTA_PC
		INNER JOIN SPARK.BI_DIM_TIEMPO ti2 ON TIEMPO_ID = VENTA_TIEMPO
		WHERE VENTA_PC=COMPRA_PC AND VENTA_SUCURSAL=COMPRA_SUCURSAL AND ti.TIEMPO_MES=ti2.TIEMPO_MES) AS CANTIDAD_VENTA
FROM SPARK.BI_FACT_COMPRA_PC
INNER JOIN SPARK.BI_DIM_TIEMPO ti ON TIEMPO_ID = COMPRA_TIEMPO
GROUP BY COMPRA_PC, COMPRA_SUCURSAL, TIEMPO_MES)

GO

-- Ganancias (precio de venta � precio de compra) x Sucursal x mes
CREATE VIEW SPARK.GANANCIAS_PC AS (
SELECT COMPRA_PC AS PC, COMPRA_SUCURSAL AS SUCURSAL, ti.TIEMPO_MES AS MES,
	   ((SELECT SUM(VENTA_IMPORTE_TOTAL)
	     FROM SPARK.BI_FACT_VENTA_PC
		 INNER JOIN SPARK.BI_DIM_TIEMPO ti2 ON TIEMPO_ID = VENTA_TIEMPO
		 WHERE VENTA_PC=COMPRA_PC AND VENTA_SUCURSAL=COMPRA_SUCURSAL AND ti.TIEMPO_MES=ti2.TIEMPO_MES)
		 - SUM(COMPRA_IMPORTE_TOTAL)) AS GANANCIAS
FROM SPARK.BI_FACT_COMPRA_PC
INNER JOIN SPARK.BI_DIM_TIEMPO ti ON TIEMPO_ID = COMPRA_TIEMPO
GROUP BY COMPRA_PC, COMPRA_SUCURSAL, ti.TIEMPO_MES)

GO


--                                          ------------ ACCESORIOS ------------


-- Precio promedio de cada accesorio, vendido y comprado.
CREATE VIEW SPARK.PRECIO_PROMEDIO_ACCESORIO AS(
SELECT COMPRA_ACCESORIO AS ACCESORIO, AVG(COMPRA_PRECIO_PROMEDIO) AS PRECIO_PROMEDIO_COMPRA,
	   (SELECT AVG(VENTA_PRECIO_PROMEDIO)
	    FROM SPARK.BI_FACT_VENTA_ACCESORIO
		WHERE VENTA_ACCESORIO=COMPRA_ACCESORIO) AS PRECIO_PROMEDIO_VENTA
FROM SPARK.BI_FACT_COMPRA_ACCESORIO
GROUP BY COMPRA_ACCESORIO)

GO


-- Ganancias (precio de venta � precio de compra) x Sucursal x mes
CREATE VIEW SPARK.GANANCIAS_ACCESORIO AS(
SELECT COMPRA_ACCESORIO AS ACCESORIO, COMPRA_SUCURSAL AS SUCURSAL, ti.TIEMPO_MES AS MES, 
	   ((SELECT SUM(VENTA_IMPORTE_TOTAL)
	    FROM SPARK.BI_FACT_VENTA_ACCESORIO
		INNER JOIN SPARK.BI_DIM_TIEMPO ti2 ON TIEMPO_ID = VENTA_TIEMPO
		WHERE VENTA_ACCESORIO=COMPRA_ACCESORIO AND VENTA_SUCURSAL=COMPRA_SUCURSAL AND ti.TIEMPO_MES=ti2.TIEMPO_MES)
		- SUM(COMPRA_IMPORTE_TOTAL)) AS GANANCIAS
FROM SPARK.BI_FACT_COMPRA_ACCESORIO
INNER JOIN SPARK.BI_DIM_TIEMPO ti ON TIEMPO_ID = COMPRA_TIEMPO
GROUP BY COMPRA_ACCESORIO, COMPRA_SUCURSAL, TIEMPO_MES)

GO


-- Promedio de tiempo en stock de cada modelo de accesorio.
CREATE VIEW SPARK.TIEMPO_PROMEDIO_ACCESORIO AS(
SELECT FC.COMPRA_ACCESORIO AS ACCESORIO, (
            (SELECT AVG(TIEMPO_ANIO * 12 + TIEMPO_MES)
            FROM SPARK.BI_FACT_VENTA_ACCESORIO FV
			INNER JOIN SPARK.BI_DIM_TIEMPO ON VENTA_TIEMPO = TIEMPO_ID
            WHERE FC.COMPRA_ACCESORIO=FV.VENTA_ACCESORIO) -
												   (SELECT AVG(TIEMPO_ANIO * 12 + TIEMPO_MES)
                                                    FROM SPARK.BI_FACT_COMPRA_ACCESORIO FC2
													INNER JOIN SPARK.BI_DIM_TIEMPO ON COMPRA_TIEMPO = TIEMPO_ID
                                                    WHERE FC2.COMPRA_ACCESORIO=FC.COMPRA_ACCESORIO
                                                    )) AS TIEMPO_PROMEDIO_STOCK_EN_MESES
            FROM SPARK.BI_FACT_COMPRA_ACCESORIO FC
            GROUP BY FC.COMPRA_ACCESORIO)

GO

-- M�xima cantidad de stock por cada sucursal (anual)
CREATE VIEW SPARK.MAX_STOCK_ACCESORIO AS(
SELECT VENTA_SUCURSAL, TIEMPO_ANIO, SPARK.StockMaxAnio(VENTA_SUCURSAL, TIEMPO_ANIO) AS STOCK_MAXIMO
FROM SPARK.BI_FACT_VENTA_ACCESORIO
INNER JOIN SPARK.BI_DIM_TIEMPO ON VENTA_TIEMPO = TIEMPO_ID
GROUP BY VENTA_SUCURSAL, TIEMPO_ANIO)
GO

