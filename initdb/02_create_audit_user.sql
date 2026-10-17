-- Esquema propio para ms-rutaexpress-audit (ver nota en 01_create_catalog_user.sql
-- sobre por que cada microservicio necesita su propio usuario/esquema Oracle).
-- La imagen gvenzl/oracle-free corre estos scripts como SYSDBA en la raiz del CDB;
-- sin este cambio de contenedor los GRANT quedan en la raiz y no en XEPDB1 (ORA-01045).
ALTER SESSION SET CONTAINER = XEPDB1;
CREATE USER audit_user IDENTIFIED BY changeit;
GRANT CONNECT, RESOURCE TO audit_user;
ALTER USER audit_user QUOTA UNLIMITED ON USERS;
