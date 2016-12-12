/*La empresa El Desv�n, que se dedica a la rama textil ha decidido informatizar su gesti�n de n�minas. Para ello BK programaci�n desarrollar� para ellos la base de datos.
El gerente le ha explicado c�mo funciona la gesti�n de n�minas y Juan, que ser� quien se encargue de crear el modelo, las tablas y las consultas, ha recogido la siguiente informaci�n:
o	A cada empleado se le entrega un justificante de n�mina al mes. De cada empleado registraremos su c�digo de empleado, nombre, apellidos, n�mero de hijos, cuenta corriente y porcentaje de retenci�n para Hacienda.
o	Un empleado puede trabajar en varios Departamentos y en cada uno de ellos realizar� una funci�n.
o	De un Departamento mantenemos el nombre del mismo y un c�digo de Departamento.
o	Los datos de un justificante de n�mina son el ingreso total percibido por el empleado y el descuento total aplicado.
o	La distinci�n entre dos justificantes de n�mina se hace, adem�s de mediante el c�digo de empleado, mediante el ejercicio fiscal y n�mero de mes al que pertenece.
o	Cada justificante de n�mina consta de varias l�neas y cada l�nea se identifica por un n�mero de l�nea del correspondiente justificante. Una l�nea puede corresponder a un ingreso o a un descuento. En ambos casos se recoge la cantidad (positiva o negativa). En el caso de los descuentos se recoge la base y el porcentaje.
 */

--1. Visualizar todos los campos de los empleados.
SELECT * FROM EMPLEADOS ORDER BY CODIGO;


--2. C�digo y nombre de los empleados ordenados ascendentemente por nombre.
SELECT CODIGO, NOMBRE FROM EMPLEADOS ORDER BY CODIGO ASC;


--3. Nombre de los empleados que tienen m�s de 2 hijos.
SELECT NOMBRE FROM EMPLEADOS WHERE HIJOS>2;


--4. Nombre,  N�mero de cuenta de los empleados cuya retenci�n es mayor o igual que 7 y que tengan alg�n hijo.
SELECT NOMBRE, CUENTA FROM EMPLEADOS WHERE RETENCION=7 AND HIJOS>0;


--5. C�digo del empleado, Mes y ejercicio de los justificantes de n�mina pertenecientes los empleado cuyos c�digos sean 1 , 21, 13 o 4 ordenado por c�digo.
SELECT COD_EMP, MES, EJERCICIO FROM JUST_NOMINAS WHERE COD_EMP IN(1,21,13,4) ORDER BY COD_EMP;

--6. C�digo y n�mero de cuenta de los empleados cuyo nombre empiece por 'A' o por 'J' y que el n� de hijos est� entre 2 y 5.
SELECT CODIGO, CUENTA FROM EMPLEADOS WHERE NOMBRE LIKE'A%' OR NOMBRE LIKE'J%' AND HIJOS IN (2,3,4,5);

--Otra opci�n:
SELECT CODIGO, CUENTA FROM EMPLEADOS WHERE NOMBRE LIKE'A%' OR NOMBRE LIKE'J%' AND HIJOS BETWEEN 2 AND 5;


--7. N�mero de empleados que hay en la base de datos.
SELECT COUNT(CODIGO) "N�_EMPLEADOS" FROM EMPLEADOS;

--Tambi�n podr�a ser:
SELECT COUNT(*) "N�_EMPLEADOS" FROM EMPLEADOS;


--8. Nombre del primer y �ltimo empleado en t�rminos alfab�ticos.
SELECT MIN(NOMBRE) "PRIMER NOMBRE", MAX(NOMBRE) "ULTIMO NOMBRE" FROM EMPLEADOS;


--9. Nombre y n�mero de hijos de los empleados cuya retenci�n es: 8, 10 o 12 ordenado por hijos y dentro de �ste por nombre.
SELECT NOMBRE, HIJOS FROM EMPLEADOS WHERE RETENCION IN(8,10,12) ORDER BY HIJOS DESC,NOMBRE;


