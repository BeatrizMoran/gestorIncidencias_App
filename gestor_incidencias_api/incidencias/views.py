from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from incidencias.models import Incidencia, Mensaje
from incidencias.serializers import IncidenciaSerializer, MensajeSerializer


# Create your views here.

class IncidenciasListApiView(APIView):

    def get(self, request, *args, **kwargs):
        departamentos = Incidencia.objects.all()
        serializer = IncidenciaSerializer(departamentos, many=True)
        return Response(serializer.data, status = status.HTTP_200_OK)


class IncidenciaDetailApiView(APIView):
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
        if not(incidencia_instance):
            return Response(
                {"res": "Object with incidencia id does not exist"},
                status = status.HTTP_404_NOT_FOUND
            )
        data = {
            "descripcion": incidencia_instance.descripcion,
            "ubicacion": incidencia_instance.ubicacion,
            "urgencia": incidencia_instance.urgencia,
            "estado": incidencia_instance.estado,
            "asignado_a": incidencia_instance.asignado_a,
            "reportado_por": incidencia_instance.reportado_por,
        }

        serializer = IncidenciaSerializer(instance=incidencia_instance, data=data, partial = True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status = status.HTTP_200_OK)
        return Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)

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
        mensajes = Mensaje.objects.filter(destinatario=request.user).order_by('-fecha_envio')
        serializer = MensajeSerializer(mensajes, many=True)
        return Response(serializer.data)