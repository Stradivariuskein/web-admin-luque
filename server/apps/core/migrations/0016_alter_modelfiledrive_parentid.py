# Generated by Django 4.2.5 on 2023-10-19 13:33

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0015_alter_modelfolderdrive_parentid'),
    ]

    operations = [
        migrations.AlterField(
            model_name='modelfiledrive',
            name='parentId',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='core.modelfolderdrive'),
        ),
    ]
