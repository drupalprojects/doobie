@front @specific_text @javascript
Feature: View home page header
  In order to have access to different sections of drupal.org
  As any user
  I need to be able to view navigations links and site search field

  @anon @known_git6failure
  Scenario Outline: View header navigation links in header area
    Given I am on "<page>"
    And I should see the following <links> in "top header" area
    | links             |
    | Get Started       |
    | Community         |
    | Documentation     |
    | Support           |
    | Download & Extend |
    | Marketplace       |
    | About             |

    Examples:
    | page            |
    | /               |
    | /start          |
    | /community      |
    | /documentation  |
    | /support        |
    | /download       |
    | /about          |

  @anon @wip
  Scenario: View home page header banner link and texts
    Given I am on the homepage
    Then I should see that drupal banner is linked to the home page
    Then I should see the "text" "Come for the software, stay for the community" in "left header" area
    And I should see the "text" "Drupal is an open source content management platform powering millions of websites and applications." in "left header" area

  @anon @known_git6failure @wip
  Scenario Outline: View page header on other pages: Home page header text doesn't appear on other pages
    Given I am on "<page>"
    Then I should not see the "text" "Come for the software, stay for the community" in "left header" area
    And I should not see the "text" "Drupal is an open source content management platform powering millions of websites and applications." in "left header" area

    Examples:
    | page            |
    | /start          |
    | /community      |
    | /documentation  |
    | /support        |
    | /download       |
    | /about          |

  @anon @known_git7failure
  Scenario: View search box and filter options in header area
    Given I am on the homepage
    Then I should see the "text" "Search git7site.devdrupal.org" in "right header" area
    And I should see the "text" "Refine your search" in "right header" area
    And I should not see the "link" "Refine your search" in "right header" area
    And I should see the following <options> in "right header" area
    | options         |
    | All             |
    | Modules         |
    | Themes          |
    | Documentation   |
    | Forums & Issues |
    | Groups          |

  @anon @javascript @known_git7failure @wip
  Scenario Outline: View search filter options in header area on other pages
    Given I am on "<page>"
    And I wait until the page is loaded
    And I see the "link" "Refine your search" in "right header" area
    When I click "Refine your search"
    Then I should see the following <options> in "right header" area
    | options         |
    | All             |
    | Modules         |
    | Themes          |
    | Documentation   |
    | Forums & Issues |
    | Groups          |

    Examples:
    | page            |
    | /start          |
    | /community      |
    | /documentation  |
    | /support        |
    | /download       |
    | /about          |

  @anon @flaky @known_git7failure @wip
  Scenario Outline: View bottom header tabs anonymously
    Given I am on "<page>"
    Then I should see the following <tabs> in "bottom header" area
    | tabs              |
    | Drupal Homepage   |
    | Log in / Register |

    Examples:
    | page            |
    | /               |
    | /start          |
    | /community      |
    | /documentation  |
    | /support        |
    | /download       |
    | /about          |

  @flaky @known_git7failure @wip
  Scenario Outline: View bottom header tabs as authenticated user
    Given I am logged in as "site user"
    And I am on "<page>"
    Then I should see the following <tabs> in "bottom header" area
    | tabs                    |
    | Drupal Homepage         |
    | Your Dashboard          |
    And I should see the following <links> in "bottom header" area
    | links                   |
    | Logged in as site user  |
    | Log out                 |

    Examples:
    | page            |
    | /               |
    | /start          |
    | /community      |
    | /documentation  |
    | /support        |
    | /download       |
    | /about          |
