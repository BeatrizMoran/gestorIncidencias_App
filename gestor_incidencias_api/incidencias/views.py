from rest_framework_simplejwt.authentication import JWTAuthentication
from .permissions import ReadOnlyPermission
from rest_framework.permissions import IsAuthenticated

from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from drf_yasg.utils import swagger_auto_schema

from incidencias.models import Incidencia, Notificacion, ComentarioIncidencia
from incidencias.serializers import IncidenciaSerializer, NotificacionSerializer, ComentarioIncidenciaSerializer


# Create your views here.

class IncidenciasListApiView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        # Incidencias del usuario autenticado
        incidencias = Incidencia.objects.filter(asignado_a=request.user)

        # Obtener parámetros de filtro de la query
        estado = request.query_params.get("estado")
        urgencia = request.query_params.get("urgencia")
        fecha = request.query_params.get("fecha")  # Esperado formato: "YYYY-MM-DD"

        if estado:
            incidencias = incidencias.filter(estado=estado)

        if urgencia:
            incidencias = incidencias.filter(urgencia=urgencia)

        if fecha:
            incidencias = incidencias.filter(created_at__date=fecha)

        serializer = IncidenciaSerializer(incidencias, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    # generar automáticamente documentación Swagger/OpenAPI
    @swagger_auto_schema(request_body=IncidenciaSerializer,
                         operation_description="Crear una nueva incidencia",
                        operation_summary="Crear incidencia"
                         )
    def post(self, request, *args, **kwargs):
        serializer = IncidenciaSerializer(data=request.data)
        if serializer.is_valid():
            # Guardamos la incidencia con el usuario reportante
            incidencia = serializer.save(reportado_por=request.user)

            # Si no se proporciona "asignado_a", lo asignamos al usuario actual
            if not incidencia.asignado_a:
                incidencia.asignado_a = request.user
                incidencia.save()

            return Response(IncidenciaSerializer(incidencia).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class IncidenciaDetailApiView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get_object(self, incidencia_id):
        try:
            return Incidencia.objects.get(id=incidencia_id)
        except Incidencia.DoesNotExist:
            return None

    def get(self, request, incidencia_id, *args, **kwargs):
        incidencia_instance = self.get_object(incidencia_id)
        if not(incidencia_instance):
            return Response(
                {
                    "res": "Object with incidencia id does not exist"
                },
                status = status.HTTP_404_BAD_REQUEST
            )
        serializer = IncidenciaSerializer(incidencia_instance)
        return Response(serializer.data, status = status.HTTP_200_OK)

    @swagger_auto_schema(request_body=IncidenciaSerializer)
    def put(self, request, incidencia_id, *args, **kwargs):
        incidencia_instance = self.get_object(incidencia_id)
        if not incidencia_instance:
            return Response(
                {"res": "Object with incidencia id does not exist"},
                status=status.HTTP_404_NOT_FOUND
            )

        # Combinar los datos entrantes con los actuales (si no vienen en request)
        data = {
            "descripcion": request.data.get("descripcion", incidencia_instance.descripcion),
            "ubicacion": request.data.get("ubicacion", incidencia_instance.ubicacion),
            "urgencia": request.data.get("urgencia", incidencia_instance.urgencia),
            "estado": request.data.get("estado", incidencia_instance.estado),
            "asignado_a": request.data.get("asignado_a",
                                           incidencia_instance.asignado_a.id if incidencia_instance.asignado_a else None),
            "reportado_por": incidencia_instance.reportado_por.id,
        }

        serializer = IncidenciaSerializer(instance=incidencia_instance, data=data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @swagger_auto_schema(request_body=IncidenciaSerializer)
    def delete(self, request, incidencia_id, *args, **kwargs):
        incidencia_instance = self.get_object(incidencia_id)
        if not (incidencia_instance):
            return Response(
                {"res": "Object with incidencia id does not exist"},
                status=status.HTTP_404_NOT_FOUND
            )
        incidencia_instance.delete()
        return Response(
            {"res": "Object deleted"},
            status=status.HTTP_200_OK
        )

#Mensajes

class NotificacionesUsuarioView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        notificaciones = Notificacion.objects.filter(destinatario=request.user).order_by('-fecha_envio')
        serializer = NotificacionSerializer(notificaciones, many=True)
        return Response(serializer.data)

#Gerentes


class NotificacionesListApiView(APIView):
    #añade permisos para comprobar si el usuario esta autenticado
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        # Filtrar solo notificaciones asignadas al usuario actual
        notificaciones = Notificacion.objects.filter(destinatario=request.user)
        serializer = NotificacionSerializer(notificaciones, many=True)
        return Response(serializer.data, status = status.HTTP_200_OK)

class NotificacionDetailApiView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get_object(self, notificacion_id):
        try:
            return Notificacion.objects.get(id=notificacion_id)
        except Notificacion.DoesNotExist:
            return None

    def get(self, request, notificacion_id, *args, **kwargs):
        notificacion_instance = self.get_object(notificacion_id)
        if not(notificacion_instance):
            return Response(
                {
                    "res": "Object with notificacion id does not exist"
                },
                status = status.HTTP_404_BAD_REQUEST
            )
        serializer = NotificacionSerializer(notificacion_instance)
        return Response(serializer.data, status = status.HTTP_200_OK)

    def put(self, request, notificacion_id, *args, **kwargs):
        notificacion_instance = self.get_object(notificacion_id)
        if not notificacion_instance:
            return Response(
                {"res": "Object with notificacion id does not exist"},
                status=status.HTTP_404_NOT_FOUND
            )

        # Solo actualizamos el campo `leido` a True
        notificacion_instance.leido = True
        notificacion_instance.save()

        serializer = NotificacionSerializer(notificacion_instance)
        return Response(serializer.data, status=status.HTTP_200_OK)


#Listar todos los comentarios de una incidencia, y crear comentario
class ComentariosIncidenciaListApiView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, incidencia_id, *args, **kwargs):
        # Obtener la incidencia o devolver 404
        try:
            incidencia = Incidencia.objects.get(id=incidencia_id)
        except Incidencia.DoesNotExist:
            return Response({"res": "Incidencia no encontrada"}, status=status.HTTP_404_NOT_FOUND)

        comentarios = incidencia.comentarios.all()  # related_name='comentarios'
        serializer = ComentarioIncidenciaSerializer(comentarios, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @swagger_auto_schema(request_body=ComentarioIncidenciaSerializer)
    def post(self, request, incidencia_id, *args, **kwargs):
        # Añadir incidencia al data recibido para que el serializer pueda validar correctamente
        data = request.data.copy()
        data['incidencia'] = incidencia_id

        serializer = ComentarioIncidenciaSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


#ver detalle y borrar un comentario de una incidencia
class ComentarioIncidenciaDetailApiView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get_object(self, incidencia_id, comentario_id):
        try:
            comentario = ComentarioIncidencia.objects.get(id=comentario_id, incidencia_id=incidencia_id)
            return comentario
        except ComentarioIncidencia.DoesNotExist:
            return None

    def get(self, request, incidencia_id, comentario_id, *args, **kwargs):
        comentario = self.get_object(incidencia_id, comentario_id)
        if not comentario:
            return Response({"res": "Comentario no encontrado para esta incidencia"}, status=status.HTTP_404_NOT_FOUND)
        serializer = ComentarioIncidenciaSerializer(comentario)
        return Response(serializer.data, status=status.HTTP_200_OK)


    @swagger_auto_schema(request_body=ComentarioIncidenciaSerializer)
    def delete(self, request, incidencia_id, comentario_id, *args, **kwargs):
        comentario = self.get_object(incidencia_id, comentario_id)
        if not comentario:
            return Response({"res": "Comentario no encontrado para esta incidencia"}, status=status.HTTP_404_NOT_FOUND)
        comentario.delete()
        return Response({"res": "Comentario eliminado"}, status=status.HTTP_200_OK)

