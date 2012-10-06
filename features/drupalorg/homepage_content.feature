Feature: Verify home page content
  In order to have an overview about Drupal.org and its applications
  As any user
  I need to be able to view useful links and statistics in different regions of homepage

  Background:
    Given I am on the homepage

  @anon
  Scenario: Check texts and links in top left content area
    Then I should see the "link" "Why Choose Drupal?" in "top left content" area
    And I should see the "text" "Use Drupal to build everything from personal blogs to enterprise applications" in "top left content" area
    And I should see the "link" "Drupal Distributions" in "top left content" area
    And I should see the "text" "Distributions are a collection of pre-configured themes and modules" in "top left content" area

  @anon
  Scenario: Check top middle content area on homepage
    Then I should see the "link" "Sites Made with Drupal" in "top middle content" area
    And I should see the "text" "Drupal is used by some of the biggest sites on the Web, like" in "top middle content" area

  @anon @known_git6failure
  Scenario: Check top right content area for links and counts
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

  @anon
  Scenario: Check people, country and language statistics in power Drupal text
    Then I should see at least "682000" "people" in power Drupal text
    And I should see at least "200" "countries" in power Drupal text
    And I should see at least "150" "languages" in power Drupal text

  @anon
  Scenario: Check tabs in bottom right content area
    And I should see the following <tabs> in "bottom right content" area
    | tabs          |
    | News          |
    | Docs Updates  |
    | Forum Posts   |
    | Commits       |

  @anon
  Scenario: Check footer links and text
    And I should see the following <links> in "footer" area
    | links                 |
    | Drupal News           |
    | Community             |
    | Get Started           |
    | Download & Extend     |
    | About                 |
    | registered trademark  |
    And I should see the "text" "Drupal is a registered trademark of Dries Buytaert" in "footer" area
