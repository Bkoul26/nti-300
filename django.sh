#!/bin/bash
# put this at the beginning of each of your scripts
# it will remove the centos7 repos, which are flakey right now
# and put in our (more stable) repositories.

for file in $( ls /etc/yum.repos.d/ ); do mv /etc/yum.repos.d/$file /etc/yum.repos.d/$file.bak; done


echo "[nti-310-epel]
name=NTI310 EPEL
baseurl=http://34.71.91.10/epel
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/local-repo.repo

echo "[nti-310-base]
name=NTI310 BASE
baseurl=http://34.71.91.10/base
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/local-repo.repo

echo "[nti-310-extras]
name=NTI310 EXTRAS
baseurl=http://34.71.91.10/extras/
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/local-repo.repo

echo "[nti-310-updates]
name=NTI310 UPDATES
baseurl=http://34.71.91.10/updates/
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/local-repo.repo
yum -y install python-pip   
pip install virtualenv  
pip install --upgrade pip       
mkdir ~/newproject    
cd ~/newproject    
virtualenv newenv    
source newenv/bin/activate    
pip install django      
django-admin --version            
django-admin startproject newproject   
cd newproject/    
python manage.py migrate   
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@newproject.com','NTI300NTI300')" | python manage.py shell   
myip=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \[\'$myip\'\]/g" newproject/settings.py 
python manage.py runserver 0.0.0.0:8000
