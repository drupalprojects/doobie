@user
Feature: User log out
  In order to leave the site and prevent others from using my account
  As an authenticated user
  I should be able to log out

  @failing
  Scenario: Log in as Trusted User and view links and texts
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    Then I should see the heading "Trusted User"
    And I should see the following <links>
      | links                     |
      | Your Dashboard            |
      | Logged in as Trusted User |
      | Log out                   |
      | Dashboard                 |
      | Your Posts                |
      | Your Commits              |
      | Your Issues               |
      | Your Projects             |
      | Profile                   |
      | View                      |
      | Edit                      |
    And I should not see the following <links>
      | links                |
      | Log in / Register    |
      | Create new account   |
      | Log in               |
      | Request new password |
    And I should not see the following <texts>
      | texts    |
      | Username |
      | Password |

  Scenario: Trusted User logs out
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    When I follow "Log out"
    Then I should be on "/"
    And I should see the link "Log in / Register"
    And I should not see the following <links>
      | links                     |
      | Your Dashboard            |
      | Logged in as Trusted User |
      | Log out                   |

  @anon
  Scenario: Visit /user url anonymously
    Given I am not logged in
    When I visit "/user"
    Then I should see the heading "User account"
    And I should see the following <links>
      | links                |
      | Log in / Register    |
      | Create new account   |
      | Log in               |
      | Request new password |
    And I should see the following <texts>
      | texts    |
      | Username |
      | Password |
    And I should not see the following <links>
      | links                     |
      | Your Dashboard            |
      | Logged in as Trusted User |
      | Log out                   |
      | Dashboard                 |
      | Your Posts                |
      | Your Commits              |
      | Your Issues               |
      | Your Projects             |
      | Profile                   |
      | View                      |
      | Edit                      |
