--Repetir la consulta y registrar nuevo plan
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM LecturasSensor
WHERE fecha_lectura BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE();


/*
Tiempo de CPU: 16 ms

Tiempo total: 288 ms

Lecturas lógicas: 251

Tipo de operación: Clustered Index SEEK
*/