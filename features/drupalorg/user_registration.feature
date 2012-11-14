@user @javascript @anon
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

  @known_git6failure
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

  @known_git6failure
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

  @known_git6failure
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

  @known_git6failure
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
