@project
Feature: Create a project
  In order to share my code with the community
  As a contributor
  I need to be able to create a project

  @known_git7failure
  Scenario: Access Add content page, view links and visit Create Module project page
    Given I am logged in as "git vetted user"
    And I follow "Your Dashboard"
    And I follow "Your Projects"
    When I follow "Add a new project"
    And I see the heading "Add content"
    And I see the following <links>
    | links                     |
    | Book page                 |
    | Case study                |
    | Change record             |
    | Distribution project      |
    | Drupal core               |
    | Drupal.org project        |
    | Forum topic               |
    | Issue                     |
    | Module project            |
    | Organization              |
    | Theme Engine project      |
    | Theme project             |
    And I follow "Module project"
    Then I should be on "/node/add/project-module"
    And I should see the heading "Create Module project"

  Scenario: Project type select box is not available for git user
    Given I am logged in as "git user"
    When I visit "/node/add/project-module"
    Then I should not see "Project type"

  Scenario: Sandbox project can be created by git vetted user
    Given I am logged in as "git vetted user"
    When I visit "/node/add/project-module"
    Then I should see "Project type"
    And I should see "Sandbox project" in the dropdown "Project type"

  Scenario: Sandbox project can be created by admin
    Given I am logged in as "admin test"
    When I visit "/node/add/project-module"
    Then I should see "Project type"
    And I should see "Sandbox project" in the dropdown "Project type"

  Scenario: Submit create Module project form with empty values
    Given I am logged in as "git vetted user"
    And I am on "/node/add/project-module"
    When I press "Save"
    Then I should see the following <texts>
    | texts                                 |
    | Name field is required                |
    | Maintenance status field is required  |
    | Development status field is required  |
    | Short name field is required          |
    And the following <fields> should be outlined in red
    | fields              |
    | Name                |
    | Short name          |
    | Maintenance status  |
    | Development status  |

  @javascript @clean_data @known_git7failure
  Scenario: Create a Project
    Given I am logged in as "git vetted user"
    And I am on "/node/add/project-module"
    When I fill in "Name" with random text
    And I select "Sandbox project" from "Project type"
    And I fill in "Short name" with random text
    And I fill in "Description" with random text
    And I select the following <fields> with <values>
    | fields              | values                    |
    | Module categories  | Event                      |
    | Maintenance status  | Actively maintained       |
    | Development status  | Under active development  |
    And I upload the following <files> for "Images"
    | files           | description     |
    | desert.jpg      | Desert pic      |
    | hydrangeas.jpg  | Hydrangeas pic  |
    | koala.jpg       | Koala pic       |
    And I upload the following <files> for "File attachments"
    | files           | description     |
    | desert.jpg      | Desert pic      |
    | hydrangeas.jpg  | Hydrangeas pic  |
    | koala.jpg       | Koala pic       |
    And I follow "Resources"
    And I fill in the following:
    | Screenshots    | screenshots...                       |
    | License        | license...                           |
    | Documentation  | docs here                            |
    | Demo           | http://mytestsite.com/demo           |
    | Changelog      | http://mytestsite.com/changelog.txt  |
    | Homepage       | http://mytestsite.com                |
    And I follow "Revision information"
    And I fill in "Testing create project" for "Revision log message"
    And I press "Save"
    Then I should see the project was created
    And I should see the random "Name" text
    And I should see the random "Short name" text
    And I should see the random "Description" text
    