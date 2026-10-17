-- Segundo usuario/esquema, exclusivo para ms-rutaexpress-catalog.
-- El usuario "rutaexpress" (creado por APP_USER/APP_USER_PASSWORD en docker-compose.yml)
-- lo usa ms-rutaexpress-shipments. Cada microservicio necesita su PROPIO esquema Oracle:
-- si comparten uno, Flyway choca porque ambos numeran su primera migracion como V1 con
-- contenido distinto (V1__create_shipments_table.sql vs V1__create_shipping_services_table.sql),
-- y Flyway lo detecta como "checksum mismatch" al migrar el segundo servicio.
-- La imagen gvenzl/oracle-free corre estos scripts como SYSDBA en la raiz del CDB;
-- sin este cambio de contenedor los GRANT quedan en la raiz y no en XEPDB1 (ORA-01045).
ALTER SESSION SET CONTAINER = XEPDB1;
CREATE USER catalog IDENTIFIED BY catalog;
GRANT CONNECT, RESOURCE TO catalog;
ALTER USER catalog QUOTA UNLIMITED ON USERS;
