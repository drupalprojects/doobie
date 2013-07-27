@user @profile
Feature: Verify the DA membership block on a user profile
  In order to know the DA membership of a user
  As any user
  I should see the DA member badge block on the profile page

  @anon
  Scenario: See that the user is not a member: Site user
    Given I am on "/user/2360770"
    Then I should not see "is an individual member of the Drupal Association"
    And I should not see "My organization is a member of the Drupal Association"
    And I should not see "Page not found"
    And I should see "Member for"

  @anon @content
  Scenario: See that the user is not an individual member: Angie Byron (webchick)
    Given I am on "/user/24967"
    Then I should not see "is an individual member of the Drupal Association"
    And I should see "is an Organization Member of the Drupal Association"
    And I should not see "Hey! Want to support the Drupal Community"

  @anon @content
  Scenario: See that the user is an organization member and individual member: Larry Garfield (Crell)
    Given I am on "/user/26398"
    Then I should see "is an individual member of the Drupal Association"
    And I should see "is an Organization member of the Drupal Association"
    And I should not see "Hey! Want to support the Drupal Community"

  Scenario: See member block on own profile
    Given I am logged in as "site user"
    When I follow "Logged in as site user"
    Then I should see the heading "site user"
    And I should see "History"
    And I should see "Member for"
    And I should see "Hey! Want to support the Drupal Community"
