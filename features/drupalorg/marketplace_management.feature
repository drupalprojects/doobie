@marketplace
Feature: Marketplace Management
  In order to manage marketplace listings
  As an authenticated user
  I should be able to search and filter the list of organization pages

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    And I am on "/drupal-services/manage"

  Scenario: Visit manage marketplace page and view text and links
    Then I should see the heading "Marketplace management"
    And I should see the following <links>
      | links                  |
      | Marketplace guidelines |
      | marketplace listings   |
      | training listings      |
      | Add your listing       |
    And I should see at least "5" records

  Scenario: Filter service provider list
    When I select the following <fields> with <values>
      | fields                   | values                                         |
      | Published                | Yes                                            |
      | Services listing request | Request listing in the Drupal services section |
      | Training section request | No request                                     |
      | Training listing         | Do not list                                    |
    And I select "Do not list" from field "Services listing"
    And I press "Apply"
    Then I should see at least "2" records
