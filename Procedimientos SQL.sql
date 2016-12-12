create or replace PROCEDURE CALCULAR_CLIENTE (
    P_AÑO IN NUMBER,
    P_COD_CLIENTE IN E_PEDIDOS.CODIGOCLIENTE%TYPE,
    P_PEDIDOS_PAGADOS OUT NUMBER,
    P_PEDIDOS_NO_PAGADOS OUT NUMBER
)
AS
--Creamos el cursor que contendrá los datos de los clientes con los pedidos pagados y enviados
CURSOR C_CLIENTES IS SELECT CODIGOPEDIDO, PEDIDOPAGADO, CODIGOCLIENTE
FROM E_PEDIDOS
WHERE ESTADOENVIO='E' AND CODIGOCLIENTE=P_COD_CLIENTE AND TO_CHAR(FECHAPEDIDO, 'YYYY')=P_AÑO;--Pedido ya entregado y enviado recogiendo los parametros de entrada

V_CONTADOR NUMBER;--Contará los ciclos del LOOP y por tanto el numero de pedidos del cliente
V_PRECIO_PEDIDO_PAGADO NUMBER;
V_PRECIO_PEDIDO_NOPAGADO NUMBER;
V_EXISTE_CLIENTE E_PEDIDOS.CODIGOCLIENTE%TYPE;

BEGIN
V_CONTADOR:=0;
V_PRECIO_PEDIDO_PAGADO:=0;
V_PRECIO_PEDIDO_NOPAGADO:=0;
V_EXISTE_CLIENTE :=0;


FOR R_CLIENTES IN C_CLIENTES LOOP --Recorremos el cursor creando el registro

V_CONTADOR:=V_CONTADOR+1; --Cada ciclo del FOR sumará uno al contador, su valor coincide con el numero de pedidos del cliente en un año

IF (R_CLIENTES.PEDIDOPAGADO='S') THEN
V_PRECIO_PEDIDO_PAGADO:=CALCULAR_PEDIDO(R_CLIENTES.CODIGOPEDIDO); --Pasamos como parámetro a la función del apartado 1 el código de pedido para obtener el total del pedido
P_PEDIDOS_PAGADOS:=P_PEDIDOS_PAGADOS+V_PRECIO_PEDIDO_PAGADO; --Vamos acumulando en el parámetro de salida la suma de los distintos pedidos ya pagados del cliente
END IF;  --Cerramos el if

IF  (R_CLIENTES.PEDIDOPAGADO='N')  THEN
V_PRECIO_PEDIDO_NOPAGADO:=CALCULAR_PEDIDO(R_CLIENTES.CODIGOPEDIDO); --Pasamos como parámetro a la función del apartado 1 el código de pedido para obtener el total del pedido
P_PEDIDOS_PAGADOS:=P_PEDIDOS_PAGADOS+V_PRECIO_PEDIDO_NOPAGADO; --Vamos acumulando en el parámetro de salida la suma de los distintos pedidos ya pagados del cliente
END IF;  --Cerramos el if
END LOOP; --Cerramos el LOOP de este cursor

/*Cursor implicito para ver si existe un determinado cliente*/
SELECT COUNT(CODIGOCLIENTE) INTO V_EXISTE_CLIENTE 
FROM E_CLIENTES
WHERE CODIGOCLIENTE = P_COD_CLIENTE;

--Excepción si el código de cliente introducido no existe   
IF (V_EXISTE_CLIENTE=0) THEN 
 P_PEDIDOS_NO_PAGADOS:=-1;
 P_PEDIDOS_PAGADOS:=-1;
 RAISE_APPLICATION_ERROR(-20201,'El cliente no existe'); 
END IF;

--Excepción si no hay ningun pedido para ese cliente pedidos para el cliente
 IF (V_CONTADOR=0) THEN 
 P_PEDIDOS_NO_PAGADOS:=-1;
 P_PEDIDOS_PAGADOS:=-1;
 RAISE_APPLICATION_ERROR(-20202,'No existen pedidos para ese cliente'); 
END IF;

--Excepción si al menos no hay dos registros de pedidos para el cliente
 IF (V_CONTADOR<2) THEN 
 P_PEDIDOS_NO_PAGADOS:=-1;
 P_PEDIDOS_PAGADOS:=-1;
 RAISE_APPLICATION_ERROR(-20203,'No existen dos registros de pedidos del cliente para el año introducido'); 
END IF;

END CALCULAR_CLIENTE;
