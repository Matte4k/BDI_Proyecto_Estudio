-------------------
/*
use master
go
-------------------
IF (select name from sys.databases where name ='sistema_riego') is not null  
    DROP DATABASE sistema_riego;
go
CREATE DATABASE sistema_riego;
*/

go
USE sistema_riego;
go

CREATE TABLE ZonaRiego
(
  id_zona INT IDENTITY,
  nombre VARCHAR(15) NOT NULL,
  descripcion VARCHAR(30) NOT NULL,
  superficie FLOAT NOT NULL,
  CONSTRAINT pk_id_zona PRIMARY KEY (id_zona)
);

/* Este procedimiento crea la cantidad de registros que se le pida para realizar las pruebas. */

CREATE OR ALTER PROCEDURE GenerarZonasRiegoPrueba
    @Cantidad INT = 100
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;

    WHILE @i <= @Cantidad
    BEGIN
        INSERT INTO ZonaRiego (nombre, descripcion, superficie)
        VALUES (
            CONCAT('Zona ', RIGHT('000' + CAST(@i AS varchar(3)), 3)),
            CONCAT('Zona de riego de prueba ', @i),
            CAST(10 + (ABS(CHECKSUM(NEWID())) % 991) AS float)          -- valor entre 10 y 1000
        );

        SET @i = @i + 1;
    END;
END;
GO

/* Ejecución del procedimiento para generar 100 zonas de riego de prueba. */

EXEC GenerarZonasRiegoPrueba @Cantidad = 100;


/*-- Configurar el modelo de recuperación de la base de datos a FULL --*/

-- Vemos el modelo de recuperación actual --
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'sistema_riego';
GO

-- Si NO está en FULL, lo cambiamos --
ALTER DATABASE sistema_riego
SET RECOVERY FULL;
GO

/*-- Realizar un backup completo de la base de datos --*/

BACKUP DATABASE sistema_riego
TO DISK = 'C:\Backups\sistema_riego_FULL.bak'
WITH INIT,                   -- sobrescribe el archivo si existe
     NAME = 'Backup FULL inicial sistema_riego';
GO

-- Generamos 10 registros --
EXEC GenerarZonasRiegoPrueba @Cantidad = 10;
GO

SELECT SYSDATETIME() AS HoraDespuesPrimeros10;
GO

/* Verificamos que se hayan realizado los 10 registros*/
SELECT COUNT(*) AS CantZonaRiego
FROM ZonaRiego;
GO

/* 
--Todos los insertados
SELECT *
FROM ZonaRiego;
GO 

--Solo los ultimos 10
SELECT TOP 10 *
FROM ZonaRiego
ORDER BY id_zona DESC;
GO
*/

/* Backup con registro principal + los 10 creados. Guardado como LOG1 */
BACKUP LOG sistema_riego
TO DISK = 'C:\Backups\sistema_riego_LOG1.trn'
WITH INIT,
     NAME = 'Backup LOG 1 - luego de primeros 10 inserts en ZonaRiego';
GO

SELECT SYSDATETIME() AS HoraBackupLog1; --Guardamos la hora del backup log 1
GO

-- Generamos 10 registros --
EXEC GenerarZonasRiegoPrueba @Cantidad = 10;
GO

SELECT SYSDATETIME() AS HoraDespuesSegundos10;
GO

/* Verificamos que se hayan realizado los otros 10 registros*/
SELECT COUNT(*) AS CantZonaRiego
FROM ZonaRiego;
GO

/* 
--Todos los insertados
SELECT *
FROM ZonaRiego;
GO 

--Solo los ultimos 10
SELECT TOP 10 *
FROM ZonaRiego
ORDER BY id_zona DESC;
GO
*/

/* Backup con registro principal + 10 del log1 + los 10 nuevos. Guardado como LOG2 */
BACKUP LOG sistema_riego
TO DISK = 'C:\Backups\sistema_riego_LOG2.trn'
WITH INIT,
     NAME = 'Backup LOG 2 - luego de otros 10 inserts en ZonaRiego';
GO

SELECT SYSDATETIME() AS HoraBackupLog1; --Guardamos la hora del backup log 2
GO

/* RESTAURACIONES DE LA BASE DE DATOS */

RESTORE DATABASE sistema_riego
FROM DISK = 'C:\Backups\sistema_riego_FULL.bak'
WITH NORECOVERY,             -- la base queda en estado "restoring"
     REPLACE,                -- permite sobrescribir
     STATS = 5;
GO

/* Restauramos hasta el LOG1 */

RESTORE LOG sistema_riego
FROM DISK = 'C:\Backups\sistema_riego_LOG1.trn'
WITH RECOVERY,               -- ahora la base queda ONLINE
     STATS = 5;
GO

-- Verificamos --

SELECT COUNT(*) AS CantZonaRiego
FROM ZonaRiego;
GO

SELECT TOP 20 *
FROM ZonaRiego
ORDER BY id_zona;
GO

-- Restauramos FULL --
RESTORE DATABASE sistema_riego
FROM DISK = 'C:\Backups\sistema_riego_FULL.bak'
WITH NORECOVERY,
     REPLACE,
     STATS = 5;
GO

-- Aplicamos LOG1 (sin recuperar todavia) --
RESTORE LOG sistema_riego
FROM DISK = 'C:\Backups\sistema_riego_LOG1.trn'
WITH NORECOVERY,
     STATS = 5;
GO

-- Aplicamos LOG2 y RECOVERY --
RESTORE LOG sistema_riego
FROM DISK = 'C:\Backups\sistema_riego_LOG2.trn'
WITH RECOVERY,
     STATS = 5;
GO

-- Verificamos --

SELECT COUNT(*) AS CantZonaRiego
FROM ZonaRiego;
GO

SELECT TOP 30 *
FROM ZonaRiego
ORDER BY id_zona;
GO

