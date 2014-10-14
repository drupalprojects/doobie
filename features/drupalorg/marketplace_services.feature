@marketplace @anon
Feature: Browse Drupal services section
  In order to find Drupal service providers
  As any user
  I should be able to see the list of service providers in the Marketplace

  Scenario: Browse to the Marketplace page
    Given I am on the homepage
    When I follow "Marketplace"
    Then I should see the heading "Marketplace"
    And I should be on "/drupal-services"
    And I should see the following <texts>
      | texts                                                 |
      | Services                                              |
      | Sectors                                               |
      | Locations                                             |
      | Featured providers section lists companies which have |
      | Posted by                                             |
    And I should see the link "Marketplace guidelines"
    And I should see the link "Show more"
    And I should not see the link "Add your listing"

  Scenario: See a paged list of service providers
    Given I am on "/drupal-services"
    Then I should see at least "10" records
    And I should see the link "next"
    And I should see the link "last"
    And I should not see the link "previous"
    And I should not see the link "first"
    And I click on page "2"
    And I should see at least "10" records
    And I should see the following <links>
      | links    |
      | first    |
      | next     |
      | previous |
      | last     |
    When I click on page "last"
    Then I should see at least "1" record
    And I should see the following <links>
      | links    |
      | first    |
      | previous |
    And I should not see the link "next"
    And I should not see the link "last"

  Scenario: View All providers section
    Given I am on "/drupal-services"
    When I follow "All providers"
    Then I should see the heading "Marketplace"
    And I should be on "/drupal-services/all"
    And I should see the following <texts>
      | texts                                               |
      | Services                                            |
      | Sectors                                             |
      | Locations                                           |
      | All providers section lists companies which provide |
      | Posted by                                           |
    And I should see the link "Marketplace guidelines"
    And I should see the link "Show more"
    And I should not see the link "Add your listing"

  Scenario: View Feature providers section
    Given I am on "/drupal-services/all"
    When I follow "Featured providers"
    Then I should see the heading "Marketplace"
    And I should be on "/drupal-services/featured"
    And I should see "Posted by"
    And I should see "Featured providers section lists companies which have"
    And I should see the heading "Services"
    And I should see the link "Show more"

  @failing
 Scenario Outline: Visit marketplace links and view corresponding headings
    Given I am on "/drupal-services"
    When I follow "<link>"
    Then I should be on "<url>"
    And I should see the heading "<heading>"

  Examples:
    | link                                  | url                           | heading                               |
    | Working with Drupal service providers | /node/51169                   | Working with Drupal service providers |
    | Paid services                         | /paid-services                | Paid Drupal services                  |
    | Hosting support                       | /hosting-support              | Hosting support                       |
    | Jobs                                  | http://groups.drupal.org/jobs | Drupal Jobs                           |
    | Marketplace guidelines                | /node/1735708                 | Marketplace guidelines                |

  Scenario: View service provider from Featured section
    Given I am on "/drupal-services"
    And I follow "Featured providers"
    When I follow Featured providers title post
    Then I should see "This organization is a Featured services provider."

  Scenario: View service provider from All providers section
    Given I am on "/drupal-services"
    And I follow "All providers"
    When I follow All providers title post
    Then I should see "This organization is a Drupal services provider."
