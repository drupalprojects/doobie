@community @forums @anon @javascript
Feature: Display of advertisements in Hosting support and Paid services forums
  In order to get information about sponsors
  As any user
  I should see an advertisement on the forum page

  Scenario: Advertisement in services hosting support page
    Given I am on the homepage
    And I follow "Support"
    And I wait until the page loads
    And I follow "Forums"
    And I wait until the page loads
    When I follow "Hosting support"
    Then I should see the heading "Hosting support"
    And I should see the "image" "advertisement" in "right sidebar" area

  Scenario: Advertisement in paid services page
    Given I am on "/forum"
    When I follow "Paid Drupal services"
    And I wait until the page loads
    Then I should see the "image" "advertisement" in "right sidebar" area
    And I should see the heading "Paid Drupal services"

  Scenario: Advertisement under individual paid service forum
    Given I am on "/forum"
    And I follow "Paid Drupal services"
    And I wait until the page loads
    And I see the heading "Paid Drupal services"
    When I follow a post
    Then I should see the "image" "advertisement" in "right sidebar" area
