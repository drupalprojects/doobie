@community @search
Feature: Community Search Documentation
  In order to find out drupal activities/options for getting involved with the site
  As any user
  I should search for the avaliable options in the site

  @javascript
  Scenario: Search for documentation
    Given I am on the homepage
    When I follow "Community"
    And I wait until the page loads
    And I fill in "FAQ" for "Search Documentation"
    Then I should see the heading "FAQ: Frequently Asked Questions"
    And I should be on "/documentation/modules/faq"
