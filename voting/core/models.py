from django.db import models


class Composer(models.Model):
    name = models.CharField(max_length=65)


class Adjective(models.Model):
    name = models.CharField(max_length=65)


class VoteCounter(models.Model):
    composer = models.ForeignKey(Composer)
    adjective = models.ForeignKey(Adjective)
    count = models.IntegerField(default=0)
