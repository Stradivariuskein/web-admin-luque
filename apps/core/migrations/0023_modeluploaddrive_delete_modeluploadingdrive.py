# Generated by Django 4.2.5 on 2023-11-24 19:13

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0022_modelartic_active'),
    ]

    operations = [
        migrations.CreateModel(
            name='ModelUploadDrive',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fileDrive', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='core.modelfolderdrive')),
            ],
        ),
        migrations.DeleteModel(
            name='ModelUploadingDrive',
        ),
    ]
