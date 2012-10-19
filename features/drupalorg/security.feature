@security @anon
Feature: To view list of security announcements
  In order to know the security announcements
  As a user
  I should go to security advisories page

  Scenario: Visit Security Info page and view texts and links
    Given that I am on the homepage
    When I follow "Security Info"
    Then I should see the heading "Security advisories"
    And I should see at least "10" records
    And I should see the heading "Security announcements"
    And I should see the heading "Contacting the Security team"
    And I should see the following <texts>
    | texts |
    | Drupal core |
    | Categories: |
    | Writing secure code |
    | There are many useful |
    And I should see the following <links>
    | links |
    | Contributed projects |
    | Public service announcements |
    | Read more |
    | Drupal Security Team |
    | next |
    | last |
    | 2 |
    And I should not see the link "previous"
    And I should not see the link "first"

  Scenario: View paginated items: Second page
    Given I am on "/security"
    When I click on page "2"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should see the link "last"
    And I should see the heading "Security advisories"

  Scenario: View paginated items: Last page
    Given I am on "/security?page=2"
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "last"
    And I should not see the link "next"
    And I should see the heading "Security advisories"

  Scenario: View various parameters on Security Info page
    Given I am on the homepage
    When I follow "Security Info"
    Then I should see the following <texts>
    | texts |
    | Advisory ID: |
    | Project: |
    | Version: |
    | Date: |
    | Security risk: |
    | Exploitable from: |
    | Vulnerability: |

  Scenario: Read more
    Given I am on "/security"
    When I follow "Read more"
    Then I should not see "Page not found"
    And I should see the heading "Description"
    And I should see the heading "Solution"
    And I should see the heading "Reported by"

