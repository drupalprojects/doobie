@user @javascript @known_git6failure
Feature:
  In order to create an efficient, personalized workspace 
  As an authenticated user
  I should be able to add blocks to my dashboard

  Background:
    Given I am logged in as "site user"
    And I wait until the page is loaded

  Scenario: Add a new block to the Dashboard
    And I follow "Your Dashboard"
    And I wait until the page is loaded
    And there are no blocks on my dashboard
    When I follow "Add a block"
    Then I should see the following <blocklinks> in small boxes
    | blocklinks                |
    | Drupal News               |
    | Planet Drupal             |
    | Your Posts                |
    | Your Issues               |
    | Project Issue Summary     |
    | Contributor Links         |
    | Documentation Team links  |
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
    | /planet              | Add Drupal Planet to dashboard            | Drupal Planet            |
    | /talk                | Add Drupal talk to dashboard              | talk                     |
    | /project/issues/user | Add Your Issues to dashboard              | Issues for site user     |
    | /getting-involved    | Add Contributor Links to dashboard        | Contributor Links        |

  Scenario:Add from the user track page
    And I follow "Your Dashboard"
    And I wait until the page is loaded
    And I click "Your Posts"
    And I wait until the page is loaded
    When I click "Add Your Posts to dashboard"
    And I wait until the page is loaded
    Then I should not see "Access denied"
    And I should see "Track posts" 

  Scenario: User cannot add someone else's block
    When I visit "/user/33570/track"
    Then I should not see "Add Your Posts to dashboard"
