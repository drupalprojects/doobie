@anon
Feature: Drupal case studies
  In order to see the Drupal case studies
  As any user
  I want to look for a link on the home page that takes me there

  @timeout
  Scenario: Verify case study page
    Given that I am on the homepage
    When I follow "Sites Made with Drupal"
    Then I should see the heading "Drupal Case Studies"
    And I should not see the link "Add your case study"
    And I should not see the link "Case Study guidelines"

  @javascript
  Scenario: View the image slideshow
    Given that I am on the homepage
    When I follow "Sites Made with Drupal"
    Then I should not see the slideshow case studies in the view content
    And I should see "1"
    And wait "2" seconds
    And I should see "2"
    And wait "2" seconds
    And I should see "3"
    And wait "2" seconds
    And I should see "4"    

  Scenario: To see the list of categories on the right sidebar
    Given that I am on the homepage
    When I follow "Sites Made with Drupal"
    Then I should see at least "5" links in the "right sidebar"
    And I should see the link "Education"
    And I should see the link "Technology"
    And I should see the heading "Browse by category"

  Scenario: Browse the community showcase tab and look for pagination links
    Given I am on "/case-studies"
    When I follow "Community showcase"
    Then I should see at least "5" records
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

  Scenario Outline: Navigate into featured showcase categories
    Given I am on "/case-studies"
    When I follow "<category>"
    Then I should see "Categories:"
    And I should not see "Page not found"
    And I should see "Category: <category>"
    Examples:
    | category      |
    | Education     |
    | Entertainment |
    | Healthcare    |

  Scenario: To see the list of categories on the right sidebar in community showcase page
    Given that I am on the homepage
    When I follow "Sites Made with Drupal"
    And I follow "Community showcase"
    Then I should see at least "10" links in the "right sidebar"
    And I should see the link "Education"
    And I should see the link "Technology"

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
    Given I am on "/case-studies/community?page=2"
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "next"
    And I should not see the link "last"

  Scenario Outline: Navigate into community showcase categories
    Given I am on "/case-studies/community"
    When I follow "<category>"
    Then I should see "Categories:"
    And I should not see "Page not found"
    And I should see at least "1" record
    Examples:
    | category      |
    | Education     |
    | Entertainment |
    | Healthcare    |

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

  Scenario Outline: Follow tags
    Given I am on "/case-studies"
    When I follow the tag "<tagname>"
    Then I should see "Category: <tagname>"
    And I should see at least "1" record
    Examples:
    | tagname       |
    | Education     |
    | Entertainment |
    | Community     |
