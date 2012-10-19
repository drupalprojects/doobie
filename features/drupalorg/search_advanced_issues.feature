@anon @wip
Feature: Visitor searches issues and gets results from drupal site
  In order to see search issues in the related projects
  As a visitor to Drupal.org
  I want to search for the issues in the site

  @known_git6failure
  Scenario: Search for drupal issues
    Given that I am on the homepage
    When I search sitewide for "BDD"
    And I see "results containing the words: BDD"
    And I follow "Advanced Issues"
    Then I should see the heading "Issues"
    And I should see the following <texts>
    | texts        |
    | Search for   |
    | Project      |
    | Assigned     |
    | Submitted by |
    | Participant  |
    | Status       |
    | Priority     |
    | Category     |
    | Issue tags   |

  Scenario: Search for drupal issues
    Given I am on "/search/apachesolr_multisitesearch"
    When I fill in "Enter your keywords" with "homepage banner"
    And I press "Search" in the "content" region
    And I see "results containing the words: homepage banner"
    And I follow "Advanced Issues"
    Then I should see at least "5" records
    And I should see the following <texts>
    | texts        |
    | Project      |
    | Summary      |
    | Status       |
    | Priority     |
    | Category     |
    | Version      |
    | Replies      |
    | Last updated |
    | Assigned to  |
    | Created      |
    | Score        |
