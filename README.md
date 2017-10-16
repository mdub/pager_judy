# REA Group PagerDuty account 	[![Build status](https://badge.buildkite.com/94204ed8f1b5430f74385e4342653a78b5f1eb4d1864055b4e.svg)](https://buildkite.com/rea/cowbell-slash-pagerjudy)
GDE make PagerDuty duty less painful

## Why?

We want to move to a shared REA-group PagerDuty account
- visibility of incidents and system health
- negotiating power
- opportunity for consistency

A few problems with the way GDE manage our stuff in PagerDuty now
- config-as-clicks
- difficult to understand the imapct of changes
- the Nobody user costs us a seat
- public holidays are painful

A few additional problems with the way REA teams manage their stuff in PagerDuty now:
- cases of one PD service being used for dozens of systems: can't downtime or divert a system's alerts
- inconsistencies in naming and structure make it hard to move between teams or apply improvements widely

## Proposal:
- Wrap the PagerDuty API in scripts/a tool that can apply service, escalation policy and list of people on a schedule
- Specify our existing PagerDuty config as code
- Brainstorm how we would like to struture our services and escalation policies in PagerDuty. The PD docs have some recommendations and our PD customer success manager Hailey is happy to discuss our options
- Update our PD config as code
- Deploy our PD config-as-code into the new PD account (maybe only systems without AH support at first)
  - Will require new Slack integrations and redeploying our apps with new PD endpoints
- Remove our systems from the rea-cobra PD account

## Next steps:
  - Assist Luke Harris and Sean Waller to adopt this for Data Services. Splitting out to PD service per system for them will require some effort.
  - Programattically generate the schedule (PSW are doing this already)
  - Update/replace the pagerduty Slack bot

## Unknowns:
  - When should we migrate our AH supported things?
  - How are we going to structure the AH pager pools? Luke proposed cross-escalation with AAP a while back but most of their teams is now part of Data Services. Need to re-evaluate options.
  - Luke Harris would like slack notifications for systems with AH support to go into both team and ah-alerts channels. Not sure how we'd do that yet.

## References
- [New rea-group PagerDuty account](rea-group.pagerduty.com)
- [Old rea-cobra PagerDuty account](rea-cobra.pagerduty.com)
- Somewhat out of date explanation of [how the GDE pager works](https://community.rea-group.com/docs/DOC-47301)
- [Some problems in the current DS/AAP/DE pager setup](https://community.rea-group.com/blogs/lukeck/2016/05/06/pager-setup-for-dsaapdelivery-eng)
- [Conventions for naming things in the new shared PD account](https://community.rea-group.com/docs/DOC-59788-rea-central-pagerduty-account-rules)
- [PSW's custodianator](https://git.realestate.com.au/cobra-psw/custodianator)
- [REA's PagerDuty vendor repo](https://git.realestate.com.au/vendor/pagerduty)
- [PagerDuty API docs](https://v2.developer.pagerduty.com/)
- [PagerDuty docs](https://support.pagerduty.com/v1/docs/)
- [PagerDuty account migration checklist](https://docs.google.com/document/d/1Xnm9ikm9kyTXlFyqP8vzgatlJ4g8iRYrNtWAcFyaCUo/edit?usp=sharing)
