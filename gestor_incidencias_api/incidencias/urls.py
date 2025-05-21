from django.urls import path, include

from incidencias.views import IncidenciasListApiView, IncidenciaDetailApiView, NotificacionesListApiView, \
    ComentariosIncidenciaView

urlpatterns = [
    path("incidencias", IncidenciasListApiView.as_view()),
    path("incidencias/<int:incidencia_id>", IncidenciaDetailApiView.as_view()),

    path("notificaciones", NotificacionesListApiView.as_view()),
    path('incidencias/<int:incidencia_id>/comentarios/', ComentariosIncidenciaView.as_view(),
         name='comentarios_incidencia'),

]