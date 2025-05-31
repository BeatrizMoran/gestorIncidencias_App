# Proyecto Incidencias App

Este repositorio contiene el backend, frontend y las pruebas de la API para la aplicación de gestión de incidencias.

---

## Estructura del repositorio

- `gestor_incidencias_api/` - Código fuente del backend (API REST con Django REST Framework).
- `gestorIncidencias/` - Código fuente del frontend (App iOS).
- `postman-tests/` - Colección de pruebas en Postman para la API (`.json`).

---

## Instrucciones para iniciar la aplicación

### Backend

1. Clonar el repositorio:

    git clone <URL_DEL_REPOSITORIO>
    cd gestor_incidencias_api

Crear y activar un entorno virtual :

    python -m venv venv
    # Linux/macOS
    source venv/bin/activate
    # Windows
    venv\Scripts\activate

Instalar dependencias:

    pip install -r requirements.txt

Ejecutar migraciones:

    python manage.py migrate

Levantar el servidor:

    python manage.py runserver

Datos para pruebas
Para realizar pruebas con la aplicación, puedes usar el siguiente usuario de prueba:

    Email: prueba@gmail.com

    Contraseña: prueba

Pruebas API con Postman
    Importa la colección postman-tests/INCIDENCIAS_APP.postman_collection.json en Postman para probar los endpoints de la API.

    Asegúrate de autenticarte con el usuario de prueba para obtener el token JWT necesario para los endpoints protegidos.