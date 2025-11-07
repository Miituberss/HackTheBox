# 00_Overview

Los **Registros de Eventos de Windows (Windows Event Logs)** son un componente fundamental del sistema operativo para registrar actividades, errores y advertencias. Son la fuente de información más importante para los analistas de seguridad en las fases de detección, análisis y forense digital.

Este módulo se centra en cómo interactuar con estos registros, especialmente los de **Seguridad**, **Aplicación** y **Sistema**, para identificar indicadores de compromiso (**IOCs**) y actividad maliciosa. Además, introduce **Sysmon** como una herramienta esencial para generar *logs* de seguridad de mayor fidelidad y **Event Tracing for Windows (ETW)** como el mecanismo subyacente para la recolección de eventos a un nivel más profundo. El objetivo final es automatizar la búsqueda de patrones de ataque conocidos (**Tácticas y Técnicas Adversarias**).

---

# Concepts

## 📜 Registros de Eventos de Windows (WEL)

Los registros de eventos se almacenan en formato `.evt` (antiguo) o `.evtx` (moderno). La información registrada incluye la **fecha y hora**, el **origen** (proveedor), la **categoría**, el **ID del Evento** y una **descripción** detallada.

### Tipos de Logs Principales:

| Registro | ID de Evento Clave | Descripción de Seguridad |
| :--- | :--- | :--- |
| **Seguridad** | **4624** (Login Exitoso), **4625** (Login Fallido) | Contiene eventos de auditoría de seguridad, *logins* de usuarios, cambios de privilegios, y acceso a objetos. |
| **Aplicación** | 1000 (Errores Comunes) | Registra eventos de programas instalados o servicios (ej. errores de *software* o fallos de aplicación). |
| **Sistema** | 7045 (Servicio Instalado) | Registra eventos relacionados con el sistema operativo y sus servicios (ej. inicio/apagado del sistema, fallos de *drivers*). |
| **PowerShell** | 4104 (Bloqueo de Scripts) | Registra el contenido de los comandos ejecutados en PowerShell (esencial para detectar *scripts* codificados u ofuscados). |

## 🛡️ Sysmon (System Monitor)

**Sysmon** es un servicio del sistema de Microsoft Sysinternals que, una vez instalado, persiste a través de reinicios y proporciona información detallada sobre la actividad del sistema que no es cubierta por los registros estándar.

### Tipos de Eventos de Sysmon Clave:

| Sysmon ID | Descripción | Uso en Detección |
| :--- | :--- | :--- |
| **1** | **Creación de Proceso** | Registra el proceso padre, hijo, *hash* del ejecutable y la **línea de comandos** completa (fundamental para detectar ejecución sospechosa). |
| **3** | **Conexión de Red** | Registra *endpoints* (IP/Puerto) para cada conexión de red, identificando comunicaciones de C2 (Comando y Control). |
| **7** | **Carga de Imágenes** | Registra la carga de módulos o DLLs en un proceso (útil para detectar inyección de DLL o *DLL Hijacking*). |
| **10** | **Acceso a Proceso** | Indica que un proceso está intentando leer la memoria de otro (clave para detectar **volcado de credenciales** como el ataque a **LSASS**). |
| **23** | **Creación de Archivo con Nombre Eliminado** | Identifica archivos que han sido creados y luego eliminados (a menudo utilizados por *malware* para persistencia o *staging*). |

## 📡 Event Tracing for Windows (ETW)

**ETW** es el mecanismo de registro de eventos subyacente y de alto rendimiento integrado en el kernel de Windows.

* **Arquitectura:** Los **Proveedores** (ej. kernel, aplicaciones) generan eventos que son recopilados por un **Controlador de Sesión** y luego consumidos por **Consumidores** (ej. Visor de Eventos).
* **Ventaja en Detección:** Los proveedores de ETW pueden exponer datos de procesos de manera profunda (ej. *syscalls*) que son inaccesibles por métodos tradicionales. Muchos productos de seguridad (EDR) interactúan directamente con ETW para obtener datos de telemetría de alta fidelidad.

---

# Tools

## 💻 PowerShell (Get-WinEvent)

**`Get-WinEvent`** es el *cmdlet* principal de PowerShell para consultar los registros de eventos de Windows. Es mucho más eficiente y flexible que el antiguo `Get-EventLog`.

| Comando / Sintaxis de Uso | Caso de Uso |
| :--- | :--- |
| `Get-WinEvent -LogName Security -MaxEvents 100` | Muestra los 100 eventos más recientes del registro de **Seguridad**. |
| `Get-WinEvent -FilterHashTable @{LogName='Security'; ID=4624}` | Filtra eventos de **Login Exitoso** (ID 4624) usando la sintaxis de *hash table* (más flexible). |
| `Get-WinEvent -FilterXml (Get-Content C:\Query.xml)` | Carga y ejecuta una **consulta XML** personalizada (Vía XPath), ideal para consultas complejas o recurrentes. |
| `Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational` | Accede específicamente al registro de eventos de **Sysmon**. |
| `Get-WinEvent -LogName "Windows PowerShell" | Where-Object {$_.Message -like "*-enc*"}` | Busca en los *logs* de PowerShell cualquier comando que contenga el parámetro `-enc` (código ofuscado/codificado), indicando potencial actividad maliciosa. |

## 🔍 Visor de Eventos (eventvwr.msc)

* **Función:** Interfaz gráfica nativa de Windows para visualizar y buscar en los registros de eventos.
* **Consultas Personalizadas:** Permite crear y guardar consultas basadas en criterios como el Nivel de Evento, Origen, y **XML (XPath)** para búsquedas complejas y específicas.

## 🕵️ Detección de Evil con Sysmon

### Detección de Volcado de Credenciales (Credential Dumping)

* **Indicador:** Un proceso, como `lsass.exe`, siendo accedido por un proceso no esperado.
* **Sysmon ID:** Evento **10** (*ProcessAccess*).
* **Query (Ejemplo):** Buscar Evento ID 10 donde `TargetImage` sea `C:\Windows\System32\lsass.exe` y `SourceImage` NO sea un proceso del sistema esperado (ej. `dwm.exe`, `taskmgr.exe`).

### Detección de Inyección de Código (PowerShell/C-Sharp Injection)

* **Indicador:** Un proceso que lanza código que normalmente no debería estar allí.
* **Sysmon ID:** Evento **1** (*ProcessCreate*) o Evento **7** (*ImageLoad*).
* **Técnica:** Buscar en los logs de PowerShell comandos con `-enc` (encoded) o el uso de *cmdlets* asociados a descarga y ejecución de código (ej. `Invoke-WebRequest`, `Invoke-Expression`).