@marketplace @anon
Feature: List of organizations providing hosting
  In order to see the list of Shared Hosting Providers for Drupal
  As a user
  I want to navigate to the page and browse the providers

  Scenario: View the hosting providers
    Given that I am on the homepage
    When I follow "Marketplace"
    And I follow "Hosting"
    And I should see the heading "Shared Hosting Providers"
    And I should see the following <texts>
    | texts |
    | This section lists organizations that provide Drupal hosting services |
    | Hosting Types |
    | Other great hosts that support Drupal |
    And I should see the following <links>
    | links |
    | Services |
    | Training |
    | Enterprise & Managed |
    | Platform as a Service |
    | Paid services |
    | Hosting support |
    | Drupal.org advertising policy |
    | Add your listing |

  Scenario: View other hosts
    Given I am on "/hosting"
    Then I should see the heading "Other great hosts that support Drupal"
    And I should see at least "5" records

  Scenario: View Enterprise and Managed page
    Given I am on "/hosting"
    When I follow "Enterprise & Managed"
    Then I should see the heading "Enterprise & Managed Hosting"
    And I should see the heading "Other great hosts that support Drupal"
    And I should see at least "6" records

  Scenario: View Platform as a Service page
    Given I am on "/hosting"
    When I follow "Platform as a Service"
    Then I should see the heading "Platform as a Service"
    And I should see the heading "Other great hosts that support Drupal"
    And I should see at least "3" records
