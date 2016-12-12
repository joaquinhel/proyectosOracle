/*1.A. Crea el tipo de objetos "MiembroEscolar" con los siguientes atributos:
•	codigo INTEGER,
•	dni VARCHAR2(10),
•	nombre VARCHAR2(30),
•	apellidos VARCHAR2(30),
•	sexo VARCHAR2(1),
•	fecha_nac DATE 
*/

CREATE OR REPLACE TYPE MIEMBROESCOLAR AS OBJECT(
	CODIGO INTEGER,
	DNI VARCHAR2(10),
	NOMBRE VARCHAR2(30),
	APELLIDOS VARCHAR2(30),
	SEXO VARCHAR2(1),
	FECHA_NAC DATE
	) NOT FINAL;
	/
	
/*1.B. Crea, como tipo heredado de "MiembroEscolar", el tipo de objeto "Profesor" con los siguientes atributos:
•	especialidad VARCHAR2(20),
•	antiguedad INTEGER 
*/
CREATE OR REPLACE TYPE PROFESOR UNDER MIEMBROESCOLAR(
	ESPECIALIDAD VARCHAR2(20),
	ANTIGUEDAD INTEGER,
-- Declaración método constructor (actividad 2)
	CONSTRUCTOR FUNCTION PROFESOR(CODIGO INTEGER, NOMBRE VARCHAR2,
		PRIMER_APELLIDO VARCHAR2, SEGUNDO_APELLIDO VARCHAR2, ESPECIALIDAD VARCHAR2)
		RETURN SELF AS RESULT,
-- Declaración del método GET para obtener el nombre completo (actividad 3)
	MEMBER FUNCTION GETNOMBRECOMPLETO RETURN VARCHAR2
		);
	/

/*1.C Crea el tipo de objeto "Cursos" con los siguientes atributos:
•	codigo INTEGER,
•	nombre VARCHAR2(20),
•	refProfe REF Profesor,
•	max_Alumn INTEGER,
•	fecha_Inic DATE,
•	fecha_Fin DATE,
•	num_Horas INTEGER
*/
CREATE OR REPLACE TYPE CURSOS AS OBJECT(
	CODIGO INTEGER,
	NOMBRE VARCHAR2(20),
	REF_PROFE REF PROFESOR,
	MAX_ALUMN INTEGER,
	FECHA_INIC DATE,
	FECHA_FIN DATE,
	NUM_HORAS INTEGER,
-- Declaramos el método MAP para la actividad 8.
	MAP MEMBER FUNCTION ORDENARCURSOS RETURN VARCHAR2
	);
	/

/*1.D Crea, como tipo heredado de "MiembroEscolar", el tipo de objeto "Alumno" con los siguientes atributos:
•	cursoAlumno Cursos*/
CREATE OR REPLACE TYPE ALUMNO UNDER MIEMBROESCOLAR(
	CURSOALUMNO CURSOS
	);
	/
 
/*2. Crea un método constructor para el tipo de objetos "Profesor", en el que se indiquen como parámetros el código, 
nombre, primer apellido, segundo apellido y especialidad. Este método debe asignar al atributo "apellidos" los datos
de primer apellido y segundo apellido que se han pasado como parámetros, uniéndolos con un espacio entre ellos.
*/
CREATE OR REPLACE TYPE BODY PROFESOR AS 
	CONSTRUCTOR FUNCTION PROFESOR (CODIGO INTEGER, NOMBRE VARCHAR2, PRIMER_APELLIDO VARCHAR2, SEGUNDO_APELLIDO VARCHAR2, ESPECIALIDAD VARCHAR2)
RETURN SELF AS RESULT IS 
	BEGIN
		SELF.CODIGO:=CODIGO;
		SELF.NOMBRE:=NOMBRE;
		SELF.APELLIDOS:= PRIMER_APELLIDO ||' '|| SEGUNDO_APELLIDO;
		SELF.ESPECIALIDAD:=ESPECIALIDAD;
	RETURN;
	END PROFESOR;



/*3. Crea un método "getNombreCompleto" para el tipo de objetos "Profesor" que permita obtener su
 nombre completo con el formato "apellidos nombre".*/
