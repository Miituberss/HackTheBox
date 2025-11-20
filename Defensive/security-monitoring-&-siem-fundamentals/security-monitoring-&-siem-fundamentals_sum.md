# 00_Overview

El **SIEM (Security Information and Event Management)** es una solución integral que combina la gestión de información de seguridad (**SIM**) con la gestión de eventos de seguridad (**SEM**). Su propósito principal es **agregar, correlacionar y analizar** datos de *logs* de múltiples fuentes en tiempo real para detectar amenazas, generar alertas y asegurar el cumplimiento normativo.

El SIEM es la pieza central del **SOC (Security Operations Center)**, proporcionando la visibilidad necesaria para que los analistas puedan identificar patrones de actividad maliciosa que serían invisibles al examinar *logs* individuales. El proceso de convertir datos crudos en inteligencia accionable es clave para una respuesta a incidentes eficaz.

---

# Concepts

## ⚙️ ¿Cómo Funciona una Solución SIEM?

El flujo de datos dentro de un SIEM sigue un proceso estandarizado:

1.  **Recolección (*Collection*):** Los *logs* y datos de eventos se recopilan de diversas fuentes (sistemas operativos, *firewalls*, servidores web, aplicaciones).
2.  **Agregación (*Aggregation*):** Los datos se consolidan en una ubicación centralizada (la base de datos del SIEM) para facilitar el análisis a gran escala.
3.  **Normalización (*Normalization*):** Los datos brutos se transforman en un **formato estandarizado y coherente** para permitir la correlación entre distintos sistemas. Esto es crucial para que un evento de *login* en Windows (`ID 4624`) y un evento de *login* en Linux (`ssh: accepted`) puedan ser analizados juntos.
4.  **Correlación (*Correlation*):** Se examinan los eventos para encontrar **relaciones** entre ellos (ej. un *login* fallido seguido de un *login* exitoso en un *host* diferente), identificando patrones de ataque que abarcan múltiples sistemas.
5.  **Análisis y Alerta (*Analysis & Alerting*):** Se aplican reglas de detección y algoritmos de análisis de comportamiento (UEBA) para generar alertas sobre amenazas confirmadas o anomalías.

## 📊 Casos de Uso del SIEM

* **Detección de Amenazas y Alerta:** El uso más crítico; identificar IOCs y actividad sospechosa en tiempo real (ej. ataques de *brute-force*, movimiento lateral).
* **Gestión de Cumplimiento (*Compliance*):** Recopilar datos para demostrar el cumplimiento con normativas como PCI DSS o GDPR.
* **Investigación y Forense:** Proporcionar un repositorio centralizado de *logs* históricos para investigar incidentes pasados.

## 🏢 El Centro de Operaciones de Seguridad (SOC)

El SOC es el equipo centralizado responsable de la monitorización, detección, análisis y respuesta a los incidentes de ciberseguridad.

### Niveles de Analistas:

| Nivel | Rol Principal | Tareas Típicas |
| :--- | :--- | :--- |
| **Tier 1** | **Analista de Triage (Triaje)** | Monitoriza las alertas del SIEM, filtra el ruido, y clasifica las alertas como falsos positivos o incidentes reales. |
| **Tier 2** | **Analista de Investigación** | Investiga incidentes escalados por el Tier 1, realiza análisis forense de *logs* y determina el alcance y la causa raíz. |
| **Tier 3** | **Cazador de Amenazas (*Threat Hunter*) / Arquitecto** | Busca proactivamente amenazas no detectadas (*Threat Hunting*) y desarrolla nuevas reglas de correlación y detección para el SIEM. |

---

# Tools

## 📦 Elastic Stack (ELK)

El **Elastic Stack** es una pila de *software* de código abierto que se utiliza comúnmente como una solución SIEM, especialmente popular en la comunidad técnica.

| Componente | Función Principal | Descripción |
| :--- | :--- | :--- |
| **Elasticsearch (E)** | Almacenamiento y Búsqueda | Base de datos distribuida y motor de búsqueda para la ingesta y recuperación de grandes volúmenes de datos. |
| **Logstash (L)** | Procesamiento de Datos | Canalización de procesamiento de datos que ingiere, enriquece y transforma los *logs* antes de enviarlos a Elasticsearch. |
| **Kibana (K)** | Visualización y GUI | Interfaz gráfica utilizada para consultar los datos, crear *dashboards*, generar visualizaciones y gestionar alertas. |
| **Beats** | Recolección Ligera | Agentes ligeros instalados en los *endpoints* para enviar datos de sistemas específicos (ej. `Filebeat` para archivos de *logs*, `Winlogbeat` para Event Logs de Windows). |

## 📐 Elastic Common Schema (ECS)

* **Descripción:** Un estándar de campo para el Elastic Stack.
* **Función:** Proporciona un **esquema de campo uniforme** para los datos de *logs* y métricas, permitiendo que los datos de diferentes fuentes sean mapeados a un conjunto común de campos.
* **Importancia:** El ECS es la base para la **Normalización**; garantiza que un analista pueda buscar el campo `source.ip` y que este campo sea correcto para cualquier fuente de datos (Windows, Linux, *firewall*, etc.), facilitando la correlación.

## 🔎 Ejemplos de Detección (Visualizaciones en Kibana)

Un analista de SOC (Tier 1/2) utiliza visualizaciones y filtros en Kibana para identificar anomalías:

| Caso de Uso | Indicador de Compromiso (IOC) | Detección en SIEM |
| :--- | :--- | :--- |
| **Uso de Cuentas de Servicio** | Una cuenta de servicio se conecta vía RDP (Remote Desktop Protocol). | **Regla de Correlación:** Alerta si `user.type = service` y `event.action = RDP logon`. |
| **Movimiento Lateral** | El mismo usuario falla en un *login* en el Servidor A y luego tiene éxito en el Servidor B en un corto periodo. | **Visualización:** Histograma de eventos de *login* fallidos y exitosos por IP de origen. |
| **Uso de Cuenta Deshabilitada** | Múltiples intentos de *login* de una cuenta deshabilitada (ej. `Anni` desactivada). | **Filtro:** `user.name = "Anni"` y `event.outcome = failure`. |
| **SSH en Root** | *Login* SSH de un usuario `root` cuando la política dicta no usarlo. | **Filtro:** `user.name = "root"` y `network.protocol = SSH`. |