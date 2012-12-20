@project @sandbox @wip
Feature: Check the Releases Tab and Project Short Name on Edit Sandbox Project
  In order to ensure that unsuspecting users don't access sandbox code
  As a vetted user
  I should not be able to see the Releases tab, Administer releases permissions and Release links and not be able to edit the Project Short Name

  Scenario: Create a sample sandbox project
    Given I am logged in as "git vetted user"
    And I visit "/node/add/project-core"
    When I create a "sandbox" project
    And I see "has been created"
    And I follow "Logged in as git vetted user"
    And I follow "Your Projects"
    Then I should see at least "1" record

  Scenario: Sandbox Project edit page doesn't have Releases Tab and editable Project Short Name
    Given I am logged in as "git vetted user"
    And I follow "Your Projects"
    When I click the edit link for the sandbox project
    Then I should not see the link "Releases"
    And I should see that the project short name is readonly

  Scenario: Administer Releases column doesn't exist in maintainers table
    Given I am logged in as "git vetted user"
    And I follow "Your Projects"
    When I click the edit link for the sandbox project
    And I follow "Maintainers"
    Then I should not see "Administer releases"

  @clean_data
  Scenario: Releases links don't exist on Sandbox project main page
    Given I am logged in as "git vetted user"
    And I follow "Your Projects"
    When I click the Sandbox project link
    Then I should not see the following <links>
    | links                 |
    | View all releases     |
    | Add new release       |
    | Administer releases   |
