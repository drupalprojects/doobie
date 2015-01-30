@user @profile
Feature: Verify ssh keys of a user
  In order to add/edit/view ssh keys
  As an authenticated user
  I should edit my profile

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    And I follow "SSH keys"

  @failing
  Scenario: View page contents
    Then I should see "Need help with public keys? View the excellent GitHub.com SSH public key help"
    And I should see the link "Add a public key"
    And I should see the following <texts>
      | texts       |
      | Title       |
      | Fingerprint |
      | Operations  |

  @failing
  Scenario: Visit Add a public key link and view page contents
    When I follow "Add a public key"
    Then I should see the heading "Add a SSH key"
    And I should see the following <texts>
      | texts                                          |
      | Need help with public keys? View the excellent |
      | Title                                          |
      | Key                                            |
    And I should see the link "Cancel"

  @failing
  Scenario: Add a public key: Cancel
    When I follow "Add a public key"
    And I follow "Cancel"
    Then I should see the link "Add a public key"
    And I should not see "Key field is required"

  @failing
  Scenario: Add a public key: Blank validation
    When I follow "Add a public key"
    And I press "Save"
    Then I should see "Key field is required"
    And I should not see "Title field is required"
    And I should not see "has been saved"

  @failing
  Scenario: Add a public key: Dummy key
    When I follow "Add a public key"
    And I fill in "Key" with random text
    And I press "Save"
    Then I should see "The key is invalid"
    And I should not see "has been saved"

  @linux @failing
  Scenario: Add a public key: Invalid key
    When I follow "Add a public key"
    And I generate a ssh key
    And I fill in "Key" with a "invalid" ssh key
    And I press "Save"
    Then I should see "The key is invalid"
    And I should not see "has been saved"

  @linux @dependent @failing
  Scenario: Add a public key: Valid key
    When I follow "Add a public key"
    And I fill in "Key" with a "valid" ssh key
    And I press "Save"
    Then I should see "The SSH public key"
    And I should see "has been saved"
    And I should not see "The key is invalid"

  @linux @dependent @failing
  Scenario: Add a public key: Duplicate key validation
    When I follow "Add a public key"
    And I fill in "Key" with a "valid" ssh key
    And I press "Save"
    Then I should not see "The SSH public key"
    And I should not see "has been saved"
    And I should not see "The key is invalid"
    And I should see "The public key with fingerprint"
    And I should see "is already in use"

  @linux @dependent @failing
  Scenario: Delete a key: View delete page
    When I follow "Delete" for a key
    Then I should see "Are you sure you want to delete the public key"
    And I should see the link "Cancel"

  @linux @dependent @failing
  Scenario: Delete a key: Cancel
    When I follow "Delete" for a key
    And I follow "Cancel"
    Then I should see the link "Add a public key"
    And I should not see "The SSH public key"
    And I should not see "has been deleted"

  @linux @dependent @failing
  Scenario: Delete a key: Delete
    When I follow "Delete" for a key
    And I press "Delete"
    Then I should see "The SSH public key"
    And I should see "has been deleted"

  @linux @failing
  Scenario: Add another public key: Valid key
    When I follow "Add a public key"
    And I generate a ssh key
    And I fill in "Key" with a "valid" ssh key
    And I press "Save"
    Then I should see "The SSH public key"
    And I should see "has been saved"
    And I should not see "The key is invalid"

  @linux @failing
  Scenario: Edit a key title
    When I follow "Edit" for a key
    And I fill in "Title" with random text
    And I press "Save"
    Then I should not see "Key field is required"
    And I should see "The SSH public key"
    And I should see "has been saved"
