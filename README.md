# Gestión de Incidencias

Una empresa de la zona ha contratado a vuestro equipo para desarrollar una nueva aplicación que permita gestionar de manera ágil y eficiente las incidencias reportadas en su operativa diaria. La aplicación estará destinada principalmente a los operarios encargados de resolver las incidencias, aunque también será utilizada por el personal de gerencia.

Se pretende automatizar los siguientes procesos:

- Registro y seguimiento de incidencias.

- Asignación de incidencias a operarios.

- Gestión de estados de las incidencias.

- Notificaciones personalizadas.

## Requisitos

### Generales

- La aplicación dispondrá de un sistema de autenticación que permita identificar a los usuarios mediante credenciales seguras.

- Cada usuario visualizará únicamente la información relevante según su rol.
  
  - **Operarios:** utilizarán la aplicación móvil (iOS) o una tablet para gestionar las incidencias que tienen asignadas.
  
  - **Gerencia:** utilizará la aplicación web para gestionar todas las incidencias, asignarlas y hacer seguimiento completo.

- Se establecerá un sistema de comunicación entre operarios y gerencia.

### Requisitos funcionales según plataforma

#### API en Django (SGE)

- Gestionará el sistema de autenticación y autorización de usuarios (operarios y gerencia).

- Permitirá registrar incidencias con información como descripción, ubicación, urgencia y estado.

- Permitirá actualizar el estado de una incidencia (pendiente, en proceso, resuelta, cancelada).

- Permitirá asignar incidencias a operarios.

- Permitirá registrar comentarios o acciones realizadas por los operarios en las incidencias.

- Permitirá listar incidencias propias y consultar históricos filtrando por fecha, estado o urgencia.

- Expondrá todos estos servicios como API REST documentada con Swagger o Redoc.

#### Aplicación iOS (PMDM)

- Permitirá al operario autenticarse en la app mediante credenciales.

- Mostrará el listado de incidencias asignadas al operario con su información principal.

- Permitirá registrar nuevas incidencias desde el móvil, indicando descripción, ubicación y urgencia.

- Permitirá modificar el estado de las incidencias asignadas.

- Mostrará el historial de incidencias resueltas por el operario.

- Mostrará notificaciones sobre cambios en las incidencias asignadas (opcionalmente mediante notificaciones push o vista de mensajes).

#### Aplicación Web en Vue (LM)

- Permitirá a gerencia y operarios autenticarse con credenciales.

- Permitirá a gerencia visualizar y gestionar el listado completo de incidencias con todos sus detalles.

- Permitirá crear nuevas incidencias y asignarlas a operarios.

- Permitirá a operarios registrar acciones sobre sus incidencias y modificar su estado.

- Permitirá a gerencia consultar históricos con filtros por estado, urgencia y fechas.

- Mostrará un sistema de mensajería donde se visualizarán notificaciones o mensajes entre gerencia y operarios.

## Plataforma tecnológica

- La empresa desea que el backend se desarrolle en Django como API REST, el frontend web en Vue y una aplicación móvil para iOS.

- Se utilizará MySQL como servidor de BBDD.

