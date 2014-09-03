#! /bin/bash
#
# Copyright(C) 2013 - 2014, Developed by KPISOFT PTE. LTD. All rights reserved.
# This file is part of EPM Parent.
# 
# The intellectual and technical concepts contained herein may be covered 
# by patents, patents in process, and are protected by trade secret or 
# copyright law. Any unauthorized use of this code without prior approval 
# from KPISOFT PTE. LTD. is prohibited.
#

export M2_HOME=/opt/apache-maven-3.0.5
export M2=$M2_HOME/bin
PATH=$M2:$PATH
echo "INT 214 Automated Build"

JBoss="/opt/jboss7"
Tomcat="/opt/m1dev"
WorkingCopy="/opt/epm"

echo "Getting latest update from SVN repository"
cd $WorkingCopy
echo `pwd`
svn update
echo "*** SVN sync completed ***"

echo "Maven clean and Compile"
mvn clean install -DskipTests=true

echo "Stop Tomcat"
#Check whether they are already stooped
"$Tomcat"/bin/single_shutdown.sh

echo "Stopping Jboss"
#"$JBoss"/bin/jboss-cli.sh --connect controller="$IP":"$port" command=:shutdown  
cd "$JBoss"/bin/
./single_shutdown.sh

echo "Clean up JBoss deployments"
cd "$JBoss"/standalone/deployments/
#rm -fr *
rm "$JBoss"/standalone/deployments/ums-service.ear
rm "$JBoss"/standalone/deployments/ums-service.ear.deployed
rm -rf "$JBoss"/standalone/tmp
echo "***JBoss deployments Clean up completed**"

echo "Copy ear in JBoss deployments"
cp "$WorkingCopy"/middleware/ums/ums-service/target/ums-service.ear  "$JBoss"/standalone/deployments/
rm -rf "$JBoss"/standalone/deployments/activemq.rar.deployed
touch "$JBoss"/standalone/deployments/activemq.rar.dodeploy
echo "Clean up Tomcat Webapps"
cd "$Tomcat"/webapps
rm -rf epm-*
rm -rf "$TOMCAT"/work/Catalina/localhost/epm-ui
echo "***Tomcat Clean up completed**"

echo "Copy ear in Tomcat Webapps"
cp "$WorkingCopy"/webapp/epm-ui/target/epm-ui.war "$Tomcat"/webapps

echo "Starting Tomcat"
#"$Tomcat"/bin/startup.sh
"$Tomcat"/bin/single_startup.sh

echo "Starting Jboss"
#"$JBoss"/bin/standalone.sh
cd "$JBoss"/bin/
./single_startup.sh
echo "********Done***********"
