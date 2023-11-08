(: If $file does not exist or is not valid xml return an error node, otherwise return the file :)
declare function local:doc_if_valid($file as xs:string) as node() {
  if (doc-available($file)) then
    doc($file)
  else
    <myRoot><error>Invalid file '{$file}'</error></myRoot>
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
    return element player {
        <name>{($xml//player[@id = $player])[1]/@name/string()[1]}</name>,
        <type>{($xml//player[@id = $player])[1]/@type/string()[1]}</type>,
        <date_of_birth>{($xml//player[@id = $player])[1]/@date_of_birth/string()[1]}</date_of_birth>,
        <nationality>{($xml//player[@id = $player])[1]/@nationality/string()[1]}</nationality>,
        <events_played>{count($xml//player[@id = $xml//player[@id = $player][1]/@id and @played = "true"])}</events_played>    
    }
};


declare function local:competitor_lineup_getter($xml as document-node(), $competitors as element()*) as element()* {
    for $competitor in $competitors
    return element competitor {
        attribute id {$competitor/@id},
        <name>{$competitor/@name/string()}</name>,
        <players>{local:player_getter($xml, $competitor)}</players>
    }
};

let $info := local:doc_if_valid("season_info.xml")
let $lineups := local:doc_if_valid("season_lineups.xml")
let $competitors := local:stage_getter($info)//competitor

return
            <seasonData>
                <season>
                    <competition>
                        <name>{$info//season/competition/@name/string()}</name>
                        <gender>{$info//season/competition/@gender/string()}</gender>
                    </competition>
                    <name>{$info//season/@name/string()}</name>
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
            </seasonData>