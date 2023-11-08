declare function local:year_month($date as xs:string) as xs:gYearMonth {
  xs:gYearMonth(xs:date($date))
};

(: If $file doesn't exists or is not valid xml return an error node, otherwise return the file :)
declare function local:doc_if_valid($file as xs:string) as node() {
  if (doc-available($file)) then
    doc($file)
  else
    <myRoot><error>Invalid file '{$file}'</error></myRoot>
};

declare function local:max_month_stats($vacc_records as node()+, $month as xs:gYearMonth) as node() {
  let $month_records := $vacc_records[local:year_month(./date) eq $month]
  let $max_people_vaccinated := max($month_records/people_vaccinated)
  let $max_total_vaccinations := max($month_records/total_vaccinations)
  let $max_people_fully_vaccinated := max($month_records/people_fully_vaccinated)
  let $max_total_boosters := max($month_records/total_boosters)
  return
    <record>
      <month>{$month}</month>
      {if ($max_people_vaccinated) then
        <max_people_vaccinated>{$max_people_vaccinated}</max_people_vaccinated>
      else ()}
      {if ($max_total_vaccinations) then
        <max_total_vaccinations>{$max_total_vaccinations}</max_total_vaccinations>
      else ()}
      {if ($max_people_fully_vaccinated) then
        <max_people_fully_vaccinated>{$max_people_fully_vaccinated}</max_people_fully_vaccinated>
      else ()}
      {if ($max_total_boosters) then
        <max_total_boosters>{$max_total_boosters}</max_total_boosters>
      else ()}
    </record>
};

declare variable $country as xs:string external;

let $timezone_info := local:doc_if_valid('./data/timezone_info.xml')

let $error :=
  if ($timezone_info/error) then
    $timezone_info
  else if ($timezone_info//message) then
    <myRoot><error>{$timezone_info//message/text()}</error></myRoot>
  else ()

return
<country_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="./data/country_data.xsd">
{
  let $body :=
  if ($error) then
    $error
  else
    let $vaccinations := local:doc_if_valid('./data/vaccinations.xml')
    return if ($vaccinations/error) then
      $vaccinations
    else
      let $vacc_records := $vaccinations//record[lower-case(./location/text()) = lower-case($country)]
      return
        if (not($vacc_records)) then
          <myRoot>
            <error>No country vaccination information found for '{$country}'</error> 
          </myRoot>
        else
          let $locations := local:doc_if_valid('./data/locations.xml')
          return if ($locations/error) then
            $locations
          else
            let $location_record := $locations//record[lower-case(./location/text()) = lower-case($country)]
            let $months := distinct-values($vacc_records/local:year_month(./date))

            let $monthly_records :=
              for $month in $months return local:max_month_stats($vacc_records, $month)

            return
            <myRoot>
                <location>
                  <country>{$country}</country>
                  {$timezone_info//timezone}
                  {$timezone_info//timezone_offset}
                  {$location_record/vaccines}
                  <source>
                    {$location_record/source_name}
                    {$location_record/source_website}
                  </source>
                </location>
                <statistics>
                  {$monthly_records}
                </statistics>
            </myRoot>

  return $body/*
}
</country_data>