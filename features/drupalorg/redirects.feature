@other @anon
Feature: Redirect urls
  In order to experience a seamless transition to D7
  As any visitor
  I need to be redirected from D6 urls to D7 urls

  Scenario: Solr module search redirect
    When I visit "/project/modules"
    Then I should be on "/project/project_module"

  Scenario: Views module index
    When I visit "/project/modules/index"
    Then I should be on "/project/project_module/index"
