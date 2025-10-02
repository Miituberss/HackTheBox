# 00_Overview

El módulo de **Footprinting** establece las bases fundamentales para la fase inicial de una prueba de penetración: la **recopilación de información** o **enumeración**. El objetivo primordial no es entrar en los sistemas a la fuerza (evitando métodos ruidosos como el *brute-force*), sino **entender a fondo la infraestructura** del objetivo y encontrar *todas las posibles vías de acceso*.

Se define y promueve una **metodología estandarizada de 6 capas** para mapear sistemáticamente la infraestructura externa e interna de una compañía, pasando de la presencia en internet hasta la configuración del sistema operativo. El módulo enfatiza la importancia de combinar la **recolección pasiva (OSINT)** con la **enumeración activa** para construir una imagen técnica completa del entorno del objetivo.

---

# Concepts

## Principios Fundamentales de la Enumeración

La enumeración es un proceso dinámico y en bucle. Los principios buscan cambiar el enfoque del pentester de lo *obvio* a lo *invisible*:

* **Principio 1:** Hay más de lo que se ve. Considerar todos los puntos de vista (incluido el del desarrollador o administrador).
* **Principio 2:** Distinguir entre lo que se ve y lo que no se ve.
* **Principio 3:** Siempre hay formas de obtener más información. Entender el objetivo.

## 📊 Enumeración vs. OSINT

| Concepto                             | Tipo de Recolección | Descripción Clave                                                                                                                              |
| :----------------------------------- | :------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------- |
| **OSINT** (Open Source Intelligence) | **Pasiva**          | Basada exclusivamente en el uso de proveedores de terceros (ej. Google, crt.sh). No implica ninguna conexión directa o activa con el objetivo. |
| **Enumeración**                      | **Activa y Pasiva** | Un término más amplio que incluye tanto métodos pasivos como activos (ej. escaneos de puertos).                                                |

## 🏗️ Metodología de Enumeración de 6 Capas

Se establece una metodología estática de 6 capas que actúan como "obstáculos" a superar en una prueba de penetración:

| Capa                       | Descripción                                                                    | Categorías de Información Clave                                          |
| :------------------------- | :----------------------------------------------------------------------------- | :----------------------------------------------------------------------- |
| **1. Internet Presence**   | Identificación de toda la infraestructura accesible externamente.              | Dominios, Subdominios, IPs, ASN, Instancias Cloud, Medidas de Seguridad. |
| **2. Gateway**             | Identificación de medidas de seguridad que protegen la infraestructura.        | Firewalls, DMZ, IDS/IPS, EDR, Proxies, Cloudflare.                       |
| **3. Accessible Services** | Identificación de interfaces y servicios accesibles interna o externamente.    | Tipo de Servicio, Funcionalidad, Configuración, Versión, Puerto.         |
| **4. Processes**           | Identificación de los procesos, fuentes y destinos asociados a los servicios.  | PID, Tareas, Origen/Destino de datos procesados.                         |
| **5. Privileges**          | Identificación de permisos y privilegios internos de los servicios accesibles. | Grupos, Usuarios, Restricciones, Entorno.                                |
| **6. OS Setup**            | Recolección de información sobre el sistema operativo y su configuración.      | Tipo de SO, Nivel de Parches, Configuración de Red, Archivos Sensibles.  |

## 🌐 Conceptos Clave de la Capa 1 (Internet Presence)

* **Certificados SSL:** A menudo contienen nombres alternativos de dominio (SAN), revelando subdominios adicionales.
* **Certificate Transparency (crt.sh):** Logs públicos que almacenan certificados emitidos, siendo una fuente pasiva excelente para descubrir subdominios.
* **Registros DNS (TXT, MX, NS):** Los registros **TXT** pueden revelar la tecnología de terceros que utiliza la empresa (ej. Atlassian, LogMeIn, Mailgun), proporcionando nuevos objetivos de prueba.
* **Recursos en la Nube:** Las empresas suelen utilizar servicios como AWS S3, Azure Blobs o GCP Cloud Storage.
    * Se pueden descubrir mediante **Google Dorks** (ej. `inurl:amazonaws.com`) o herramientas especializadas como **GrayHatWarfare**.
    * La mala configuración puede llevar a la exposición de archivos sensibles, incluyendo **claves privadas SSH** (`id_rsa`).
* **Staff:** Las ofertas de trabajo y los perfiles de empleados (ej. en LinkedIn) revelan *skills* requeridas, indicando las tecnologías (lenguajes, *frameworks*, BBDD) y suites (*Atlassian*) utilizadas en la infraestructura.

