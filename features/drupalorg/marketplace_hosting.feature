@marketplace @anon @content
Feature: Drupal hosting providers
  In order to choose a Drupal hosting provider
  As a site builder
  I should be able to see categorized lists of hosting providers

  Scenario: View Shared hosting providers
    Given I am on the homepage
    When I follow "Marketplace"
    And I follow "Hosting"
    Then I should see the heading "Shared Hosting Providers"
    And I should see the following <texts>
      | texts                                     |
      | These hosting companies are great choices |
      | how to get your organization listed       |
    And I should see the following <tabs>
      | tabs     |
      | Services |
      | Hosting  |
      | Training |
    And I should see that the tab "Hosting" is highlighted
    And I should see at least "5" WebAds

  Scenario: View Enterprise and Managed hosting providers
    Given I am on "/hosting"
    When I follow "Enterprise & Managed"
    Then I should see the heading "Enterprise & Managed Hosting"
    And I should see "These hosting companies are great choices"
    And I should see at least "2" WebAds

  Scenario: View Platform as a Service hosting providers
    Given I am on "/hosting"
    When I follow "Platform as a Service"
    Then I should see the heading "Platform as a Service"
    And I should see "These hosting companies are great choices"
    And I should see at least "2" WebAds

  Scenario Outline: Visit links on hosting page and view corresponding headings
    Given I am on "/hosting"
    When I follow "<link>"
    Then I should be on "<url>"
    And I should see the heading "<heading>"

  Examples:
    | link                          | url                                                | heading                      |
    | Enterprise & Managed          | /hosting/enterprise                                | Enterprise & Managed Hosting |
    | Platform as a Service         | /hosting/paas                                      | Platform as a Service        |
    | Shared Hosting                | /hosting                                           | Shared Hosting Providers     |
    | Drupal.org advertising policy | https://association.drupal.org/advertising/hosting | Drupal Association Media Kit |
