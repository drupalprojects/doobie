@user @profile
Feature: Manage user email addresses
  In order to manage my email addresses
  As an authenticated user
  I should be able to edit my profile and add or remove addresses

  Background:
    Given I am logged in as "site user"
    And I follow "Edit"

  Scenario: View page contents: Email address field not editable
    Then the "E-mail address" field should be "disabled"
    And I should see the following <texts>
    | texts               |
    | E-mail address      |
    | Location            |
    | Signature settings  |
    And I should see the following <links>
    | links            |
    | Account          |
    | Git access       |
    | Drupal           |
    | E-mail addresses |

  Scenario: Has at least one email address
    When I follow "E-mail addresses"
    Then I should see at least "1" email address
    And I should see "Confirmed"
    And I should see "Primary address"

  Scenario: Add one more email address: Invalid
    When I follow "E-mail addresses"
    And I enter "test" for field "Add new e-mail"
    And I press "Save"
    Then I should see "You must enter a valid e-mail address"

  Scenario: Add one more email address: Existing
    When I follow "E-mail addresses"
    And I enter "siteuser@happypunch.com" for field "Add new e-mail"
    And I press "Save"
    Then I should see "Entered address is already registered on this site"

  Scenario: Add one more email address: Valid
    When I follow "E-mail addresses"
    And I enter "siteuser1@example.com" for field "Add new e-mail"
    And I press "Save"
    Then I should see "has been added to your account. Check your e-mail in order to confirm this new address"

  Scenario: See at least one confirmed email address
    When I follow "E-mail addresses"
    And I follow "Delete"
    And I press "Delete"
    Then I should see at least "1" confirmed email address
    And I should see "has been removed from your account."
