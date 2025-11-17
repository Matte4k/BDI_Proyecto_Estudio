--Borrar el índice CLUSTERED actual--

--Identificamos el nombre--
EXEC sp_helpindex 'LecturasSensor';

--pk_id_lectura   clustered, unique, primary key
--Columnas: id_lectura, id_sensor_lectura

/*
La clave primaria es CLUSTERED

Lo que implica que los datos de la tabla están ordenados físicamente por (id_lectura, id_sensor_lectura).

Antes de poder crear un índice CLUSTERED en fecha_lectura

Debemos quitar este índice clustered y recrearlo como NONCLUSTERED.

*/

--Eliminar el índice CLUSTERED de la PK
ALTER TABLE LecturasSensor
DROP CONSTRAINT pk_id_lectura;

--Crear nuevamente la PK como índice NONCLUSTERED

ALTER TABLE LecturasSensor
ADD CONSTRAINT pk_id_lectura
PRIMARY KEY NONCLUSTERED (id_lectura, id_sensor_lectura);

--Crear el nuevo índice CLUSTERED en fecha_lectura
CREATE CLUSTERED INDEX IX_LECTURAS_FECHA
ON LecturasSensor (fecha_lectura);
