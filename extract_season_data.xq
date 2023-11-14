(: If $file does not exist or is not valid xml return an error node, otherwise return the file :)
declare function local:doc_if_valid($file as xs:string) as node() {
  if (doc-available($file)) then
    doc($file)
  else
    <season_data><error>Invalid file '{$file}'</error></season_data>
};  

declare function local:competitor_getter($group as element()*) as element()* {
    for $competitor in $group//competitor
    return element competitor {
        attribute id {$competitor/@id},
        <name>{$competitor/@name/string()}</name>,
        <abbreviation>{$competitor/@abbreviation/string()}</abbreviation>
    }
};

declare function local:group_getter($stage as element()) as element()* {
    for $group in $stage//group
    return
    <group>{local:competitor_getter($group)}</group>
};

declare function local:stage_getter($xml as document-node()) as element()* {
  for $stage in $xml//stage
    return element stage {
        attribute start_date {$stage/@start_date},
        attribute end_date {$stage/@end_date},
        attribute phase {$stage/@phase},
        <groups>{local:group_getter($stage)}</groups>
    }      
};

declare function local:player_getter($xml as document-node(), $competitor as element()*) as element()* {
    let $players := $xml//competitor[@id=$competitor/@id]//player/@id
    for $player in distinct-values($players)
    let $p := ($xml//player[@id = $player])[1]
    return element player {
        <name>{$p/@name/string()}</name>,
        <type>{$p/@type/string()}</type>,
        <date_of_birth>{$p/@date_of_birth/string()}</date_of_birth>,
        <nationality>{$p/@nationality/string()}</nationality>,
        <events_played>{count($xml//player[@id = $xml//player[@id = $player][1]/@id and @played = "true" and ../../@id=$competitor/@id])}</events_played>    
    }
};

declare function local:competitor_lineup_getter($xml as document-node(), $competitors as element()*) as element()* {
    let $competitorids := $xml//competitor[@id=$competitors/@id]/@id
    for $uniquecompetitor in distinct-values($competitorids)
    let $competitor := ($xml//competitor[@id=$uniquecompetitor])[1]
    return element competitor {
        attribute id {$competitor/@id},
        <name>{$competitor/@name/string()}</name>,
        <players>{local:player_getter($xml, $competitor)}</players>
    }
};

declare variable $season_prefix as xs:string external;
declare variable $season_year as xs:string external;

let $info := local:doc_if_valid("season_info.xml")
let $lineups := local:doc_if_valid("season_lineups.xml")
let $competitors := local:stage_getter($info)//competitor

return
if (not(normalize-space($season_year))) then
<season_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="./data/season_data.xsd"> 
    <error>Year cannot be an empty string</error>
</season_data>
else if (not($season_year castable as xs:integer)) then
<season_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="./data/season_data.xsd"> 
    <error>Year must be integer number</error>
</season_data>
else if (not(normalize-space($season_prefix))) then
<season_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="./data/season_data.xsd"> 
    <error>Name cannot be an empty string</error>
</season_data>
else if ($info//page_not_found/@message = "Wrong identifier") then
<season_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="./data/season_data.xsd"> 
    <error>Season with requested ID does not exist (Internal API error)</error>
</season_data>
else if ($info//page_not_found/@message = "Invalid route.") then
<season_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="./data/season_data.xsd"> 
    <error>Season (ID) with requested parameters was not found</error>
</season_data>
else if ($info//h1/text() = "Developer Inactive") then
<season_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="./data/season_data.xsd"> 
    <error>API key is not valid. Developer is inactive.</error>
</season_data>
else
<season_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="./data/season_data.xsd"> 
    <season>
        <name>{$info//season/@name/string()}</name>
        <competition>
            <name>{$info//season/competition/@name/string()}</name>
            <gender>{$info//season/competition/@gender/string()}</gender>
        </competition>
        <date>
            <start>{$info//season/@start_date/string()}</start>
            <end>{$info//season/@end_date/string()}</end>
            <year>{$info//season/@year/string()}</year>
        </date>
    </season>  
    <stages>
        {local:stage_getter($info)}
    </stages>
    <competitors>
        {local:competitor_lineup_getter($lineups, $competitors)}
    </competitors>               
</season_data>