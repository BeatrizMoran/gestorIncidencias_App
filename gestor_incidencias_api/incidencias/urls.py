from django.urls import path, include

from incidencias.views import IncidenciasListApiView, IncidenciaDetailApiView, NotificacionesListApiView, \
    ComentariosIncidenciaListApiView, ComentarioIncidenciaDetailApiView, NotificacionDetailApiView

urlpatterns = [
    path("incidencias", IncidenciasListApiView.as_view()),
    path("incidencias/<int:incidencia_id>", IncidenciaDetailApiView.as_view()),

    path("notificaciones", NotificacionesListApiView.as_view()),
    path('notificaciones/<int:notificacion_id>/marcar_leido', NotificacionDetailApiView.as_view()),
    path('notificaciones/<int:notificacion_id>', NotificacionDetailApiView.as_view()),

    path('incidencias/<int:incidencia_id>/comentarios', ComentariosIncidenciaListApiView.as_view(),
         name='comentarios-list'),
    path('incidencias/<int:incidencia_id>/comentarios/<int:comentario_id>',
         ComentarioIncidenciaDetailApiView.as_view(), name='comentario-detail'),

]