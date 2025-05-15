from django.contrib import admin
from django.contrib.auth.models import Group

from incidencias.models import Incidencia, CustomUser, ComentarioIncidencia, Mensaje

# Register your models here.
admin.site.register(CustomUser)
admin.site.register(Incidencia)
admin.site.register(ComentarioIncidencia)
admin.site.register(Mensaje)

