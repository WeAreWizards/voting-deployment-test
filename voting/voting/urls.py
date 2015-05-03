from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

from core.views import index, vote

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),

    url(r'^vote/', vote, name='vote'),
    url(r'', index, name='index'),
)
