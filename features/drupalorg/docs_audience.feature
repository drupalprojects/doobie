@docs @javascript
Feature: Provides audience information for documentation on About this page
  In order to make sure that the documentation is specific to different skillsets
  As a document manager
  I want to specify the audience for a documentation page

  Background:
   Given I am logged in as "docs manager" 
   And I am on "/documentation/administer"

  Scenario: Change the audience on a documentation page to Developers and coders
    When I follow "Edit"
    And I select "Developers and coders" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Developers and coders"

  Scenario: Change the audience on a documentation page to Documentation contributors
    When I follow "Edit"
    And I select "Documentation contributors" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Documentation contributors"

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

  Scenario: Change the audience on a documentation page to Themers
    When I follow "Edit"
    And I select "Themers" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Themers"

  Scenario: Change the audience on a documentation page to Site administrators
    When I follow "Edit"
    And I select "Site administrators" from "Audience"
    And I fill in "Log message" with random text
    And I press "Save"
    Then I should see "Site administrators"
