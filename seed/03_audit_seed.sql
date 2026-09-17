-- Datos de ejemplo para el esquema "audit_user" (ms-rutaexpress-audit).
-- Ejecutar conectado como el usuario audit_user, despues de que Flyway haya
-- creado la tabla AUDIT_EVENT. Asume que 02_shipments_seed.sql ya corrio,
-- ya que SHIPMENT_ID referencia los ids 1-6 de shipments (sin FK real entre
-- esquemas, son microservicios independientes) reflejando el estado actual
-- de cada envio como si fuera el ultimo evento ShipmentStatusChanged
-- consumido desde el topico shipments.events.
--
-- docker exec -i rutaexpress-oracle bash -c "sqlplus -s audit_user/changeit@//localhost:1521/XEPDB1" < seed/03_audit_seed.sql

INSERT INTO AUDIT_EVENT (id, event_id, event_type, source_topic, shipment_id, actor, occurred_at, trace_id, correlation_id, raw_payload)
VALUES (AUDIT_EVENT_SEQ.NEXTVAL, 'evt-audit-0001', 'ShipmentStatusChanged', 'shipments.events', '1', 'ms-rutaexpress-shipments', SYSTIMESTAMP, 'trace-0001', '1',
'{"type":"ShipmentStatusChanged","eventId":"evt-audit-0001","correlationId":"1","payload":{"shipmentId":1,"previousStatus":null,"newStatus":"CREADO"}}');

INSERT INTO AUDIT_EVENT (id, event_id, event_type, source_topic, shipment_id, actor, occurred_at, trace_id, correlation_id, raw_payload)
VALUES (AUDIT_EVENT_SEQ.NEXTVAL, 'evt-audit-0002', 'ShipmentStatusChanged', 'shipments.events', '2', 'ms-rutaexpress-shipments', SYSTIMESTAMP, 'trace-0002', '2',
'{"type":"ShipmentStatusChanged","eventId":"evt-audit-0002","correlationId":"2","payload":{"shipmentId":2,"previousStatus":"CREADO","newStatus":"ACEPTADO"}}');

INSERT INTO AUDIT_EVENT (id, event_id, event_type, source_topic, shipment_id, actor, occurred_at, trace_id, correlation_id, raw_payload)
VALUES (AUDIT_EVENT_SEQ.NEXTVAL, 'evt-audit-0003', 'ShipmentStatusChanged', 'shipments.events', '3', 'ms-rutaexpress-shipments', SYSTIMESTAMP, 'trace-0003', '3',
'{"type":"ShipmentStatusChanged","eventId":"evt-audit-0003","correlationId":"3","payload":{"shipmentId":3,"previousStatus":"ACEPTADO","newStatus":"EN_BODEGA"}}');

INSERT INTO AUDIT_EVENT (id, event_id, event_type, source_topic, shipment_id, actor, occurred_at, trace_id, correlation_id, raw_payload)
VALUES (AUDIT_EVENT_SEQ.NEXTVAL, 'evt-audit-0004', 'ShipmentStatusChanged', 'shipments.events', '4', 'ms-rutaexpress-shipments', SYSTIMESTAMP, 'trace-0004', '4',
'{"type":"ShipmentStatusChanged","eventId":"evt-audit-0004","correlationId":"4","payload":{"shipmentId":4,"previousStatus":"EN_BODEGA","newStatus":"EN_RUTA"}}');

INSERT INTO AUDIT_EVENT (id, event_id, event_type, source_topic, shipment_id, actor, occurred_at, trace_id, correlation_id, raw_payload)
VALUES (AUDIT_EVENT_SEQ.NEXTVAL, 'evt-audit-0005', 'ShipmentStatusChanged', 'shipments.events', '5', 'ms-rutaexpress-shipments', SYSTIMESTAMP, 'trace-0005', '5',
'{"type":"ShipmentStatusChanged","eventId":"evt-audit-0005","correlationId":"5","payload":{"shipmentId":5,"previousStatus":"EN_RUTA","newStatus":"ENTREGADO"}}');

INSERT INTO AUDIT_EVENT (id, event_id, event_type, source_topic, shipment_id, actor, occurred_at, trace_id, correlation_id, raw_payload)
VALUES (AUDIT_EVENT_SEQ.NEXTVAL, 'evt-audit-0006', 'ShipmentStatusChanged', 'shipments.events', '6', 'ms-rutaexpress-shipments', SYSTIMESTAMP, 'trace-0006', '6',
'{"type":"ShipmentStatusChanged","eventId":"evt-audit-0006","correlationId":"6","payload":{"shipmentId":6,"previousStatus":"CREADO","newStatus":"CANCELADO"}}');

COMMIT;
