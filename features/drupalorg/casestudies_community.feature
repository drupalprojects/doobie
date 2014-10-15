@casestudies @anon
Feature: Community case studies
  In order to see various examples of sites made with Drupal
  As any user
  I should be able to browse Community case studies section

  Scenario: Browse Community showcase tab and view pagination links
    Given I am on "/case-studies"
    When I follow "Community showcase"
    Then I should see at least "8" records
    And I should see the heading "Drupal Case Studies"
    And I should see the following <tabs>
      | tabs               |
      | Featured showcase  |
      | Community showcase |
    And I should see that the tab "Community showcase" is highlighted
    And I should see "Categories:"
    And I should see the following <links>
      | links |
      | next  |
      | last  |
    And I should not see the following <links>
      | links               |
      | previous            |
      | first               |
      | Add your case study |
    And I should see the text "Browse by category" in the "right sidebar" region
    And I should see at least "10" links in the "right sidebar"
    And I should see the link "Education"
    And I should see the link "Technology"
    And I should see an image for every case study

  Scenario: Browse pagination links in community showcase page: Second page
    Given I am on "/case-studies/community"
    When I click on page "2"
    Then I should see "Drupal Case Studies"
    And I should see the following <links>
      | links    |
      | first    |
      | previous |
      | next     |
      | last     |

  Scenario: Browse pagination links in community showcase page: Last page
    Given I am on "/case-studies/community"
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "next"
    And I should not see the link "last"

  Scenario Outline: Navigate into community showcase categories
    Given I am on "/case-studies/community"
    When I follow "<category>" in the "right sidebar" region
    Then I should not see "Page not found"
    And I should see "Categories:"
    And I should see at least "1" record
  Examples:
    | category      |
    | Education     |
    | Entertainment |
    | Healthcare    |

  @javascript
  Scenario: View individual case study from Community section
    Given I am on "/case-studies/community"
    When I click on a case study
    Then I should not see "Page not found"
    And I should see that the tab "Community showcase" is highlighted
    And I should see the following <texts>
      | texts                                             |
      | Why Drupal was chosen                             |
      | Posted by                                         |
      | Why these modules/theme/distribution were chosen: |
