Feature: Market place drupal training services
  In order to advertise the training sessions of my organization
  As an authenticated user
  I should be able to create the organization

  @anon
  Scenario: View training page
    Given I am on the homepage
    When I follow "Marketplace"
    And I follow "Training"
    Then I should see "Drupal training services"
    And I should see "For upcoming Trainings check"

  @known_git6failure @anon
  Scenario: View right sidebar navigation
    Given I am on the homepage
    When I visit "/training"
    Then I should see "Browse by country"
    And I should see at least "10" links in the "right sidebar"
    And I should not see the link "Add your listing"

  @anon
  Scenario: View events section
    Given I am on "/training"
    When I follow "Events section"
    Then I should see the heading "Upcoming events"
    And I should see the heading "Drupal Events Activity"
    And I should see the following <texts>
    | texts                         |
    | User group meeting            |
    | Drupalcon                     |
    | Drupalcamp or Regional Summit |
    | Training (free or commercial) |

  @anon 
  Scenario: Global training days that are currently running on the site
    Given I am on "/training"
    When I follow "Global Training Days 2012"
    Then I should see the heading "Learn Drupal: Global Training Days"
    And I should see "Global Training dates"
    And I should see "We had another great Global Training Day"

  @anon
  Scenario: Marketplace guidelines list
    Given I am on "/training"
    When I follow "Marketplace guidelines"
    Then I should see the heading "Marketplace guidelines"
    And I should see the heading "Drupal Services"
    And I should see the heading "Featured providers"
    And I should see the heading "Training"
    And I should see the heading "Hosting"

  Scenario: Add organization
    Given I am logged in as "site user"
    And I visit "/node/add/organization"
    And I see "Request improvements to vocabularies by"
    When I create a new organization
    Then I should see "has been created"

  @dependent @retest-after-next-build @clean_data
  Scenario: View the created training session
    Given I am logged in as "site user"
    And I follow "Your Dashboard"
    When I follow an issue of the project
    Then I should see "to the Training section"
    And I should see "has been posted"
    And I should see "Drupal.org webmasters"
    And I should see "Posted by site user"
