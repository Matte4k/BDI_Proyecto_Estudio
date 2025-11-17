/*
	Crear índice CLUSTERED + columnas incluidas

*/

CREATE NONCLUSTERED INDEX IX_LECTURAS_FECHA_INCL
ON LecturasSensor (fecha_lectura)
INCLUDE (humedad, temperatura, nivel_bateria);

--Repetimos la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT humedad, temperatura, nivel_bateria, fecha_lectura
FROM LecturasSensor
WHERE fecha_lectura BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE();

/*
Tiempo de CPU: 31 ms

Tiempo total: 203 ms

Lecturas lógicas: 196

Tipo de operación: Clustered Index SEEK
*/