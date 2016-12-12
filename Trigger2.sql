CREATE OR REPLACE TRIGGER DISP_PEDIDOS
BEFORE INSERT OR UPDATE 
ON E_PEDIDOS 
FOR EACH ROW

BEGIN
IF (:NEW.FECHAPEDIDO>:NEW.FECHAESPERADA) THEN
RAISE_APPLICATION_ERROR(-101, 'La fecha de pedido no puede ser anterior a la fecha esperada de entrega');
END IF;

IF (:NEW.FECHAPEDIDO>:NEW.FECHAENTREGA) THEN
RAISE_APPLICATION_ERROR(-102, 'La fecha de pedido no puede ser anterior a la fecha de entrega');
END IF;

IF (:NEW.ESTADOENVIO NOT IN ('E','D','P')) THEN
RAISE_APPLICATION_ERROR(-103, 'El valor introducido para el estado del envío es incorrecto');
END IF;

IF (:NEW.ESTADOENVIO NOT IN ('S','N') ) THEN
RAISE_APPLICATION_ERROR(-104, 'El valor introducido para el estado del pago');
END IF;

END;

