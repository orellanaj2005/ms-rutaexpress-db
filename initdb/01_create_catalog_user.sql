-- Segundo usuario/esquema, exclusivo para ms-rutaexpress-catalog.
-- El usuario "rutaexpress" (creado por APP_USER/APP_USER_PASSWORD en docker-compose.yml)
-- lo usa ms-rutaexpress-shipments. Cada microservicio necesita su PROPIO esquema Oracle:
-- si comparten uno, Flyway choca porque ambos numeran su primera migracion como V1 con
-- contenido distinto (V1__create_shipments_table.sql vs V1__create_shipping_services_table.sql),
-- y Flyway lo detecta como "checksum mismatch" al migrar el segundo servicio.
CREATE USER catalog IDENTIFIED BY catalog;
GRANT CONNECT, RESOURCE TO catalog;
ALTER USER catalog QUOTA UNLIMITED ON USERS;
