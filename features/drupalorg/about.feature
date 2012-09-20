@anon
Feature: Find About Drupal
  In order to find the about Drupal
  As any user
  I want to see about page

  Scenario: Browse to the About page
    Given that I am on the homepage 
    When I follow "About"
    Then I should see the heading "About Drupal"

  Scenario: Browse to the About page
    Given I am on "/about"
    When I follow "About the Drupal project ›"
    Then I should see the heading "About the Drupal project"

  Scenario: Use the sitewide search
    Given that I am on the homepage
    When I search sitewide for "about"
    And I follow "About Drupal"
    Then I should be on "/about"
    And I should see the heading "About Drupal"
    And I should not see "Page not found"
