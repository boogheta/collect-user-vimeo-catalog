#!/bin/bash

source config.sh

HEADERS="-H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/99.0' -H 'Accept: application/vnd.vimeo.*+json;version=3.4.1' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Accept-Encoding: gzip, deflate, br' -H 'Referer: https://vimeo.com/' -H 'Authorization: jwt $AUTHORIZATION_KEY' -H 'Content-Type: application/json' -H 'Origin: https://vimeo.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-site' -H 'Pragma: no-cache' -H 'Cache-Control: no-cach'"

TIMESTAMP=$(date +%s)

seq $TOTALPAGES | while read PAGE; do
  if [ ! -s page-$PAGE.json ]; then
    echo "collecting page $PAGE for user $USER_ID"
    curl "https://api.vimeo.com/users/$USER_ID/folders/root?fields=folder.created_time%2Cfolder.metadata%2Cfolder.modified_time%2Cfolder.name%2Cfolder.privacy%2Cfolder.is_private_to_user%2Cfolder.slack_incoming_webhooks_id%2Cfolder.slack_user_preferences%2Cfolder.slack_language_preference%2Cfolder.slack_integration_channel%2Cfolder.resource_key%2Cfolder.uri%2Cfolder.user.uri%2Cfolder.access_grant.uri%2Cfolder.access_grant.permission_policy%2Cfolder.access_grant.folder%2Cfolder.last_user_action_event_date%2Cvideo.created_time%2Cvideo.release_time%2Cvideo.duration%2Cvideo.file_transfer%2Cvideo.link%2Cvideo.player_embed_url%2Cvideo.last_user_action_event_date%2Cvideo.name%2Cvideo.pictures.uri%2Cvideo.pictures.sizes%2Cvideo.privacy%2Cvideo.review_page%2Cvideo.transcode%2Cvideo.uri%2Cvideo.edit_session%2Cvideo.disabled_properties%2Cvideo.parent_project%2Cvideo.metadata.connections.albums%2Cvideo.metadata.connections.available_albums%2Cvideo.metadata.connections.available_channels%2Cvideo.metadata.connections.comments%2Cvideo.metadata.connections.credits%2Cvideo.metadata.connections.likes%2Cvideo.metadata.connections.notes%2Cvideo.metadata.connections.pictures%2Cvideo.metadata.connections.publish_to_social%2Cvideo.metadata.connections.recommendations%2Cvideo.metadata.connections.related%2Cvideo.metadata.connections.texttracks%2Cvideo.metadata.connections.versions%2Cvideo.metadata.interactions.can_update_privacy_to_public%2Cvideo.metadata.interactions.has_restricted_privacy_options%2Cvideo.metadata.interactions.delete%2Cvideo.metadata.interactions.edit%2Cvideo.metadata.interactions.edit_content_rating%2Cvideo.metadata.interactions.edit_privacy%2Cvideo.metadata.interactions.report%2Cvideo.metadata.interactions.view_team_members%2Cvideo.metadata.interactions.watchlater%2Cvideo.metadata.interactions.create_editor%2Clive_event.pictures.sizes%2Clive_event.pictures.uri%2Clive_event.uri%2Clive_event.title%2Clive_event.link%2Clive_event.created_time%2Clive_event.embed.html%2Clive_event.embed.responsive_html%2Clive_event.embed.chat_embed_code%2Clive_event.stream_privacy%2Clive_event.type%2Clive_event.metadata.interactions%2Clive_event.from_webinar%2Clive_event.webinar%2Clive_event.user.uri%2Ctype&per_page=$VIDEOS_BY_PAGE&offset=0&t=$TIMESTAMP&direction=DESC&sort=alphabetical&page="$PAGE $HEADERS > page-$PAGE.json
  fi
done

./extract_csv.py $USER_ID $TOTALPAGES
