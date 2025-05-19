from django.contrib.auth import get_user_model
from rest_framework import serializers

from incidencias.models import Incidencia, CustomUser, Notificacion

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
    class Meta:
        model = Notificacion
        fields = ['id', 'titulo', 'cuerpo', 'fecha_envio', 'leido']