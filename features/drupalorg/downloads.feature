@downloads @known_git6failure @anon @wip
Feature: Download and Extend Drupal
  In order to download and extend Drupal
  As a sitebuilder
  I should be able to see download page and visit various links present

  Scenario: View Download & Extend page
    Given I am on the homepage
    When I follow "Download & Extend"
    Then I should be on "/download"
    And I should see the following <tabs>
    | tabs                   |
    | Download & Extend Home |
    | Drupal Core            |
    | Distributions          |
    | Modules                |
    | Themes                 |
    And I should see that the tab "Download & Extend Home" is highlighted
    And I should see "Download Drupal core files, and extend your site"
    And I should see the following <texts>
    | texts             |
    | Download & Extend |
    | Core              |
    | Distributions     |
    | Themes            |
    | Translations      |
    | Drupal Modules    |
    | Most installed    |
    | Module Categories |
    | New Modules       |
    | Module Index      |
    And I should see "Show only modules for Drupal version"	
  
  Scenario Outline: Visit links on Download & Extend page
    Given I am on "/download"
    When I follow "<link>"
    Then I should be on "<url>"

    Examples:
    | link                            | url                    |
    | Download Drupal 7               | /project/drupal        |
    | Download Drupal 6               | /project/drupal        |
    | Other Releases                  | /node/3060/release     |
    | More Information                | /project/drupal        |
    | Search for More Distributions   | /project/distributions |
    | Search for More Themes          | /project/themes        |
  
  Scenario: View the links under Translations
    Given I am on "/download"
    Then I should see the following <links> under "Translations"
    | links     |
    | Catalan   |
    | French    |
    | Hungarian |
    | Dutch     |
	
  Scenario: View all translations
    Given I am on "/download"
    And I follow "All Translations"
    Then I should see the heading "Translate"
    And I should see the heading "Drupal translations"
    And I should see "Install Drupal localized with translation"
    And the current url should be "localize.drupal.org"
