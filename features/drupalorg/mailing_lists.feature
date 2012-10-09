@community @anon
Feature: Mailing lists subscription and archives
  In order to participate in mailing list discussions
  As a site visitor
  I need to be able to access mailing list archives and subscribe to the lists

  Scenario: Check the mailing list page
    Given I am on the homepage
    And I follow "Community"
    And I follow "Mailing Lists"
    Then I should see the heading "Mailing lists"
    And I should see the following <texts>
    | texts                   |
    | Last updated            |
    | Drupal uses email lists |
    | Support                 |
    | Development             |
    | Themes                  |
    | Translations            |
    | Consulting              |
    | Webmasters              |
    | Infrastructure          |
    | Subscribe               |
    | Page status             |
    And I should see the following <links>
    | links                    |
    | Getting Involved Guide   |
    | view archive             |
    | mailman page             |
    | up                       |
    | Log in to edit this page |

  Scenario Outline: Follow view archive and verify the page
    Given I am on "/mailing-lists"
    When I clik on link "view archive" under section "<section>"
    Then I should see the following <texts>
    | texts                                        |
    | You can get more information about this list |
    | Archives                                     |
    | Archive                                      |
    | View by:                                     |
    | Downloadable version                         |
    And I should see the following <links>
    | links       |
    | Thread      |
    | Subject     |
    | Author      |
    | Date        |
    | Gzip'd Text |
    And I should see "The <section heading> Archives"
    Examples:
    | section      | section heading |
    | Support      | support         |
    | Development  | development     |
    | Themes       | themes          |
    | Translations | translations    |
    | Consulting   | consulting      |

  Scenario Outline: Follow view archive for members only section
    Given I am on "/mailing-lists"
    When I clik on link "view archive" under section "<section>"
    Then I should see "<section heading> Private Archives Authentication"
    And I should see "Email address:"
    And I should see "Password:"
    Examples:
    | section        | section heading |
    | Webmasters     | webmasters      |
    | Infrastructure | infrastructure  |

  Scenario Outline: Follow mailman page and verify the page
    Given I am on "/mailing-lists"
    When I clik on link "mailman page" under section "<section>"
    Then I should see the following <texts>
    | texts          |
    | A list for     |
    | English (USA)  |
    | About          |
    | Using          |
    | Subscribing to |
    | Subscribers    |
    And I should see "<section heading>"
    Examples:
    | section        | section heading                                                    |
    | Support        | A list for support questions                                       |
    | Development    | A list for whover                                                  |
    | Themes         | A list for theme developers                                        |
    | Translations   | A list for translators                                             |
    | Consulting     | A list for Drupal consultants and Drupal service/hosting providers |
    | Webmasters     | A list for the webmasters at *.drupal.org                          |
    | Infrastructure | Drupal.org Infrastructure Maintainers                              |

  Scenario: Subscribe to mailing list: Empty validation
    Given I am on "/mailing-lists"
    When I press "Subscribe"
    Then I should see "E-mail address field is required"
    And the field "E-mail address" should be outlined in red

  Scenario: Subscribe to mailing list: Invalid email validation
    Given I am on "/mailing-lists"
    When I fill in "E-mail address" with random text
    And I press "Subscribe"
    Then I should see "Please enter a valid e-mail address"
    And the field "E-mail address" should be outlined in red

  Scenario: Subscribe to mailing list: Valid email but dont select any items
    Given I am on "/mailing-lists"
    When I fill in "E-mail address" with "myuser@example.com"
    And I press "Subscribe"
    Then I should see "You did not fill in the form properly"
    And I should not see "Please enter a valid e-mail address"

  Scenario: Subscribe to mailing list: Fill all fields
    Given I am on "/mailing-lists"
    When I fill in "E-mail address" with "myuser@example.com"
    And I check the box "support"
    And I check the box "development"
    And I press "Subscribe"
    Then I should see "You will receive confirmation emails for your subscriptions. Please read them carefully and follow the directions"

