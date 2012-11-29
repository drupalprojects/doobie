@front @wip
Feature: Drupal.org frontpage footer
  In order to have easy access to different sections of drupal.org
  As any user
  I should be able to see footer links

  @anon @known_git7failure
  Scenario Outline: View links and text in the footer
    Given I am on "<page>"
    Then I should see the "text" "Drupal is a registered trademark of Dries Buytaert" in "footer" area
    And I should see the following <links> in "footer" area
    | links                 |
    | Drupal News           |
    | Community             |
    | Get Started           |
    | Download & Extend     |
    | About                 |
    | registered trademark  |

    Examples:
    | page            |
    | /               |
    | /start          |
    | /community      |
    | /documentation  |
    | /support        |
    | /download       |
    | /about          |
