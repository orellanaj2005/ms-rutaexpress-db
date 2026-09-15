-- Esquema propio para ms-rutaexpress-report (ver nota en 01_create_catalog_user.sql
-- sobre por que cada microservicio necesita su propio usuario/esquema Oracle).
CREATE USER report_user IDENTIFIED BY changeit;
GRANT CONNECT, RESOURCE TO report_user;
ALTER USER report_user QUOTA UNLIMITED ON USERS;