- Cada parte de la aplicación (backend y frontend ) deberá desplegarse como un contenedor [Docker](https://www.docker.com) independiente para facilitar su despliegue.

- La API deberá estar documentada con [Swagger](https://swagger.io) o [Redoc](https://redocly.com).

- La aplicación móvil será compatibles con versiones de ios 16 o posteriores.

## Restricciones y sugerencias

- Los estudiantes que NO cursen LM, pero sí SGE y PMDM, deberán realizar la api completa en Django y la app móvil con los requisitos previamente establecidos. Podrán realizar el trabajo de forma individual o en equipos de dos personas.

- El resto de estudiantes, deberán realizar la api completa en Django, la app móvil y la aplicación web con los requisitos previamente establecidos. En ambos casos consumirán los servicios de la api.

- Los equipos deberán ser comunicados por correo antes del miércoles 7 de mayo a las 22:00.

- Se deberá realizar pruebas de la API con [Postman](https://www.postman.com) y añadir al repositorio el fichero *.json* con las pruebas realizadas.

- Todos los productos desarrollados deberán añadirse como subcarpetas en el repositorio. Una estructura podría ser si fueran nombres de carpetas:
  
  - proyeto-app
  
  - proyecto-frontend
  
  - proyecto-backend

- Todo el software y materiales utilizados deberán ser de fuentes libres o de dominio público y correctamente atribuidos.

## Plazo

- Fecha de entrega: 1/06/2025 a las 23:59h.

- El lunes 2/06/2025 se expondrá el trabajo realizado y se responderán preguntas del equipo docente, lo que influirá en la calificación.

## Importante

- **No se tolerará el plagio.** Si se detecta, el resultado será un 0 automático para todas las personas involucradas.    

## Rúbricas de evaluación

## Rúbrica de evaluación

| Categoría                   | No entregado (0) | Insuficiente (2)                                                | Aceptable (4)                                                                   | Bien (6)                                                                                              | Notable (8)                                                                                        | Excelente (10)                                                                                                                                |
| --------------------------- | ---------------- | --------------------------------------------------------------- | ------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **Requisitos mínimos**      |                  | No funciona correctamente o faltan requisitos obligatorios.     | Se ha desarrollado parte de la funcionalidad pero presenta errores importantes. | Se ha implementado la API REST con autenticación, gestión básica de incidencias y acceso según roles. | API REST completa y funcional, roles diferenciados, gestión de incidencias y consultas históricas. | API REST bien estructurada, completa, documentada, sin errores; funcionalidad completa incluyendo comentarios, filtros avanzados y seguridad. |
| **App iOS (PMDM)**          |                  | No entregada o no funcional.                                    | Aplicación básica con errores o funcionalidades incompletas.                    | El operario puede autenticarse, visualizar incidencias y cambiar su estado.                           | Todas las funcionalidades requeridas están implementadas; interfaz clara y sin errores.            | Interfaz cuidada, experiencia de usuario fluida, funcionalidades extra como notificaciones push o filtros avanzados.                          |
| **App Web en Vue (LM)**     |                  | No entregada o no funcional.                                    | Interfaz funcional mínima con errores o limitaciones.                           | Gerencia puede acceder, ver incidencias y asignarlas.                                                 | Aplicación completa para gerencia y operarios, con filtros y sistema de mensajes.                  | Funcionalidad completa, diseño bien estructurado, buena usabilidad y sistema de comunicación eficaz.                                          |
| **Documentación y pruebas** |                  | No se entrega documentación ni pruebas.                         | Documentación incompleta y pruebas insuficientes.                               | API documentada con Swagger/Redoc, y pruebas básicas en Postman.                                      | Documentación clara, pruebas detalladas de los casos principales.                                  | Documentación profesional, pruebas exhaustivas con múltiples casos y resultados esperados.                                                    |
| **Dominio del tema**        |                  | El presentador no conoce el proyecto y no responde a preguntas. | Responde con dificultad a las preguntas o muestra desconocimiento parcial.      | Muestra conocimiento básico y responde la mayoría de preguntas.                                       | Domina el proyecto, responde con claridad a las preguntas técnicas y funcionales.                  | Explica y defiende el proyecto con profundidad, incluyendo decisiones técnicas y posibles mejoras futuras.                                    |
| **Entrega y repositorio**   |                  | No se entrega correctamente o fuera de plazo.                   | Repositorio incompleto o mal estructurado.                                      | Repositorio correcto con estructura clara y entregado a tiempo.                                       | Buen uso de Git, commits frecuentes y relevantes por todos los integrantes.                        | Uso avanzado de control de versiones, buena documentación del código, estructura profesional del repositorio.                                 |

## Penalizaciones

|         | Insuficiente (-5 cada ítem)                                                                  |
| ------- | -------------------------------------------------------------------------------------------- |
| Plazo   | No se ha entregado el proyecto en el plazo previsto.                                         |
| Entrega | No se ha entregado el código fuente en un repositorio Git o no tiene la estructura adecuada. |
| Github  | Número mínimo de commits o falta de regularidad en las contribuciones.                       |
| Errores | Errores de sintaxis o ejecución en el código.                                                |
| Pruebas | Número de pruebas insuficiente o poco relevante.                                             |
