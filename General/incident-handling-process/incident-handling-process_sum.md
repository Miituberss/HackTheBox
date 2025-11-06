# 00_Overview

La **Gestión de Incidentes (Incident Handling)** es el proceso formal y sistemático que una organización sigue para responder, gestionar y recuperarse de un incidente de ciberseguridad. Este proceso es crucial para minimizar el daño, reducir el tiempo de inactividad, recuperar datos y garantizar la continuidad del negocio.

La respuesta a incidentes es una disciplina que debe estar formalizada y documentada a través de un **Plan de Respuesta a Incidentes (IRP)**. La eficacia de la respuesta depende directamente de la **Fase de Preparación**, que incluye tener políticas claras, documentación accesible, herramientas adecuadas y equipos bien capacitados.

El módulo enfatiza la importancia de frameworks como el **Cyber Kill Chain** y **MITRE ATT&CK** para contextualizar los ataques y planificar las defensas.

---

# Concepts

## 🛡️ Fases del Proceso de Gestión de Incidentes (NIST SP 800-61)

El proceso de respuesta a incidentes se divide típicamente en cuatro fases clave (con la adición de la Preparación y las Lecciones Aprendidas):

| Fase | Descripción | Tareas Clave |
| :--- | :--- | :--- |
| **1. Preparación** | Asegurar que la organización está lista para manejar un incidente. | Desarrollo de políticas y documentación, formación del equipo, configuración de herramientas (EDR, Firewall), *hardening* de sistemas. |
| **2. Detección y Análisis** | Identificar si un evento es un incidente, determinar su alcance y naturaleza. | *Triage*, identificación de la fuente, análisis de *logs*, correlación de eventos, recopilación de datos volátiles (ej. `netstat`). |
| **3. Contención, Erradicación y Recuperación** | Limitar el daño, eliminar la causa raíz y restaurar la operación normal. | **Contención:** Aislar el sistema, implementar cortafuegos. **Erradicación:** Eliminar *malware* y vulnerabilidades. **Recuperación:** Validar sistemas, ponerlos en producción. |
| **4. Post-Incidente (Lecciones Aprendidas)** | Revisar la eficacia de la respuesta y documentar las mejoras. | Reuniones de revisión, actualización de políticas y procedimientos, revisión del **IRP** y documentación final del caso. |

## ⚔️ Frameworks de Ataque

### Cyber Kill Chain (Lockheed Martin)

Modelo secuencial que describe las etapas de un ciberataque, permitiendo al defensor identificar y detener la intrusión en cualquier punto de la cadena.

| Etapa | Descripción | Tarea del Atacante |
| :--- | :--- | :--- |
| **1. Reconocimiento** | Recopilación de información del objetivo. | *Footprinting*, OSINT, escaneo. |
| **2. Armamento** | Creación de una herramienta de ataque (ej. *exploit* + *payload*). | Combinar *shellcode* con un *exploit*. |
| **3. Entrega** | Transmitir el arma al objetivo (ej. email, USB, web). | Enviar un email de *phishing*. |
| **4. Explotación** | El arma explota la vulnerabilidad y se ejecuta el código. | Ejecutar el *exploit*. |
| **5. Instalación** | Establecer persistencia en el sistema (ej. *backdoors*). | Crear una clave de registro `Run`. |
| **6. Comando y Control (C2)** | Crear un canal de comunicación externo para la gestión remota. | Conexión a un *domain* externo. |
| **7. Acciones sobre Objetivos** | El atacante logra su objetivo final (ej. robo de datos, disrupción). | Exfiltración de credenciales. |

### MITRE ATT&CK Framework

Base de conocimiento globalmente accesible de tácticas y técnicas adversarias basadas en casos reales.

* **Tácticas:** El *por qué* de un ataque (ej. Acceso Inicial, Persistencia, Exfiltración).
* **Técnicas:** El *cómo* de un ataque (ej. `T1053` Task Scheduler).
* **Uso:** Permite a los analistas mapear las acciones del adversario a un modelo estandarizado, facilitando la comprensión de la amenaza y el desarrollo de defensas.

## 📝 Preparación y Documentación

* **IRP (Plan de Respuesta a Incidentes):** Documento central que define procedimientos y responsabilidades para cada fase del manejo de incidentes.
* **Políticas Claras:** Políticas de acceso, uso aceptable y copias de seguridad deben estar establecidas y ser fácilmente accesibles.
* **Higiene del Endpoint:** El *hardening* y el uso de soluciones de protección de *endpoint* (EDR) son esenciales. **EDR** proporciona la visibilidad necesaria para detectar y mitigar actividades maliciosas.

---

# Tools

## 🖥️ Herramientas de Recolección Forense (Triage)

Durante la fase de **Detección y Análisis (Triage)**, los analistas recopilan información volátil y persistente de los sistemas comprometidos.

| Herramienta / Dato | Comando / Método de Uso | Objetivo de Seguridad |
| :--- | :--- | :--- |
| **`netstat`** | `netstat -ano` (Windows) / `netstat -tunlp` (Linux) | Recopila **datos volátiles** sobre conexiones de red activas, puertos abiertos (`LISTENING`), y relaciones de procesos (PID). Ayuda a identificar comunicaciones C2 sospechosas. |
| **Registro de Ejecución** | Windows Registry (`HKCU\Software\Microsoft\Windows\CurrentVersion\Run`) | Identifica programas que han establecido **persistencia** y se ejecutan automáticamente al inicio de sesión. |
| **VaultCli.dll** | Se utiliza mediante la línea de comandos | Herramienta de Windows para acceder a las credenciales almacenadas en el **Administrador de Credenciales** (Credential Manager). Su uso sospechoso (ej. por un atacante) indica un intento de exfiltración de credenciales. |
| **TheHive / MISP** | Plataformas SOAR/Threat Intelligence | **Sistemas de Orquestación y *Case Management*** que se utilizan para mapear automáticamente la actividad del incidente a frameworks como MITRE ATT&CK y centralizar la información. |

## 🛡️ Herramientas de Evasión y Defensa

| Tarea | Ejemplo de Herramienta de Defensa | Función Específica |
| :--- | :--- | :--- |
| **Prevención de Exfiltración** | **DMARC** (Domain-based Message Authentication, Reporting & Conformance) | Protocolo de correo electrónico que ayuda a prevenir el *spoofing* de dominio, mitigando ataques de *phishing* que podrían ser usados para la entrega (Delivery). |
| **Control de Endpoints** | **EDR** (Endpoint Detection and Response) | Proporciona visibilidad profunda del sistema y la capacidad de detener procesos y aislar *hosts* durante la fase de Contención. |
