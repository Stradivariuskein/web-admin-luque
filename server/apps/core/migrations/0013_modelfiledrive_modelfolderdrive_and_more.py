# Generated by Django 4.2.5 on 2023-10-19 12:36

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0012_rename_filrid_modellistdrive_parentmaid_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='ModelFileDrive',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(default='', max_length=300)),
                ('driveId', models.CharField(max_length=50)),
                ('listXlsxID', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='core.modellistxlsx')),
            ],
        ),
        migrations.CreateModel(
            name='ModelFolderDrive',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('driveId', models.CharField(max_length=50)),
                ('name', models.CharField(default='', max_length=300)),
            ],
        ),
        migrations.DeleteModel(
            name='ModelListDrive',
        ),
        migrations.AddField(
            model_name='modelfiledrive',
            name='parentMaId',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='parent_ma_id_files', to='core.modelfolderdrive'),
        ),
        migrations.AddField(
            model_name='modelfiledrive',
            name='parentMiId',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='parent_mi_id_files', to='core.modelfolderdrive'),
        ),
        migrations.AddField(
            model_name='modelfiledrive',
            name='parentOrderMaId',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='parent_order_ma_id_files', to='core.modelfolderdrive'),
        ),
        migrations.AddField(
            model_name='modelfiledrive',
            name='parentOrderMiId',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='parent_order_mi_id_files', to='core.modelfolderdrive'),
        ),
    ]
