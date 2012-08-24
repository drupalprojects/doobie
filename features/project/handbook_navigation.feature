Feature: 
  In order to understand drupal.org and its community
  As any user
  I need to be able to go through Community Documentations

  Scenario: Check Community Documentation tab
    Given I am on "/documentation"
    Then I should see the following <tabs>
    | tabs                  |
    | Community Docs Home   |
    | Installation Guide    |
    | Administration Guide  |
    Then I should see that the tab "Community Docs Home" is highlighted
    And I should see the heading "Community Documentation"
    And I should see the following <blocks> in the right sidebar
    | blocks |
    | Help maintain the Community Documentation |
    And I should see the copyright statement in the right sidebar

  Scenario: Check Installation Guide tab
    Given I am on "/documentation/install"
    Then I should see the following <tabs>
    | tabs                  |
    | Community Docs Home   |
    | Installation Guide    |
    | Administration Guide  |
    Then I should see that the tab "Installation Guide" is highlighted
    And I should see the heading "Community Documentation"
    And I should see the following <blocks> in the right sidebar
    | blocks |
    | Page status |
    | About this page |
    | Installation guide |
    And I should see the copyright statement in the right sidebar

  Scenario: Check Administration Guide tab
    Given I am on "/documentation/administer"
    Then I should see the following <tabs>
    | tabs                  |
    | Community Docs Home   |
    | Installation Guide    |
    | Administration Guide  |
    Then I should see that the tab "Administration Guide" is highlighted
    And I should see the heading "Community Documentation"
    And I should see the following <blocks> in the right sidebar
    | blocks |
    | Page status |
    | About this page |
    | Administration Guide |
    And I should see the copyright statement in the right sidebar