from django.http import HttpResponse
from django.shortcuts import render, get_object_or_404
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView

from BookExperiences.models import Review
from BookExperiences.serializers import ReviewSerializer


class IndexView(ListCreateAPIView):
    serializer_class = ReviewSerializer

    def get_queryset(self):
        return Review.objects.order_by()


class DetailsView(RetrieveUpdateDestroyAPIView):
    serializer_class = ReviewSerializer

    def get_object(self):
        return get_object_or_404(Review.objects.all(), id=self.kwargs['id'])
