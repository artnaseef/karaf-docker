# Karaf Docker Image
This docker image provides a vanilla Karaf installation.

# Base Image
`openjdk:8`

# User
`karaf` is the user that owns and runs the installation.

Home directory is `/opt/karaf`

# Directories
`/opt/karaf` home directory contains a subdirectory named based on the version of karaf: `/opt/karaf/apache-karaf-${version}`.  This is the karaf root directory (`KARAF_HOME` and `KARAF_BASE`).  For example, for version 4.0.6, the actual path is `/opt/karaf/apache-karaf-4.0.6`.

A symbolic link to the versioned directory exists at `/opt/karaf/apache-karaf`.

The `etc`, `deploy`, and other karaf folders all reside at their usual location under the karaf root directory.

# Example use
    docker pull artnaseef/karaf:4.0.6
    docker container create --name karaf -p 8101:8101 -p 8181:8181 artnaseef/karaf:4.0.6
    
    # Start the karaf container attaching the foreground to the karaf console
    docker start -a karaf
    
    # SSH into the karaf console
    ssh -o port=8101 -o User="karaf" -o CheckHostIP="no" -o StrictHostKeyChecking=false -o UserKnownHostsFile=/dev/null -o HostKeyAlgorithms=+ssh-dss localhost