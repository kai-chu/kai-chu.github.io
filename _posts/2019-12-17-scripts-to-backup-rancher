---
layout: post
title:  "Scripts to backup your rancher container"
date:   2019-09-20 18:28:39 +0200
categories: rancher cloud
---
Following [rancher official website](https://rancher.com/docs/rancher/v2.x/en/backups/backups/single-node-backups/
),I have created a script to backup. It will stop rancher, backup with busy_box to current working dir and then restart the container again.
```
$./backup_rancher.sh rancher/rancher:v2.3.2
```
The parameter rancher/rancher:v2.3.2 is depending on value on the field of IMAGE in your $docker ps 
```
$ docker ps
CONTAINER ID        IMAGE                    COMMAND            ...
b9ad26b8ece5        rancher/rancher:v2.3.2   "entrypoint.sh"    ...
```

// backup_rancher.sh
```
#!/bin/bash 
set -u
set -e 

function backup() {
  rancher_image=$1
  rancher_container_name=$2
  rancher_container_tag=$3
  rancher_backup_date="$(date '+%Y-%m-%d-%H-%M-%S')"

  rancher_backup_container_name="rancher-data-$rancher_backup_date"
  rancher_backup_filename="rancher-data-backup-$rancher_container_tag-$rancher_backup_date.tar.gz"

  echo "...Stoping target rancher container $rancher_container_name"
  docker stop "$rancher_container_name"
  
  echo "...Creating util container and starting backup"
  docker create --volumes-from "$rancher_container_name" --name "$rancher_backup_container_name" "$rancher_image"
  docker run --volumes-from "$rancher_backup_container_name" -v "/$PWD"://backup:z "$docker_repository/busybox" tar zcvf //backup/$rancher_backup_filename //var/lib/rancher
  
  echo "...Removing backup util container $rancher_backup_container_name"
  docker rm -f "$rancher_backup_container_name" 
  
  echo "...Restarting target rancher container $rancher_container_name"
  docker start "$rancher_container_name"
}

function main() {
  ancestor_filter=$1
  
  for rancher in $(docker ps --filter status=running --filter ancestor=$ancestor_filter --format '{{.Image}}|{{.Names}}') 
  do
    echo "Found running rancher container $rancher"
    IFS='|' read -ra rancherArr <<< $rancher
    IFS=' ' 
    docker_image="${rancherArr[0]}"
    docker_names="${rancherArr[1]}"
    
    echo "...Resolving docker image tag from $docker_image"
    docker_image_tag='latest'
    docker_image_repository="${docker_image}"
    if [[ "${docker_image}" =~ ^(.*):(.*) ]] 
    then 
      docker_image_repository="${BASH_REMATCH[1]}"
      docker_image_tag="${BASH_REMATCH[2]}"
      echo "Resolved image repository: $docker_image_repository, tag: $docker_image_tag"
    else 
      echo "No match tag found, use default tag $docker_image_tag"
    fi
    backup $docker_image $docker_names $docker_image_tag
  done
}


# Change to your proxy registry if you are behind a proxy
docker_repository="ivy.sth.shb.se/docker-shb"

main "$@"
```
