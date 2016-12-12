/*EJERCICIO 1:
Vamos a crear las tablas para una Academia donde se imparten distintos cursos de informática. Empezaremos creando con SQL
las siguientes tablas:
•	Tabla ALUMNOS recogerá información sobre el alumnado: Nombre, Apellido1, Apellido2, NIF, Dirección, Sexo, Fecha de Nacimiento
y Curso en el que se matricula.
•	Tabla CURSOS con los siguientes campos: Nombre del Curso, Código del Curso que lo identifica, NIF del Profesor, 
Máximo número de alumnos/as recomendado, Fecha de inicio, Fecha final, Número de horas totales del curso. Los alumnos/as no 
pueden compaginar varios cursos a la vez.
•	Tabla PROFESORES con los siguientes campos: Nombre, Apellido1, Apellido2, NIF, Dirección, Titulación, Salario.
a.	Debes elegir los nombres más adecuados para los atributos teniendo en cuenta las reglas.
b.	Debes elegir los tipos de datos adecuados en función del contenido de los campos.
c.	Debes establecer las siguientes restricciones: 
1.	El alumno o alumna debe matricularse en un curso antes de que se le pueda dar de alta.
2.	En un curso, el número de horas es un dato que no puede faltar, es obligatorio que contenga información.
3.	En la tabla PROFESORES, el atributo Salario no puede estar vacío.
4.	Dos cursos no pueden llamarse de la misma forma.
5.	Dos profesores no pueden llamarse igual.
6.	Podremos diferenciar las tuplas de la tabla CURSOS por el Código del Curso.
7.	Podremos diferenciar las tuplas de la tabla PROFESORES y ALUMNOS por el NIF.
8.	La fecha de comienzo del curso nunca puede ser menor que la fecha de finalización.
9.	El dominio del atributo sexo es M (mujer) y H (hombre).
10.	Se debe cumplir la regla de integridad referencial.
 */


-- EJERCICIO 1:
--CREAMOS LA TABLA PROFESORES:
CREATE TABLE PROFESORES (
NIF VARCHAR(9), 
NOMBRE VARCHAR(30), 
APELLIDO1 VARCHAR(30), 
APELLIDO2 VARCHAR(30), 
DIRECCION VARCHAR(120), 
TITULACION VARCHAR (50), 
SALARIO NUMBER(7) NOT NULL,

CONSTRAINT PRO_NIF_PK PRIMARY KEY (NIF),
CONSTRAINT PRO_SAL_CK CHECK (SALARIO>=0),
CONSTRAINT PRO_NOM_UK UNIQUE (NOMBRE, APELLIDO1, APELLIDO2)
);

-- CREAMOS LA TABLA CURSOS
CREATE TABLE CURSOS (
COD_CURSO VARCHAR2(6),
NOMBRE VARCHAR2(50),
NIF_PROFE VARCHAR2(9),
MAX_ALUMNOS NUMBER(3),
F_INICIO DATE,
F_FIN DATE,
HORAS_TOTAL NUMBER(3) NOT NULL,

CONSTRAINT CUR_COD_PK PRIMARY KEY(COD_CURSO),
CONSTRAINT CUR_NOM_UK UNIQUE (NOMBRE),
CONSTRAINT CUR_FEC_CK CHECK (F_INICIO<F_FIN)
);


-- CREAMOS LA TABLA ALUMNOS:
CREATE TABLE ALUMNOS (
NOMBRE VARCHAR2(30), 
APELLIDO1 VARCHAR2(30), 
APELLIDO2 VARCHAR2(30), 
NIF VARCHAR2(9), DIRECCION VARCHAR(120), 
SEXO VARCHAR2(1), 
F_NACIMIENTO DATE, 
COD_CUR VARCHAR(5) NOT NULL,

CONSTRAINT ALU_NIF_PK PRIMARY KEY (NIF),
CONSTRAINT ALU_COD_FK FOREIGN KEY (COD_CUR) REFERENCES CURSOS (COD_CURSO),
CONSTRAINT ALU_SEX_CK CHECK (SEXO IN ('H','M'))
);


/*EJERCICIO2:
Vamos a modificar las tablas que hemos creado en el apartado anterior:
1.	Crea un nuevo atributo llamado Edad de tipo numérico a la tabla ALUMNOS.  */
ALTER TABLE ALUMNOS ADD (EDAD NUMBER(3));

/*Añade las siguientes restricciones:
2.	Modifica el campo que has creado anteriormente para que la edad del alumno o alumna esté comprendida entre 14 y 65 años.*/
ALTER TABLE ALUMNOS MODIFY EDAD NUMBER(3) CHECK (EDAD BETWEEN 14 AND 65);

/*3.	Modifica el campo Número de horas del CURSO de manera que solo pueda haber cursos con 30, 40 o 60 horas.
DOS POSIBLES SOLUCIONES: */
ALTER TABLE CURSOS ADD CONSTRAINT CUR_HOR_CK CHECK (HORAS_TOTAL IN (30,40, 60));
ALTER TABLE CURSOS MODIFY HORAS_TOTAL CHECK (HORAS_TOTAL IN (30,40,60));


--4.	No podemos añadir un curso si su número máximo de alumnos es inferior a 15.
ALTER TABLE CURSOS ADD CONSTRAINT ALU_MIN_CK CHECK (MAX_ALUMNOS>=15);

--5.	Elimina la restricción que controla los valores que puede tomar el atributo Sexo.
ALTER TABLE ALUMNOS DROP CONSTRAINT ALU_SEX_CK;

--6.	Elimina la columna Dirección de la tabla PROFESORES.
ALTER TABLE PROFESORES DROP COLUMN DIRECCION;

--7.	Cambia la clave primaria de la tabla PROFESORES por Nombre y Apellidos.
ALTER TABLE PROFESORES DROP CONSTRAINT PRO_NIF_PK CASCADE;
ALTER TABLE PROFESORES ADD CONSTRAINT NOM_APE_PK PRIMARY KEY (nombre,  apellido1, apellido2);

--8.	Renombra la tabla PROFESORES por TUTORES.
RENAME PROFESORES TO TUTORES;

--9.	Elimina la tabla ALUMNOS.
DROP TABLE ALUMNOS;

--10.	Crea un usuario con tu nombre y clave BD02 y dale todos los privilegios sobre la tabla CURSOS.
CREATE USER JOAQUIN IDENTIFIED BY BD02;
GRANT ALL ON CURSOS TO JOAQUIN;

--11.	Ahora al usuario anterior quítale permisos para modificar o actualizar la tabla CURSOS.
REVOKE UPDATE, ALTER ON CURSOS FROM JOAQUIN;


