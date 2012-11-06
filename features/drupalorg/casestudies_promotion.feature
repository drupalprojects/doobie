@casestudies @slow @wip
Feature: Case studies promotion
  In order to show case studies on home page
  As a site administrator
  I need to be able to promote the case studies

  Scenario: Cases studies slideshow
    Given I am logged in as "site user"
    When I visit "/case-studies"
    Then I should see "4" recently published featured case studies in the slideshow

  @known_git6failure
  Scenario: Cases study block on front page
    Given I am logged in as "site user"
    When I follow "Drupal Homepage" 
    Then the case study should be one of the "10" recently published featured case studies
