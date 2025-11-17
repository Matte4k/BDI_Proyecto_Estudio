--Carga masiva de 1.000.000 de registros en LecturasSensor


USE sistema_riego;
GO


DECLARE @minSensor INT, @maxSensor INT;
SELECT @minSensor = MIN(id_sensor), @maxSensor = MAX(id_sensor) FROM Sensores;

;WITH Numbers AS (
    SELECT TOP (1000000)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects AS a
    CROSS JOIN sys.objects AS b
    CROSS JOIN sys.objects AS c
)
INSERT INTO LecturasSensor (fecha_lectura, humedad, temperatura, nivel_bateria, id_sensor_lectura)
SELECT
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 730, GETDATE()),   -- 2 años hacia atrás
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 100, 2) AS FLOAT),    -- humedad
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 35 + 5, 2) AS FLOAT), -- temperatura
    ABS(CHECKSUM(NEWID())) % 100,                              -- batería
    FLOOR(RAND(CHECKSUM(NEWID())) * (@maxSensor - @minSensor + 1)) + @minSensor
FROM Numbers;

GO


SELECT COUNT(*) AS TotalLecturas FROM LecturasSensor;
