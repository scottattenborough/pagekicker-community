#!/bin/bash

# configuration file
#  all these values in this block must be customized 
MACHINE_NAME="Fred's Personal PageKicker Box"
TMPDIR="/tmp/pagekicker/"
SFB_HOME="/home/fred/pagekicker-community/"
LOCAL_DATA="$SFB_HOME"local-data/
SFB_MAGENTO_HOME="/home/fred/bin/magento-1.9.2.4-1/apps/magento/htdocs/"
SFB_PHP_BIN="/usr/bin/php"
JAVA_BIN="/usr/bin/java"
PYTHON_BIN="/usr/bin/python"
PANDOC_BIN="/usr/bin/pandoc"
SFB_VERSION=`git rev-parse HEAD` #replace with git command that produces unique identifier
environment="development" # each environment is assumed to have a separate working tree
COMMUNITY_GITHUB_REPO="https://github.com/fredzannarbor/pagekicker-community"
MY_GITHUB_REPO="https://github.com/fredzannarbor/pagekicker-community"
google_form="http://goo.gl/forms/ur1Otr1G2q" #Google feedback form used in delivery email

USER_HOME="/home/$USER/"
LOCAL_USER="fred"
WEB_HOST="http://127.0.0.1/"
WEB_ROOT="/home/fred/bin/magento-1.9.2.4-1/apache2/htdocs$""pk-html/" # place where html files generated by PK for users are stored
WEB_SCRIPTPATH="scripts/" 
APACHE_ROOT="/home/fred/bin/magento-1.9.2.4-1/apache2/htdocs$"
LOCAL_MYSQL_PATH="/opt/bitnami/mysql/bin/mysql"
LOCAL_MYSQL_USER="root"
LOCAL_MYSQL_PASSWORD="$PASSWORD"
metadatatargetpath=$SFB_MAGENTO_HOME"var/import/" # these all follow Magento file structure
mediatargetpath=$SFB_MAGENTO_HOME"media/import/"
mediaarchivetxt=$SFB_MAGENTO_HOME"media/archive/txt/"
scriptpath=$SFB_HOME"scripts/" # all PK programs run from $scriptpath unless special circumstances require
confdir=$SFB_HOME"conf/"
textpath=$SFB_HOME"txt/"
imagedir="images/"
logdir=$LOCAL_DATA"logs/uuids/"
confdir="$SFB_HOME"conf/
sfb_log=$logdir"sfb_log.txt"
xformlog=$logdir$uuid"/xformlog.txt"
todaysarchivefolder=$(date +"%Y%m%d")
sfb_log_archive=$LOCAL_DATA"archives/sfb_log_archive.txt"
GMAIL_ID="fred@pagekicker.com"
GMAIL_PASSWORD="@Lm5kqxNEQy7"

