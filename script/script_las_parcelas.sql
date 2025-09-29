-- SCRIPT TEMA "Sistema de Control de Riegos Inteligentes"
-- DEFINNICIÓN DEL MODELO DE DATOS

CREATE DATATABLE sistema_riego;

USE sistema_riego;

CREATE TABLE localidad
(
  id_localidad INT NOT NULL,
  localidad VARCHAR(200) NOT NULL,
  PRIMARY KEY (id_localidad)
);

CREATE TABLE ubicacion
(
  direccion VARCHAR(200) NOT NULL,
  id_ubicacion INT NOT NULL,
  id_localidad INT NOT NULL,
  PRIMARY KEY (id_ubicacion),
  FOREIGN KEY (id_localidad) REFERENCES localidad(id_localidad)
);

CREATE TABLE cultivo
(
  nombre VARCHAR(200) NOT NULL,
  cantidad INT NOT NULL,
  id_cultivo INT NOT NULL,
  especie VARCHAR(200) NOT NULL,
  ciclo_edad INT,
  temporada VARCHAR(200) NOT NULL,
  PRIMARY KEY (id_cultivo)
);

CREATE TABLE parcelas
(
  area INT(200) NOT NULL,
  id_parcela INT NOT NULL,
  tipo_suelo VARCHAR(200) NOT NULL,
  id_ubicacion INT NOT NULL,
  id_cultivo INT NOT NULL,
  PRIMARY KEY (id_parcela),
  FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion),
  FOREIGN KEY (id_cultivo) REFERENCES cultivo(id_cultivo)
);

CREATE TABLE empleado
(
  id_empleado INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  apellido VARCHAR(200) NOT NULL,
  rol VARCHAR(200) NOT NULL,
  PRIMARY KEY (id_empleado)
);

CREATE TABLE registros
(
  detalles INT NOT NULL,
  id_parcela INT NOT NULL,
  id_empleado INT NOT NULL,
  PRIMARY KEY (id_parcela, id_empleado),
  FOREIGN KEY (id_parcela) REFERENCES parcelas(id_parcela),
  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE condicion_ambiental
(
  id_ambiente INT NOT NULL,
  humedad INT NOT NULL,
  temperatura INT NOT NULL,
  precipitaciones INT NOT NULL,
  PRIMARY KEY (id_ambiente)
);

CREATE TABLE sensores
(
  id_sensor INT NOT NULL,
  tipo INT NOT NULL,
  modelo INT NOT NULL,
  id_ambiente INT NOT NULL,
  id_parcela INT NOT NULL,
  PRIMARY KEY (id_sensor),
  FOREIGN KEY (id_ambiente) REFERENCES condicion_ambiental(id_ambiente),
  FOREIGN KEY (id_parcela) REFERENCES parcelas(id_parcela)
);

CREATE TABLE riego
(
  id_riego INT NOT NULL,
  fecha_hora_inicio DATE NOT NULL,
  fecha_hora_fin DATE NOT NULL,
  cantidad_ltr_m3 INT NOT NULL,
  PRIMARY KEY (id_riego)
);

CREATE TABLE sensor_riego
(
  estado VARCHAR(200) NOT NULL,
  id_sensor INT NOT NULL,
  id_riego INT NOT NULL,
  PRIMARY KEY (id_sensor, id_riego),
  FOREIGN KEY (id_sensor) REFERENCES sensores(id_sensor),
  FOREIGN KEY (id_riego) REFERENCES riego(id_riego)
);