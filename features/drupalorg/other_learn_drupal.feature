@other @anon
Feature: Learn Drupal page
  In order to find out about Drupal Global Training Days program
  As any user
  I should be able to view Learn Drupal page

  Scenario: View the page and links
    Given I am on "/learn-drupal"
    Then I should see the heading "Learn Drupal: Global Training Days"
    And I should see "Drupal Global Training Days is an initiative"
    And I should see "Global Training dates"
    And I should see the link "Previous Global Training Days"
    And I should see the link "Add a Training"

  Scenario: Follow Add a Training link
    Given I am on "/learn-drupal"
    When I follow "Add a Training"
    Then I should see "Call for Training: Sign up to participate"
    And I should see "Pick an Offering"
    And I should see "Terms of Participation"
    And I should see "Curriculum"
    And I should see "Submit"
