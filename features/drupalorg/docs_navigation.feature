@docs @anon @specific_text
Feature:
  In order to understand drupal.org and its community
  As any user
  I need to access community documentation guides

  Scenario: Visit community documentation tab and view other tabs, heading, texts and blocks
    Given I am on the homepage
    When I follow "Documentation"
    Then I should see the following <tabs>
    | tabs                  |
    | Community Docs Home   |
    | Installation Guide    |
    | Administration Guide  |
    And I should see that the tab "Community Docs Home" is highlighted
    And I should see the heading "Community Documentation"
	  And I should see "The Drupal.org online Community Documentation"
    And I should see the following <blocks> in the right sidebar
    | blocks                                    |
    | Help maintain the Community Documentation |
    And I should see the text "online documentation is" in the "right sidebar" region
    And I should see the text "by the individual contributors and can be used in accordance with the Creative Commons License, Attribution-ShareAlike" in the "right sidebar" region

  Scenario: Visit installation guide tab and view other tabs, heading, texts and blocks
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
    | Installation Guide |
    And I should see the text "online documentation is" in the "right sidebar" region
    And I should see the text "by the individual contributors and can be used in accordance with the Creative Commons License, Attribution-ShareAlike" in the "right sidebar" region

  Scenario: Visit administration guide tab and view other tabs, heading, texts and blocks
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
    | Page status 	       |
    | About this page      |
    | Administration Guide |
    And I should see the text "online documentation is" in the "right sidebar" region
    And I should see the text "by the individual contributors and can be used in accordance with the Creative Commons License, Attribution-ShareAlike" in the "right sidebar" region

  Scenario Outline: Visit documentation links and view corresponding headings
  Given I am on "/documentation"
  When I follow "<link>"
  Then I should be on "<url>"
  And I should see the heading "<link>"

  Examples:
  | link                     | url                              |
  | Understanding Drupal     | /documentation/understand        |
  | Installation Guide       | /documentation/install           |
  | Administration Guide     | /documentation/administer        |
  | Structure Guide          | /documentation/structure         |
  | Site Building Guide      | /documentation/build             |
  | Multilingual Guide       | /documentation/multilingual      |
  | Theming Guide            | /documentation/theme             |
  | Mobile Guide             | /documentation/mobile            |
  | Develop for Drupal       | /documentation/develop           |

