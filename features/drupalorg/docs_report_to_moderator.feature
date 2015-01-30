@docs
Feature: Use the "report to moderator" to file a documentation issue
  In order to report a problem with documentation to the page moderator
  As a Confirmed User
  I want to report an issue from the page itself

  Scenario: See the link to report a documentation page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    When I visit "/documentation/multilingual"
    Then I should see the link "Report to moderator"

  Scenario: Report an issue page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    And I am on "/documentation/multilingual"
    When I follow "Report to moderator"
    Then I should see "Create issue"
    And I should see "Correction/Clarification" in the dropdown "Component"
    And the "Title" field should contain "Moderation report for Multilingual Guide"
    And I should see "I am reporting"

  Scenario: Report an issue with a documentation page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    And I am on "/documentation/multilingual"
    When I follow "Report to moderator"
    And I fill in "Issue summary" with random text
    And I select "Task" from "Category"
    And press "Save"
    Then I should see "has been created"

  @anon
  Scenario: Anonymous users should not be able to report a documentation issue
    Given I am not logged in
    When I am on "/documentation/multilingual"
    Then I should see the link "Log in to edit this page"
    And I should not see the link "Report to moderator"
