{"id"=>"PA5SDL1",
  "name"=>"3rd party JS - Production - API",
  "description"=>
   "See here for details:\n" +
   "https://git.realestate.com.au/resi/third-party-js-dependencies-monitoring",
  "auto_resolve_timeout"=>nil,
  "acknowledgement_timeout"=>3600,
  "created_at"=>"2015-10-09T12:03:01+11:00",
  "status"=>"active",
  "last_incident_timestamp"=>"2017-08-09T10:04:21+10:00",
  "teams"=>
   [{"id"=>"P5994QA",
     "type"=>"team_reference",
     "summary"=>"PSW",
     "self"=>"https://api.pagerduty.com/teams/P5994QA",
     "html_url"=>"https://rea-cobra.pagerduty.com/teams/P5994QA"}],
  "incident_urgency_rule"=>
   {"type"=>"use_support_hours",
    "during_support_hours"=>{"type"=>"constant", "urgency"=>"high"},
    "outside_support_hours"=>{"type"=>"constant", "urgency"=>"low"}},
  "scheduled_actions"=>
   [{"type"=>"urgency_change",
     "at"=>{"type"=>"named_time", "name"=>"support_hours_start"},
     "to_urgency"=>"high"}],
  "support_hours"=>
   {"type"=>"fixed_time_per_day",
    "time_zone"=>"Australia/Melbourne",
    "days_of_week"=>[1, 2, 3, 4, 5],
    "start_time"=>"09:00:00",
    "end_time"=>"17:00:00"},
  "escalation_policy"=>
   {"id"=>"P3SRURE",
    "type"=>"escalation_policy_reference",
    "summary"=>"PSW",
    "self"=>"https://api.pagerduty.com/escalation_policies/P3SRURE",
    "html_url"=>"https://rea-cobra.pagerduty.com/escalation_policies/P3SRURE"},
  "addons"=>[],
  "privilege"=>nil,
  "alert_creation"=>"create_incidents",
  "integrations"=>
   [{"id"=>"PE8ZSDJ",
     "type"=>"generic_events_api_inbound_integration_reference",
     "summary"=>"Generic API",
     "self"=>"https://api.pagerduty.com/services/PA5SDL1/integrations/PE8ZSDJ",
     "html_url"=>"https://rea-cobra.pagerduty.com/services/PA5SDL1/integrations/PE8ZSDJ"}],
  "type"=>"service",
  "summary"=>"3rd party JS - Production - API",
  "self"=>"https://api.pagerduty.com/services/PA5SDL1",
  "html_url"=>"https://rea-cobra.pagerduty.com/services/PA5SDL1"}
