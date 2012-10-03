@user @javascript @flaky
Feature:
  In order to get immediate access to important information
  As an authenticated user
  I need to be able to arrange blocks on my Dashboard page

  Background:
    Given I am logged in as "site user"

  Scenario: Click Restore to defaults and check the positions of Dashboard blocks
    When I follow "Your Dashboard"
    And I click "Add a block"
    And I click "Restore to defaults"
    # Intermittent failures unless we wait.
    And wait "2" seconds
    And I press "Confirm"
    Then I should see the following <blocks> in the "left" column
    | blocks        |
    | Drupal News   |
    | Planet Drupal |
    And I should see the following <blocks> in the "center" column
    | blocks      |
    | Your Posts  |
    | Your Issues |
    And I should see the following <blocks> in the "right" column
    | blocks                 |
    | Issues for Drupal core |
    | Contributor Links      |

  Scenario: Check the positions of Documentation Team Links and Project Issue Summary links
    When I follow "Your Dashboard"
    And I click "Add a block"
    Then I should see the following <blocklinks> in small boxes
    | blocklinks                |
    | Project Issue Summary     |
    | Documentation Team links  |
