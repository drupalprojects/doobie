@anon @wip @javascript @search
Feature: Visitor searches site and sorts the results
  In order to see relevant search results
  As a visitor to Drupal.org
  I want to sort search results by relevant terms

  Background:
    Given I am on "/search"
    And I search sitewide for "views"
    And I follow "Modules ("
    And I wait until the page loads

  @failing
  Scenario: Sort by Title
    When I select "Title" from "Sort by"
    And I see the results sorted in alphabetical order by project title
    And I click on page "2"
    And I see "results containing the words: views"
    Then I should see the results sorted in alphabetical order by project title

  @failing
  Scenario: Sort by Author
    When I select "Author" from "Sort by"
    And I see the results sorted in alphabetical order by project author
    And I click on page "3"
    And I see "results containing the words: views"
    Then I should see the results sorted in alphabetical order by project author

  @failing
  Scenario: Sort by Created date
    When I select "Created date" from "Sort by"
    And I see the results sorted by the project posted date
    And I click on page "3"
    And I see "results containing the words: views"
    Then I should see the results sorted by the project posted date

  # See https://drupal.org/node/1824900
  @slow @failing
  Scenario: Sort by most installed
    When I select "Most installed" from "Sort by"
    Then I should see "results containing the words: views"
    And I should see the results sorted by most installed modules

  #@slow
  #Scenario: Sort by last build
  #  When I select "Last build" from "Sort by"
  #  Then I should see "results containing the words: views"
  #  And I should see the results sorted by last build of the project

  @slow @failing
  Scenario: Sort by last release
    When I select "Last release" from "Sort by"
    Then I should see "results containing the words: views"
    And I should see the results sorted by latest release of the project
