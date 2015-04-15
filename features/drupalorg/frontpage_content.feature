@front @javascript @anon
Feature: Drupal.org frontpage
  In order to have an overview about Drupal.org and Drupal project
  As any user
  I should go to Drupal.org frontpage

  Background:
    Given I am on the homepage
    And I wait until the page loads

  Scenario: View texts and links in top left content area
    Then I should see the "link" "Why Choose Drupal?" in "top left content" area
    And I should see the "text" "Use Drupal to build everything from personal blogs to enterprise applications" in "top left content" area

  Scenario: View sites made with Drupal in top middle content area
    Then I should see the "link" "Sites Made with Drupal" in "top middle content" area
    And I should see the image of a drupal site in top middle content area
    And I should see the "text" "Drupal is used by some of the biggest sites on the Web, like" in "top middle content" area

  Scenario: View project and activity links, the count against each of them and advertisement in top right content area
    And I should see the following <links> in "top right content" area
      | links               |
      | Develop with Drupal |
      | Modules             |
      | Themes              |
      | Distributions       |
      | Developers          |
      | Code commits        |
      | Issue comments      |
      | Drupal Core         |
      | Security Info       |
      | Developer Docs      |
      | API Docs            |
    And I should see at least "12000" "Modules" in top right content area
    And I should see at least "1000" "Themes" in top right content area
    And I should see at least "400" "Distributions" in top right content area
    And I should see at least "10000" "Developers" in top right content area
    And I should see an advertisement in top right content area

  @failing
  Scenario: View power Drupal text with people, country and language statistics in it
    Then I should see at least "682000" "people" in power Drupal text
    And I should see at least "200" "countries" in power Drupal text
    And I should see at least "150" "languages" in power Drupal text

  @local
  Scenario Outline: Visit the links in frontpage content area
    When I follow "<link>"
    And I wait until the page loads
    Then I should see the heading "<title>"

  Examples:
    | link                      | title                   |
    | Why Choose Drupal?        | About Drupal            |
    | Get Started with Drupal   | Get Started with Drupal |
    | Distributions             | Download & Extend       |
    | Sites Made with Drupal    | Drupal Case Studies     |
    | Develop with Drupal       | Download & Extend       |
    | Developers                | All commits             |
    | Code commits              | All commits             |
    | Issue comments            | Issues for all projects |
    | Security Info             | Security advisories     |
    | Developer Docs            | Develop for Drupal      |
    | API Docs                  | API reference           |

  @local
  Scenario: Find modules for Drupal
    When I follow "Modules"
    Then I should see "Modules match your search"

  @local
  Scenario: Find themes for Drupal
    When I follow "Themes"
    Then I should see "Themes match your search"

  Scenario: Find out about Drupal core
    When I follow "Drupal Core"
    Then I should see "Get started by downloading the official Drupal core files"

  Scenario: View tabs in bottom right content area
    And I should see the following <tabs> in "bottom right content" area
      | tabs         |
      | News         |
      | Docs Updates |
      | Forum Posts  |
      | Commits      |
