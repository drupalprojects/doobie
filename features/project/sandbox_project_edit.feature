Feature: Check the Releases Tab and Project Short Name on Edit Sandbox Project
  In order to ensure that unsuspecting users don't access sandbox code 
  As a vetted user
  I should not be able to see the Releases tab, Administer releases permissions and Release links and not be able to edit the Project Short Name

  Background:
    Given I am logged in as "git vetted user"
    And I follow "Your Dashboard"
    And I follow "Your Projects"

  Scenario: Check Sandbox Project edit page doesn't have Releases Tab and editable Project Short Name
    When I click the edit link for the sandbox project
    Then I should not see the Releases tab
    And I should see that the project short name is readonly

  Scenario: Check Administer Releases column doesn't exist in maintainers table
    When I click the edit link for the sandbox project
    And I follow "Maintainers"
    Then I should not see "Administer releases"

  Scenario: Check Releases links don't exist on Sandbox project main page
    When I click the Sandbox project link
    Then I should not see the following <links>
    | links                 |
    | View all releases     |
    | Add new release       |
    | Administer releases   |