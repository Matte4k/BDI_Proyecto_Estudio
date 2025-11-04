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
-------------------
if object_id('RegistroRiego') is not null DROP TABLE gasto;
go
if object_id('Resultados') is not null DROP TABLE edificio;
go
if object_id('ConfiguracionesRiego') is not null DROP TABLE localidad;
go
if object_id('LecturasSensor') is not null DROP TABLE provincia;
go
if object_id('Sensores') is not null DROP TABLE zona;
go
if object_id('ZonaRiego') is not null DROP TABLE conserje;
go
if object_id('Estados') is not null DROP TABLE administrador;
go
-------------------
CREATE TABLE Estados
(
  id_estado INT NOT NULL,
  nombre VARCHAR(10) NOT NULL,
  CONSTRAINT pk_id_estado PRIMARY KEY (id_estado)
);
go
-------------------
CREATE TABLE ZonaRiego
(
  id_zona INT IDENTITY,
  nombre VARCHAR(15) NOT NULL,
  descripcion VARCHAR(30) NOT NULL,
  superficie FLOAT NOT NULL,
  CONSTRAINT pk_id_zona PRIMARY KEY (id_zona)
);
go
-------------------
CREATE TABLE Sensores
(
  id_sensor INT IDENTITY,
  modelo VARCHAR(50) NOT NULL,
  fecha_instalacion DATE NOT NULL DEFAULT(GETDATE()),
  estado_sensor INT NOT NULL,
  zona_asignada INT NOT NULL,
  CONSTRAINT pk_id_sensor PRIMARY KEY (id_sensor),
  CONSTRAINT fk_estado_sensor FOREIGN KEY (estado_sensor) REFERENCES Estados(id_estado),
  CONSTRAINT fk_zona_asignada FOREIGN KEY (zona_asignada) REFERENCES ZonaRiego(id_zona)
);
go
-------------------
CREATE TABLE LecturasSensor
(
  id_lectura INT IDENTITY,
  fecha_lectura DATE NOT NULL DEFAULT(GETDATE()),
  humedad FLOAT NOT NULL,
  temperatura FLOAT NOT NULL,
  nivel_bateria INT NOT NULL,
  id_sensor_lectura INT NOT NULL,
  CONSTRAINT pk_id_lectura PRIMARY KEY (id_lectura, id_sensor_lectura),
  CONSTRAINT fk_id_sensor_lectura FOREIGN KEY (id_sensor_lectura) REFERENCES Sensores(id_sensor)
);
go
-------------------
CREATE TABLE ConfiguracionesRiego
(
  id_config INT IDENTITY,
  humedad_minima FLOAT NOT NULL,
  duracion_riego INT NOT NULL,
  frecuencia_lectura INT NOT NULL,
  fecha_actualizacion DATE NOT NULL DEFAULT(GETDATE()),
  id_zona_config INT NOT NULL,
  CONSTRAINT pk_id_config PRIMARY KEY (id_config, id_zona_config),
  CONSTRAINT fk_id_zona_config FOREIGN KEY (id_zona_config) REFERENCES ZonaRiego(id_zona)
);
go
-------------------
CREATE TABLE Resultados
(
  id_resultado INT,
  nombre VARCHAR(10) NOT NULL,
  CONSTRAINT pk_id_resultado PRIMARY KEY (id_resultado)
);
go
-------------------
CREATE TABLE RegistroRiego
(
  id_registro INT IDENTITY,
  fecha_riego DATE NOT NULL DEFAULT(GETDATE()),
  volumen_agua FLOAT NOT NULL,
  id_zona_registro INT NOT NULL,
  resultado INT NOT NULL,
  CONSTRAINT pk_id_registro PRIMARY KEY (id_registro, id_zona_registro),
  CONSTRAINT fk_id_zona_registro FOREIGN KEY (id_zona_registro) REFERENCES ZonaRiego(id_zona),
  CONSTRAINT fk_resultado_registro FOREIGN KEY (resultado) REFERENCES Resultados(id_resultado)
);
go
-------------------