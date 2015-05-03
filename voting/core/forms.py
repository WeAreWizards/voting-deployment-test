from django import forms

from .models import Quality, Composer


class VoteForm(forms.Form):
    composer = forms.ModelChoiceField(queryset=Composer.objects)
    quality = forms.ModelChoiceField(queryset=Quality.objects)
