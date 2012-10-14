@front
Feature: Frontpage news section
  In order to get the latest news updates
  As any user
  I should be able to read the News section on the Drupal front page

  Scenario: Create a news post
    Given I am logged in as "site user"
    And I visit "/forum"
    And I follow "News and announcements"
    And I follow "Post new Forum topic"
    When I create a forum topic
    Then I should see "has been created"

  @javascript @dependent
  Scenario: Admin promotes the news post
    Given I am logged in as "admin test"
    And I am on the forum topic page
    And I follow "Edit"
    And I wait until the page is loaded
    When I click "Publishing options"
    And I check the box "Promoted to front page"
    And I press "Save"
    And I wait until the page is loaded
    Then I should see "has been updated"

  @anon @dependent
  Scenario: Frontpage News tab
    Given I am on the homepage
    Then I should see the forum topic link
    And I should see the introductory text
    And I should see at least "3" more news links

  @anon @dependent @clean_data
  Scenario: Frontpage News tab: More news
    Given I am on the homepage
    When I follow "More news"
    Then I should see the heading "Drupal News"
    And I should see the forum topic link