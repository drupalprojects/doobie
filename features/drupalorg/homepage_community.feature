Feature: Drupal community
  In order to learn about the drupal communities
  As a user
  I should be able to see the communites that are available in drupal org

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
      
  Scenario: To search for right side links on the side bar
    Given I am on the homepage
    When I follow "Community"
    Then I should see the heading "Recent activity"
    And I should see at least "10" links in the "content" region

  @javascript @known_git6failure
  Scenario: Search for documentation
    Given I am on the homepage
    When I follow "Community"
    And I fill in "Search Documenation" with "drupal"
    And I wait for the suggestion box to appear
    And I follow "Learn Drupal: Global Training Days"
    Then I should see the heading "Learn Drupal: Global Training Days"
