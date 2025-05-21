from django.contrib.auth import get_user_model
from rest_framework import serializers

from incidencias.models import Incidencia, CustomUser, Notificacion, ComentarioIncidencia

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'name']

class IncidenciaSerializer(serializers.ModelSerializer):
    asignado_a = serializers.PrimaryKeyRelatedField(
        queryset=CustomUser.objects.all(),
        required=False,
        allow_null=True,
        write_only=True
    )

    reportado_por = serializers.PrimaryKeyRelatedField(
        queryset=CustomUser.objects.all(),
        required=False,
        allow_null=True,
        write_only=True
    )
    asignado_a_data = UserSerializer(source="asignado_a", read_only=True)

    reportado_por_data = UserSerializer(source="reportado_por", read_only=True)


    class Meta:
        model = Incidencia
        fields = [
            "id",
            "descripcion",
            "ubicacion",
            "urgencia",
            "estado",
            "created_at",
            "updated_at",
            "asignado_a",
            "asignado_a_data",
            "reportado_por",
            "reportado_por_data"
        ]
        read_only_fields = ["id", "created_at", "updated_at"]


class NotificacionSerializer(serializers.ModelSerializer):
    incidencia = serializers.PrimaryKeyRelatedField(
        queryset=Incidencia.objects.all(),
        required=False,
        allow_null=True,
        write_only=True
    )
    remitente = serializers.PrimaryKeyRelatedField(
        queryset=CustomUser.objects.all(),
        required=False,
        allow_null=True,
        write_only=True
    )

    destinatario = serializers.PrimaryKeyRelatedField(
        queryset=CustomUser.objects.all(),
        required=False,
        allow_null=True,
        write_only=True
    )
    incidencia_data = IncidenciaSerializer(source="incidencia", read_only=True)

    remitente_data = UserSerializer(source="remitente", read_only=True)

    destinatario_data = UserSerializer(source="destinatario", read_only=True)
    class Meta:
        model = Notificacion
        fields = ['id',
                  "incidencia",
                  "incidencia_data",
                  'remitente',
                  'remitente_data',
                  'destinatario',
                  'destinatario_data',
                  "cuerpo",
                  "fecha_envio",
                  "leido"]

class ComentarioIncidenciaSerializer(serializers.ModelSerializer):
    class Meta:
        model = ComentarioIncidencia
