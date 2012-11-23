@about @content @wip
Feature: About Drupal.org section
  In order to find out about Drupal.org website
  As any user
  I should be able to see About Drupal.org page and visit various links

  Scenario: View the about page
    #Given I am on the homepage
    #When I follow "About Drupal.org"
    Given I am not logged in
    When I visit "/about-drupal.org"
    Then I should see the heading "Drupal.org"
    And I should see the following <texts>
    | texts                              |
    | Who are the maintainers?           |
    | How can I contribute?              |
    | About Drupal.org                   |
    | It's built with Drupal             |
    | Login or register to post comments |
    And I should see the following <links>
    | links                        |
    | Drupal.org-specific projects |
    | Contribute to documentation  |
    | Donating to Drupal           |
    | Drupal.org improvements      |
    | Login                        |
    | Register                     |
    And I should see the following <tabs>
    | tabs                 |
    | Drupal.org Projects  |
    | About Drupal.org     |
    | Webmasters           |
    | Documentation        |
    | Project Applications |
    | Infrastructure       |
    | Theme                |
    And I should see that the tab "About Drupal.org" is highlighted

  @known_git6failure
  Scenario Outline: Tabs navigation on the page
    Given I am on "/about-drupal.org"
    When I follow "<tab>" tab on the top navigation
    Then I should not see "Page not found"
    And I should see the heading "Drupal.org"
    And I should see that the tab "<tab>" is highlighted
    Examples:
    | tab                  |
    | Drupal.org Projects  |
    | Webmasters           |
    | Documentation        |
    | Project Applications |
    | Infrastructure       |
    | Theme                |
