
 
/*Ejercicio 2:
Inserta varios registros m�s en la tabla PROFESORADO utilizando sentencias SQL. En la entrega de la tarea debes copiar las sentencias que has utilizado. Los datos deben ser los siguientes: 
Tabla PROFESORADO
Las columnas con los datos que aparecen en blanco no deben utilizarse en las sentencias.
Codigo	Nombre	Apellidos	DNI	Especialidad	Fecha Nacimiento	Antig�edad
5	Jos�	1	1C	Matem�ticas	01/12/1970	4
6	Marta	Mora Losa	2N	Lengua	 	 
7	Juan	Martos Lora	 	Dibujo	23/06/1969	 
8	Sara	Feria Arias	 	 	 	3 */
INSERT INTO PROFESORADO (CODIGO, NOMBRE, APELLIDOS, DNI, ESPECIALIDAD, FECHA_NAC, ANTIGUEDAD) VALUES (5, 'JOSE', '1', '1C', 'MATEMATICAS', '01/12/1970', 4);
INSERT INTO PROFESORADO (CODIGO, NOMBRE, APELLIDOS, DNI, ESPECIALIDAD) VALUES (6, 'MARTA', 'MORA LOSA', '2N', 'LENGUA');
INSERT INTO PROFESORADO (CODIGO, NOMBRE, APELLIDOS, ESPECIALIDAD, FECHA_NAC) VALUES (7, 'JUAN', 'MARTOS LORA', 'DIBUJO', '01/12/1970');
INSERT INTO PROFESORADO (CODIGO, NOMBRE, APELLIDOS, ANTIGUEDAD) VALUES (8, 'SARA', 'FERIAS ARIAS', 3); 

--Ejercicio 4: 
--Modifica de la tabla CURSOS el registro cuyo c�digo es 4, cambiando el valor de la fecha de inicio: 1/11/2016, fecha de fin: 31/12/2016 y el precio del curso a 1250.
UPDATE CURSOS SET FECHA_INIC= '1/11/2016', FECHA_FIN= '31/12/2016', PRECIO_CURSO= 1250 WHERE CODIGO=4;
  
--Ejercicio 5
--Modifica la columna terminado a los alumnos asign�ndole una �S� si el  n� de pagos totales es igual al n� de pagos realizados . Debes hacerlo usando una sola sentencia SQL que debes copiar para la entrega de la tarea.
UPDATE ALUMNADO SET TERMINADO='S' WHERE NRO_PAGOS_TOTALES= NRO_PAGOS_REALIZADOS;

--Ejercicio 8: 
--Elimina de la tabla ALUMNADO aquellos registros asociados al curso con c�digo 2. Debes hacerlo usando una sola sentencia SQL que debes copiar para la entrega de la tarea.
DELETE FROM ALUMNADO WHERE COD_CURSO=2;

--Ejercicio 9  
--Inserta en la tabla CURSOS_REALIZADOS un registro por cada curso que haya realizado un profesor, almacenando tambi�n el n� total de alumnos de ese curso. Debes hacerlo usando un sola sentencia SQL y copiarla en la entrega de la tarea.
INSERT INTO CURSOS_REALIZADOS 
select C.COD_PROFE,A.COD_CURSO,count(A.COD_CURSO) AS ALUMNOS
from alumnado A, CURSOS C
WHERE A.COD_CURSO=C.CODIGO
group by A.COD_CURSO, C.COD_PROFE;

--Ejercicio 10:
--Inserta en la tabla PENDIENTES_PAGO los alumnos cuyos cursos hayan finalizado (FECHA_FIN sea menor que la fecha del sistema) y que el n� de pagos totales sea mayor que n� de pagos realizados, se almacenar� en la tabla el n� de pagos pendientes. Debes hacerlo usando un sola sentencia SQL y copiarla en la entrega de la tarea.
INSERT INTO PENDIENTES_PAGO (COD_ALU, NRO_PAGOS_PENDIENTES)
SELECT A.CODIGO, (A.NRO_PAGOS_TOTALES-A.NRO_PAGOS_REALIZADOS) "PAGOS PENDIENTES"
FROM ALUMNADO A, CURSOS C
WHERE A. COD_CURSO=C.CODIGO 
AND A.NRO_PAGOS_TOTALES>A.NRO_PAGOS_REALIZADOS  
AND C.FECHA_FIN<SYSDATE;
Ejercicio 11:
En la tabla CURSOS, actualiza el campo FECHA_FIN a la fecha del sistema a los cursos con c�digo 2 y 3. Debes hacerlo usando un sola sentencia SQL y copiarla en la entrega de la tarea.
UPDATE CURSOS SET FECHA_FIN=SYSDATE WHERE CODIGO IN (2,3);

--Ejercicio 12:
--Actualiza la columna Max_Alumn del registro del curso con c�digo 2, asign�ndole el valor correspondiente al n�mero total de alumnos y alumnas que hay en la tabla ALUMNADO y que tienen asignado ese mismo curso. Debes hacerlo usando un sola sentencia SQL y copiarla en la entrega de la tarea.
UPDATE CURSOS SET MAX_ALUMN = 
(SELECT COUNT (CODIGO)
FROM ALUMNADO
WHERE COD_CURSO=2)
WHERE CODIGO=2;
 
--Ejercicio 13:
--Elimina de la tabla CURSOS aquellos cursos que no tengan ning�n alumno asignado a �l. Debes hacerlo usando un sola sentencia SQL y copiarla en la entrega de la tarea.
DELETE FROM CURSOS
WHERE CODIGO NOT IN (SELECT DISTINCT COD_CURSO FROM ALUMNADO);

--Otra soluci�n:
DELETE FROM CURSOS WHERE CODIGO=(SELECT COD_CURSO
FROM ALUMNADO 
GROUP BY COD_CURSO
HAVING COUNT(COD_CURSO)=0);

--Ejercicio 14: 
--Incrementa en un 10% el precio del precio del curso para aquellos cursos que tengan m�s de 20 alumnos inscritos en �l. Debes hacerlo usando un sola sentencia SQL y copiarla en la entrega de la tarea.
UPDATE CURSOS SET PRECIO_CURSO=PRECIO_CURSO*1.10 
WHERE CODIGO IN (
SELECT COD_CURSO 
FROM ALUMNADO
GROUP BY COD_CURSO
HAVING COUNT (CODIGO)>20); 





