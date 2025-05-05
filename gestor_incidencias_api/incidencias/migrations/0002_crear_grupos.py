from django.db import migrations
from django.contrib.auth.models import Group

def crear_grupos(apps, schema_editor):
    Group.objects.get_or_create(name="operario")
    Group.objects.get_or_create(name="gerencia")




class Migration(migrations.Migration):

    dependencies = [
        ('incidencias', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(crear_grupos),
    ]