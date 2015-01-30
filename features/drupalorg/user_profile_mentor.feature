@user @profile
Feature: To verify that mentors can be added/viewed/removed by a user
  In order to give credit to the community members who have significantly influenced my contributions to Drupal
  As a community member
  I should be able to add mentors to my profile

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"

  @failing
  Scenario: Confirmed User adds mentors to his profile
    When I follow "Edit"
    And I follow "Drupal" tab
    And I fill in "My mentors" with "eliza411"
    And I press "Save"
    Then I should see "The changes have been saved"

  @failing
  Scenario: Mentor should be displayed in the profile page
    When I visit "/user"
    Then I should see "My mentors"
    And I should see the link "eliza411"

  @failing
  Scenario: Confirmed User adds more mentors to his profile
    When I follow "Edit"
    And I follow "Drupal" tab
    And I fill in "eliza411, pradeeprkara, sachin2dhoni, jhedstrom" for "My mentors"
    And I press "Save"
    Then I should see "The changes have been saved"

  @failing
  Scenario: Mentor should be displayed in the profile page
    When I visit "/user"
    Then I should see "My mentors"
    And I should see the following <links>
      | links        |
      | eliza411     |
      | pradeeprkara |
      | sachin2dhoni |
      | jhedstrom    |

  @failing
  Scenario: Follow a mentor and users name should be listed
    When I follow "eliza411"
    Then I should see the link "Confirmed User"
    And I should see the heading "People mentored by eliza411"

  @failing
  Scenario: Remove the mentors added
    When I follow "Edit"
    And I follow "Drupal" tab
    And I fill in "" for "My mentors"
    And I press "Save"
    Then I should see "The changes have been saved"
