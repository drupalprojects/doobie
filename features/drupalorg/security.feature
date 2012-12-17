@security @anon
Feature: Security announcements
  In order to know latest security announcements
  As any user
  I should be able to view security advisories

  Scenario: Visit Security page and view texts and links
    Given I am on the homepage
    When I follow "Security Info"
    Then I should see the heading "Security advisories"
    And I should be on "/security"
    And I should see at least "10" records
    And I should see the heading "Security announcements"
    And I should see the heading "Contacting the Security team"
    And I should see the following <tabs>
    | tabs                         |
    | Drupal core                  |
    | Contributed projects         |
    | Public service announcements |
    And I should see that the tab "Drupal core" is highlighted
    And I should see the following <texts>
    | texts                                               |
    | also sent to the security announcements e-mail list |
    | SA-CORE                                             |
    | Posted by                                           |
    | Categories:                                         |
    | In addition to the news page                        |
    | In order to report a security issue                 |
    | Writing secure code                                 |
    | If you are a Drupal developer                       |
    | There are many useful                               |
    And I should see the following <links>
    | links                |
    | Read more            |
    | Drupal Security Team |
    | next                 |
    | last                 |
    | 2                    |
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

  Scenario: View various parameters on Security advisories page
    Given I am on the homepage
    When I follow "Security Announcements"
    Then I should see the following <texts>
    | texts             |
    | Advisory ID:      |
    | Project:          |
    | Version:          |
    | Date:             |
    | Security risk:    |
    | Exploitable from: |
    | Vulnerability:    |
    And I should be on "/security"

  Scenario: View individual advisory
    Given I am on "/security"
    When I follow "Read more"
    Then I should not see "Page not found"
    And I should not see the link "Add new comment"
    And I should see "Posted by"
    And I should see the heading "Description"
    And I should see the heading "Solution"
    And I should see the heading "Reported by"
    And I should see "Categories:"