MEMBER FUNCTION GETNOMBRECOMPLETO RETURN VARCHAR2
IS
	BEGIN
		RETURN SELF.APELLIDOS||' '||SELF.NOMBRE;
END GETNOMBRECOMPLETO;
END; --Cerramos el TYPE BODY
/

/*4. Crea una tabla "Profesorado" de objetos "Profesor". Inserta en dicha tabla dos objetos "Profesor". El primero de ellos con los datos: 
•	codigo: 2
•	dni: 51083099F
•	nombre: MARIA LUISA
•	apellidos: FABRE BERDUN
•	sexo: F
•	fecha_nac: 31/03/1975
•	especialidad: TECNOLOGIA
•	antiguedad: 4
*/
CREATE TABLE PROFESORADO OF PROFESOR (PRIMARY KEY (CODIGO));
INSERT INTO PROFESORADO VALUES (2,'51083099F', 'MARIA LUISA', 'FABRE VERDUN', 'F', '31/03/1975', 'TECNOLOGIA', 4);

/*El segundo objeto "Profesor" debes crearlo usando el método constructor que has realizado anteriormente. Debes usar los siguientes datos:
•	codigo: 3
•	nombre: JAVIER
•	apellidos: JIMENEZ HERNANDO
•	especialidad: LENGUA
*/
--Es necesario introducir los dos apellidos por separado, ya que el constructor así lo requiere.
INSERT INTO PROFESORADO VALUES (PROFESOR (3, 'JAVIER', 'JIMENEZ', 'HERNANDO', 'LENGUA'));
/



--5. Crea una colección VARRAY llamada "ListaCursos" en la que se puedan almacenar hasta 10 objetos "Cursos".
CREATE OR REPLACE TYPE LISTACURSOS IS VARRAY(10) OF CURSOS;
--Guarda en una instancia "listaCursos1" de dicha lista, los dos cursos siguientes:
DECLARE
	LISTACURSOS1 LISTACURSOS; --Instancia del varray
	REF_PROFE REF PROFESOR; --El atributo ref_profe guardará una OID de profesor
	UNALUMNO ALUMNO; --Es necesario crearla para realizar el apartado 7
