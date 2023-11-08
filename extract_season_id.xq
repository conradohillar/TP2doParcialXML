declare variable $prefix as xs:string external;
declare variable $year as xs:string external;

for $season in doc("seasons.xml")//season
where starts-with($season/@name, $prefix) and ($season/@year = $year)
return data($season/@id)