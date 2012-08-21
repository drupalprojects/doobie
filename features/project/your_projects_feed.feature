Feature: Your Project Tab
  In order to easily manage the projects I've created
  As a project maintainer
  I should be able to view the issues associated with the Projects, created by the user.

  Scenario: Check the feed icon on Your Projects page
    Given I am logged in as "git vetted user"
    And I follow "Your Dashboard"
    And I follow "Your Projects"
    And I click on the feed icon
    Then I should see at least "2" feed items
    And I should see the text "test issue two" in the feed