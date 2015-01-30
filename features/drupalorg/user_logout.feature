@user
Feature: User log out
  In order to leave the site and prevent others from using my account
  As an authenticated user
  I should be able to log out

  @failing
  Scenario: Log in as Confirmed User and view links and texts
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    Then I should see the heading "Confirmed User"
    And I should see the following <links>
      | links                     |
      | Your Dashboard            |
      | Logged in as Confirmed User |
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

  Scenario: Confirmed User logs out
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    When I follow "Log out"
    Then I should be on "/"
    And I should see the link "Log in / Register"
    And I should not see the following <links>
      | links                     |
      | Your Dashboard            |
      | Logged in as Confirmed User |
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
      | Logged in as Confirmed User |
      | Log out                   |
      | Dashboard                 |
      | Your Posts                |
      | Your Commits              |
      | Your Issues               |
      | Your Projects             |
      | Profile                   |
      | View                      |
      | Edit                      |
