Feature: Update the language of a user in his profile
  In order to update my known languages
  As a site user
  I should be able to select multiple languages and save the same

  Background:
    Given I am logged in as "site user"
    And I follow "Edit"

    Scenario: Select languages: First time
      When I follow "Personal information"
      And I select "Dutch" from "Languages spoken"
      And I additionally select "Ewe" from "Languages spoken"
      And I additionally select "Fiji" from "Languages spoken"
      And I press "Save"
      And I follow "View"
      Then I should see the following <texts>
      | texts |
      | Dutch |
      | Ewe   |
      | Fiji  |

    Scenario: Select languages: Second time
      When I follow "Personal information"
      And I additionally select "Czech" from "Languages spoken"
      And I additionally select "German" from "Languages spoken"
      And I additionally select "Hindi" from "Languages spoken"
      And I press "Save"
      And I follow "View"
      Then I should see the following <texts>
      | texts  |
      | Dutch  |
      | Ewe    |
      | Fiji   |
      | Czech  |
      | German |
      | Hindi  |
