@issues
Feature: Drupal Create Issues
  In order to get help contributing code or using modules and themes
  As a Trusted User
  I want create an issue

  @javascript @failing
 Scenario: Create an issue from the main issues page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I am on "/node/add/project-issue"
    When I fill in "Project" with "Achievements"
    And I select "Achievements" from the suggestion "Project"
    And I press "Next"
    And I wait until the page loads
    And I fill in "Title" with random text
    And I fill in "Issue summary" with random text
    And I select the following <fields> with <values>
      | fields    | values     |
      | Version   | 7.x-1.4    |
      | Component | Code       |
      | Category  | Task       |
      | Priority  | Normal     |
      | Assigned  | Trusted User  |
      | Status    | Needs work |
    And I press "Save"
    Then I should see "has been created"

  @wip @notification
  Scenario: Create an issue from a specific project's issue page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I am on "/project/issues/achievements"
    When I follow "Create a new issue"
    And I select the following <fields> with <values>
      | fields    | values     |
      | Version   | 7.x-1.4    |
      | Component | Code       |
      | Category  | Task       |
      | Priority  | Normal     |
      | Assigned  | Trusted User  |
      | Status    | Needs work |
    And I fill in "Title" with random text
    And I fill in "Issue summary" with random text
    And I press "Save"
    Then I should see "has been created"
