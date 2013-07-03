@security @anon
Feature: Security announcements for contributed modules
  In order to know the security announcements for contributed modules
  As any user
  I should be able to view Security advisories page for contributed modules

  Scenario: View the security announcements page for contributed modules
    Given I am on the homepage
    When I follow "Security Info"
    Then I should see the heading "Security advisories"
    And I should see the heading "Security announcements"
    And I should be on "/security"
    And I follow "Contributed projects"
    And I should see at least "10" records
    And I should see the heading "Security announcements"
    And I should see the heading "Contacting the Security team"
    And I should be on "/security/contrib"
    And I should see the following <tabs>
    | tabs                         |
    | Drupal core                  |
    | Contributed projects         |
    | Public service announcements |
    And I should see that the tab "Contributed projects" is highlighted
    And I should see the following <texts>
    | texts                                                                         |
    | SA-CONTRIB                                                                    |
    | Posted by                                                                     |
    | Version:                                                                      |
    | Security advisories for third-party projects that are not part of Drupal core |
    | all security announcements are posted to                                      |
    | In order to report a security issue                                           |
    And I should see the following <links>
    | links                |
    | Read more            |
    | Drupal Security Team |
    | next                 |
    | last                 |
    | 2                    |
    And I should not see the link "previous"
    And I should not see the link "first"
    And I should not see "SA-CORE"

  Scenario: View paginated items: Second page
    Given I am on "/security/contrib"
    When I click on page "2"
    Then I should see the following <links>
    | links    |
    | first    |
    | previous |
    | next     |
    | last     |
    And I should see the heading "Security advisories"

  Scenario: View paginated items: Last page
    Given I am on "/security/contrib?page=2"
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "last"
    And I should not see the link "next"
    And I should see the heading "Security advisories"

  Scenario: View various parameters on Contributed projects page
    Given I am on "/security"
    When I follow "Contributed projects"
    Then I should see the following <texts>
    | texts             |
    | Advisory ID:      |
    | Project:          |
    | Version:          |
    | Date:             |
    | Security risk:    |
    | Exploitable from: |
    | Vulnerability:    |

  Scenario: View individual advisory
    Given I am on "/security/contrib"
    When I follow "Read more"
    Then I should not see "Page not found"
    And I should not see the link "Add new comment"
    And I should see "Posted by"
