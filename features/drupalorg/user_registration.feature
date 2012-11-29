@user @anon
Feature: Register an account on Drupal.org with valid username and email
  In order to start using additional features of the site
  As any user
  I should be able to register on the site

  Background:
    Given that I am on the homepage
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

  @known_git6failure @javascript
  Scenario: Create an account
    When I follow "Create new account"
    And I fill in "Username" with random text
    And I fill in "E-mail address" with "samp5+foo@example.com"
    And I fill in "Full name" with random text
    And I fill in "First or given name" with random text
    And I fill in "Last name or surname" with random text
    And I select "United States" from "Country"
    And I press "Create new account"
    And I wait for "4" seconds
    Then I should see "Your password and further instructions have been sent to your e-mail address."

  @known_git6failure @javascript
  Scenario: Create a different user with the same Email Id
    When I follow "Create new account"
    And I fill in "Username" with random text
    And I fill in "E-mail address" with "samp5+foo@example.com"
    And I fill in "Full name" with random text
    And I fill in "First or given name" with random text
    And I fill in "Last name or surname" with random text
    And I select "United States" from "Country"
    And I press "Create new account"
    And I wait for "4" seconds
    Then I should see "The e-mail address samp5+foo@example.com is already registered."

  @known_git6failure @javascript
  Scenario: Create a different user with the similar Email Id(For ex:same+similar@example.com)
    When I follow "Create new account"
    And I fill in "Username" with random text
    And I fill in "E-mail address" with "samp5+bar@example.com"
    And I fill in "Full name" with random text
    And I fill in "First or given name" with random text
    And I fill in "Last name or surname" with random text
    And I select "United States" from "Country"
    And I press "Create new account"
    And I wait for "4" seconds
    Then I should see "An e-mail address similar to samp5+bar@example.com is already registered."

  @known_git6failure @javascript
  Scenario: Create a different user with the different Email Id
    When I follow "Create new account"
    And I fill in "Username" with random text
    And I fill in "E-mail address" with "samp545@example.com"
    And I fill in "Full name" with random text
    And I fill in "First or given name" with random text
    And I fill in "Last name or surname" with random text
    And I select "United States" from "Country"
    And I press "Create new account"
    And I wait for "4" seconds
    Then I should see "Your password and further instructions have been sent to your e-mail address."

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
    | example#5    |
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
    | address                    |
    | testuserforgi6.gmail.com   |
    | testuserforgi6gmail.com    |
    | testuserforgi6gmail.com@   |
    | test@user@forgi6@gmailcom  |