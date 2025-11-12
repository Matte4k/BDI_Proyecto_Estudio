use master;
GO

use sistema_riego;
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

-------------------
-- ACTUALIZACION --
-------------------
SELECT * FROM ZonaRiego
WHERE id_zona = 137;
GO

EXEC sp_modificar_zona_riego @id_zona = 137, @nombre = 'Zona_Modificada', @descripcion = 'Descripción actualizada', @superficie = 500.0;
GO

SELECT * FROM ZonaRiego
WHERE id_zona = 137;
GO

-----------------
-- ELIMINACION --
-----------------
SELECT * FROM ZonaRiego
WHERE id_zona = 150;
GO

EXEC sp_eliminar_zona_riego @id_zona = 150;
GO

SELECT * FROM ZonaRiego
WHERE id_zona > 145;
GO