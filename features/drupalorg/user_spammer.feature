@admin @spam
Feature: Remove default post speed throttle
  In order to present quality content
  As a site administrator
  I want allow known users to post content as fast as they like

  Scenario: View link on user profile
    Given I am logged in as the "admin test"
    When I visit "/user/33572"
    Then I should see the link "revoke role Not a spammer"

  Scenario: Assign user admin role
    Given I am logged in as the "admin test"
    And I visit "/user/1123222/edit"
    And I check "user administrator"
    And I press "Save"
    And I see "have been saved"
    When I am logged in as the "git-vetted"
    And I visit "/user/33570"
    Then I should see "SSH Keys"
    And I should see "revoke role Not a spammer"

  Scenario: Assign "spam fighter"
    Given I am logged in as the "admin test"
    And I visit "/user/1118416/edit"
    And I check "spam fighter"
    And I press "Save"
    And I see "have been saved"
    When I am logged in as the "git-peon"
    And I visit "/user/33570"
    And I should see "revoke role Not a spammer"
