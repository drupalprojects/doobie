@user @javascript @wip
Feature: Home page preference functionality
  In order to have quick access to dashboard and its related links
  As an authenticated user
  I need to be able to use my dashboard as my home page

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I wait until the page loads
    And I follow "Your Dashboard"
    And I wait until the page loads

  Scenario: Select dashboard as homepage and visit homepage by clicking drupal banner
    When I select the radio button "Make this your Homepage"
    And I click the drupal banner in the header
    And I wait until the page loads
    Then I should see the heading "Trusted User"
    And I should see the link "Add a block"
    And I should see "Use Default Homepage"
    And I should not see the link "Make this your Homepage"

  Scenario: Select default home page and visit homepage by clicking drupal banner
    When I select the radio button "Use Default Homepage"
    And I click the drupal banner in the header
    And I wait until the page loads
    Then I should see the link "Why Choose Drupal?"
    And I should see the link "Sites Made with Drupal"
    And I should not see the link "Add a block"
