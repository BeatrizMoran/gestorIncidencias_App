from django.urls import path, include

from incidencias.views import IncidenciasListApiView, IncidenciaDetailApiView

urlpatterns = [
    path("incidencias", IncidenciasListApiView.as_view()),
    path("incidencias/<int:incidencia_id>", IncidenciaDetailApiView.as_view()),

]