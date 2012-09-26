@slow
Feature: Documents Management
  In order to see the list of documents
  As an authenticated user
  I should be able to search and filter the list

  Background:
   Given I am logged in as "docs manager"
   And I am on the homepage
   And I visit "/documentation/manage"
  
  @timeout
  Scenario: Search records by Comment count
    When I select "Is not equal to" from field "Comment count"
    And I enter "5" for field "Comment count"
    And I press "Apply"
    Then I should see at least "2" records
    And I should see "Yes"

  Scenario: Search records by Published: Yes
    When I select "Yes" from "Published"
    And I press "Apply"
    Then I should see at least "20" records
    And I should see "Yes" under "Published"
    And I should not see "No" under "Published"

  Scenario: Search records by Published: No
    When I select "No" from "Published"
    And I press "Apply"
    Then I should see at least "40" records
    And I should see "No" under "Published"
    And I should not see "Yes" under "Published"
    
  Scenario: Search records by Title
    When I fill in "git" for "Title contains"
    And I press "Apply"
    Then I should see at least "20" records
    And I should see "git" under "Title"
    
  Scenario: Search records by Top level book
    When I select "Contains" from field "Top level book"
    And I enter "guide" for field "top level book"
    And I press "Apply"
    Then I should see at least "10" records
    And I should see "guide" under "Top level book"
  
  Scenario: Search records by Page status: No known problems
    When I select "No known problems" from "Page status"
    And I press "Apply"
    Then I should see at least "10" records
    
  Scenario: Search records by Page status: Incomplete
    When I select "Incomplete" from "Page status"
    And I press "Apply"
    Then I should see at least "10" records
    
  Scenario Outline: Search records by Page status
    When I select "<value>" from "Page status"
    And I press "Apply"
    Then I should see at least "2" records
    Examples:
    | value             |
    | No known problems |
    | Incomplete        |
    | Insecure code     |
    
  Scenario Outline: Search records by Drupal version
    When I select "<version>" from "Drupal version"
    And I press "Apply"
    Then I should see at least "2" records
    Examples:
    | version               |
    | Drupal 4.5.x or older |
    | Drupal 4.6.x          |
    | Drupal 4.7.x          |
    | Drupal 5.x            |
    | Drupal 6.x            |
    | Drupal 7.x            |
    | Drupal 8.x            |
    
  Scenario Outline: Search records by Audience type
    When I select "<audience>" from "Audience type"
    And I press "Apply"
    Then I should see at least "2" records
    Examples:
    | audience                   |
    | Developers and coders      |
    | Documentation contributors |
    | Site administrators        |
    | Site builders              |
    | Site users                 |
    | Themers                    |
    
  Scenario Outline: Search records by Level
    When I select "<levels>" from "Level"
    And I press "Apply"
    Then I should see at least "2" records
    Examples:
    | levels       |
    | Beginner     |
    | Intermediate |
    | Advanced     |
  
  Scenario: Search by entering in all the fields
    When I select "Is between" from field "Comment count"
    And I enter "0" for field "Comment count minimum"
    And I enter "10" for field "Comment count maximum"
    And I select "Contains any word" from field "Top level book"
    And I enter "site" for field "top level book"
    And I fill in "git" for "Title contains"
    And I select the following <fields> with <values>
    | fields         | values                 |
    | Published      | Yes                    |
    | Page status    | No known problems      |
    | Drupal version | Drupal 6.x             |
    | Audience type  | Developers and coders  |
    | Level          | Intermediate |
    And I press "Apply"
    Then I should see at least "1" record
    
  Scenario: Search by entering in all the fields: No records
    When I select "Is less than" from field "Comment count"
    And I enter "0" for field "Comment count"
    And I press "Apply"
    Then I should see at least "0" records
  
  @wip
  Scenario: Verify pagination links: First page
    And I should see the following <links>
    | links |
    | next  |
    | last  |
    | 1     |
    | 2     |
    And I should not see the link "first"
    
  Scenario: Verify pagination links: Second page
    When I click on page "2"
    Then I should see the following <links>
    | links    |
    | first    |
    | previous |
    | 1        |
    | 3        |
    | next     |
    | last     |
   
  Scenario: Verify pagination links: Last page
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "last"
