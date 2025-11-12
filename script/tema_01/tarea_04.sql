use master;
GO

use sistema_riego;
GO

----------------------
-- HUMEDAD PROMEDIO --
----------------------
CREATE FUNCTION fn_promedio_humedad_zona (@id_zona INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @promedio FLOAT;                                    -- DECLARE se usa para definir una variable dentro del cuerpo de la funcion.
    SELECT @promedio = AVG(humedad)
    FROM LecturasSensor AS L
    INNER JOIN Sensores AS S ON L.id_sensor_lectura = S.id_sensor
    WHERE S.zona_asignada = @id_zona;
    RETURN @promedio;
END;
GO

----------------------------------
-- CANTIDAD DE SENSORES ACTIVOS --
----------------------------------
CREATE FUNCTION fn_cant_sensores_activos ()
RETURNS INT
AS
BEGIN
    DECLARE @cantidad INT;
    SELECT @cantidad = COUNT(*) FROM Sensores WHERE estado_sensor = 1;
    RETURN @cantidad;
END;
GO

------------------------
-- EFICIENCIA DE ZONA --
------------------------
CREATE FUNCTION fn_eficiencia_riego_zona (@id_zona INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @total INT, @exitosos INT;
    SELECT @total = COUNT(*) FROM RegistroRiego WHERE id_zona_registro = @id_zona;
    SELECT @exitosos = COUNT(*) FROM RegistroRiego WHERE id_zona_registro = @id_zona AND resultado = 1;
    RETURN CASE WHEN @total = 0 THEN 0 ELSE CAST(@exitosos AS FLOAT)/@total * 100 END;
END;
GO