from django.shortcuts import render, redirect

from .models import Quality, Composer, VoteCounter
from .forms import VoteForm


def index(request):
    composer, composer_1, composer_2 = Composer.objects.order_by('?')[:3]

    composer_quality = VoteCounter.objects.filter(
        composer=composer,
    ).order_by('-count')[0].quality

    random_quality = Quality.objects.order_by('?')[0]

    return render(
        request,
        'index.html',
        dict(
            composer=composer,
            composer_quality=composer_quality,
            random_quality=random_quality,
            composer_1=composer_1,
            composer_2=composer_2,
        )
    )


def vote(request):
    form = VoteForm(data=request.POST)
    if form.is_valid():
        votes, created = VoteCounter.objects.get_or_create(
            composer=form.cleaned_data['composer'],
            quality=form.cleaned_data['quality'],
        )
        votes.count += 1
        votes.save()
    return redirect('index')
