@community
Feature: Community Spotlight
  In order to exhibit the skills and capacities to the Drupal Community
  As a contributer
  I need to be able to create community spotlight and check its display once it is promoted

  Scenario: Create community spotlight as site user
    Given I am logged in as "site user"
    And I am on "/forum"
    And I follow "Community Spotlight"
    And I follow "Add new Forum topic"
    When I create a forum
    Then I should see the community spotlight title
    And I should see "has been created"

  @javascript
  Scenario: Admin promotes the community spotlight
    Given there is a new "Community Spotlight" forum topic
    And I am logged in as "admin test"
    And I edit the "community spotlight"
    And I wait until the page is loaded
    When I click "Publishing options"
    And I check the box "Promoted to front page"
    And I press "Save"
    And I wait until the page is loaded
    Then I should see the community spotlight title
    And I should see "has been updated"
    And I should see "Posted by site user"

  Scenario: Visit getting involved page and view heading and community spotlight link
    Given there is a new "Community Spotlight" forum topic
    And I am on "/community"
    When I follow "Getting Involved"
    Then I should see the heading "Community Spotlight"
    And I should see the community spotlight link

  Scenario: Visit community spotlight page and view the records
    Given there is a new "Community Spotlight" forum topic
    And I am on "/community"
    When I follow "Getting Involved"
    And I follow "View more community spotlights"
    Then I should see the heading "Community Spotlight"
    And I should see the community spotlight link
    And I should see at least "5" records


