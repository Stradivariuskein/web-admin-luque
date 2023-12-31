# Generated by Django 4.2.5 on 2023-10-18 19:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0011_modeltoupdatelist'),
    ]

    operations = [
        migrations.RenameField(
            model_name='modellistdrive',
            old_name='filrId',
            new_name='parentMaId',
        ),
        migrations.RenameField(
            model_name='modellistdrive',
            old_name='parenId',
            new_name='parentMiId',
        ),
        migrations.AddField(
            model_name='modellistdrive',
            name='parentOrderMaId',
            field=models.CharField(default=None, max_length=50, null=True),
        ),
        migrations.AddField(
            model_name='modellistdrive',
            name='parentOrderMiId',
            field=models.CharField(default=None, max_length=50, null=True),
        ),
    ]
