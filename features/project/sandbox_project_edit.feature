@project @sandbox
Feature: Check the Releases Tab and Project Short Name on Edit Sandbox Project
  In order to ensure that unsuspecting users don't access sandbox code
  As a vetted user
  I should not be able to see the Releases tab, Administer releases permissions and Release links and not be able to edit the Project Short Name

  @failing
 Scenario: Create a sample sandbox project
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I visit "/node/add/project-theme"
    When I create a "sandbox" project
    And I see "has been created"
    And I follow "Logged in as git vetted user"
    And I follow "Your Projects"
    Then I should see at least "1" record

  @failing
 Scenario: Sandbox Project edit page doesn't have Releases Tab and editable Project Short Name
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I follow "Your Projects"
    When I click the "Edit" link in the "Sandbox projects" table
    Then I should not see the link "Releases"
    And I should see that the project short name is readonly

  @failing
 Scenario: Administer Releases column doesn't exist in maintainers table
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I follow "Your Projects"
    When I click the "Edit" link in the "Sandbox projects" table
    And I follow "Maintainers"
    Then I should not see "Administer releases"

  @clean_data @failing
 Scenario: Releases links don't exist on Sandbox project main page
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I follow "Your Projects"
    When I click the first project link in the "Sandbox projects" table
    Then I should not see the following <links>
      | links               |
      | View all releases   |
      | Add new release     |
      | Administer releases |
