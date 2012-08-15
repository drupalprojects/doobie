Feature: Drupal Create Issues
  In order to get help contributing code or using modules and themes
  As a site user
  I want create an issue

  Scenario: Create an issue from the main issues page
    Given I am logged in as "site user"
    And I am on "/project/issues"
    When I follow "Create a new issue"
    And I select "Achievements" from "Project"
    And I press "Next"
    And I select the following <fields> with <values>
    | fields    | values     |
    | Version   | 7.x-1.4    |
    | Component | Code       |
    | Category  | task       |
    | Priority  | normal     |
    | Assigned  | site user  |
    | Status    | needs work |
    And I fill in "Title" with random text
    And I fill in "Description" with random text
    And I attach the file "koala.jpg" to "Attach new file"
    And I press "Save"
    Then I should see "has been created"

  Scenario: Create an issue from a specific project's issue page
    Given I am logged in as "site user"
    And I am on "/project/issues/achievements"
    When I follow "Create a new issue"
    And I select "Achievements" from "Project"
    And I press "Next"
    And I select the following <fields> with <values>
    | fields    | values     |
    | Version   | 7.x-1.4    |
    | Component | Code       |
    | Category  | task       |
    | Priority  | normal     |
    | Assigned  | site user  |
    | Status    | needs work |
    And I fill in "Title" with random text
    And I fill in "Description" with random text
    And I attach the file "koala.jpg" to "Attach new file"
    And I press "Save"
    Then I should see "has been created"
