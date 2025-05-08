from django.contrib.auth import get_user_model
from rest_framework import serializers

from incidencias.models import Incidencia, Mensaje

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'name']

class IncidenciaSerializer(serializers.ModelSerializer):
    asignado_a = UserSerializer(read_only=True)
    reportado_por = UserSerializer(read_only=True)

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
            "reportado_por",
        ]
        read_only_fields = ["id", "created_at", "updated_at", "asignado_a", "reportado_por"]

class MensajeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Mensaje
        fields = ['id', 'titulo', 'cuerpo', 'fecha_envio', 'leido']