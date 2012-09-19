Feature: Mailing list archives
  In order to discover the history of a mailing list discussion
  As a site visitor
  I need to be able to access mailing list archives

  Scenario: Visit list archives
    Given I am on the homepage
    When I follow "Community"
    And I follow "Mailing Lists"
    And I follow "view archive"
    Then I should see "The support Archives"

  Scenario: Visit list info
    Given I am on "mailing-lists"
    When I follow "mailman page"
    Then I should see "About support"
