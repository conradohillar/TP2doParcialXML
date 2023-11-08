#!/bin/bash

# Validate argument number
if [ $# -ne 2 ]; then
  echo "Invalid argument number. Arguments must be Prefix - Year".
  exit 1
fi

echo "Processing league: $1 $2"

# Download seasons.xml from API
curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o seasons.xml 
# Delete namespace from seasons.xml
sed -i 's@xmlns="http://schemas.sportradar.com/sportsapi/rugby-league/v3"@@g' seasons.xml
sed -i 's@xsi:schemaLocation="http://schemas.sportradar.com/sportsapi/rugby-league/v3 https://schemas.sportradar.com/sportsapi/rugby-league/v3/schemas/seasons.xsd"@@g' seasons.xml

# Download season_info.xml
season_id=`java net.sf.saxon.Query -q:extract_season_id.xq prefix=$1 year=$2 | cut -d ">" -f 2`
curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons/${season_id}/info.xml?api_key=${API_KEY} -o season_info.xml
#curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o season_lineups.xml