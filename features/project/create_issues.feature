Feature: Drupal Create Issues
  In order to get help contributing code 
  As an site user
  I want create an issue

  Scenario: Create an issue by following a project sidebar link
    Given I am logged in as "site user"
    And I am on "/project/issues"
    When I follow "Create a new issue"
    And I select "Achievements" from "Project"
    And I press "Next"
    And I select the following <fields> with <values>
    | fields | values |
    | Version | 7.x-1.4 |
    | Component | Code |
    | Category | task |
    | Priority | normal |
    | Assigned | site user |
    | Status | needs work |
    And I fill in "Title" with random text
    And I fill in "Description" with random text
    And I attach the file "koala.jpg" to "Attach new file"
    And I press "Save"
    Then I should see "has been created" 
