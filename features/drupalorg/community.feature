Feature: List of drupal communities
  In order to participate in drupal communities
  As a user
  I should see the communites that are available on the site

  Scenario: Verify that we are on the communtity page
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

  Scenario: Create test issue to check recent activity
    Given I am logged in as "site user"
    And I visit "/node/1765126"
    When I follow "open"
    And I follow "Create a new issue"
    And I create a new issue
    Then I should see "has been created"

  @dependent @clean_data
  Scenario: Look for the issue created in recent activity block
    Given I am on the homepage
    When I follow "Community"
    Then I should see the issue link
    And I should see the heading "Recent activity"

  Scenario: Create one more test issue to check recent activity
    Given I am logged in as "site user"
    And I visit "/node/1765126"
    When I follow "open"
    And I follow "Create a new issue"
    And I create a new issue
    Then I should see "has been created"

  @dependent @clean_data
  Scenario: Look for the issue created in recent activity block
    Given I am on the homepage
    When I follow "Community"
    Then I should see the issue link
    And I should see the heading "Recent activity"

  @javascript @known_git6failure
  Scenario: Search for documentation
    Given I am on the homepage
    When I follow "Community"
    And I fill in "FAQ" for "Search Documentation:"
    And I wait for the suggestion box to appear
    And I follow "Drupal FAQs"
    Then I should see the heading "Drupal FAQs"
    And I should see "General Drupal FAQ:"
    And I should see the link "Drupal project Frequently Asked Questions (FAQ)"