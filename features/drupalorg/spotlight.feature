@community @javascript @anon
Feature: Community Spotlight pages
  In order to find contributors to Drupal Community
  As any user
  I need to be able to check Spotlight pages of Melissa and Greg and search for Neil Drumm using the header search box
	
  @timeout
  Scenario: Browse to the Community Spotlight page
    Given I am on the homepage
    When I follow "Community"
    And I follow "Community Spotlight"
    Then I should see the heading "Community Spotlight"
    And I should see at least "8" records
    
  Scenario: Browse to Community Spotlight page of Melissa 
    Given I am on "/community-spotlight"
    When I follow "Community Spotlight: Melissa Anderson (eliza411)"
    Then I should see "Comments"
    And I should see "The migration NEVER would"
    And I should see "Great to see this!"
    
  Scenario Outline: Browse to the Community Spotlight page of Greg
    Given I am on "/community-spotlight"
    When I follow "Greg Knaddison (greggles)"
    Then I should see "Greg Knaddison (greggles)"
    And I should see <comments>
    Examples:
    | comments |
    | "Greg rocks" |
    | "+1 - Greg has been an" |
    | "g.d.o wouldn't be the same" |
    | "Profound respect for Greg's" |

  @known_git6failure	
  Scenario: Search and find Neil Drumm Community Spotlight
    Given I am on "/community-spotlight"
    When I search sitewide for "Neil Drumm"
    And I follow "Refine your search"
    And I check "Forums & Issues" 
    And I press "Search"
    Then I should not see "Your search yielded no results"
    And I should see "Community Spotlight: Neil Drumm"
    And I follow "Community Spotlight: Neil Drumm"
    And I should see "Community Spotlight: Neil Drumm"
    Then I move backward one page
    And I should see "Search results"
    Then I select <option> from "Sort by:" results will contain <text>
    | option | text |
    | "Type" | "Aten Design Group" |
    | "Date" | "Make better use of Grammar Parser" |
    | "Author" | "In an installed module I want to reposition a submit button next to select box or remove it." |
    | "Title" | "!password is not populated in slave user registration email"|
