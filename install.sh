#!/bin/bash
################################################################################
#  Copyright 2018 Arthur Naseef
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
################################################################################

set -e
set -x

KARAF_VERSION="4.0.6"
MAVEN_CENTRAL_BASE_URL="http://central.maven.org/maven2"
MAVEN_KARAF_BASE_URL="${MAVEN_CENTRAL_BASE_URL}/org/apache/karaf/apache-karaf"

KARAF_PKG_FILENAME="apache-karaf-${KARAF_VERSION}.tar.gz"
KARAF_URL="${MAVEN_KARAF_BASE_URL}/${KARAF_VERSION}/${KARAF_PKG_FILENAME}"

KARAF_ROOTDIR_NAME="apache-karaf-${KARAF_VERSION}"

LOGGING_CONFIG_FILE_PATH="/opt/karaf/apache-karaf/etc/org.ops4j.pax.logging.cfg"


###
### MAIN BODY STARTS HERE
###

cd /opt/karaf
wget -O "${KARAF_PKG_FILENAME}" "${KARAF_URL}"

tar xvf "${KARAF_PKG_FILENAME}"
ln -s "${KARAF_ROOTDIR_NAME}" apache-karaf
chown karaf:karaf -R "${KARAF_ROOTDIR_NAME}"

rm "${KARAF_PKG_FILENAME}"

cat >"${LOGGING_CONFIG_FILE_PATH}" <<-"!"
	# Root logger
	log4j.rootLogger=INFO, out, stdout, osgi:*
	log4j.throwableRenderer=org.apache.log4j.OsgiThrowableRenderer

	# Security audit logger
	log4j.logger.org.apache.karaf.jaas.modules.audit=INFO, audit
	log4j.additivity.org.apache.karaf.jaas.modules.audit=false

	# CONSOLE appender not used by default
	log4j.appender.stdout=org.apache.log4j.ConsoleAppender
	log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
	log4j.appender.stdout.layout.ConversionPattern=%d{ISO8601} | %-5.5p | %t | %c | %X{bundle.id} - %X{bundle.name} - %X{bundle.version} | %m%n

	# File appender
	log4j.appender.out=org.apache.log4j.RollingFileAppender
	log4j.appender.out.layout=org.apache.log4j.PatternLayout
	log4j.appender.out.layout.ConversionPattern=%d{ISO8601} | %p | %t | %c | %X{bundle.id} - %X{bundle.name} - %X{bundle.version} | %m%n
	log4j.appender.out.file=${karaf.data}/log/karaf.log
	log4j.appender.out.append=true
	log4j.appender.out.maxFileSize=1MB
	log4j.appender.out.maxBackupIndex=10

	# Audit appender
	log4j.appender.audit=org.apache.log4j.RollingFileAppender
	log4j.appender.audit.layout=org.apache.log4j.PatternLayout
	log4j.appender.audit.layout.ConversionPattern=%d{ISO8601} | %p | %t | %c | %X{bundle.id} - %X{bundle.name} - %X{bundle.version} | %m%n
	log4j.appender.audit.file=${karaf.data}/security/audit.log
	log4j.appender.audit.append=true
	log4j.appender.audit.maxFileSize=1MB
	log4j.appender.audit.maxBackupIndex=10
!
