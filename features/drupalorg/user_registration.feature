# https://drupal.org/node/2045095
@user @anon @wip
Feature: Register an account on Drupal.org with valid username and email
  In order to start using additional features of the site
  As any user
  I should be able to register on the site

  Background:
    Given I am on the homepage
    And I follow "Log in / Register"

  Scenario: Register to the site
    Then I should see the heading "User account"
    And I should see the following <links>
      | links                |
      | Create new account   |
      | Log in               |
      | Request new password |
    And I should see the following <texts>
      | texts    |
      | Username |
      | Password |

  Scenario: Create an account
    When I follow "Create new account"
    And I fill in "Username" with random text
    And I fill in "E-mail address" with "samp9+foo@example.com"
    And I fill in "Full name" with random text
    And I fill in "First or given name" with random text
    And I fill in "Last name or surname" with random text
    And I select "United States" from "Country"
    And I press "Create new account"
    Then I should see "A welcome message with further instructions has been sent to your e-mail address."

  Scenario: Create a different user with the same Email Id
    When I follow "Create new account"
    And I fill in "Username" with random text
    And I fill in "E-mail address" with "samp9+foo@example.com"
    And I fill in "Full name" with random text
    And I fill in "First or given name" with random text
    And I fill in "Last name or surname" with random text
    And I select "United States" from "Country"
    And I press "Create new account"
    And I wait until the page loads
    Then I should see "The e-mail address samp9+foo@example.com is already registered."

  Scenario: Create a different user with the similar Email Id(For ex:same+similar@example.com)
    When I follow "Create new account"
    And I fill in "Username" with random text
    And I fill in "E-mail address" with "samp9+bar@example.com"
    And I fill in "Full name" with random text
    And I fill in "First or given name" with random text
    And I fill in "Last name or surname" with random text
    And I select "United States" from "Country"
    And I press "Create new account"
    Then I should see "An e-mail address similar to samp9+bar@example.com is already registered."

  Scenario: Create a different user with the different Email Id
    When I follow "Create new account"
    And I fill in "Username" with random text
    And I fill in "E-mail address" with "samp949@example.com"
    And I fill in "Full name" with random text
    And I fill in "First or given name" with random text
    And I fill in "Last name or surname" with random text
    And I select "United States" from "Country"
    And I press "Create new account"
    Then I should see "A welcome message with further instructions has been sent to your e-mail address"

  Scenario Outline: Username validation: Valid username
    When I follow "Create new account"
    And I fill in "Username" with "<text>"
    And I press "Create new account"
    Then I should see "The username contains an illegal character"
    And the field "Username" should be outlined in red
  Examples:
    | text         |
    | example*123  |
    | ~example~    |
    | example#9    |
    | example%23   |
    | example(123) |

  Scenario: Username validation: Existing username
    When I follow "Create new account"
    And I fill in "Username" with "site user"
    And I fill in "E-mail address" with "testuserforgi6@example.com"
    And I press "Create new account"
    Then I should see "The name site user is already taken"
    And the field "Username" should be outlined in red

  Scenario Outline: Email address validation: Valid email address
    When I follow "Create new account"
    And I fill in "Username" with random text
    And I fill in "E-mail address" with "<address>"
    And I press "Create new account"
    Then I should see "The e-mail address <address> is not valid"
    And the field "E-mail address" should be outlined in red
  Examples:
    | address                   |
    | testuserforgi6.gmail.com  |
    | testuserforgi6gmail.com   |
    | testuserforgi6gmail.com@  |
    | test@user@forgi6@gmailcom |

  @known_git7failure
  Scenario: EmailAddress validation: In valid email address
    Given I am on the homepage
    And I follow "Log in / Register"
    When I follow "Create new account"
    And I fill in "Username" with "testsample161424"
    And I fill in "E-mail address" with "testsample161424@mailinator.com"
    And I select "United States" from "Country"
    And I press "Create new account"
    Then I should see "has been denied access"
    And the field "E-mail address" should be outlined in red
