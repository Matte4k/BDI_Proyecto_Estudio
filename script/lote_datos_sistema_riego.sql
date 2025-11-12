-----------------------------------------
-- BASE DE DATOS I - PROYECTO INTEGRADOR
-- GRUPO 26
-- LOTE DE DATOS - SISTEMA RIEGO
-----------------------------------------

use master;
GO

use sistema_riego;
GO

----------------
-- RESULTADOS --
----------------
INSERT INTO Resultados (id_resultado, nombre) VALUES (1, 'Exitoso');
INSERT INTO Resultados (id_resultado, nombre) VALUES (2, 'Fallido');
INSERT INTO Resultados (id_resultado, nombre) VALUES (3, 'Cancelado');

-------------
-- ESTADOS --
-------------
INSERT INTO Estados (id_estado, nombre) VALUES (1, 'Activo');
INSERT INTO Estados (id_estado, nombre) VALUES (2, 'Inactivo');

-- Nota: Los siguientes datos fueron generados automaticamente con ayuda de ChatGPT

-------------------
-- ZONA DE RIEGO --
-------------------
;WITH Numbers AS (
    SELECT TOP (500) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
INSERT INTO ZonaRiego (nombre, descripcion, superficie)
SELECT 
    CONCAT('Zona_', n),
    CONCAT('Área de cultivo número ', n),
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 1000 + 100, 2) AS FLOAT)
FROM Numbers;
GO

--------------
-- SENSORES --
--------------
DECLARE @minZona INT, @maxZona INT;
SELECT @minZona = MIN(id_zona), @maxZona = MAX(id_zona) FROM ZonaRiego;

;WITH Numbers AS (
    SELECT TOP (1000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
INSERT INTO Sensores (modelo, fecha_instalacion, estado_sensor, zona_asignada)
SELECT
    CONCAT('Modelo_', (n % 20) + 1),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 1000, GETDATE()),
    CASE WHEN RAND(CHECKSUM(NEWID())) > 0.2 THEN 1 ELSE 2 END,  -- 80% activos
    FLOOR(RAND(CHECKSUM(NEWID())) * (@maxZona - @minZona + 1)) + @minZona
FROM Numbers;
GO

---------------------
-- LECTURAS SENSOR --
---------------------
DECLARE @minSensor INT, @maxSensor INT;
SELECT @minSensor = MIN(id_sensor), @maxSensor = MAX(id_sensor) FROM Sensores;

;WITH Numbers AS (
    SELECT TOP (5000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects AS a CROSS JOIN sys.objects AS b
)
INSERT INTO LecturasSensor (fecha_lectura, humedad, temperatura, nivel_bateria, id_sensor_lectura)
SELECT
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()),
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 100, 2) AS FLOAT),
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 35 + 5, 2) AS FLOAT),
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 100, 0) AS INT),
    FLOOR(RAND(CHECKSUM(NEWID())) * (@maxSensor - @minSensor + 1)) + @minSensor
FROM Numbers;
GO

---------------------------
-- CONFIGURACIONES RIEGO --
---------------------------
DECLARE @minZona2 INT, @maxZona2 INT;
SELECT @minZona2 = MIN(id_zona), @maxZona2 = MAX(id_zona) FROM ZonaRiego;

;WITH Numbers AS (
    SELECT TOP (500) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
INSERT INTO ConfiguracionesRiego (humedad_minima, duracion_riego, frecuencia_lectura, id_zona_config)
SELECT
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 30 + 20, 2) AS FLOAT),
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 60 + 10, 0) AS INT),
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 15 + 5, 0) AS INT),
    FLOOR(RAND(CHECKSUM(NEWID())) * (@maxZona2 - @minZona2 + 1)) + @minZona2
FROM Numbers;
GO

--------------------
-- REGISTRO RIEGO --
--------------------
DECLARE @minZona3 INT, @maxZona3 INT;
SELECT @minZona3 = MIN(id_zona), @maxZona3 = MAX(id_zona) FROM ZonaRiego;

;WITH Numbers AS (
    SELECT TOP (2000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects AS a CROSS JOIN sys.objects AS b
)
INSERT INTO RegistroRiego (fecha_riego, volumen_agua, id_zona_registro, resultado)
SELECT
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()),
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 500 + 50, 2) AS FLOAT),
    FLOOR(RAND(CHECKSUM(NEWID())) * (@maxZona3 - @minZona3 + 1)) + @minZona3,
    CASE 
        WHEN RAND(CHECKSUM(NEWID())) < 0.7 THEN 1  -- 70% exitosos
        WHEN RAND(CHECKSUM(NEWID())) < 0.9 THEN 2  -- 20% fallidos
        ELSE 3  -- 10% cancelados
    END
FROM Numbers;
GO

SELECT COUNT(*) AS Tablas_RegistroRiego FROM RegistroRiego;
SELECT COUNT(*) AS Tablas_ConfiguracionesRiego FROM ConfiguracionesRiego;
SELECT COUNT(*) AS Tablas_LecturasSensor FROM LecturasSensor;
SELECT COUNT(*) AS Tablas_Sensores FROM Sensores;
SELECT COUNT(*) AS Tablas_ZonaRiego FROM ZonaRiego;
SELECT COUNT(*) AS Tablas_Estados FROM Estados;
SELECT COUNT(*) AS Tablas_Resultados FROM Resultados;