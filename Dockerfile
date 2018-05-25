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
FROM openjdk:8

LABEL maintainer="Arthur Naseef <artnaseef@apache.org>"

EXPOSE 8181/tcp 8101/tcp

RUN useradd -d /opt/karaf -ms /bin/bash karaf
RUN apt-get update \
    && apt-get install -y wget \
    && rm -rf /vbar/lib/apt/lists/* \

USER karaf:karaf

# Install Karaf
COPY install.sh /tmp/install.sh

RUN /tmp/install.sh \
	&& rm -f /tmp/install.sh

USER karaf:karaf

WORKDIR /opt/karaf/apache-karaf
ENTRYPOINT ["/opt/karaf/apache-karaf/bin/karaf", "console"]
# ENTRYPOINT ["/bin/sh", "-c", "id; exec /opt/karaf/apache-karaf/bin/karaf console"]
