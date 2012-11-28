@community @search
Feature: Community Search Documentation
  In order to find out drupal activities/options for getting involved with the site
  As any user
  I should search for the avaliable options in the site

  @javascript @known_git6failure
  Scenario: Search for documentation
    Given I am on the homepage
    When I follow "Community"
    And I wait until the page loads
    And I fill in "FAQ" for "Search Documentation:"
    And I wait for the suggestion box to appear
    And I follow "Drupal FAQs"
    Then I should see the heading "Drupal project Frequently Asked Questions (FAQ)"
    And I should see "About Drupal"
    And I should see the link "Drupal project Frequently Asked Questions (FAQ)"
    And I should see the following <links>
    | links              |
    | About Drupal       |
    | Using Drupal       |
    | Configuring Drupal |
