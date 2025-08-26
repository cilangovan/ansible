#!/bin/sh
#
#  PENTAHO CORPORATION PROPRIETARY AND CONFIDENTIAL
# 
#  Copyright 2002 - 2014 Pentaho Corporation (Pentaho). All rights reserved.
# 
#  NOTICE: All information including source code contained herein is, and
#  remains the sole property of Pentaho and its licensors. The intellectual
#  and technical concepts contained herein are proprietary and confidential
#  to, and are trade secrets of Pentaho and may be covered by U.S. and foreign
#  patents, or patents in process, and are protected by trade secret and
#  copyright laws. The receipt or possession of this source code and/or related
#  information does not convey or imply any rights to reproduce, disclose or
#  distribute its contents, or to manufacture, use, or sell anything that it
#  may describe, in whole or in part. Any reproduction, modification, distribution,
#  or public display of this information without the express written authorization
#  from Pentaho is strictly prohibited and in violation of applicable laws and
#  international treaties. Access to the source code contained herein is strictly
#  prohibited to anyone except those individuals and entities who have executed
#  confidentiality and non-disclosure agreements or other agreements with Pentaho,
#  explicitly covering such access.
# 
### ====================================================================== ###
##                                                                          ##
##  Pentaho Start Script                                                    ##
##                                                                          ##
### ====================================================================== ###

DIR_REL=`dirname $0`
cd $DIR_REL
DIR=`pwd`
#cd -

. "$DIR/set-pentaho-env.sh"

setPentahoEnv "$DIR/jre"

### =========================================================== ###
## Set a variable for DI_HOME (to be used as a system property)  ##
## The plugin loading system for kettle needs this set to know   ##
## where to load the plugins from                                ##
### =========================================================== ###
DI_HOME="$DIR/pentaho-solutions/system/kettle"

if [ -f "$DIR/promptuser.sh" ]; then
  sh "$DIR/promptuser.sh"
  rm "$DIR/promptuser.sh"
fi
if [ "$?" = 0 ]; then
  cd "$DIR/tomcat/bin"
  CATALINA_OPTS="-Xms{{bi_server_xms}} -Xmx{{bi_server_xmx}} -XX:MaxPermSize=256m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Dfile.encoding=utf8 -DDI_HOME=\"$DI_HOME\""
  export CATALINA_OPTS

# START PENTAHO LICENSE
  if [ -n "$PENTAHO_INSTALLED_LICENSE_PATH" ]; then
       export CATALINA_OPTS="$CATALINA_OPTS -Dpentaho.installed.licenses.file=$PENTAHO_INSTALLED_LICENSE_PATH"
  fi
# END PENTAHO LICENSE
  JAVA_HOME=$_PENTAHO_JAVA_HOME
  sh startup.sh
fi
