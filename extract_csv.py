#!/usr/bin/env python

import os, sys
import json
import csv

user = sys.argv[1]
pages = int(sys.argv[2])

headers = "id,name,url,duration,created_at,modified_at,privacy_view,privacy_embed,nb_likes,nb_comments,thumbnail,download_link"

videos = []

for i in range(1, pages + 1):
    with open("page-%s.json" % i) as f:
        page = json.load(f)
    for video in page["data"]:
        video = video["video"]
        videos.append({
            "id": video["uri"].replace('/videos/', ''),
            "name": video["name"],
            "url": video["link"],
            "duration": video["duration"],
            "created_at": video["created_time"],
            "modified_at": video["last_user_action_event_date"],
            "privacy_view": video["privacy"]["view"],
            "privacy_embed": video["privacy"]["embed"],
            "nb_likes": video["metadata"]["connections"]["likes"]["total"],
            "nb_comments": video["metadata"]["connections"]["comments"]["total"],
            "thumbnail": video["pictures"]["sizes"][1]["link"],
            "download_link": video["file_transfer"]["link"]
        })

with open("vimeo-catalog-%s.csv" % user, "w") as f:
    writer = csv.DictWriter(f, fieldnames=headers.split(","))
    writer.writeheader()
    writer.writerows(videos)
