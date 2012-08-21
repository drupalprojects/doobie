Feature: Check the Releases Tab and Project Short Name on Edit Sandbox Project
  In order to ensure that unsuspecting users don't access sandbox code 
  As a vetted user
  I should not be able to see the Releases tab and not be able to edit the Project Short Name

  Scenario: Visit Sandbox Project edit page
    Given I am logged in as "git vetted user"
    And I follow "Your Dashboard"
    And I follow "Your Projects"
    And I click the edit link for the first sandbox project from the list
    Then I should not see the Releases tab
    And I should see that the project short name is readonly