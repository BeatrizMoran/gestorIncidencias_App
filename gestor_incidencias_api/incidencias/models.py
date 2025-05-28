from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.models import User, PermissionsMixin
from django.db import models

class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("El email es obligatorio")

        email = self.normalize_email(email)
        user = self.model(email=email,**extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None,**extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, password,**extra_fields)

class CustomUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)

    name = models.CharField(max_length=255)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    objects = CustomUserManager()
    USERNAME_FIELD ='email'
    REQUIRED_FIELDS = ['name']

    def __str__(self):
        return self.email

class Incidencia(models.Model):
    ESTADOS = [
        ('pendiente', 'Pendiente'),
        ('en_proceso', 'En Proceso'),
        ('resuelta', 'Resuelta'),
        ('cancelada', 'Cancelada'),
    ]
    URGENCIAS = [
        ('baja', 'Baja'),
        ('media', 'Media'),
        ('alta', 'Alta'),
    ]
    descripcion = models.TextField()
    ubicacion = models.CharField(max_length=255)
    urgencia = models.CharField(max_length=10, choices=URGENCIAS, default='media')
    estado = models.CharField(max_length=15, choices=ESTADOS, default='pendiente')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    asignado_a = models.ForeignKey(
        CustomUser,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='incidencias_asignadas'
    )
    reportado_por = models.ForeignKey(
        CustomUser,
        on_delete=models.CASCADE,
        related_name='incidencias_reportadas'
    )

    def __str__(self):
        return f"Incidencia #{self.id}: {self.descripcion[:50]}..."

class ComentarioIncidencia(models.Model):
    incidencia = models.ForeignKey(
        Incidencia,
        on_delete=models.CASCADE,
        related_name='comentarios'
    )
    #autor = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    texto = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Comentario en Incidencia #{self.incidencia.id} "

class Notificacion(models.Model):
    incidencia = models.ForeignKey('Incidencia', on_delete=models.CASCADE, related_name='mensajes')
    remitente = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='mensajes_enviados')
    destinatario = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='mensajes_recibidos')
    cuerpo = models.TextField()
    fecha_envio = models.DateTimeField(auto_now_add=True)
    leido = models.BooleanField(default=False)

    def __str__(self):
        return f'Mensaje para {self.destinatario.name} - {self.fecha_envio}'