BEGIN
--Incluimos un “null” por cada posición del varray (10)
LISTACURSOS1:=LISTACURSOS (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

/*5.1 El primer curso que debes almacenar en dicha lista debe tener los siguientes datos:
•	codigo: 1
•	nombre: Curso 1
•	ref_Profe: Referencia al profesor cuyo código es 3.
•	max_Alumn: 20
•	fecha_Inic: 1/6/2011
•	fecha_Fin: 30/6/2011
•	num_Horas: 30
*/

--Obtenemos el identificador OID (REF(P1)) y lo guardamos en el atributo del objeto cursos, 
--este indicador hace referencia (proviene) a la tabla profesorado, concretamente del profesor con código 3.

SELECT REF(P1) INTO REF_PROFE FROM PROFESORADO P1 WHERE P1.CODIGO=3;

--Creamos la primera lista (objeto) con los datos que ya tenemos a partir del tipo de datos cursos
LISTACURSOS1 (1):= CURSOS(1, 'CURSO 1', REF_PROFE, 20, '1/6/2011', '30/6/2011', 30);

/*5.2 El segundo curso que debes almacenar en dicha lista debe tener los siguientes datos:
•	codigo: 2
•	nombre: Curso 2
•	ref_Profe: Referencia al profesor cuyo DNI es 51083099F.
•	max_Alumn: 20
•	fecha_Inic: 1/6/2011
•	fecha_Fin: 30/6/2011
•	num_Horas: 30
*/
--Obtenemos el identificador OID (REF(P2)) y lo guardamos en el atributo del objeto cursos, este 
--indicador hace referencia (proviene) a la tabla profesorado, concretamente del profesor con DNI 51083099F.

SELECT REF(P2) INTO REF_PROFE FROM PROFESORADO P2 WHERE P2.DNI = '51083099F';

--Creamos la segunda lista (objeto) con los datos que ya tenemos a partir del tipo de datos cursos
LISTACURSOS1 (2):= CURSOS(2, 'CURSO 2', REF_PROFE, 20, '1/6/2011', '30/6/2011', 30);



--6. Crea una tabla "Alumnado" de objetos "Alumno".

CREATE TABLE ALUMNADO OF ALUMNO (PRIMARY KEY(CODIGO));
/*
 Inserta en dicha tabla las siguientes filas:
•	codigo: 100
•	dni: 76401092Z
•	nombre: MANUEL
•	apellidos: SUAREZ IBAÑEZ
•	sexo: M
•	fecha_nac: 30/6/1990
•	cursoAlumno: objeto creado anteriormente para el primer curso.
*/
--Insertamos los valores con el constructor por defecto que Oracle crea de forma automática.
INSERT INTO ALUMNADO VALUES (ALUMNO(100, '76401092Z', 'MANUEL', 'SUAREZ IBAÑEZ', 'M', '30/6/1990', LISTACURSOS1 (1)));
/*
•	codigo: 102
•	dni: 6915588V
•	nombre: MILAGROSA
•	apellidos: DIAZ PEREZ
•	sexo: F
•	fecha_nac: 28/10/1984
•	cursoAlumno: objeto que se encuentre en la segunda posición de "listaCursos1" 
*/
--Insertamos los valores con el constructor por defecto que Oracle crea de forma automática.
INSERT INTO ALUMNADO VALUES (ALUMNO(102, '6915588V', 'MILAGROSA', 'DIAZ PEREZ', 'F', '28/10/1984', LISTACURSOS1 (2)));


/*7. Obtener, de la tabla "Alumnado", el alumno que tiene el código 100, asignándoselo a una variable "unAlumno".
Modifica el código del alumno guardado en esa variable "unAlumno" asignando el valor 101, y su curso debe ser 
el segundo que se había creado anteriormente. Inserta ese alumno en la tabla "Alumnado".
*/
--Con “value” hacemos referencia al objeto completo. Guardamos el objeto con código 100 de
-- la tabla alumnado en lavariable unalumno que declaramos en el ejercicio 5
SELECT VALUE(A) INTO UNALUMNO FROM ALUMNADO A WHERE A.CODIGO = 100;
--Cambiamos el valor del atributo código de unalumno
UNALUMNO.CODIGO := 101;
--Cambiamos el curso (1) por el curso(2)
UNALUMNO.CURSOALUMNO := LISTACURSOS1 (2);
--Realizamos la inserción en la tabla alumnado de los dos valores anteriores(UNALUMNO).
INSERT INTO ALUMNADO VALUES (UNALUMNO);
END; --Cerramos el bloque anónimo abierto en el ejercicio 5
/


/*8. Crea un método MAP "ordenarCursos" para el tipo "Cursos". Este método debe retornar el nombre completo del 
profesor al que hace referencia cada curso. Para obtener el nombre debes utilizar el método getNombreCompleto que 
se ha creado anteriormente. Realiza una consulta de la tabla "Alumnado" ordenada por "cursoAlumno" para comprobar el 
funcionamiento del método MAP.*/

--Primero debemos ir al apartado 1.c y declarar el método MAP que desarrollaremos aquí
CREATE OR REPLACE TYPE BODY CURSOS AS
MAP MEMBER FUNCTION ORDENARCURSOS RETURN VARCHAR2 IS
	NOM_COMPLETO_PRO PROFESOR; --Objeto del tipo profesor
BEGIN
--Para acceder al objeto referido por un REF (en la tabla cursos) se utiliza DEREF
--En la cláusula FROM podemos utilizar cualquier tabla, ya que la referencia apunta a un objeto 
--que se encuentra almacenado en una tabla, no hace falta de nuevo incluir la tabla, por ello
--utilizamos la tabla por defecto DUAL

	SELECT DEREF(REF_PROFE)INTO NOM_COMPLETO_PRO FROM DUAL;
--Llamamos al método getnombrecompleto del objeto NOM_COM_PRO
	RETURN NOM_COMPELTO_PRO.GETNOMBRECOMPLETO; 
END ORDENARCURSOS;
END;

SELECT * FROM ALUMNADO ORDER BY CURSOALUMNO;
/