--10. N�mero de hijos y n�mero de empleados agrupados por hijos, mostrando s�lo los grupos cuyo n�mero de empleados sea mayor que 1. Es decir, mostrar cu�ntos empleados hay que tengan 1 hijo, 2 hijos,�
SELECT HIJOS, COUNT(NOMBRE) "N�_EMPLEADOS" FROM EMPLEADOS WHERE HIJOS>0 GROUP BY HIJOS;


--11.  Nombre y funci�n de los empleados que han trabajado en el departamento 1.
SELECT E.NOMBRE, T.FUNCION FROM EMPLEADOS E, TRABAJAN T WHERE T.COD_EMP=E.CODIGO  AND COD_DEP=1;

--Otra soluci�n:
SELECT E.NOMBRE, T.FUNCION FROM EMPLEADOS E JOIN TRABAJAN T ON COD_EMP=CODIGO WHERE T.COD_DEP = 1;


--12.  Versi�n 1: Visualizar por departamento cu�ntos empleados tiene.
SELECT T.COD_DEP, COUNT(E.CODIGO) "N�TRABAJADORES" FROM EMPLEADOS E, TRABAJAN T WHERE T.COD_EMP=E.CODIGO GROUP BY T.COD_DEP ORDER BY T.COD_DEP;

--Versi�n 2: Igual pero visualizando el nombre del departamento
SELECT D.NOMBRE, COUNT(E.CODIGO) "N�TRABAJADORES"
FROM EMPLEADOS E, TRABAJAN T, DEPARTAMENTOS D
WHERE E.CODIGO=T.COD_EMP AND T.COD_DEP=D.CODIGO GROUP BY D.NOMBRE ORDER BY D.NOMBRE;


13.  Nombre del empleado, nombre del departamento y funci�n que han realizado de los empleados que tienen 1 hijo.
SELECT E.NOMBRE "NOMBRE EMPLEADO", D.NOMBRE "NOMBRE DEL DEPARTAMENTO", T.FUNCION
FROM EMPLEADOS E, TRABAJAN T, DEPARTAMENTOS D
WHERE E.CODIGO=T.COD_EMP AND T.COD_DEP=D.CODIGO AND E.HIJOS=1 ORDER BY E.NOMBRE;


--14.  Nombre del empleado y nombre del departamento en el que han trabajado empleados que no tienen hijos.
SELECT DISTINCT E.NOMBRE "NOMBRE EMPLEADO", D.NOMBRE "NOMBRE DEL DEPARTAMENTO" FROM EMPLEADOS E, TRABAJAN T, DEPARTAMENTOS D WHERE E.CODIGO=T.COD_EMP AND T.COD_DEP=D.CODIGO AND E.HIJOS=0 ORDER BY E.NOMBRE;


--15.  Nombre del empleado, mes y ejercicio de sus justificantes de n�mina, n�mero de l�nea y cantidad de las l�neas de los justificantes para el empleado cuyo c�digo=1.
SELECT E.NOMBRE, L.MES, L.EJERCICIO, L.NUMERO, L.CANTIDAD FROM LINEAS L, EMPLEADOS E WHERE L.COD_EMP=E.CODIGO AND E.CODIGO=1;


--16.  Nombre del empleado, mes y ejercicio de sus justificantes de n�mina para los empleados que han trabajado en el departamento de Ventas.
SELECT D.NOMBRE, E.NOMBRE, L.MES, L.EJERCICIO FROM LINEAS L, EMPLEADOS E, TRABAJAN T, DEPARTAMENTOS D WHERE L.COD_EMP=E.CODIGO AND E.CODIGO=T.COD_EMP AND T.COD_DEP=D.CODIGO AND D.NOMBRE='Ventas';

--17.  Nombre del empleado e ingresos totales percibidos agrupados por nombre.
SELECT E.NOMBRE, SUM(J.INGRESO)"INGRESOS TOTALES"  FROM EMPLEADOS E JOIN JUST_NOMINAS J ON E.CODIGO=J.COD_EMP GROUP BY E.NOMBRE;

--O Tambi�n:
SELECT E.NOMBRE, SUM(J.INGRESO)"INGRESOS TOTALES" FROM EMPLEADOS E, JUST_NOMINAS J WHERE J.COD_EMP=E.CODIGO GROUP BY E.NOMBRE;


