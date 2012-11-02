@marketplace @wip
Feature: Marketplace Management
  In order to manage marketplace listings
  As an authenticated user
  I should be able to search and filter the list of organization pages

  Background:
    Given I am logged in as "site user"
    And I am on "/drupal-services/manage"

  Scenario: Visit manage marketplace page and view text and links    
    Then I should see the heading "Marketplace management"
    And I should see the following <links>
    | links                   |
    | Marketplace guidelines  |
    | marketplace listings    |
    | training listings       |
    | Add your listing        |
   And I should see at least "10" records

  Scenario: Filter service provider list
    When I select the following <fields> with <values>
    | fields                        | values                                          |
    | Published                     | Yes                                             |
    | Request for Services section  | Request listing in the Drupal services section  |
    | Services listing              | All providers                                   |
    | Request for Training section  | No request                                      |
    | Training listing              | Do not list                                     |
    And I press "Apply"
    Then I should see at least "3" records