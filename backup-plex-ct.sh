#!/bin/bash

# stop plex container
docker-compose -f /home/lurch/code/docker/prod/homeserver.yml stop plex

# backup plex container locally
restic -p /docker/backup/pass.txt -r /docker/backup/plex-restic backup /docker/vols/plex

# start plex container
docker-compose -f /home/lurch/code/docker/prod/homeserver.yml start plex

# apply retention policy
restic -p /docker/backup/pass.txt -r /docker/backup/plex-restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 

# prune the unneeded snapshots
restic -p /docker/backup/pass.txt -r /docker/backup/plex-restic prune

# copy backup repo to nas
rsync -avz /docker/backup/plex-restic /mnt/nas/backups/restic/plex
