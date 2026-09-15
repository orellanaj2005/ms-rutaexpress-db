-- Esquema propio para ms-rutaexpress-audit (ver nota en 01_create_catalog_user.sql
-- sobre por que cada microservicio necesita su propio usuario/esquema Oracle).
CREATE USER audit_user IDENTIFIED BY changeit;
GRANT CONNECT, RESOURCE TO audit_user;
ALTER USER audit_user QUOTA UNLIMITED ON USERS;
