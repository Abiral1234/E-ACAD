# Generated by Django 4.1 on 2022-10-21 03:31

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('authentication', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='user',
            name='address',
        ),
        migrations.RemoveField(
            model_name='user',
            name='fullname',
        ),
        migrations.RemoveField(
            model_name='user',
            name='phonenumber',
        ),
        migrations.RemoveField(
            model_name='user',
            name='profilepicture',
        ),
        migrations.AlterField(
            model_name='user',
            name='user_role',
            field=models.CharField(choices=[('user', 'user'), ('vendor', 'vendor'), ('superuser', 'superuser'), ('developer', 'developer'), ('teacher', 'teacher'), ('student', 'student')], default='student', max_length=50),
        ),
    ]
