-- Datos de ejemplo para el esquema "catalog" (ms-rutaexpress-catalog).
-- Ejecutar conectado como el usuario catalog, despues de que Flyway haya
-- creado la tabla shipping_services.
--
-- docker exec -i rutaexpress-oracle bash -c "sqlplus -s catalog/catalog@//localhost:1521/XEPDB1" < seed/01_catalog_seed.sql

INSERT INTO shipping_services (name, description, rate, capacity, active, created_at, updated_at, version)
VALUES ('Envio Express', 'Entrega en 24 horas', 12500.00, 40, 1, SYSTIMESTAMP, SYSTIMESTAMP, 0);

INSERT INTO shipping_services (name, description, rate, capacity, active, created_at, updated_at, version)
VALUES ('Envio Estandar', 'Entrega en 3 a 5 dias habiles', 5000.00, 100, 1, SYSTIMESTAMP, SYSTIMESTAMP, 0);

INSERT INTO shipping_services (name, description, rate, capacity, active, created_at, updated_at, version)
VALUES ('Envio Economico', 'Entrega en 5 a 7 dias habiles', 3000.00, 150, 1, SYSTIMESTAMP, SYSTIMESTAMP, 0);

INSERT INTO shipping_services (name, description, rate, capacity, active, created_at, updated_at, version)
VALUES ('Envio Prioritario', 'Entrega el mismo dia', 25000.00, 15, 1, SYSTIMESTAMP, SYSTIMESTAMP, 0);

COMMIT;
