#!/bin/bash

export API_KEY="2f9npdypfkpd8e7thcjnssd5"
delay=1.1

# Validate argument number
if [ $# -ne 2 ]; then
  echo "Invalid argument number. Arguments must be Prefix - Year".
  exit 1
fi

echo "Processing league: $1 $2"


# Download seasons.xml from API
curl -s http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o seasons.xml 
sleep $delay
# Delete namespace from seasons.xml
sed -i'' -e 's@xmlns="http://schemas.sportradar.com/sportsapi/rugby-league/v3"@@g' seasons.xml
sed -i'' -e 's@xsi:schemaLocation="http://schemas.sportradar.com/sportsapi/rugby-league/v3 https://schemas.sportradar.com/sportsapi/rugby-league/v3/schemas/seasons.xsd"@@g' seasons.xml

echo "Downloaded seasons.xml"


# Get season_id from seasons.xml with xQuery
season_id=`java net.sf.saxon.Query -q:extract_season_id.xq season_prefix=$1 season_year=$2 | cut -d ">" -f 2`
echo "Selected season with id ${season_id}"
# Download season_info.xml
curl -s http://api.sportradar.us/rugby-league/trial/v3/en/seasons/${season_id}/info.xml?api_key=${API_KEY} -o season_info.xml
sleep $delay

echo "Downloaded season_info.xml"


# Download season_lineups.xml
curl -s http://api.sportradar.us/rugby-league/trial/v3/en/seasons/${season_id}/info.xml?api_key=${API_KEY} -o season_lineups.xml
sleep $delay

echo "Downloaded season_lineups.xml"