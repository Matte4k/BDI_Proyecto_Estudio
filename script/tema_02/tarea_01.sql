use master;
GO

use sistema_riego;
GO

/*
Manejo de transacciones
*/
BEGIN TRY;	
	BEGIN TRAN; 
	--CASO EXITOSO
		INSERT INTO RegistroRiego(volumen_agua,id_zona_registro,resultado)
		VALUES (288.70,1,1);

		INSERT INTO LecturasSensor(humedad,temperatura,nivel_bateria,id_sensor_lectura)
		VALUES(70.5,30.33,80,3);

		UPDATE ConfiguracionesRiego
			SET duracion_riego = 30
		WHERE id_config = 5;

	COMMIT TRAN;
	PRINT 'Operacion completada con exito';
END TRY
BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'Error detectado. Se revirtiron los cambios.';
END CATCH;
GO


--TABLAS 
SELECT * FROM Resultados;
SELECT * FROM ZonaRiego;
SELECT * FROM ConfiguracionesRiego;
SELECT * FROM LecturasSensor;
SELECT * FROM Sensores;
SELECT * FROM Estados;
SELECT * FROM RegistroRiego;


--CANTIDAD DE REGISTROS EN CADA TABLA
SELECT COUNT(*) AS Resultados FROM Resultados;
SELECT COUNT(*) AS ZonaRiego FROM ZonaRiego;
SELECT COUNT(*) AS ConfiguracionesRiego FROM ConfiguracionesRiego;
SELECT COUNT(*) AS LecturasSensor FROM LecturasSensor;
SELECT COUNT(*) AS Sensores FROM Sensores;
SELECT COUNT(*) AS Estados FROM Estados;
SELECT COUNT(*) AS RegistroRiego FROM RegistroRiego;