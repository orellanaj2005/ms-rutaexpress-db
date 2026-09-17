-- Datos de ejemplo para el esquema "report_user" (ms-rutaexpress-report).
-- Ejecutar conectado como el usuario report_user, despues de que Flyway haya
-- creado la tabla SHIPMENT_EVENT_LOG. Refleja el estado actual de cada uno
-- de los 6 envios de 02_shipments_seed.sql, con el nombre del servicio de
-- catalogo correspondiente para poder probar los KPIs/top-services.
--
-- docker exec -i rutaexpress-oracle bash -c "sqlplus -s report_user/changeit@//localhost:1521/XEPDB1" < seed/04_report_seed.sql

INSERT INTO SHIPMENT_EVENT_LOG (id, event_id, shipment_id, status, service_type, occurred_at)
VALUES (SHIPMENT_EVENT_SEQ.NEXTVAL, 'evt-report-0001', '1', 'CREADO', 'Envio Express', SYSTIMESTAMP);

INSERT INTO SHIPMENT_EVENT_LOG (id, event_id, shipment_id, status, service_type, occurred_at)
VALUES (SHIPMENT_EVENT_SEQ.NEXTVAL, 'evt-report-0002', '2', 'ACEPTADO', 'Envio Estandar', SYSTIMESTAMP);

INSERT INTO SHIPMENT_EVENT_LOG (id, event_id, shipment_id, status, service_type, occurred_at)
VALUES (SHIPMENT_EVENT_SEQ.NEXTVAL, 'evt-report-0003', '3', 'EN_BODEGA', 'Envio Economico', SYSTIMESTAMP);

INSERT INTO SHIPMENT_EVENT_LOG (id, event_id, shipment_id, status, service_type, occurred_at)
VALUES (SHIPMENT_EVENT_SEQ.NEXTVAL, 'evt-report-0004', '4', 'EN_RUTA', 'Envio Prioritario', SYSTIMESTAMP);

INSERT INTO SHIPMENT_EVENT_LOG (id, event_id, shipment_id, status, service_type, occurred_at)
VALUES (SHIPMENT_EVENT_SEQ.NEXTVAL, 'evt-report-0005', '5', 'ENTREGADO', 'Envio Estandar', SYSTIMESTAMP);

INSERT INTO SHIPMENT_EVENT_LOG (id, event_id, shipment_id, status, service_type, occurred_at)
VALUES (SHIPMENT_EVENT_SEQ.NEXTVAL, 'evt-report-0006', '6', 'CANCELADO', 'Envio Express', SYSTIMESTAMP);

COMMIT;
