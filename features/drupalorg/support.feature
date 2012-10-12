@wip @support @anon
Feature: Drupal support
  In order to get the help from drupal community
  As a user
  I should be able to view various options provided on the support page

  Scenario: View the support page
    Given I am on the homepage
    When I follow "Support"
    Then I should be on "/support"
    And I should see the heading "Support"
    And I should see the heading "Get help with Drupal software"
    And I should see the heading "Get help with Drupal.org"

  Scenario: View the support links
    Given I am on the homepage
    When I follow "Support"
    Then I should see the following <links>
    | links                       |
    | Community Documentation     |
    | IRC online chat             |
    | Forums                      |
    | Other languages             |
    | Books                       |
    | Professional services       |
    | Drupal training             |
    | Learn more about Drupal.org |
    | Report an issue             |
    | hosting                     |
    And I should not see the following <links>
    | links                     |
    | Spam                      |
    | Site content issues       |
    | Site functionality issues |
    And I should see "Read the Drupal.org online documentation"
    And I should see "Find out how Drupal.org is built and maintained"
    And I should see "Find organizations that provide Drupal training services."