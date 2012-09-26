Feature: Create a project
  In order to share my code with the community
  As a contributor
  I need to be able to create a project

  Scenario: Access the form using path
    Given I am logged in as "git vetted user"
    And I am on "/node/add/project-project"
    Then I should see the heading "Create Project"

  Scenario: Access the form from menu
    Given I am logged in as "git vetted user"
    When I follow "Your Dashboard"
    And I follow "Your Projects"
    And I follow "Add a new project"
    Then I should see the heading "Create Project"

  Scenario: Check Sandbox checkbox is readonly for git user
    Given I am logged in as "git user"
    And I am on "/node/add/project-project"
    Then the "Sandbox" checkbox should be checked
    And I should see that the Sandbox checkbox is "disabled"

  Scenario: Check Sandbox checkbox can be checked by git vetted user
    Given I am logged in as "git vetted user"
    And I am on "/node/add/project-project"
    Then I should see that the Sandbox checkbox is "enabled"

  Scenario: Check Sandbox checkbox can be checked by admin
    Given I am logged in as "admin test"
    And I am on "/node/add/project-project"
    Then I should see that the Sandbox checkbox is "enabled"
  
  @javascript
  Scenario: Check Project Short name can be set if Sandbox checkbox is unchecked
    Given I am logged in as "git vetted user"
    And I am on "/node/add/project-project"
    When I uncheck sandbox
    Then I should see "Short project name"

  @javascript @clean_data
  Scenario: Create a Project
    Given I am logged in as "git vetted user"
    And I am on "/node/add/project-project"
    When I select "Modules" from Project Type on Create Project page
    And I select the following <fields> with <values>
    | fields              | values                    |
    | Modules categories  | Event                     |
    | Maintenance status  | Actively maintained       |
    | Development status  | Under active development  |
    And I upload the following "project image" <files>
    | files           | description     | alt text    |
    | desert.jpg      | Desert pic      | Desert      |
    | hydrangeas.jpg  | Hydrangeas pic  | Hydrangeas  |
    | koala.jpg       | Koala pic       | Koala       |
    And I fill in "Project title:" with random text
    And I fill in "Description: " with random text
    And I follow "Project resources"
    And I fill in the following:
    | Homepage:       | http://mytestsite.com |
    | Documentation:  | docs here             |
    | Screenshots:    | screenshots...         |
    | Changelog:      | http://mytestsite.com |
    | Demo site:      | http://mytestsite.com |
    And I fill in "Testing create project" for "Log message:"
    And I press "Save"
    Then I check the project is created