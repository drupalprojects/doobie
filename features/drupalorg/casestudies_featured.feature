@casestudies @anon
Feature: Featured Drupal case studies
  In order to see best examples of sites made with Drupal
  As any user
  I should be able to browse Featured case studies section

  @timeout
  Scenario: View case study page
    Given that I am on the homepage
    When I follow "Sites Made with Drupal"
    Then I should see the heading "Drupal Case Studies"
    And I should see "Categories:"
    And I should not see the link "Add your case study"
    And I should not see the link "Case Study guidelines"
    And I should see the link "next"
    And I should see the link "last"
    And I should see the following <tabs>
    | tabs               |
    | Featured showcase  |
    | Community showcase |
    And I should see that the tab "Featured showcase" is highlighted
    And I should see the heading "Browse by category"
    And I should see at least "10" links in the "right sidebar"
    And I should see the link "Education"
    And I should see the link "Technology"
    And I should see at least "8" records

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

  Scenario Outline: Navigate into featured showcase categories
    Given I am on "/case-studies"
    When I follow "<category>" on the "right sidebar"
    Then I should not see "Page not found"
    And I should see "Categories:"
    And I should see at least "1" record
    And I should see "Category: <category>"
    Examples:
    | category      |
    | Education     |
    | Entertainment |
    | Healthcare    |

  Scenario: View individual case study from Featured section
    Given I am on "/case-studies"
    When I click on a case study image
    Then I should not see "Page not found"
    And I should see that the tab "Featured showcase" is highlighted
    And I should see the following <texts>
    | texts                                |
    | Why Drupal was chosen:               |
    | Completed Drupal site or project URL |
    | Key modules/theme/distribution used  |
    | Posted by                            |
    | Categories:                          |

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
