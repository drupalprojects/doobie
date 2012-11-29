@casestudies @slow @anon @wip
Feature: Case studies promotion
  In order to view promoted case studies
  As any user
  I should be able to see featured slidehows and a case study on the homepage

  Scenario: Cases studies slideshow
    Given I am on the homepage
    When I visit "/case-studies"
    Then I should see "4" recently published featured case studies in the slideshow

  @known_git7failure
  Scenario: Cases study block on front page
    Given I am on the homepage
    Then the case study should be one of the "10" recently published featured case studies
