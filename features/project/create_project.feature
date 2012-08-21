Feature:
  In order to test the functionalities of Create Project
  As an Authenticated User
  I should be able to Create a Project

  @javascript
  Scenario: Create a Project
    Given I am logged in as "git user"
    When I follow "Your Dashboard"
    And I follow "Your Projects"
    And I follow "Add a new project"
    And I select "Modules" from Project Type on Create Project page
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
    | Screenshots:    | screnshots...         |
    | Changelog:      | http://mytestsite.com |
    | Demo site:      | http://mytestsite.com |
    And I fill in "Testing create project" for "Log message:"
    And I press "Save"
    Then I check the project is created