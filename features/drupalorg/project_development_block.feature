Feature: Project Development Block
In order to get the information I need to contribute code effectively
As a git user
I need to be able to access links in the Development block
  
  Background:
    Given I am logged in as "git vetted user"
    And I follow "Your Projects"
    And I click the Full project link
  
  Scenario: Project Git instructions
    Then I should see the heading "Development"
    And I should see the following <links>
    | links                   |
    | View pending patches    |
    | Repository viewer       |
    | View commits            |
    | Report a security issue |
    | View change records     |
    And I should not see the link "Sandbox security policy"
  
  Scenario: View pending patches
    When I follow "View pending patches"
    Then I should see the text "Search issues for"
     
  Scenario: View Repository
    When I follow "Repository viewer"
    Then I should see the following <texts>
    | texts       |
    | summary     |
    | description |
    | owner       |
   
  Scenario: View Commits
    When I follow "View commits"
    Then I should see the text "Commits for"
    
  Scenario: View change records
   When I follow "View change records"
   Then I should see "Change records for"
   And I should see the following <texts>
   | texts                    |
   | Keywords                 |
   | Introduced in branch     |
   | Impacts                  |