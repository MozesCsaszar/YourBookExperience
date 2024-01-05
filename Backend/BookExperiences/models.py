from django.db import models


class Review(models.Model):
    userId = models.IntegerField()
    bTitle = models.CharField(max_length=200)
    bAuthor = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    experiences = models.TextField(blank=True)
    pros = models.TextField(blank=True)
    cons = models.TextField(blank=True)
    rating = models.FloatField()
    create_date = models.DateTimeField(auto_now_add=True)
