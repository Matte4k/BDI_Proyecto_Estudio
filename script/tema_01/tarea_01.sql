use master;
GO

use sistema_riego;
GO

CREATE PROCEDURE sp_insertar_zona_riego
    @nombre VARCHAR(15),
    @descripcion VARCHAR(30),
    @superficie FLOAT
AS
BEGIN
    INSERT INTO ZonaRiego (nombre, descripcion, superficie)
    VALUES (@nombre, @descripcion, @superficie);
END;
GO

CREATE PROCEDURE sp_modificar_zona_riego
    @id_zona INT,
    @nombre VARCHAR(15),
    @descripcion VARCHAR(30),
    @superficie FLOAT
AS
BEGIN
    UPDATE ZonaRiego
    SET nombre = @nombre,
        descripcion = @descripcion,
        superficie = @superficie
    WHERE id_zona = @id_zona;
END;
GO

CREATE PROCEDURE sp_eliminar_zona_riego
    @id_zona INT
AS
BEGIN
    DELETE FROM ZonaRiego
    WHERE id_zona = @id_zona;
END;
GO