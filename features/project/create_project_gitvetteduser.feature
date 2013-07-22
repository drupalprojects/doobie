@project
Feature: Create a project
  In order to share my code with the community
  As a contributor
  I need to be able to create a project

  Scenario: Can choose between sandbox and full project
    Given I am logged in as "git vetted user"
    When I visit "/node/add/project-module"
    Then I should see "Project type"
    And I should see "Sandbox project" in the dropdown "Project type"
    And I should see "Full project" in the dropdown "Project type"

  Scenario:
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

  # See Issue 2035755 re: use of labels
  @clean_data @javascript
  Scenario: Create a sandbox project
    Given I am logged in as "git vetted user"
    And I am on "/node/add/project-module"
    When I fill in "Name" with random text
    And I select "Sandbox project" from "Project type"
    And I fill in "Description" with random text
    And I select the following <fields> with <values>
    | fields              | values                    |
    | Module categories   | Event                      |
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
    | edit-field-project-screenshots-und-0-url   | screenshots...                       |
#   | License                                    | license...                           |
    | edit-field-project-documentation-und-0-url | docs here                            |
    | edit-field-project-demo-und-0-url          | http://mytestsite.com/demo           |
    | edit-field-project-changelog-und-0-url     | http://mytestsite.com/changelog.txt  |
    | edit-field-project-homepage-und-0-url      | http://mytestsite.com                |
    And I follow "Revision information"
    And I fill in "Testing create project" for "Revision log message"
    And I press "Save"
    Then I should not see "Sandbox projects may not have releases."
    Then I should see the project was created
    And I should see the random "Name" text
    And I should see the random "Description" text

  Scenario Outline: Create each project type
    Given I am logged in as "git vetted user"
    And I am at "<url>"
    When I create a "full" project
    Then I should see "has been created"    

    Examples:
    | url                            |
    | /node/add/project-module       |
    | /node/add/project-theme-engine |
    | /node/add/project-distribution |
    | /node/add/project-theme        |

  Scenario Outline: Cannot create full projects for Drupal*
    Given I am logged in as "git vetted user"
    And I am at "<url>"
    Then I should not see "Project type"
    And I should not see "Short name"

    Examples:
    | url                         | project     |
    | /node/add/project-core      | Drupal core |
    | /node/add/project-drupalorg | Drupal.org  |

  Scenario Outline: Create Drupal* sandbox projects
    Given I am logged in as "git vetted user"
    And I am at "<url>"
    When I fill in "Name" with random text
    And I select "Unsupported" from "Maintenance status"
    And I select "Obsolete" from "Development status"
    And I press "Save"
    Then I should see "has been created"

    Examples:
    | url                         | project     |
    | /node/add/project-core      | Drupal core |
    | /node/add/project-drupalorg | Drupal.org  |
    
