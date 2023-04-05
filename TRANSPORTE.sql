--BASE DE DATOS
create database transporte;

--CRITERI DE USUARIO
create role administrador superuser login password 'carlos9597';

--TABLESPACE
create tablespace BaseDatosII location 'C:/TBS';

--DOMINIO
create domain DOMINIO_CODIGO as integer
constraint chk_DOMINIO_CODIGO
check(value >= 0 AND value <= 400);

--MODIFICAR DOMINIO
alter domain DOMINIO_CODIGO
drop constraint chk_DOMINIO_CODIGO;

alter domain DOMINIO_CODIGO 
add constraint chk_DOMINIO_CODIGO 
check(value >= 0 and value <= 1000);

--DOMINIO
create domain PLACA as varchar
constraint chk_PLACA
check(value ~ '^[0-9]{4}[A-Z]{3}$');

--DOMINIO
create domain TEXTO50 as varchar(50) 
constraint chk_TEXTO50 not null;

--MODIFICAR DOMINIO
alter domain TEXTO50
add constraint chk_TEXTO50
check(length(value) >= 4);

--TABLA 
create table BUSES(
	ID_bus DOMINIO_CODIGO primary key,
	Modelo TEXTO50,
	Matricula PLACA
);

--TABLA
create table CONDUCTORES(
	ID_conductor DOMINIO_CODIGO primary key,
	Nombre TEXTO50,
	Cedula TEXTO50
);

--DOMINIO
create domain PARADA as smallint default 0;

--TABLA
create table LINEAS(
	ID_linea DOMINIO_CODIGO primary key,
	ID_bus DOMINIO_CODIGO,
	ID_conductor DOMINIO_CODIGO,
	Num_Paradas PARADA,
	constraint FK_BUSES foreign key (ID_bus) references BUSES(ID_bus),
	constraint FK_CONDUCTORES foreign key (ID_conductor) references CONDUCTORES(ID_conductor)
);

--INSERTAR DATOS CONDUCTOR
INSERT INTO CONDUCTORES (id_conductor,Nombre,Cedula) 
VALUES(101,'PEPE', '1111111'),(102,'PACO','1093992'),
(103,'LUIS','22222222'),(104,'ANAI','1092994'),
(105,'PEPE','1034995'),(106,'WILLIAM','6099553');

--INSERTAR DATOS BUSES
INSERT INTO BUSES (ID_bus,modelo, matricula) 
VALUES(1,'viudanegra', '1234ABC'),
(2,'pataverde', '1234BCD'),(3,'la veloz', '1234CDE'),
(4,'la rapida', '4321ABC'),(5,'lo peor', '4567ABC');

--INSERTAR DATOS LINEAS
INSERT INTO lineas (id_linea, id_conductor, ID_bus) 
VALUES(11,101,1),(21,101,2),(31,101,4),(41,102,1),
(51,105,3),(61,103,1);

--MOSTRAR DATOS
select * from conductores c;
select * from buses b;
select * from lineas l;

--MODIFICACIONES TABLA LINEAS
alter table lineas add column 
UBICACION TEXTO50 default 'Av. Olivos';

--MODIFICAR TABLA CONDUCTORES
alter table conductores 
add constraint CEDULA_UNICO
unique(Cedula);

--MODIFICAR TABLA LINEAS
alter table lineas rename column num_paradas to numero_paradas;

--MODIFICAR TABLA LINEAS
alter table lineas rename column UBICACION to NUMERO;

--MODIFICAR TABLA LINEAS
create domain NUM_COD as text 
check(value ~ '^NUM-(0[1-9]|[1-9][0-9])$');

alter table lineas drop column NUMERO;

alter table lineas add column 
NUMERO NUM_COD default 'NUM-01';

--CREAR UN SCHEMA
create schema SCH_TRANSPORT;

--MOVER DOMINIO
alter domain NUM_COD set schema SCH_TRANSPORT;

--MODIFICAR TABLA CONDUCTORES
update conductores set nombre = 'Carlos', cedula = 8378152
where id_conductor = 106;

--GESTION DE USUARIOS
--BORRAR USUARIO
drop user if exists user1;
drop role if exists user1;

--CREAR USUARIO
create user user1 login password '12345';

--CREAR ROLE
create role role1 login;

--ASIGNAMOS A USER1 A ROLE1
grant role1 to user1;

--PERMITIR ROLE1 SELECT TABLA LINEAS
grant select on lineas to role1;

--CREACION DE HERENCIAS
create table CONDUCTORES_A(
	check(id_conductor >=101 and id_conductor <= 103)
)inherits(CONDUCTORES);

create table CONDUCTORES_B(
	check(id_conductor >=104 and id_conductor <= 106)
)inherits(CONDUCTORES);

create rule CONDUCTORES_A as on insert to CONDUCTORES
where (id_conductor >=101 and id_conductor <= 103)
do instead insert into CONDUCTORES_A VALUES(new.*);

create rule CONDUCTORES_B as on insert to CONDUCTORES
where (id_conductor >=104 and id_conductor <= 106)
do instead insert into CONDUCTORES_B VALUES(new.*);
 
INSERT INTO CONDUCTORES (id_conductor,Nombre,Cedula) 
VALUES(101,'PEPE', '1111111'),(102,'PACO','1093992'),
(103,'LUIS','22222222'),(104,'ANAI','1092994'),
(105,'PEPE','1034995'),(106,'CARLOS','8378152');

select * from CONDUCTORES_A;
select * from CONDUCTORES_B;

--MOSTRAR REGISTRO BUSES
select * from buses where matricula like '%4%';

--MOSTRAR REGISTROS CONDUCTORES
select * from conductores where nombre like 'P%'; 

--MOSTRAR REGISTRO BUSES NOMBRE(MODELO) EN MAYUSCULA
select upper(modelo) from buses; 
