@user @wip
Feature: User log out
  In order to leave the site
  As an authenticated user
  I should be able to log out

  Scenario: Log in as site user and view links and texts
    Given I am logged in as "site user"
    Then I should see the heading "site user"
    And I should see the following <links>
    | links                   |
    | Your Dashboard          |
    | Logged in as site user  |
    | Log out                 |
    | Dashboard               |
    | Your Posts              |
    | Your Commits            |
    | Your Issues             |
    | Your Projects           |
    | Profile                 |
    | View                    |
    | Edit                    |
    And I should not see the following <links>
    | links                 |
    | Log in / Register     |
    | Create new account    |
    | Log in                |
    | Request new password  |
    And I should not see the following <texts>
    | texts     |
    | Username  |
    | Password  |

  Scenario: Site user logs out
    Given I am logged in as "site user"
    When I follow "Log out"
    Then I should be on "/"
    And I should see the link "Log in / Register"
    And I should not see the following <links>
    | links                   |
    | Your Dashboard          |
    | Logged in as site user  |
    | Log out                 |

  @anon
  Scenario: Visit /user url anonymously
    Given I am not logged in
    When I visit "/user"
    Then I should see the heading "User account"
    And I should see the following <links>
    | links                 |
    | Log in / Register     |
    | Create new account    |
    | Log in                |
    | Request new password  |
    And I should see the following <texts>
    | texts     |
    | Username  |
    | Password  |
    And I should not see the following <links>
    | links                   |
    | Your Dashboard          |
    | Logged in as site user  |
    | Log out                 |
    | Dashboard               |
    | Your Posts              |
    | Your Commits            |
    | Your Issues             |
    | Your Projects           |
    | Profile                 |
    | View                    |
    | Edit                    |
    