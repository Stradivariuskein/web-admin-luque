# Generated by Django 4.2.5 on 2023-09-28 16:53

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0003_delete_modelo_test_alter_listxlsx_moddate_and_more'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='Artic',
            new_name='ModelArtic',
        ),
        migrations.RenameModel(
            old_name='ListDrive',
            new_name='ModelListDrive',
        ),
        migrations.RenameModel(
            old_name='ListXlsx',
            new_name='ModelListXlsx',
        ),
    ]
