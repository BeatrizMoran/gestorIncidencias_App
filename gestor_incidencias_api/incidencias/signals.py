from django.db.models.signals import pre_save, post_save
from django.dispatch import receiver
from incidencias.models import Incidencia, Notificacion

# Diccionario para guardar estado previo temporalmente
_previous_estado = {}

@receiver(pre_save, sender=Incidencia)
def store_previous_estado(sender, instance, **kwargs):
    if instance.pk:
        try:
            old_instance = sender.objects.get(pk=instance.pk)
            _previous_estado[instance.pk] = old_instance.estado
        except sender.DoesNotExist:
            _previous_estado[instance.pk] = None
    else:
        _previous_estado[instance.pk] = None

@receiver(post_save, sender=Incidencia)
def crear_notificacion_estado(sender, instance, created, **kwargs):
    previous_estado = _previous_estado.pop(instance.pk, None)

    if created:
        # Incidencia nueva
        if instance.asignado_a:
            Notificacion.objects.create(
                incidencia=instance,
                remitente=instance.reportado_por,
                destinatario=instance.asignado_a,
                cuerpo=f'Se ha creado una nueva incidencia asignada a ti: {instance.descripcion}',
            )
    else:
        # Incidencia actualizada, revisar si cambió estado
        if previous_estado != instance.estado and instance.asignado_a:
            Notificacion.objects.create(
                incidencia=instance,
                remitente=instance.reportado_por,
                destinatario=instance.asignado_a,
                cuerpo=f'El estado de la incidencia ha cambiado de "{previous_estado}" a "{instance.estado}"',
            )
