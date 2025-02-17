# Generated by Django 5.0.1 on 2024-01-03 10:39

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Review',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('bTitle', models.CharField(max_length=200)),
                ('bAuthor', models.CharField(max_length=200)),
                ('description', models.TextField()),
                ('experiences', models.TextField()),
                ('pros', models.TextField()),
                ('cons', models.TextField()),
                ('rating', models.FloatField()),
            ],
        ),
    ]
