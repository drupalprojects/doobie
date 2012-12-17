@changerecords @anon
Feature: Look for change record block in an issue
  In order to know that an issue resulted in a change to Drupal core
  As any user
  I should be able to see the block in the issue which leads to the change record

  Scenario: Visit the node and view link and text
    Given I am on "/node/1298642"
    When I follow "#520106: Allow setting the active menu trail for dynamically-generated menu paths."
    Then I should see "Change records for this issue"
    And I should see the link "New functions to dynamically set active trails"
