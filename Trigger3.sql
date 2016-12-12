--Queremos controlar algunas restricciones a la hora de trabajar con agentes:
--A. El usuario y la clave de un agente no pueden ser iguales.
--B. La habilidad de un agente debe estar comprendida entre 0 y 9 (ambos inclusive).
--C. La categoría de un agente sólo puede ser igual a 0, 1 o 2.
--D. Si un agente pertenece a una oficina directamente, su categoría debe ser igual 2.
--E. Si un agente no pertenece a una oficina directamente, su categoría no puede ser 2.
--F. No puede haber agentes que no pertenezcan a una oficina o a una familia.
--G. No puede haber agentes que pertenezcan a una oficina y a una familia a la vez


CREATE OR REPLACE TRIGGER restricciones_agentes --Creo el trigger
BEFORE INSERT OR UPDATE ON agentes  --El trigger si lanzará antes de llevar a cabo la actualización de la tabla agentes
FOR EACH ROW  --Para cada fila

DECLARE
	mensaje VARCHAR2(300);    -- Declaro las variables mensaje de tipo VARCHAR2 y error tipo Boolean
	error	BOOLEAN;
  
BEGIN
	error := false;    -- Inicializo la variable, error que por defecto es falso, antes de ir declarando todos los casos
  
	--Apartado A (Si la condición IF es verdadera, se produce un error, se nuestra el mensaje VARCHAR y se ejecuta el último if de la aplicación)
  IF (:new.usuario = :new.clave) THEN    --:new y :old son tablas temporales que se crean cuando creamos disparadores AFTER and BEFORE
		error := true;
    mensaje := '{El usuario y la clave de un agente no pueden ser iguales}';
	END IF;
  
  
  --Apartado B
	IF (:new.habilidad < 0 or :new.habilidad > 9) THEN
		error   := true;
    mensaje := '{La habilidad de un agente debe estar comprendida entre 0 y 9 (ambos inclusive)}';
	END IF;
  
  
  -- Apartado C
  	IF (:new.categoria < 0 or :new.categoria > 2) THEN
		error   := true;
    mensaje := '{La categoría de un agente sólo puede ser igual a 0, 1 o 2}';
	END IF;
  
  
  -- Apartado D
	IF (:new.oficina is not null and :new.categoria != 2) THEN --Si pertenece a una oficina y su categoria no es dos
		error   := true;
    mensaje := mensaje || '{Si un agente pertenece a una oficina directamente, su categoría debe ser igual 2}';
	END IF;
  
  
  -- Apartado E
	IF (:new.oficina is null and :new.categoria = 2) THEN
		error   := true;
    mensaje := '{Si un agente no pertenece a una oficina directamente, su categoría no puede ser 2}';
	END IF;
  
  
  -- Apartado F
	IF (:new.oficina is null and :new.familia is null) THEN
	  error   := true;
  	mensaje := '{No puede haber agentes que no pertenezcan a una oficina o a una familia}';
	END IF;
  
  
  --Apartado G
	IF (:new.oficina is not null and :new.familia is not null) THEN
    error   := true;
    mensaje := '{No puede haber agentes que pertenezcan a una oficina y a una familia a la vez}';
	END IF;
  
  
  --Declaración del error de todas las sentencias anteriores
	IF (error = true) THEN
		RAISE_APPLICATION_ERROR(-101, mensaje);
	END IF;
END;
/

