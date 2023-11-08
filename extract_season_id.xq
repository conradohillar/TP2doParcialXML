declare variable $season_prefix as xs:string external;
declare variable $season_year as xs:string external;

data(doc("seasons.xml")//season[starts-with(@name, $season_prefix) and (@year = $season_year)][1]/@id)