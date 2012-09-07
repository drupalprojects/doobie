Feature: Drupal case studies
  In order to see the Drupal case studies
  As any user
  I want to look for a link on the home page that takes me there

  @javascript
  Scenario: View the image slideshow
    Given that I am on the homepage
    When I follow "Sites Made with Drupal"
    Then I should see the heading "Drupal Case Studies"
    And I should see "1"
    And wait "2" seconds 
    And I should see "2"
    And wait "2" seconds
    And I should see "3" 
    And wait "2" seconds
    And I should see "4"

  @wip
  Scenario: To see the list of categories on the right sidebar
    Given I am on "/case-studies"
    Then I should see "7" links in the "right sidebar"
    And I should see the link "Education" at the "top" in the "right sidebar"
    And I should see the link "Technology" at the "bottom" in the "right sidebar"
    And I should see the heading "Browse by category"

  @wip
  Scenario: Browse the community showcase tab and look for pagination links
    Given I am on "/case-studies"
    When I follow "Community showcase"
    Then I should see at least "7" records
    And I should see the following <texts>
    | texts              |
    | Featured showcase  |
    | Community showcase |
    | Categories:        |
    | Browse by category |
    | next               |
    | last               |
    And I should not see the following <texts>
    | texts    |
    | previous |
    | first    |

  Scenario: Browse pagination links in community showcase page: Second page
    Given I am on "/case-studies/community?page=2"
    Then I should see "Drupal Case Studies"
    And I should see the following <links>
    | links    |
    | first    |
    | previous |
    | next     |
    | last     |

  Scenario: Browse pagination links in community showcase page: Last page
    Given I am on "/case-studies/community?page=2"
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "next"
    And I should not see the link "last"

  @wip
  Scenario: To see the list of categories on the right sidebar in community showcase page
    Given I am on "/case-studies/community"
    Then I should see "46" links in the "right sidebar"
    And I should see the link "All sectors" at the "top" in the "right sidebar"
    And I should see the link "Youth" at the "bottom" in the "right sidebar"

  Scenario Outline: Navigate into featured showcase categories
    Given I am on "/case-studies"
    When I follow "<category>"
    And I should see "Categories:"
    And I should not see "Page not found"
    And I should see "<category>"

    Examples:
    | category      |
    | Education     |
    | Entertainment |
    | Healthcare    |
    | International |
    | Journalism    |
    | Publishing    |

  Scenario Outline: Navigate into community showcase categories
    Given I am on "/case-studies/community"
    When I follow "<category>"
    And I should see "Categories:"
    And I should not see "Page not found"
    And I should see at least "1" record

    Examples:
    | category  |
    | Arts      |
    | Athletics |
    | Bikes     |
    | Blogging  |
    | Corporate |
    | Design    |

  @wip
  Scenario: Navigate into an individual case study
    Given I am on "/case-studies/community"
    When I click on a case study image
    Then I should not see "Page not found"
    And I should see "Categories"
    And I should see the following <texts>
    | texts                                |
    | Why Drupal was chosen:               |
    | Completed Drupal site or project URL |
    | Key modules/theme/distribution used  |
