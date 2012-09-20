Feature: Getting Involved with drupal community feature
  As a user
  I should be able to know how to get involved with drupal community.

  Scenario: To verify whether we are in getting involved page.
    Given I am on the homepage
    When I follow "Community"
    And I follow "Getting Involved"
    Then I should see the heading "Getting Involved"
    And I should see the heading "Community Spotlight"
    And I should see the heading "Ways to Get Involved"
    And I should see "Drupal is an open source project built by a team of volunteers"

  Scenario: To verify Getting involove guide
    Given I am on the homepage
    When I visit "/getting-involved"
    And I follow "Getting Involved Guide"
    Then I should see the heading "Getting Involved Guide"
    And I should see the text "Why get involved"
    And I should see the text "Ready to get involved"

  Scenario: To know about community spot light
    Given I am on the homepage
    When I visit "/getting-involved"
    Then I should see the heading "Community Spotlight"
    And I should see the link "Community Spotlight:"
    And I should see "Posted by"
    And I should see community member photo

  Scenario: To check for Right side block
    Given I am on the homepage
    When I visit "/getting-involved"
    Then I should see "Ways to Get Involved"
    And I should see the following <links>
    | links                 |
    | Forums                |
    | IRC                   |
    | Community Initiatives |
    | Modules               |
    | Themes                |
    | Translations          |
    | Groups                |
    | Events                |
    | Donate                |
    | Documentation         |
    | Drupal Association    |

  Scenario: To verify drupal org activity block records
    Given I am on the homepage
    When I visit "/getting-involved"
    Then the count of "people with Git accounts" should be greater than zero
    And the count of "Git commits this week" should be greater than zero
    And the count of "users on drupal.org" should be greater than zero
    And the count of "sites running Drupal" should be greater than zero
    And the count of "comments and issue followups" should be greater than zero