@user @javascript
Feature:
  In order to test the functionalities of Drupal dashboard
  As an authenticated user
  I need to be able to check User Dashboard and its regions and blocks

  Background:
    Given I am logged in as "site user"
    And I wait until the page is loaded

  Scenario: View the links and labels on Dashboard
    And I follow "Your Dashboard"
    And I wait until the page is loaded
    When I follow "Dashboard"
    And I wait until the page is loaded
    Then I should see the following <links>
    | links                   |
    | Dashboard               |
    | Your Posts              |
    | Your Commits            |
    | Your Issues             |
    | Your Projects           |
    | Profile                 |
    | Add a block             |

  Scenario: Click Restore to defaults and view dashboard blocks
    When I follow "Your Dashboard"
    And I click "Add a block"
    And I see the following <blocklinks> in small boxes
    | blocklinks                |
    | Drupal News               |
    | Planet Drupal             |
    | Your Posts                |
    | Your Issues               |
    | Project: Issue summary     |
    | Contributor Links         |
    | Documentation Team links  |
    And I click "Restore to defaults"
    And I wait until the page is loaded
    And I press "Confirm"
    Then I should see the following <blocks> in column "1"
    | blocks        |
    | Drupal News   |
    | Planet Drupal |
    And I should see the following <blocks> in column "2"
    | blocks      |
    | Your Posts  |
    | Your Issues |
    And I should see the following <blocks> in column "3"
    | blocks                 |
    | Issues for Drupal core |
    | Contributor Links      |
    And I should not see the below <blocks> in column "1"
    | blocks                 |
    | Issues for Drupal core |
    | Contributor Links      |
    And I should see the block "Drupal News" in column "1" just "above" the block "Planet Drupal"
    And I should see the block "Your Issues" in column "2" just "below" the block "Your Posts"

  Scenario: View different blocks in columns
    When I follow "Your Dashboard"
    And I wait until the page is loaded
    Then I should see at least "2" blocks in column "1"
    And I should see at least "2" blocks in column "2"
    And I should see at least "2" blocks in column "3"
    And I should see at least "3" items in block "Planet Drupal"

  @wip @known_git7failure
  Scenario: Create test data for Your Posts
    And I am on "/node/add/project-issue/test_releases"
    And I should not see "Access denied"
    When I create a new issue
    And I see "has been created"
    And I am on "/node/add/project-issue/test_releases"
    And I create a new issue
    And I see "has been created"
    And I am on "/node/add/project-issue/test_releases"
    And I create a new issue
    Then I should see "has been created"

  @dependent
  Scenario: View the block: Your Posts
    And I follow "Your Dashboard"
    And I wait until the page is loaded
    Then I should see the block "Your Posts" in column "2"
    And I should see at least "2" items in block "Your Posts"
    And I should see the following <icons> on the block "Your Posts"
    | icons    |
    | Settings |
    | Close    |

  @dependent
  Scenario: Change number of items to show in a block
    And I follow "Your Dashboard"
    And I wait until the page is loaded
    When I change the setting "Number of posts to show" to "3" for the block "Your Posts" and save
    Then I should see at least "3" items in block "Your Posts"

  @flaky
  Scenario: Close the block
    And I follow "Your Dashboard"
    And I wait until the page is loaded
    When I close the block "Your Posts"
    Then I should not see the block
