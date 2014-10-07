@whitelist
Feature: Create new packaging whitelist entry
  In order to include an external library on the packaging whitelist
  As a packaging whitelist maintainer
  I need to add new entries

  Scenario: Create packaging whitelist entry: Authenticated user
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I am on "/node/add/packaging-whitelist"
    Then I should see the heading "Access denied"
    But I should not see "Create Packaging whitelist entry"

  Scenario: Create packaging whitelist entry as Admin user: Validation
    Given I am logged in as the "admin test"
    When I visit "/node/add/packaging-whitelist"
    And I press "Save"
    Then I should see "Title field is required"
    And the field "Title" should be outlined in red
    But I should not see "has been created"

  Scenario: Create packaging whitelist entry as Admin user
    Given I am logged in as the "admin test"
    When I visit "/node/add/packaging-whitelist"
    And I fill in "Title" with random text
    And I fill in "Allowed URL filters" with random text
    And I select "Clear BSD" from "License"
    And I press "Save"
    Then I should see the random "Title" text
    And I should see the random "Allowed URL filters" text
    And I should see "Posted by admin test on"
    And I should see the following <links>
      | links     |
      | View      |
      | Edit      |
      | Outline   |
      | Clear BSD |
