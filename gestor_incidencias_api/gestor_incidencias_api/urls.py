"""
URL configuration for gestor_incidencias_api project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
# from django.contrib import admin
from django.contrib import admin
from django.urls import path, include
from drf_yasg import openapi
from drf_yasg.views import get_schema_view
from rest_framework import permissions

schema_view = get_schema_view(
    openapi.Info(
        title="Incidencias API",
        default_version='v1',
        description="""
                API para la gestión de incidencias.

                ⚠️ **IMPORTANTE**: Todos los endpoints requieren autenticación JWT.

                1. Ve a `/auth/jwt/create` e inicia sesión con tus credenciales para obtener el token.
                    1.1.- email: prueba@gmail.com, password: prueba
                2. Copia el campo `access`.
                3. Haz clic en el botón **Authorize** arriba a la derecha.
                4. Pega el token en este formato: `JWT <tu_token>`.

                Después de eso, podrás probar los endpoints protegidos desde Swagger UI.
                """,        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email="<beatriz.moran@ikasle.egibide.org>"),
        license=openapi.License(name="MIT License"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)
urlpatterns = [

    path('auth/', include('djoser.urls')),
    path('auth/', include('djoser.urls.jwt')),
       path('admin/', admin.site.urls),
    path('api/', include("incidencias.urls")),

path('swagger/', schema_view.with_ui('swagger', cache_timeout=0),
         name='schema-swagger-ui'),



]
