# 00_Overview

El **Análisis de Tráfico de Red (NTA)** es el proceso de examinar las comunicaciones de red para establecer una línea base, caracterizar puertos y protocolos, y monitorear amenazas. Este proceso es fundamental en ciberseguridad defensiva, ya que ayuda a los especialistas a identificar anomalías y amenazas de manera temprana y eficaz.

**Casos de Uso Comunes de NTA:**
* **Recopilación:** Capturar tráfico en tiempo real para analizar amenazas inminentes.
* **Baseline:** Establecer una línea base para las comunicaciones de red diarias.
* **Identificación:** Detectar tráfico en puertos no estándar, *hosts* sospechosos y errores de protocolo (ej. errores HTTP o problemas de TCP).
* **Investigación:** Es esencial para investigar incidentes pasados y durante la búsqueda de amenazas (*threat hunting*).

---

# Concepts

## 🧠 Conocimientos Fundamentales Requeridos

Para realizar un NTA preciso, se requiere conocimiento en:
* **Pila TCP/IP y Modelo OSI:** Para comprender cómo interactúan el tráfico de red y las aplicaciones *host*.
* **Paquetes IP y Subcapas:** Entender que TCP es orientado a *stream* (fácil de seguir) mientras que UDP es rápido y no se preocupa por la integridad (*connectionless*).
* **Encapsulación de Protocolo:** Ser capaz de distinguir los encabezados de las diferentes capas (ej. Ethernet, IP, TCP/UDP).

## 📊 Modelos y Direccionamiento

| Concepto | Capa (OSI) | Descripción |
| :--- | :--- | :--- |
| **PDU** | Todas | Unidad de Datos de Protocolo. El paquete de datos que incluye encabezados de control y datos encapsulados de cada capa. |
| **MAC Address** | 2 (Data-Link) | Dirección de 48 bits, utilizada para comunicación *host-to-host* dentro de un dominio de difusión. |
| **IPv4** | 3 (Network) | Dirección de 32 bits, método principal para el enrutamiento de paquetes entre diferentes redes. |
| **IPv6** | 3 (Network) | Dirección de 128 bits, proporciona un espacio de direcciones mucho mayor y seguridad mejorada (IPSec). |

## 🔗 Protocolos de Transporte (Capa 4)

| Característica | TCP (Transmission Control Protocol) | UDP (User Datagram Protocol) |
| :--- | :--- | :--- |
| **Conexión** | Orientado a la conexión. Confiable. | Sin conexión (*connectionless*). "Envía y olvida". |
| **Establecimiento** | Utiliza el **Three-way Handshake** (SYN, SYN-ACK, ACK). | No utiliza *handshake*. |
| **Naturaleza** | Orientado a *stream*, fácil de seguir y reensamblar. | Rápido, pero no se preocupa por la completitud de la entrega. |

## ⚙️ Flujo de Trabajo (NTA Workflow)

1.  **Ingestión de tráfico:** Capturar el tráfico, utilizando filtros si se busca algo específico.
2.  **Reducción de ruido mediante filtros:** Filtrar el tráfico innecesario (ej. tráfico *Broadcast* o *Multicast*) para facilitar el análisis.
3.  **Análisis y exploración:** Investigar *hosts* específicos, protocolos y *flags* de encabezado (ej. **SYN** para escaneos de puertos).
4.  **Detección y alerta:** Decidir si la actividad es benigna o maliciosa, a menudo utilizando sistemas IDS/IPS.
5.  **Corregir y monitorear:** Si se realiza un cambio o corrección, se debe monitorear la fuente para confirmar la resolución del problema.

---

# Tools

## 💻 tcpdump (Captura CLI)

| Comando / Sintaxis de Uso | Caso de Uso |
| :--- | :--- |
| **`sudo tcpdump -i <interfaz>`** | Captura tráfico en la interfaz especificada (ej. `eth0`). |
| **`sudo tcpdump -i <interfaz> -w <archivo.pcap>`** | Guarda la captura de tráfico en un archivo **PCAP** para su análisis posterior. |
| **`sudo tcpdump -r <archivo.pcap>`** | Lee el contenido de un archivo PCAP. |
| **`sudo tcpdump -i <interfaz> host <IP>`** | Filtra para mostrar solo el tráfico que tiene como fuente o destino la IP especificada. |
| **`sudo tcpdump -i <interfaz> src host <IP>`** | Filtra para mostrar solo el tráfico que **se origina** en la IP especificada. |
| **`sudo tcpdump -i <interfaz> tcp port 80`** | Filtra el tráfico del protocolo TCP en el puerto 80 (HTTP). |

## 🔍 Wireshark / TShark (Análisis Profundo)

| Herramienta | Comando / Sintaxis de Uso | Caso de Uso / Funcionalidad Clave |
| :--- | :--- | :--- |
| **Wireshark** | Interfaz Gráfica (GUI) | Analizador gráfico, ofrece inspección profunda de paquetes. Permite **Seguir *Streams* TCP** para ver la conversación completa y **Extraer Archivos**. |
| **TShark** | `sudo tshark -i <interfaz> -w <archivo.pcap>` | Variante de línea de comandos de Wireshark. Ideal para capturas en servidores o entornos sin GUI. |
| **Filtros de Captura** | Se aplica con sintaxis **BPF** antes de la captura (ej. en `tcpdump` o al iniciar Wireshark). | Reduce la cantidad de datos guardados en el archivo PCAP. |
| **Filtros de Visualización** | Se aplica con sintaxis específica de Wireshark (ej. `http.request.method == "GET"` ) después de la captura. | Modifica la vista de los paquetes ya capturados en la GUI. |

## 🔑 BPF (Berkeley Packet Filter)

* **Descripción:** Es la sintaxis compartida por herramientas como `tcpdump` y `TShark` para definir filtros de tráfico.
* **Función:** Permite que las herramientas filtren el tráfico en la capa de Enlace de Datos, optimizando la captura.
* **Ejemplos de Sintaxis:**
    * `host <IP>`: para *hosts* específicos.
    * `tcp port 80`: para un protocolo y puerto.
    * `src <host/net/port>` o `dst <host/net/port>`: para origen o destino.
    * Uso de operadores lógicos: `and`, `or`, `not`.
