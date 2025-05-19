from django.contrib import admin
from django.contrib.auth.admin import GroupAdmin
from django.contrib.auth.models import Group

from incidencias.models import Incidencia, CustomUser, ComentarioIncidencia, Notificacion
from django.contrib import admin
from django.contrib.auth.models import Group
from django import forms
# Register your models here.

class CustomUserForm(forms.ModelForm):
    group = forms.ModelChoiceField(queryset=Group.objects.all(), required=False, label="Grupo")

    class Meta:
        model = CustomUser
        fields = ('email', 'name', 'password', 'is_staff', 'is_active', 'group')

    def save(self, commit=True):
        user = super().save(commit=False)
        if commit:
            user.save()
            # Limpia grupos anteriores y asigna el nuevo si hay
            user.groups.clear()
            if self.cleaned_data['group']:
                user.groups.add(self.cleaned_data['group'])
        return user

@admin.register(CustomUser)
class CustomUserAdmin(admin.ModelAdmin):
    form = CustomUserForm
    list_display = ('email', 'name', 'is_staff', 'is_active')
    ordering = ('email',)
    fields = ('email', 'name', 'password', 'is_staff', 'is_active', 'group')

    def save_model(self, request, obj, form, change):
        if form.cleaned_data.get('password'):
            obj.set_password(form.cleaned_data['password'])
        super().save_model(request, obj, form, change)
admin.site.register(Incidencia)
admin.site.register(ComentarioIncidencia)
admin.site.register(Notificacion)

