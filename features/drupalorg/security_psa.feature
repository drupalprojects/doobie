@security @anon
Feature: To view list of Security public service announcements
  In order to know the Security public service announcements
  As a user
  I should go to Security public service announcements page

  Scenario: View the Security public service announcements
    Given that I am on the homepage
    When I follow "Security Info"
    Then I should see the heading "Security advisories"
    And I follow "Public service announcements"
    And I should see at least "5" records
    And I should see the heading "Security announcements"
    And I should see the heading "Contacting the Security team"
    And I should see the following <texts>
    | texts |
    | DRUPAL-PSA |
    | Categories: |
    | Security-related announcements, such as information on best practices. |
    | Posted by |
    And I should see the following <links>
    | links |
    | Drupal core |
    | Contributed projects |
    | Read more |
    | Drupal Security Team |

  Scenario: Visit Public service announcements page and view various parameters
    Given I am on "/security/psa"
    When I follow "Public service announcements"
    Then I should see the following <texts>
    | texts |
    | Advisory ID: |
    | Project: |
    | Version: |
    | Date: |
    | Security risk: |
    | Exploitable from: |
    | Vulnerability: |

  Scenario: Visit Read more and view the contents
    Given I am on "/security/psa"
    When I follow "Read more"
    Then I should not see "Page not found"
    And I should see the heading "Description"
    And I should see the heading "Solution"
    And I should see the heading "Reported by"
    And I should see "Posted by Drupal Security Team"
