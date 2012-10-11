@docs @javascript
Feature: Provides audience information for documentation in About this page block
  In order to make sure that the documentation is specific to different skillsets
  As a document manager
  I want to specify the audience for a documentation page

  Background:
   Given I am logged in as "docs manager" 
   And I am on "/documentation/administer"

  Scenario: Change the audience on a documentation page to Programmers
    When I follow "Edit"
    And I select "Programmers" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Programmers"

  Scenario: Change the audience on a documentation page to Contributors
    When I follow "Edit"
    And I select "Contributors" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Contributors"

  Scenario: Change the audience on a documentation page to Site builders
    When I follow "Edit"
    And I select "Site builders" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Site builders"

  Scenario: Change the audience on a documentation page to Site users
    When I follow "Edit"
    And I select "Site users" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Site users"

  Scenario: Change the audience on a documentation page to Designers/themers
    When I follow "Edit"
    And I select "Designers/themers" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Designers/themers"

  Scenario: Change the audience on a documentation page to Site administrators
    When I follow "Edit"
    And I select "Site administrators" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Site administrators"
