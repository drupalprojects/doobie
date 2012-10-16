@front
Feature: Drupal.org frontpage
  In order to have an overview about Drupal.org and Drupal project
  As any user
  I should go to Drupal.org frontpage

  Background:
    Given I am on the homepage

  @anon
  Scenario: View texts and links in top left content area
    Then I should see the "link" "Why Choose Drupal?" in "top left content" area
    And I should see the "text" "Use Drupal to build everything from personal blogs to enterprise applications" in "top left content" area
    And I should see the "link" "Drupal Distributions" in "top left content" area
    And I should see the "text" "Distributions are a collection of pre-configured themes and modules" in "top left content" area

  @anon
  Scenario: View power Drupal text with people, country and language statistics in it
    Then I should see at least "682000" "people" in power Drupal text
    And I should see at least "200" "countries" in power Drupal text
    And I should see at least "150" "languages" in power Drupal text

  @anon @known_git6failure @wip
  Scenario Outline: Visit the links in top left content area
    When I follow "<link>"
    Then I should see the heading "<title>"

    Examples:
    | link                      | title                   |
    | Get Started with Drupal   | Get Started with Drupal |
    | Drupal Distributions      | Download & Extend       |
    | Learn about Distributions | Distributions           |

  @anon @known_git6failure @wip
  Scenario: View sites made with Drupal in top middle content area
    Then I should see the "link" "Sites Made with Drupal" in "top middle content" area
    And I should see the image of a drupal site in top middle content area
    And I should see the "text" "Drupal is used by some of the biggest sites on the Web, like" in "top middle content" area

  @anon @known_git6failure @wip @javascript
  Scenario: View project and activity links, the count against each of them and advertisement in top right content area
    And I wait until the page is loaded
    And I should see the following <links> in "top right content" area
    | links               |
    | Develop with Drupal |
    | Modules             |
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
    And I should see at least "1000" "Code commits" in top right content area
    And I should see at least "4000" "Issue comments" in top right content area
    And I should see an advertisement in top right content area

  @anon
  Scenario: View tabs in bottom right content area
    And I should see the following <tabs> in "bottom right content" area
    | tabs          |
    | News          |
    | Docs Updates  |
    | Forum Posts   |
    | Commits       |