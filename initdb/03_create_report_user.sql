-- Esquema propio para ms-rutaexpress-report (ver nota en 01_create_catalog_user.sql
-- sobre por que cada microservicio necesita su propio usuario/esquema Oracle).
-- La imagen gvenzl/oracle-free corre estos scripts como SYSDBA en la raiz del CDB;
-- sin este cambio de contenedor los GRANT quedan en la raiz y no en XEPDB1 (ORA-01045).
ALTER SESSION SET CONTAINER = XEPDB1;
CREATE USER report_user IDENTIFIED BY changeit;
GRANT CONNECT, RESOURCE TO report_user;
ALTER USER report_user QUOTA UNLIMITED ON USERS;
