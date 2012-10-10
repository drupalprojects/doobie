@community
Feature: Landing page of Community section of the site
  In order to find out about Drupal community
  As any user
  I should go to community page

  Scenario: View community page
    Given I am on the homepage
    When I follow "Community"
    Then I should see the heading "Where is the Drupal Community?"
    And I should see the following <texts>
    | texts                 |
    | Online & Local Groups |
    | Events & Meetups      |
    | Chat (IRC)            |
    | Planet Drupal         |
    | Community Spotlight   |
    | Commercial Support    |
    | Forum                 |
    | Mailing Lists         |
    | Drupal Association    |

  Scenario: Create test issue to check Recent activity block
    Given I am logged in as "site user"
    And I visit "/node/1765126"
    When I follow "open"
    And I follow "Create a new issue"
    And I create a new issue
    Then I should see "has been created"

  @dependent @clean_data
  Scenario: Look for the issue created in Recent activity block
    Given I am on the homepage
    When I follow "Community"
    Then I should see the issue link
    And I should see the heading "Recent activity"

  Scenario: Create one more test issue to check Recent activity block
    Given I am logged in as "site user"
    And I visit "/node/1765126"
    When I follow "open"
    And I follow "Create a new issue"
    And I create a new issue
    Then I should see "has been created"

  @dependent @clean_data
  Scenario: Look for the issue created in Recent activity block
    Given I am on the homepage
    When I follow "Community"
    Then I should see the issue link
    And I should see the heading "Recent activity"

  Scenario: View most Recent Activities
    Given I am on "/community"
    When I follow "More recent activity"
    Then I should be on "/tracker"
    And I should see the heading "Recent posts"
    And I should see the following <texts>
    | texts        |
    | Type         |
    | Post         |
    | Author       |
    | Replies      |
    | Last updated |
