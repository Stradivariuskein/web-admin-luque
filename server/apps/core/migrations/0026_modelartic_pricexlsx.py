# Generated by Django 4.2.5 on 2023-12-12 17:53

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0025_alter_modeltouploaddrive_filedrive'),
    ]

    operations = [
        migrations.AddField(
            model_name='modelartic',
            name='priceXlsx',
            field=models.BooleanField(default=True),
        ),
    ]
