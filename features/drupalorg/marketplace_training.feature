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

  @anon
  Scenario: Follow Global training days link
    Given I am on "/training"
    When I follow "Global Training Days"
    Then I should be on "/learn-drupal"

  Scenario: Follow Marketplace guidelines link
    Given I am logged in as "site user"
    And I am on "/training"
    When I follow "Marketplace guidelines"
    Then I should see the heading "Marketplace guidelines"
    And I should see the heading "Drupal Services"
    And I should see the heading "Featured providers"
    And I should see the heading "Training"
    And I should see the heading "Hosting"

  @anon
  Scenario: See a paged list of training providers
    Given I am on "/training"
    Then I should see at least "5" records
    And I should see the link "next"
    And I should see the link "last"
    And I should not see the link "previous"
    And I should not see the link "first"
    When I click on page "2"
    Then I should see at least "5" records
    And I should see the following <links>
    | links     |
    | first     |
    | previous  |
    | 1         |
    | 2         |
    And I should not see the link "next"
    And I should not see the link "last"

  @anon
  Scenario Outline: Visit marketplace training links and view corresponding headings
    Given I am on "/training"
    When I follow "<link>"
    Then I should be on "<url>"
    And I should see the heading "<heading>"

    Examples:
    | link           | url                        | heading        |
    | Acquia         | /marketplace/acquia        | Acquia         |
    | BuildAModule   | /node/1765802              | BuildAModule   |
    | Chapter Three  | /marketplace/chapter-three | Chapter Three  |
    | Commerce Guys  | /marketplace/commerce-guys | Commerce Guys  |
    | Druler         | /node/1791714              | Druler         |

  @anon
  Scenario: Visit marketplace links and view corresponding headings
    Given I am on "/training"
    And I should see "Browse by country"
    And I follow "Australia"
    And I should see "The following is a list of organizations that indicate they provide Drupal training services."
    When I follow training organization post
    Then I should see "Australia" under "Locations" heading