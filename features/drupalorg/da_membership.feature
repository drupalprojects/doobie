@anon
Feature: Verify the DA membership block on a user profile
  In order to know the DA membership of a user
  As a user
  I should see the DA member badge block on their profile page

  Scenario: Check user is not a member: Site user
    Given I am on "/user/2244103"
    Then I should not see "is an individual member of the Drupal Association"
    And I should not see "My organization is a member of the Drupal Association"

  Scenario: Check user is an individual member only: Angie Byron (webchick)
    Given I am on "/node/3060/committers"
    When I follow "webchick"
    Then I should see "is an individual member of the Drupal Association"
    And I should not see "My organization is a member of the Drupal Association"
    And I should not see "Hey! Want to support the Drupal Community"

  Scenario: Check user is an organization member and individual member: Larry Garfield (Crell)
    Given I am on "/node/3060/committers"
    When I follow "Crell"
    Then I should see "is an individual member of the Drupal Association"
    And I should see "My organization is a member of the Drupal Association"
    And I should not see "Hey! Want to support the Drupal Community"
