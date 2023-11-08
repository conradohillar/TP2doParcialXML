#!/bin/bash

export API_KEY=2f9npdypfkpd8e7thcjnssd5

if [ $# -ne 2 ]; then
  echo "Invalid argument number. Arguments must be Prefix Year".
  exit 1
fi

curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o seasons.xml 
curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o season_info.xml
curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o season_lineups.xml
