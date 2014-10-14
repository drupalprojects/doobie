@admin @spam
Feature: Remove default post speed throttle
  In order to present quality content
  As a site administrator
  I want allow known users to post content as fast as they like

  @failing
 Scenario: View link on user profile
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    When I visit "/user/33572"
    Then I should see the link "revoke role Not a spammer"

  @failing
 Scenario: Assign user admin role
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Administrative User"
    And I visit "/user/1123222/edit"
    And I check "user administrator"
    And I press "Save"
    And I see "have been saved"
    When I am logged in as "Git Vetted User"
    And I visit "/user/33570"
    Then I should see "SSH Keys"
    And I should see "revoke role Not a spammer"

  @failing
 Scenario: Assign "spam fighter"
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "/user/1118416/edit"
    And I check "spam fighter"
    And I press "Save"
    And I see "have been saved"
    When I am logged in as the "git-peon"
    And I visit "/user/33570"
    And I should see "revoke role Not a spammer"


