@community @anon
Feature: Ways to get involved with the Drupal community
  In order to participate in the Drupal community
  As any user
  I should find out how to get involved

  Scenario: Navigate to the Getting Involved page
    Given I am on the homepage
    When I follow "Community"
    And I follow "Getting Involved"
    Then I should see the heading "Getting Involved"
    And I should see the heading "Community Spotlight"
    And I should see the heading "Ways to Get Involved"
    And I should see "Drupal is an open source project built by a team of volunteers"

  Scenario: Open Getting involved guide
    Given I am on "/getting-involved"
    When I follow "Getting Involved Guide"
    Then I should see the heading "Getting Involved Guide"
    And I should see the text "Why get involved"
    And I should see the text "Ready to get involved"

  Scenario: View Community spotlight
    Given I am on the homepage
    When I follow "Getting Involved"
    Then I should see the heading "Community Spotlight"
    And I should see the link "Community Spotlight:"
    And I should see "Posted by"
    And I should see community member photo

  Scenario: View Ways to get involved block
    Given I am on the homepage
    When I follow "Getting Involved"
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

  Scenario: View Drupal.org activity block
    Given I am on the homepage
    When I follow "Getting Involved"
    Then the count of "people with Git accounts" should be greater than zero
    And the count of "Git commits this week" should be greater than zero
    And the count of "users on drupal.org" should be greater than zero
    And the count of "sites running Drupal" should be greater than zero
    And the count of "comments and issue followups" should be greater than zero
    And I should see "Drupal.org Activity"

  Scenario: View community spotlight
    Given I am on "/getting-involved"
    When I follow "View more community spotlights"
    Then I should be on "/community-spotlight"
    And I should see the heading "Community Spotlight"