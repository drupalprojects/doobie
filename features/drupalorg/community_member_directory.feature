@community
Feature: View members of drupal community
  In order to interact with various members of the community
  As any user
  I should be able to see the members who have logged in recently

  @anon
  Scenario: Navigate to the page as anonymous user
    Given I am on the homepage
    When I follow "Community"
    And I follow "Member Directory"
    Then I should see the heading "Community"
    And I should see the link "next"
    And I should see the link "last"
    And I should not see the link "first"
    And I should see at least "20" members

  Scenario: Navigate to the page as authenticated user
    Given I am logged in as the "site user"
    When I follow "Community"
    And I follow "Member Directory"
    Then I should see the heading "Community"
    And I should see the link "next"
    And I should see the link "last"
    And I should not see the link "first"
    And I should see at least "20" members
    And I should see the link "site user" in the "content" region

  @anon @javascript
  Scenario: Navigate to groups page
    Given I am on "/profile"
    When I follow "Groups.Drupal.org"
    Then I should see the heading "Collaborate with the Drupal community"
    And I should see the link "Go to Drupal.org"

  @anon @javascript
  Scenario: Navigate to regional groups page
    Given I am on "/profile"
    When I follow "regional groups"
    And I wait until the page loads 
    Then I should see the heading "Working and regional Groups & Meetups"
    And I should see the link "Go to Drupal.org"
