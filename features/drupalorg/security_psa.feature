@security @anon
Feature: Security public service announcements
  In order to know the Security public service announcements
  As any user
  I should be able to view the list of such announcements

  Scenario: View the Security public service announcements
    Given that I am on the homepage
    When I follow "Security Info"
    Then I should see the heading "Security advisories"
    And I follow "Public service announcements"
    And I should be on "/security/psa"
    And I should see at least "5" records
    And I should see the heading "Security announcements"
    And I should see the heading "Contacting the Security team"
    And I should see the following <tabs>
    | tabs                         |
    | Drupal core                  |
    | Contributed projects         |
    | Public service announcements |
    And I should see that the tab "Public service announcements" is highlighted
    And I should see the following <texts>
    | texts                                                                 |
    | DRUPAL-PSA                                                            |
    | Submitted by                                                          |
    | Drupal version:                                                       |
    | Security-related announcements, such as information on best practices |
    | all security announcements are posted to                              |
    | In order to report a security issue                                   |
    And I should see the following <links>
    | links                |
    | Read more            |
    | Drupal Security Team |

  Scenario: View various parameters on Public service announcements
    Given I am on "/security/psa"
    When I follow "Public service announcements"
    Then I should see the following <texts>
    | texts             |
    | Advisory ID:      |
    | Project:          |
    | Version:          |
    | Date:             |
    | Security risk:    |
    | Exploitable from: |
    | Vulnerability:    |

  Scenario: View individual announcement
    Given I am on "/security/psa"
    When I follow "Read more"
    Then I should not see "Page not found"
    And I should not see the link "Add new comment"
    And I should see "Submitted by Drupal Security Team"
    And I should see the heading "Description"
    And I should see the heading "Solution"
    And I should see the heading "Reported by"
    And I should see "Drupal version:"
