from rest_framework_simplejwt.authentication import JWTAuthentication
from .permissions import ReadOnlyPermission
from rest_framework.permissions import IsAuthenticated

from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from incidencias.models import Incidencia, Notificacion
from incidencias.serializers import IncidenciaSerializer, NotificacionSerializer


# Create your views here.

class IncidenciasListApiView(APIView):
    #añade permisos para comprobar si el usuario esta autenticado
    authentication_classes = [JWTAuthentication]
    permission_classes = [ReadOnlyPermission]

    def get(self, request, *args, **kwargs):
        departamentos = Incidencia.objects.all()
        serializer = IncidenciaSerializer(departamentos, many=True)
        return Response(serializer.data, status = status.HTTP_200_OK)

    # generar automáticamente documentación Swagger/OpenAPI
    # @swagger_auto_schema(request_body=IncidenciaSerializer)
    def post(self, request, *args, **kwargs):
        serializer = IncidenciaSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(reportado_por=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class IncidenciaDetailApiView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [ReadOnlyPermission]

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

class MensajesUsuarioView(APIView):
    #permission_classes = [IsAuthenticated]

    def get(self, request):
        notificaciones = Notificacion.objects.filter(destinatario=request.user).order_by('-fecha_envio')
        serializer = NotificacionSerializer(notificaciones, many=True)
        return Response(serializer.data)

#Gerentes
