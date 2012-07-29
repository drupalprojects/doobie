Feature: Search
In order to see a word definition
As a website user
I need to be able to search for a word

@javascript
Scenario: Searching for a page with autocompletion
 Given I am on "/project/issues"
  When I fill in "projects" with "Bluemarine"
  And I wait for the suggestion box to appear
  Then I should see "Bluemarine"
  And I should see "Bluemarine_smarty"
  And I should see "Bluemarine ETS"
  And I should see "Bluemarine Twig"
  And I should not see "Bluefreedom"

@javascript
Scenario: Searching for a page with autocompletion
 Given I am on "/project/issues"
 When I fill in "projects" with "Bluema"
  And I wait for the suggestion box to appear
  Then I should see "Bluemarine"
  And I should see "Bluemarine_smarty"
  And I should see "Bluemarine ETS"
  And I should see "Bluemasters"
  And I should not see "Bluefreedom"

@javascript
Scenario:Searching for a listed Entries
 Given I am on "/project/issues"
  When I fill in "projects" with "Userdashboard"
   Then I wait for the suggestion box to appear
   And I fill in "Project" with "Userdashboard"
   When I press "Search" to filter
   Then I wait "1000" seconds for the results to show
   And I should see the link "Userdashboard"
  
  
  
    


 
  





