@user
Feature:
  In order to create an efficient, personalized workspace
  As an authenticated user
  I should be able to add blocks to my dashboard

  Background:
    Given I am logged in as the "site user"
    And I wait until the page is loaded

  @javascript
  Scenario: Add a new block to the Dashboard
    And I follow "Your Dashboard"
    And I wait until the page is loaded
    And I follow "Dashboard"
    And I wait until the page is loaded
    And there are no blocks on my dashboard
    When I follow "Add a block"
    Then I should see the following <blocklinks> in small boxes
    | blocklinks                            |
    | Drupal News                           |
    | Planet Drupal                         |
    | Your Posts                            |
    | Your Issues                           |
    | Project issue: Issue queue statistics |
    | Contributor Links                     |
    | Documentation Team links              |
    And I click the link "Contributor Links" to add
    And I should see the block "Contributor Links" in column "1"a

  Scenario Outline: Add block from project page
    And I am on "<page>"
    And I wait until the page is loaded
    When I click "<blocklink>"
    And I wait until the page is loaded
    Then I should not see "Access denied"
    And I should see "<blocktitle>"

    Examples:
    | page                 | blocklink                                 | blocktitle               |
    | /project/drupal      | Add Issues for Drupal core to dashboard   | Issues for Drupal core   |
    | /node/24572          | Add Documentation Team links to dashboard | Documentation Team links |
    | /news                | Add Drupal News to dashboard              | Drupal News              |
    | /planet              | Add Planet Drupal to dashboard            | Plant Drupal             |
    | /talk                | Add Drupal Talk to dashboard              | Drupal talk              |
    | /project/issues/user | Add Your Issues to dashboard              | site user                |
    | /getting-involved    | Add Contributor Links to dashboard        | Contributor Links        |

  Scenario:Add from the user track page
    And I follow "Your Dashboard"
    And I wait until the page is loaded
    And I click "Your Posts"
    And I wait until the page is loaded
    When I follow "Add Your Posts to dashboard"
    And I wait until the page is loaded
    Then I should not see "Access denied"
    And I should see "Your Posts"

  Scenario: User cannot add someone else's block
    When I visit "/user/33570/track"
    Then I should not see "Add Your Posts to dashboard"

  @javascript @wip
  Scenario: Add Issue queue statistics
    And I follow "Your Dashboard"
    When I click "Add a block"
    And I click "Project issue: Issue queue statistics"
    And I click "Configure"
    And I fill in "Project name" with "Token"
    And I press "Save"
    Then I should see "Issues for Token"