--18.  Nombre de los empleados que han ganado m�s de 2000 � en el a�o 2006.
SELECT E.NOMBRE, SUM(J.INGRESO)
FROM JUST_NOMINAS J, EMPLEADOS E
WHERE E.CODIGO=J.COD_EMP AND EJERCICIO=2006
GROUP BY E.NOMBRE
HAVING SUM(J.INGRESO)>2000

--19.  N�mero de empleados cuyo n�mero de hijos es superior a la media de hijos de los empleados.
SELECT COUNT (CODIGO) "N�EMPLEADOS" FROM EMPLEADOS WHERE HIJOS>(SELECT AVG(HIJOS)FROM EMPLEADOS);


--20.  Nombre de los empleados que m�s hijos tienen o que menos hijos tienen.
SELECT NOMBRE, HIJOS FROM EMPLEADOS WHERE HIJOS=(SELECT MAX(HIJOS) FROM EMPLEADOS)
UNION
SELECT NOMBRE, HIJOS FROM EMPLEADOS WHERE HIJOS=(SELECT MIN(HIJOS) FROM EMPLEADOS)
ORDER BY HIJOS;

--Otra opci�n ser�a:
SELECT NOMBRE, HIJOS FROM EMPLEADOS WHERE HIJOS <= ALL (SELECT HIJOS FROM EMPLEADOS)
UNION
SELECT NOMBRE, HIJOS FROM EMPLEADOS WHERE HIJOS >= ALL (SELECT HIJOS FROM EMPLEADOS)
ORDER BY HIJOS;

--21.  Nombre de los empleados que no tienen justificante de n�minas.
SELECT E.NOMBRE FROM EMPLEADOS E FULL OUTER JOIN JUST_NOMINAS J ON J.COD_EMP=E.CODIGO
WHERE J.INGRESO IS NULL;


