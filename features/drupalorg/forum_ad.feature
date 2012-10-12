@wip @community @forums @anon
Feature: Display ads in the Hosting support and Paid services forum
  In order to get information about sponsors
  As any user
  I should see an Ad on the forum page

  Background:
    Given that I am on the homepage
    And I follow "Support"
    And I follow "Forums"

  Scenario: Advertisement in services hosting support page
    When I follow "Hosting support"
    Then I should see the heading "Hosting support"
    And I should see the advertisment in the right sidebar

  Scenario: Advertisement in paid services page
    When I follow "Paid Drupal services"
    Then I should see the heading "Paid Drupal services"
    And I should see the advertisment in the right sidebar

  Scenario: Advertisement under individual paid service forum
    When I follow "Paid Drupal services"
    Then I should see the heading "Paid Drupal services"
    And I follow a post
    Then I should see the advertisment in the right sidebar
    