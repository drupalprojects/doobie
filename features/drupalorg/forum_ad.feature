@community @forums @anon
Feature: Display ads in the Hosting support forum
  In order to get information about sponsors
  As any user
  I should see an Ad on the forum page

  Background:
    Given that I am on the homepage
    And I follow "Support"
    And I follow "Forums"

  Scenario: To navigate to the forum page
    When I follow "Hosting support"
    Then I should see the heading "Hosting support"
    And I should see the advertisment in the right sidebar
  