--22.  Nombre y fecha de nacimiento con formato "1 de Enero de 2000" y etiquetada la columna como fecha, de todos los empleados.
SELECT NOMBRE, FNACIMIENTO, CONCAT(TO_CHAR(FNACIMIENTO, 'DD "de "'), CONCAT(INITCAP(TO_CHAR(FNACIMIENTO,'MONTH')), TO_CHAR(FNACIMIENTO,' "de "
YYYY'))) "FECHA"
FROM EMPLEADOS;

--Utilizando tres veces la funci�n TO_CHAR obtengo de la columna FNACIMIENTO todos los datos que necesito.

SELECT NOMBRE, FNACIMIENTO, TO_CHAR(FNACIMIENTO, 'DD "de "') ||' '||INITCAP(TO_CHAR(FNACIMIENTO,'MONTH')) ||' ' || TO_CHAR(FNACIMIENTO,' "de "YYYY') "FECHA"
FROM EMPLEADOS;


--23.  Nombre de los empleados, nombre de los departamentos en los que ha trabajado y funci�n en may�sculas que ha realizado en cada departamento.
SELECT E.NOMBRE "NOMBRE EMPLEADO", D.NOMBRE "NOMBRE DEPARTAMENTO", UPPER (T.FUNCION) "FUNCI�N"
FROM EMPLEADOS E, TRABAJAN T, DEPARTAMENTOS D
WHERE E.CODIGO=T.COD_EMP AND T.COD_DEP=D.CODIGO;


--24.  Nombre, edad y n�mero de hijos de los empleados que tienen menos de 40 a�os y tienen hijos.
SELECT NOMBRE, TRUNC(MONTHS_BETWEEN(SYSDATE,FNACIMIENTO)/12) "EDAD", HIJOS
FROM EMPLEADOS
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,FNACIMIENTO)/12) > 40 AND HIJOS >= 1
ORDER BY HIJOS;


--25.  Visualizaremos el nombre de cada departamento y el ingreso mayor y el menor dentro de cada mes.
SELECT D.NOMBRE, MAX (J.INGRESO)"INGRESO MAYOR", MIN(J.INGRESO) "INGRESO MENOR", J.MES
FROM DEPARTAMENTOS D, TRABAJAN T, EMPLEADOS E, JUST_NOMINAS J
WHERE J.COD_EMP=E.CODIGO AND E.CODIGO=T.COD_EMP AND T.COD_DEP=D.CODIGO
GROUP BY D.NOMBRE, J.MES
ORDER BY J.MES;


--26.  Nombre, edad de los empleados y nombre del departamento de los empleados que han trabajado en m�s de un departamento.
SELECT EMPLEADOS.NOMBRE, TRUNC(MONTHS_BETWEEN(SYSDATE,FNACIMIENTO)/12) "EDAD", DEPARTAMENTOS.NOMBRE "DEPARTAMETOS"

FROM EMPLEADOS, DEPARTAMENTOS, TRABAJAN

WHERE (EMPLEADOS.CODIGO=TRABAJAN.COD_EMP AND DEPARTAMENTOS.CODIGO=TRABAJAN.COD_DEP) AND EMPLEADOS.CODIGO
IN (SELECT COD_EMP FROM TRABAJAN GROUP BY COD_EMP HAVING COUNT(COD_DEP)>1);


--27.  Por cada departamento y dentro de �ste por cada a�o visualizar el total de ingresos y el total de gastos de todos sus empleados.
S�lo tendremos en cuenta aquellos departamentos que tengan m�s de 3 empleados y los a�os por departamento en los que la suma de los ingresos de los empleados sea mayor de 60.000�.

--Departamentos con ingresos superiores a 60000�
SELECT D.NOMBRE
FROM TRABAJAN T, EMPLEADOS E, JUST_NOMINAS J, DEPARTAMENTOS D
WHERE E.CODIGO=T.COD_EMP AND J.COD_EMP=E.CODIGO AND T.COD_DEP=D.CODIGO
GROUP BY D.NOMBRE
HAVING SUM(J.INGRESO)>60000;

--Departamentos con m�s de tres trabajadores:
SELECT T.COD_DEP
FROM TRABAJAN T, EMPLEADOS E
WHERE E.CODIGO=T.COD_EMP
GROUP BY COD_DEP
HAVING COUNT(T.COD_DEP) >3;


--Resultado final:
SELECT D.NOMBRE, J.EJERCICIO
FROM DEPARTAMENTOS D, TRABAJAN T, EMPLEADOS E, JUST_NOMINAS J
WHERE J.COD_EMP=E.CODIGO AND E.CODIGO=T.COD_EMP AND T.COD_DEP=D.CODIGO
AND T.COD_DEP IN (SELECT T.COD_DEP
FROM TRABAJAN T, EMPLEADOS E
WHERE E.CODIGO=T.COD_EMP GROUP BY COD_DEP
HAVING COUNT(T.COD_DEP) >3)
AND D.NOMBRE IN (SELECT D.NOMBRE
FROM TRABAJAN T, EMPLEADOS E, JUST_NOMINAS J, DEPARTAMENTOS D
WHERE E.CODIGO=T.COD_EMP AND J.COD_EMP=E.CODIGO AND T.COD_DEP=D.CODIGO
GROUP BY D.NOMBRE
HAVING SUM(J.INGRESO)>60000)
GROUP BY J.EJERCICIO, D.NOMBRE
ORDER BY D.NOMBRE;


--28.  Nombre e ingresos percibidos empleado m�s joven y del m�s longevo.
SELECT E.NOMBRE, SUM(J.INGRESO) "INGRESOS" FROM EMPLEADOS E JOIN JUST_NOMINAS J ON J.COD_EMP=E.CODIGO
WHERE E.FNACIMIENTO <= ALL (SELECT FNACIMIENTO FROM EMPLEADOS) GROUP BY E.NOMBRE
UNION
SELECT E.NOMBRE, SUM(J.INGRESO) "INGRESOS" FROM EMPLEADOS E JOIN JUST_NOMINAS J ON J.COD_EMP=E.CODIGO
WHERE E.FNACIMIENTO >= ALL (SELECT FNACIMIENTO FROM EMPLEADOS) GROUP BY E.NOMBRE;

OTRA OPCI�N SER�A:
SELECT E.NOMBRE, SUM(J.INGRESO) "INGRESOS" FROM EMPLEADOS E JOIN JUST_NOMINAS J ON J.COD_EMP=E.CODIGO
WHERE E.FNACIMIENTO=(SELECT MAX(FNACIMIENTO) FROM EMPLEADOS) GROUP BY E.NOMBRE
UNION
SELECT E.NOMBRE, SUM(J.INGRESO) "INGRESOS" FROM EMPLEADOS E JOIN JUST_NOMINAS J ON J.COD_EMP=E.CODIGO
WHERE E.FNACIMIENTO=(SELECT MIN(FNACIMIENTO) FROM EMPLEADOS) GROUP BY E.NOMBRE;





--29.  Visualizaremos nombre del departamento, el n� de empleados que tiene, suma de los ingresos y descuentos de todos sus empleados del departamento o departamentos con menor n�mero de empleados.

--Departamentos con menos de trabajadores, concretamente 2:
SELECT T.COD_DEP FROM TRABAJAN T, EMPLEADOS E WHERE E.CODIGO=T.COD_EMP GROUP BY COD_DEP
HAVING COUNT(T.COD_DEP) = (SELECT MIN(COUNT(T.COD_DEP))FROM TRABAJAN
GROUP BY COD_DEP);

--Resultado final:
SELECT D.NOMBRE"NOMBRE DEPARTAMENTO", COUNT(DISTINCT T.COD_EMP) "N�EMPLEADOS", SUM(J.INGRESO) "INGRESOS", SUM(J.DESCUENTO)"DESCUENTOS"
FROM DEPARTAMENTOS D, TRABAJAN T, EMPLEADOS E, JUST_NOMINAS J
WHERE J.COD_EMP=E.CODIGO AND E.CODIGO=T.COD_EMP AND T.COD_DEP=D.CODIGO AND T.COD_DEP IN (SELECT T.COD_DEP FROM TRABAJAN T, EMPLEADOS E WHERE E.CODIGO=T.COD_EMP GROUP BY COD_DEP 
HAVING COUNT(T.COD_DEP) = (SELECT MIN(COUNT(T.COD_DEP))FROM TRABAJAN
GROUP BY COD_DEP))
GROUP BY D.NOMBRE,T.COD_DEP;


--30.  Nombre, media de los  ingresos de  los empleados que tengan m�s de 2 hijos y que pertenezcan al departamento o departamentos con mayor n�mero de empleados. 
--S�lo visualizaremos aquellos empleados cuyos ingresos medios sean mayores que los ingresos medios de todos los empleados.
Para obtener el departamento con m�s empleados:
SELECT COUNT(T.COD_DEP)"VECES" FROM TRABAJAN T, EMPLEADOS E WHERE E.CODIGO=T.COD_EMP GROUP BY COD_DEP
HAVING COUNT(T.COD_DEP) = (SELECT MAX(COUNT(T.COD_DEP))FROM TRABAJAN
GROUP BY COD_DEP);

--Para obtener los empleados con m�s de dos hijos:
SELECT E.NOMBRE, AVG(J.INGRESO) "INGRESOS MEDIOS"
FROM EMPLEADOS E, JUST_NOMINAS J
WHERE J.COD_EMP=E.CODIGO AND HIJOS>2 GROUP BY E.NOMBRE;

--Obtener los empleados que cobran m�s que la media:
SELECT E.NOMBRE, AVG(J.INGRESO) FROM EMPLEADOS E, JUST_NOMINAS J
WHERE J.COD_EMP=E.CODIGO GROUP BY E.NOMBRE HAVING AVG(J.INGRESO)>(SELECT AVG(INGRESO) FROM JUST_NOMINAS);

--Resultado final:
SELECT E.NOMBRE, AVG (J.INGRESO)
FROM EMPLEADOS E, JUST_NOMINAS J, TRABAJAN T
WHERE J.COD_EMP=E.CODIGO AND E.CODIGO=T.COD_EMP AND E.HIJOS>2 AND T.COD_DEP = (SELECT COUNT (T.COD_DEP)"VECES" FROM TRABAJAN T, EMPLEADOS E WHERE E.CODIGO=T.COD_EMP GROUP BY COD_DEP
HAVING COUNT (T.COD_DEP) = (SELECT MAX (COUNT (T.COD_DEP)) FROM TRABAJAN GROUP BY COD_DEP)) 
GROUP BY E.NOMBRE HAVING AVG (J.INGRESO)> (SELECT AVG (INGRESO) FROM JUST_NOMINAS);



