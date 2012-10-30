@marketplace
Feature: Training section of the Marketplace
  In order to find companies which provider Drupal training
  As any user
  I should be able to browse Training section

  @anon
  Scenario: View training page
    Given I am on the homepage
    When I follow "Marketplace"
    And I follow "Training"
    Then I should see the heading "Marketplace"
	And I should be on "/training"
	And I should see "Drupal training services"
    And I should see "For upcoming Trainings check"
    And I should see "Browse by country"
    And I should see at least "3" links in the "right sidebar"
    And I should not see the link "Add your listing"

  @anon
  Scenario: Follow Events section link
    Given I am on "/training"
    When I follow "Events section"
    Then I should see the heading "Upcoming events"
    And I should see the heading "Drupal Events Activity"
    And I should see the following <texts>
    | texts                         |
    | User group meeting            |
    | DrupalCon                     |
    | Drupalcamp or Regional Summit |
    | Training (free or commercial) |

  @anon @specific_text
  Scenario: Follow Global training days link
    Given I am on "/training"
    When I follow "Global Training Days 2012"
    Then I should see the heading "Learn Drupal: Global Training Days"
    And I should see "Global Training dates"
    And I should see "Drupal Global Training Days is an initiative"

  Scenario: Follow Marketplace guidelines link
    Given I am logged in as "site user"
    And I am on "/training"
    When I follow "Marketplace guidelines"
    Then I should see the heading "Marketplace guidelines"
    And I should see the heading "Drupal Services"
    And I should see the heading "Featured providers"
    And I should see the heading "Training"
    And I should see the heading "Hosting"
