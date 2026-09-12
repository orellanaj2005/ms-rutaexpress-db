# Oracle DB local (RutaExpress)

Base de datos Oracle local en Docker para desarrollo, usada por `ms-rutaexpress-shipments`
y `ms-rutaexpress-catalog`. Infraestructura local para no depender de una instancia Oracle
remota mientras desarrollas.

Usa la imagen [`gvenzl/oracle-free`](https://github.com/gvenzl/oci-oracle-free) (Oracle
23ai Free, community image, mucho más simple que las imágenes oficiales de Oracle que
requieren aceptar licencia y compilar la imagen tú mismo).

## Uso

```bash
docker compose up -d
docker compose logs -f oracle-db   # esperar "DATABASE IS READY TO USE!" (~2-5 min la primera vez)
docker compose ps                  # columna STATUS debe decir "healthy"
```

Para detener (conserva los datos en el volumen `oracle-data`):
```bash
docker compose down
```

Para borrar todo y partir de cero:
```bash
docker compose down -v
```

## Credenciales / conexión

⚠️ **El puerto expuesto en el host es `1522`, no `1521`.** Si tu máquina ya tiene una
instalación nativa de Oracle XE escuchando en `1521` (revisa con `netstat -ano | grep 1521`
en Git Bash o `Get-NetTCPConnection -LocalPort 1521` en PowerShell), el contenedor no puede
usar ese puerto — por eso se remapea a `1522:1521`. El puerto *interno* del contenedor sigue
siendo `1521` (irrelevante para ti, solo importa el mapeado al host).

Como el default de `ORACLE_PORT` en `ms-rutaexpress-shipments`/`ms-rutaexpress-catalog` es
`1521`, **sí necesitas** un `.env` en cada uno de esos dos repos (junto al `pom.xml`) con:
```
ORACLE_PORT=1522
```

⚠️ **Cada microservicio usa un usuario Oracle distinto** (ver sección "Dos esquemas" más abajo)
— no comparten el mismo esquema:

| Servicio | `ORACLE_USER` / `ORACLE_PASSWORD` (default en su código) |
|---|---|
| `ms-rutaexpress-shipments` | `rutaexpress` / `rutaexpress` |
| `ms-rutaexpress-catalog` | `catalog` / `catalog` |

El resto de los valores por defecto SÍ coinciden con esta base, no hace falta repetirlos:

| Variable | Default | Uso |
|---|---|---|
| `ORACLE_HOST` | `localhost` | host JDBC (en los microservicios) |
| `ORACLE_PORT` | `1521` → pon `1522` en tu `.env` | puerto JDBC |
| `ORACLE_SERVICE` | `XEPDB1` | nombre del pluggable database |

JDBC URL resultante para shipments (con el `.env` de arriba):
```
jdbc:oracle:thin:@//localhost:1522/XEPDB1
```
(catalog usa la misma URL — el usuario/password en la cadena de conexión es lo que cambia).

`ORACLE_SYS_PASSWORD` (default `oracle`) es solo el password de SYS/SYSTEM/PDBADMIN
dentro del contenedor — los microservicios nunca lo usan, es únicamente para
administración manual (ver abajo).

Si quieres cambiar cualquier valor de este compose, crea un `.env` en esta misma carpeta
(ya está en `.gitignore`) con las variables que quieras sobreescribir, p. ej.:
```
ORACLE_APP_PASSWORD=otra-clave
ORACLE_HOST_PORT=1523
```

## Verificar la conexión manualmente

Con `sqlplus` dentro del propio contenedor (usa el puerto interno 1521, no el del host):
```bash
docker exec -it rutaexpress-oracle sqlplus rutaexpress/rutaexpress@//localhost:1521/XEPDB1
# o, para el esquema de catalog:
docker exec -it rutaexpress-oracle sqlplus catalog/catalog@//localhost:1521/XEPDB1
```
Desde el host (fuera del contenedor), usa el puerto 1522:
```bash
sqlplus rutaexpress/rutaexpress@//localhost:1522/XEPDB1
```

## Dos esquemas — uno por microservicio

Este contenedor provee **dos** usuarios/esquemas Oracle vacíos dentro del mismo PDB `XEPDB1`,
uno por cada microservicio que necesita base de datos:

- `rutaexpress` (creado automáticamente por `APP_USER`/`APP_USER_PASSWORD` en
  `docker-compose.yml`) — lo usa `ms-rutaexpress-shipments`.
- `catalog` (creado por el script `initdb/01_create_catalog_user.sql`, que corre una sola vez
  cuando el volumen está vacío) — lo usa `ms-rutaexpress-catalog`.

**Por qué dos usuarios y no uno compartido:** si ambos microservicios apuntan al mismo esquema,
Flyway falla al migrar el segundo servicio con un error de "checksum mismatch" — cada
microservicio numera su primera migración como `V1`, pero con contenido distinto
(`V1__create_shipments_table.sql` vs `V1__create_shipping_services_table.sql`), y Flyway detecta
eso como una migración `V1` que cambió de contenido en vez de reconocer que son dos servicios
independientes. Más allá de Flyway, es también la práctica correcta en una arquitectura de
microservicios: cada servicio es dueño de su propio esquema, ninguno lee ni escribe directamente
en las tablas de otro.

Cada microservicio crea sus propias tablas al arrancar vía **Flyway** (migraciones en su propio
`src/main/resources/db/migration/`) — no hay que correr ningún script SQL manual para las tablas
de negocio, solo el `initdb/01_create_catalog_user.sql` de este repo se encarga de crear el
segundo usuario.

Si ya tenías el contenedor corriendo desde antes de que existiera `initdb/01_create_catalog_user.sql`
(los scripts de `container-entrypoint-initdb.d` solo corren la primera vez, con el volumen
vacío), créalo a mano una vez:
```bash
docker exec -i rutaexpress-oracle bash -c "sqlplus -s system/oracle@//localhost:1521/XEPDB1" <<'EOF'
CREATE USER catalog IDENTIFIED BY catalog;
GRANT CONNECT, RESOURCE TO catalog;
ALTER USER catalog QUOTA UNLIMITED ON USERS;
EXIT;
EOF
```

## Registro de cambios

### 2026-09-12 — Creación del contenedor Oracle local (Jassack)
Se creó este repo para levantar una base Oracle real en Docker (imagen `gvenzl/oracle-free`,
más simple que las imágenes oficiales de Oracle) y poder correr/probar `ms-rutaexpress-shipments`
y `ms-rutaexpress-catalog` localmente sin depender de una instancia Oracle remota. El puerto
expuesto se remapeó a `1522` porque esta máquina ya tenía una instalación nativa de Oracle XE
(`dbhomeXE`) ocupando el `1521` estándar.

### 2026-09-12 — Segundo usuario Oracle para catalog (Jassack)
Al correr las migraciones de Flyway de ambos servicios contra el usuario `rutaexpress` original,
`catalog` falló con un "checksum mismatch" en la migración `V1` porque compartía esquema con
`shipments` (ver detalle en "Dos esquemas" arriba). Se creó un segundo usuario `catalog` y se
agregó `initdb/01_create_catalog_user.sql` (montado en `container-entrypoint-initdb.d`) para que
un `docker compose down -v && up` desde cero también lo cree automáticamente. El cambio
correspondiente en el código de `ms-rutaexpress-catalog` (default de `ORACLE_USER`/`ORACLE_PASSWORD`
de `rutaexpress` a `catalog`) está documentado en el README de ese repo.
