-- Datos de ejemplo para el esquema "rutaexpress" (ms-rutaexpress-shipments).
-- Ejecutar conectado como el usuario rutaexpress, despues de que Flyway haya
-- creado la tabla shipments. Asume que 01_catalog_seed.sql ya corrio, ya que
-- service_id referencia los ids 1-4 de shipping_services (sin FK real entre
-- esquemas, son microservicios independientes).
--
-- docker exec -i rutaexpress-oracle bash -c "sqlplus -s rutaexpress/rutaexpress@//localhost:1521/XEPDB1" < seed/02_shipments_seed.sql
--
-- Cubre los 6 estados posibles del ciclo de vida de un envio, uno por fila,
-- para poder probar GET /api/shipments?status=... contra datos reales.

INSERT INTO shipments (id, origin_address, destination_address, recipient_name, recipient_email, recipient_phone, service_id, weight_kg, declared_value, status, created_at, updated_at, version)
VALUES (shipments_seq.NEXTVAL, 'Av. Siempre Viva 123, Santiago', 'Calle Falsa 456, Valparaiso', 'Juan Perez', 'juan.perez@example.com', '+56912345678', 1, 2.5, 15000, 'CREADO', SYSTIMESTAMP, SYSTIMESTAMP, 0);

INSERT INTO shipments (id, origin_address, destination_address, recipient_name, recipient_email, recipient_phone, service_id, weight_kg, declared_value, status, created_at, updated_at, version)
VALUES (shipments_seq.NEXTVAL, 'Av. Providencia 1000, Santiago', 'Av. Brasil 2500, Vina del Mar', 'Maria Gonzalez', 'maria.gonzalez@example.com', '+56923456789', 2, 5.0, 32000, 'ACEPTADO', SYSTIMESTAMP, SYSTIMESTAMP, 0);

INSERT INTO shipments (id, origin_address, destination_address, recipient_name, recipient_email, recipient_phone, service_id, weight_kg, declared_value, status, created_at, updated_at, version)
VALUES (shipments_seq.NEXTVAL, 'Calle Huerfanos 800, Santiago', 'Av. Alemania 700, Temuco', 'Pedro Soto', 'pedro.soto@example.com', '+56934567890', 3, 1.2, 8000, 'EN_BODEGA', SYSTIMESTAMP, SYSTIMESTAMP, 0);

INSERT INTO shipments (id, origin_address, destination_address, recipient_name, recipient_email, recipient_phone, service_id, weight_kg, declared_value, status, created_at, updated_at, version)
VALUES (shipments_seq.NEXTVAL, 'Av. Apoquindo 4500, Santiago', 'Av. Alemana 300, Puerto Montt', 'Camila Rojas', 'camila.rojas@example.com', '+56945678901', 4, 0.8, 45000, 'EN_RUTA', SYSTIMESTAMP, SYSTIMESTAMP, 0);

INSERT INTO shipments (id, origin_address, destination_address, recipient_name, recipient_email, recipient_phone, service_id, weight_kg, declared_value, status, created_at, updated_at, version)
VALUES (shipments_seq.NEXTVAL, 'Av. Vitacura 3800, Santiago', 'Los Carrera 1200, Concepcion', 'Diego Fuentes', 'diego.fuentes@example.com', '+56956789012', 2, 3.4, 20000, 'ENTREGADO', SYSTIMESTAMP, SYSTIMESTAMP, 0);

INSERT INTO shipments (id, origin_address, destination_address, recipient_name, recipient_email, recipient_phone, service_id, weight_kg, declared_value, status, created_at, updated_at, version)
VALUES (shipments_seq.NEXTVAL, 'Av. Kennedy 5000, Santiago', 'Manuel Bulnes 500, La Serena', 'Valentina Diaz', 'valentina.diaz@example.com', '+56967890123', 1, 1.5, 10000, 'CANCELADO', SYSTIMESTAMP, SYSTIMESTAMP, 0);

COMMIT;
