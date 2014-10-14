@community @clean_data
Feature: Community Spotlight
  In order to exhibit the skills and capacities to the Drupal Community
  As a contributer
  I need to be able to create community spotlight and check its display once it is promoted

  Scenario: Can navigate to add a spotlight
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I am on "/forum"
    When I follow "Community Spotlight"
    And I follow "Add new Forum topic"
    Then I should see "Create Forum topic"
    And I should not see "Access denied"

  @javascript @clean_data @failing
 Scenario: Admin can promote a community spotlight
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And there is a new "Community Spotlight" forum topic
    And I edit the "community spotlight"
    And I wait until the page is loaded
    When I click "Publishing options"
    And I check the box "Promoted to front page"
    And I press "Save"
    And I wait until the page is loaded
    Then I should see the community spotlight title
    And I should see "has been updated"
    And I should see "Posted by Trusted User"
    When I visit "/getting-involved"
    Then I should see the community spotlight link
    When I follow "View more community spotlights"
    Then I should see the community spotlight link
    And I should see at least "5" records
