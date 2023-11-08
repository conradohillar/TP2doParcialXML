#!/bin/bash

curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o seasons.xml
