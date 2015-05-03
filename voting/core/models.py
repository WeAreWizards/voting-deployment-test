from django.db import models


class Composer(models.Model):
    name = models.CharField(max_length=65)

    def __str__(self):
        return self.name


class Quality(models.Model):
    name = models.CharField(max_length=65)
    description = models.TextField()

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = 'qualities'


class VoteCounter(models.Model):
    composer = models.ForeignKey(Composer)
    quality = models.ForeignKey(Quality)
    count = models.IntegerField(default=0)

    def __str__(self):
        return "%s-%s: %d" % (self.composer, self.quality, self.count)