## 💻 Conceptos Clave de Servicios (Capa 3)

| Protocolo/Servicio | Puertos Clave | Consideraciones de Seguridad |
| :--- | :--- | :--- |
| **FTP** | 21 (TCP) | Configuraciones peligrosas incluyen **listado recursivo** (`ls_recurse_enable=YES`) o si la función de **ocultar IDs** (`hide_ids=YES`) está desactivada. |
| **SMB/Samba** | 139, 445 (TCP) | Protocolo de Microsoft para compartir archivos. Samba es la implementación para Unix/Linux. Los permisos se basan en **ACLs** y no en derechos locales. |
| **NFS** (Network File System) | 2049 (TCP/UDP) | Utilizado en sistemas Linux/Unix. La opción de *export* `no_root_squash` permite al usuario `root` del cliente tener permisos de *root* en el servidor NFS, lo cual es muy peligroso. |
| **DNS** | 53 (TCP/UDP) | Protocolo clave para la resolución de nombres. Configuraciones como `allow-transfer` o `allow-recursion` pueden exponer información de zona y ser atacadas. |
| **SNMP** (Simple Network Management Protocol) | 161 (UDP) | Utilizado para monitorización. La clave está en adivinar la **Community String** (por defecto `public` o `private`) para acceder a la MIB (Base de Información de Gestión) y obtener información del sistema (ej. SO, contacto del administrador). |
| **WMI** (Windows Management Instrumentation) | 135 (TCP) | Permite la administración remota de sistemas Windows. La comunicación se inicia en el puerto 135 y se mueve a un puerto aleatorio. |

---

# Tools

| Herramienta | Comando / Sintaxis de Uso | Caso de Uso |
| :--- | :--- | :--- |
| **curl + jq + sort -u** | `curl -s https://crt.sh/\?q\=target.com\&output\=json \| jq . \| grep name \| cut -d":" -f2 \| grep -v "CN=" \| cut -d'"' -f2 \| awk '{gsub(/\\n/,"\n");}1;' \| sort -u` | **Recolección Pasiva de Subdominios:** Obtiene logs de Certificate Transparency (`crt.sh`), extrae todos los nombres de dominio únicos y los lista. |
| **host + grep + cut** | `for i in $(cat subdomainlist);do host $i \| grep "has address" \| grep target.com \| cut -d" " -f1,4;done` | **Resolución Activa de Hosts/IPs:** Resuelve una lista de subdominios a sus direcciones IP, filtrando solo aquellos que pertenecen a la red del objetivo. |
| **Shodan** | `shodan host <IP_ADDRESS>` | **Análisis de Dispositivos Conectados a Internet:** Obtiene información de puertos abiertos, *banners*, geolocalización y organización para una IP específica. |
| **dig** | `dig any target.com` | **Consulta DNS Completa:** Muestra todos los registros DNS disponibles (A, MX, NS, TXT, SOA) para un dominio. |
| **dig (NS Query)** | `dig ns target.htb @<DNS_SERVER_IP>` | **Consulta de Nameservers Adicionales:** Consulta a un servidor DNS específico para ver qué otros *nameservers* conoce, buscando *zone transfers*. |
| **snmpwalk** | `snmpwalk -v2c -c public <IP> iso.3.6.1.2.1.1.1.0` | **Footprinting SNMP:** Utiliza la *community string* (`public` por defecto) para solicitar información de un OID específico o el árbol completo, revelando el SO, la versión y la información del sistema. |
| **enum4linux-ng** | `./enum4linux-ng.py <IP> -A` | **Enumeración SMB Automatizada:** Herramienta que automatiza múltiples consultas SMB para obtener información de usuarios, grupos, dominios, y políticas. |
| **wmiexec.py** | `/usr/share/doc/python3-impacket/examples/wmiexec.py <user>:"<password>"@<IP> "hostname"` | **Ejecución Remota de Comandos (WMI):** Utiliza el protocolo WMI para ejecutar comandos en un sistema Windows remoto si se tienen credenciales válidas. |
| **nmap (MSSQL)** | `sudo nmap <IP> -p1433 --script ms-sql-info` | **Footprinting MSSQL:** Script especializado de Nmap que extrae el *hostname*, nombre de la instancia y versión del software. |
| **odat.py (Oracle TNS)** | `./odat.py utlfile -s <IP> -d XE -U scott -P tiger --sysdba --putFile <dir_remoto> <local_file> <remote_file>` | **Carga de Archivos (Oracle):** Herramienta para interactuar con bases de datos Oracle (TNS) y subir archivos, buscando directorios web (`C:\inetpub\wwwroot`) para una webshell. |
