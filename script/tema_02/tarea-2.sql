/*
	Ejecutar una búsqueda por período (sin índices)
	Medir tiempos y plan de ejecución.
*/

SET STATISTICS TIME ON;
SET STATISTICS IO ON;


SELECT *
FROM LecturasSensor
WHERE fecha_lectura BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE();

/*
Tiempo de CPU: 78 ms

Tiempo total: 271 ms

Lecturas lógicas: 5001

Tipo de operación: Table Scan
*/