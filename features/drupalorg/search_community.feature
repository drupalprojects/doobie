@community @search
Feature: Community Search Documentation
  In order to find out drupal activities/options for getting involved with the site
  As any user
  I should search for the avaliable options in the site

  @javascript
  Scenario: Search for documentation
    Given I am on the homepage
    When I follow "Community"
    And I fill in "FAQ" for "Search Documentation"
    And I wait "1" second 
    And I follow "FAQ: Frequently Asked Questions"
    Then I should see the heading "FAQ: Frequently Asked Questions"
    And I should be on "/documentation/modules/faq"
