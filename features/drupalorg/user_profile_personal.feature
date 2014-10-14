@user @profile
Feature: Personal information in user profile
  In order to share information about myself
  As an authenticated user
  I should be able to edit my profile and fill in personal information

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I follow "Edit"
    And I wait until the page is loaded

  @failing
 Scenario: Fill all the fields and save
    When I follow "Personal information"
    And I fill in the following:
      | Full name            | DrupalSiteUser                               |
      | First or given name  | Drupal                                       |
      | Last name or surname | Trusted User                                    |
      | My website           | http://en.wikipedia.org/wiki/drupalsiteuser  |
      | Interests            | opensource                                   |
      | IRC nick             | drupalsiteuser                               |
      | LinkedIn profile     | http://de.linkedin.com/in/drupalsiteuser     |
      | Facebook page        | http://www.facebook.com/drupalsiteuser       |
      | Twitter url          | http://twitter.com/drupalsiteuser            |
      | Google profile URL   | http://plus.google.com/109229333624640995186 |
      | Bio                  | DrupTrusted Userser                             |
    And I select the following <fields> with <values>
      | fields           | values  |
      | Languages spoken | Latvian |
      | Gender           | male    |
      | Country          | Latvia  |
    And I additionally select "Ewe" from "Languages spoken"
    And I additionally select "Czech" from "Languages spoken"
    And I press "Save"
    And I follow "View"
    Then I should see the following <texts>
      | texts            |
      | DrupalSiteUser   |
      | Drupal           |
      | Trusted User     |
      | drupalsiteuser   |
      | Latvian          |
      | Ewe              |
      | Czech            |
      | Drupal site user |
    And I should see the following <links>
      | links                                        |
      | http://en.wikipedia.org/wiki/drupalsiteuser  |
      | opensource                                   |
      | male                                         |
      | Latvia                                       |
      | http://de.linkedin.com/in/drupalsiteuser     |
      | http://www.facebook.com/drupalsiteuser       |
      | http://twitter.com/drupalsiteuser            |
      | http://plus.google.com/109229333624640995186 |

  @failing
 Scenario Outline: Visit gender and country links
    When I follow "View"
    And I follow "<link>"
    And I wait until the page is loaded
    Then I should be on "<path>"
    And I should see the heading "<text>"
    And I should see the link "site user"
  Examples:
    | link       | path                                | text                            |
    | opensource | profile/profile_interest/opensource | People interested in opensource |
    | male       | profile/profile_gender/male         | People who are male             |
    | Latvia     | profile/country/Latvia              | People who live in Latvia       |

  @failing
 Scenario Outline: Enter invalid values for fields that expect a url and save
    When I follow "Personal information"
    And I fill in "<field>" with "<value>"
    And I press "Save"
    And I wait until the page is loaded
    Then I should see "The value provided for <field> is not a valid URL"
  Examples:
    | field              | value                        |
    | My website         | DrupalSiteUser.com           |
    | LinkedIn profile   | Drupal LinkedIn Siteuser.com |
    | Facebook page      | Drupal Facebook Siteuser.com |
    | Twitter url        | Drupal Twitter Siteuser.com  |
    | Google profile URL | Drupal Google Siteuser.com   |
