Feature:
  In order to test the functionalities of Drupal dashboard
  As an authenticated user
  I should be able to add a block to the Dashboard

  @javascript
  Scenario: Add a new block to the Dashboard
    Given that I am on the homepage
    When I follow "Log in / Register"
    And I am logged in as "site user"
    And I follow "Your Dashboard"
    And I follow "Dashboard"
    And I follow "Add a block"
    Then I should see the following <blocklinks> in small boxes
    | blocklinks |
    | Drupal News |
    | Planet Drupal |
    | Your Posts |
    | Your Issues |
    | Project Issue Summary |
    | Contributor Links |
    | Documentation Team links |
    And I click the link "Contributor Links" to add
    And I should see the block "Contributor Links" in column "1"
