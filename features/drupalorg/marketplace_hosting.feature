@marketplace @anon @content
Feature: Drupal hosting providers
  In order to choose Drupal hosting provider
  As a sitebuilder
  I should be able to see lists of various types of hosting providers

  @javascript
  Scenario: View Shared hosting providers
    Given I am on the homepage
    When I follow "Marketplace"
    And I follow "Hosting"
    Then I should see the heading "Shared Hosting Providers"
    And I should see the heading "Hosting Types"
    And I should see the following <texts>
    | texts                                                                 |
    | The following hosting companies are great choices                     |
    | This section lists organizations that provide Drupal hosting services |
    | Forums                                                                |
    And I should see the following <tabs>
    | tabs     |
    | Services |
    | Hosting  |
    | Training |
    And I should see that the tab "Hosting" is highlighted
    And I should see at least "5" WebAds
    And I should see the heading "Other great hosts that support Drupal"
    And I should see at least "5" records

  @javascript
  Scenario: View Enterprise and Managed hosting providers
    Given I am on "/hosting"
    When I follow "Enterprise & Managed"
    Then I should see the heading "Enterprise & Managed Hosting"
    And I should see the heading "Hosting Types"
    And I should see "The following hosting companies are great choices"
    And I should see at least "2" WebAds
    And I should see the link "Add your listing"
    And I should see the heading "Other great hosts that support Drupal"
    And I should see at least "6" records

  @javascript
  Scenario: View Platform as a Service hosting providers
    Given I am on "/hosting"
    When I follow "Platform as a Service"
    Then I should see the heading "Platform as a Service"
    And I should see the heading "Hosting Types"
    And I should see "The following hosting companies are great choices"
    And I should see at least "1" WebAd
    And I should see the link "Add your listing"
    And I should see the heading "Other great hosts that support Drupal"
    And I should see at least "3" records

  Scenario Outline: Visit links on hosting page and view corresponding headings
    Given I am on "/hosting"
    When I follow "<link>"
    Then I should be on "<url>"
    And I should see the heading "<heading>"

    Examples:
    | link                          | url                                                | heading                      |
    | Enterprise & Managed          | /hosting/enterprise                                | Enterprise & Managed Hosting |
    | Platform as a Service         | /hosting/paas                                      | Platform as a Service        |
    | Shared hosts                  | /hosting                                           | Shared Hosting Providers     |
    | Drupal.org advertising policy | https://association.drupal.org/advertising/hosting | Drupal Association Media Kit |
    | Add your listing              | https://association.drupal.org/advertising/hosting | Drupal Association Media Kit |
    | Paid services                 | /paid-services                                     | Paid Drupal services         |
    | Hosting support               | /hosting-support                                   | Hosting support              |
    