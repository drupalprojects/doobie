Feature:
  In order to understand drupal.org and its community
  As any user
  I need to be able to go through Community Documentations

  Scenario: Follow Community Documentation tab and view other tabs, texts and blocks
    Given I am on the homepage
    When I follow "Documentation"
    Then I should see the following <tabs>
    | tabs                  |
    | Community Docs Home   |
    | Installation Guide    |
    | Administration Guide  |
    And I should see that the tab "Community Docs Home" is highlighted
    And I should see the heading "Community Documentation"
    And I should see the following <blocks> in the right sidebar
    | blocks |
    | Help maintain the Community Documentation |
    And I should see the copyright statement in the right sidebar

  Scenario: Follow Installation Guide tab and view other tabs, texts and blocks
    Given I am on "/documentation"
    When I follow "Installation Guide"
    Then I should see the following <tabs>
    | tabs                  |
    | Community Docs Home   |
    | Installation Guide    |
    | Administration Guide  |
    And I should see that the tab "Installation Guide" is highlighted
    And I should see the heading "Community Documentation"
    And I should see the following <blocks> in the right sidebar
    | blocks             |
    | Page status        |
    | About this page    |
    | Installation guide |
    And I should see the copyright statement in the right sidebar

  Scenario: Follow Administration Guide tab and view other tabs, texts and blocks
    Given I am on "Documentation"
    When I follow "Administration Guide"
    Then I should see the following <tabs>
    | tabs                  |
    | Community Docs Home   |
    | Installation Guide    |
    | Administration Guide  |
    And I should see that the tab "Administration Guide" is highlighted
    And I should see the heading "Community Documentation"
    And I should see the following <blocks> in the right sidebar
    | blocks               |
    | Page status 	   |
    | About this page      |
    | Administration Guide |
    And I should see the copyright statement in the right sidebar
