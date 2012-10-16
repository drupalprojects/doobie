@security @anon
Feature: To view list of security announcements for contributed modules
  In order to know the security announcements for contributed modules
  As a user
  I should go to security advisories page of contributed modules

  Scenario: View the security announcements page for contributed modules
    Given that I am on the homepage
    When I follow "Security Info"
    Then I should see the heading "Security advisories"
    And I follow "Contributed projects"
    And I should see at least "10" records
    And I should see the heading "Security announcements"
    And I should see the heading "Contacting the Security team"
    And I should see the following <texts>
    | texts                                                                         |
    | SA-CONTRIB                                                                    |
    | Categories                                                                    |
    | Security advisories for third-party projects that are not part of Drupal core |
    And I should see the following <links>
    | links                        |
    | Drupal core                  |
    | Public service announcements |
    | Read more                    | 
    | Drupal Security Team         |
    And I should not see "SA-CORE" |

  Scenario: View paginated items: First page
    Given I am on "/security/contrib"
    Then I should see the following <links>
    | links |
    | next  |
    | last  |
    | 2     |
    And I should not see the link "previous"
    And I should not see the link "first"
    And I should see the heading "Security advisories"

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

  Scenario: Check for various parameters
    Given I am on "/security"
    When I follow "Contributed projects"
    Then I should see the following <texts>
    | texts            |
    | Advisory ID      |
    | Project          |
    | Version          |
    | Date             |
    | Security risk    |
    | Exploitable from |
    | Vulnerability    |

  Scenario: Check Read more link is working or not
    Given I am on "/security/contrib"
    When I follow "Read more"
    Then I should not see "Page not found"
    And I should see the heading "Description"
    And I should see the heading "Solution"
    And I should see the heading "Reported by"
