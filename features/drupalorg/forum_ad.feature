@forums @anon
Feature: Look for an Ad on the forum page
  In order to know the sponsors
  As a user
  I should look for an Ad on the forum page

  Background:
    Given that I am on the homepage
    And I follow "Support"
    And I follow "Forums"

  Scenario: To navigate to the forum page
    When I follow "Hosting support"
    Then I should see the heading "Hosting support"
    And I should see the advertisment in the right sidebar
  
