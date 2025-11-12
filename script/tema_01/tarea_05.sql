use master;
GO

use sistema_riego;
GO

SET STATISTICS TIME ON;			-- Este comando muestra el tiempo necesario para analizar, compilar y ejecutar cada declaracion de la consulta
SET STATISTICS IO ON;			-- Este comando muestra el tiempo de actividad en disco generado por la consulta
GO

-- Para testear vamos a usar los comandos de la Tarea 2
-----------------------
-- INSERCION DIRECTA --
-----------------------
INSERT INTO ZonaRiego (nombre, descripcion, superficie) VALUES 
('Zona_501', '햞ea experimental 1', 320.5),
('Zona_502', '햞ea experimental 2', 410.8),
('Zona_503', '햞ea experimental 3', 275.0),
('Zona_504', '햞ea experimental 4', 380.2),
('Zona_505', '햞ea experimental 5', 295.6),
('Zona_506', '햞ea experimental 6', 450.0),
('Zona_507', '햞ea experimental 7', 510.3),
('Zona_508', '햞ea experimental 8', 390.7),
('Zona_509', '햞ea experimental 9', 465.9),
('Zona_510', '햞ea experimental 10', 340.4);
GO

--------------------------------------
-- INSERCION MEDIANTE PROCEDIMIENTO --
--------------------------------------
EXEC dbo.sp_insertar_zona_riego 'Zona_511', 'Zona agregada mediante SP 1', 410.5;
EXEC dbo.sp_insertar_zona_riego 'Zona_512', 'Zona agregada mediante SP 2', 355.0;
EXEC dbo.sp_insertar_zona_riego 'Zona_513', 'Zona agregada mediante SP 3', 430.3;
EXEC dbo.sp_insertar_zona_riego 'Zona_514', 'Zona agregada mediante SP 4', 298.7;
EXEC dbo.sp_insertar_zona_riego 'Zona_515', 'Zona agregada mediante SP 5', 500.0;
EXEC dbo.sp_insertar_zona_riego 'Zona_516', 'Zona agregada mediante SP 6', 475.2;
EXEC dbo.sp_insertar_zona_riego 'Zona_517', 'Zona agregada mediante SP 7', 382.9;
EXEC dbo.sp_insertar_zona_riego 'Zona_518', 'Zona agregada mediante SP 8', 445.4;
EXEC dbo.sp_insertar_zona_riego 'Zona_519', 'Zona agregada mediante SP 9', 410.8;
EXEC dbo.sp_insertar_zona_riego 'Zona_520', 'Zona agregada mediante SP 10', 390.1;
GO

-- Y ahora para las funciones, usando la de humedad promedio
SELECT dbo.fn_promedio_humedad_zona(1) AS Promedio_Humedad;

SELECT
    AVG(humedad) AS Promedio_Humedad
FROM LecturasSensor AS L
INNER JOIN Sensores AS S ON L.id_sensor_lectura = S.id_sensor
WHERE S.zona_asignada = 1;
GO