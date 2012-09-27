@javascript
Feature:
  In order to test the functionalities of Drupal dashboard
  As an authenticated user
  I should be able to add a block to the Dashboard

  Background:
    Given I am logged in as "site user"

  Scenario: Add a new block to the Dashboard
    And I follow "Your Dashboard"
    And I follow "Dashboard"
    And there are no blocks on my dashboard
    And I follow "Add a block"
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

  @flaky
  Scenario Outline: Add block from project page
    And I am on "<page>" 
    When I click "<blocklink>"
    Then I should see "<blocktitle>"

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
    When I follow "Your Dashboard"
    And I click "Your Posts"
    And I click "Add Your Posts to dashboard"
    Then I should see "Track posts" 

  Scenario: User cannot add someone else's block
    When I visit "/user/33570/track"
    Then I should not see "Add Your Posts to dashboard"
