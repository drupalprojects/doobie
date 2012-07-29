<?php

/**
 * Note: This is awful and makes us all feel filthy.  However,
 * some of our features need to run their scenarios sequentially
 * and we need a way to pass relevant data (like generated node id)
 * from one scenario to the next.  This class provides a simple
 * registry to pass data.  We need to either commit to this method
 * or find a different approach.  In the meantime This is at the top
 * of the file to nag the maintainers until they have an answer.
 */
abstract class HackyDataRegistry {
  public static $data = array();
  public static function set($name, $value) {
    self::$data[$name] = $value;
  }
  public static function get($name) {
    return self::$data[$name];
  }
}

use Behat\Symfony2Extension\Context\KernelAwareInterface;
use Behat\MinkExtension\Context\MinkContext;
use Behat\Behat\Context\ClosuredContextInterface,
    Behat\Behat\Context\TranslatedContextInterface,
    Behat\Behat\Context\BehatContext,
    Behat\Behat\Exception\PendingException;
use Behat\Gherkin\Node\PyStringNode,
    Behat\Gherkin\Node\TableNode;
use Symfony\Component\Process\Process;

use Behat\Behat\Context\Step\Given;
use Behat\Behat\Context\Step\When;
use Behat\Behat\Context\Step\Then;

require 'vendor/autoload.php';

/**
 * Features context.
 */
class FeatureContext extends MinkContext {

  /**
   * Current authenticated user.
   *
   * A value of FALSE denotes an anonymous user.
   */
  public $user = FALSE;

  /**
   * Keep track of all users that are created so they can easily be removed.
   */
  private $users = array();

  /**
   * Store a drush alias for tests requiring shell access.
   */
  private $drushAlias = FALSE;

  /** 
   * Store region ids
   */
  public $right_sidebar = "";
  private $home_bottom_right = '';

  /** 
   *Store rss feed xml content 
   */
  private $xmlContent = "";

  /**
   * Store project value
   */
  private $project_value = '';

  /**
   * Initializes context.
   *
   * Every scenario gets its own context object.
   *
   * @param array $parameters.
   *   Context parameters (set them up through behat.yml or behat.local.yml).
   */
  public function __construct(array $parameters) {
    if (isset($parameters['basic_auth'])) {
      $this->basic_auth = $parameters['basic_auth'];
    }
    $this->default_browser = $parameters['default_browser'];
    if (isset($parameters['drush_alias'])) {
      $this->drushAlias = $parameters['drush_alias'];
    }
    if (isset($parameters['drupal_users'])) {
      $this->drupal_users = $parameters['drupal_users'];
    }
  }

  /**
   * Run before every scenario.
   *
   * @BeforeScenario
   */
  public function beforeScenario($event) {
    if (isset($this->basic_auth)) {
      $driver = $this->getSession()->getDriver();
      if ($driver instanceof Behat\Mink\Driver\Selenium2Driver) {
        // Continue if this is a Selenium driver, since this is handled in
        // locatePath().
      }
      else {
        // Setup basic auth.
        $this->getSession()->setBasicAuth($this->basic_auth['username'], $this->basic_auth['password']);
      }
    }
  }

  /**
   * Check for shell access (via drush).
   *
   * @BeforeScenario @shellAccess
   */
  public function checkShellAccess() {
    // @todo check that this is a functioning alias.
    // See http://drupal.org/node/1615450
    if (!$this->drushAlias) {
      throw new pendingException('This scenario requires shell access.');
    }
  }

  /**
   * Run after every scenario.
   *
   * @AfterScenario
   */
  public function afterScenario($event) {
    // Remove any users that were created.
    if (!empty($this->users)) {
      foreach ($this->users as $user) {
        $process = new Process("drush @{$this->drushAlias} user-cancel --yes {$user->name} --delete-content");
        $process->setTimeout(3600);
        $process->run();
        if (!$process->isSuccessful()) {
          throw new RuntimeException($process->getErrorOutput());
        }
      }
    }
  }

  /**
   * Override MinkContext::locatePath() to work around Selenium not supporting
   * basic auth.
   */
  protected function locatePath($path) {
    $driver = $this->getSession()->getDriver();
    if ($driver instanceof Behat\Mink\Driver\Selenium2Driver && isset($this->basic_auth)) {
      // Add the basic auth parameters to the base url. This only works for
      // Firefox.
      $startUrl = rtrim($this->getMinkParameter('base_url'), '/') . '/';
      $startUrl = str_replace('://', '://' . $this->basic_auth['username'] . ':' . $this->basic_auth['password'] . '@', $startUrl);
      return 0 !== strpos($path, 'http') ? $startUrl . ltrim($path, '/') : $path;
    }
    else {
      return parent::locatePath($path);
    }
  }

  /**
   * @defgroup helper functions
   * @{
   */

  /**
   * Helper function to generate a random string of arbitrary length.
   *
   * Copied from drush_generate_password().
   *
   * @param int $length
   *   Number of characters the generated string should contain.
   *
   * @return string
   *   The generated string.
   */
  public function randomString($length = 10) {
    // This variable contains the list of allowable characters for the
    // password. Note that the number 0 and the letter 'O' have been
    // removed to avoid confusion between the two. The same is true
    // of 'I', 1, and 'l'.
    $allowable_characters = 'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    // Zero-based count of characters in the allowable list:
    $len = strlen($allowable_characters) - 1;

    // Declare the password as a blank string.
    $pass = '';

    // Loop the number of times specified by $length.
    for ($i = 0; $i < $length; $i++) {

      // Each iteration, pick a random character from the
      // allowable string and append it to the password:
      $pass .= $allowable_characters[mt_rand(0, $len)];
    }

    return $pass;
  }

  /**
   * Helper function to login the current user.
   */
  public function login() {
    // Check if logged in.
    if ($this->loggedIn()) {
      $this->logout();
    }

    if (!$this->user) {
      throw new Exception('Tried to login without a user.');
    }

    $this->getSession()->visit($this->locatePath('/user'));
    $element = $this->getSession()->getPage();
    $element->fillField('Username', $this->user->name);
    $element->fillField('Password', $this->user->pass);
    $submit = $element->findButton('Log in');
    if (empty($submit)) {
      throw new Exception('No submit button at ' . $this->getSession()->getCurrentUrl());
    }

    // Log in.
    $submit->click();

    if (!$this->loggedIn()) {
      throw new Exception("Failed to log in as user \"{$this->user->name}\" with role \"{$this->user->role}\".");
    }
  }

  /**
   * Helper function to logout.
   */
  public function logout() {
    $this->getSession()->visit($this->locatePath('/user/logout'));
  }

  /**
   * Determine if the a user is already logged in.
   */
  public function loggedIn() {
    $session = $this->getSession();
    $session->visit($this->locatePath('/'));

    // If a logout link is found, we are logged in. While not perfect, this is
    // how Drupal SimpleTests currently work as well.
    $element = $session->getPage();
    return $element->findLink('Log out');
  }

  /**
   * Private function for the whoami step.
   */
  private function whoami() {
    $element = $this->getSession()->getPage();
    // Go to the user page.
    $this->getSession()->visit($this->locatePath('/user'));
    if ($find = $element->find('css', '#page-title')) {
      $page_title = $find->getText();
      if ($page_title) {
        return $page_title;
      }
    }
    return FALSE;
  }

  /**
   * @} End of defgroup "helper functions".
   */

  /**
   * @defgroup mink extensions
   * @{
   * Wrapper step definitions to the Mink extensions in order to implement
   * alternate wording for tests.
   */

  /**
   * @Given /^(?:that I|I) am at "([^"]*)"$/
   */
  public function iAmAt($path) {
    // Use the Mink Extenstion step definition.
    return new Given("I am on \"$path\"");
  }

  /**
   * @Given /^(?:that I|I) am (?:on|at) the homepage$/
   */
  public function thatIAmOnTheHomepage() {
    // Use the Mink Extenstion step definition.
    return new Given("I am on homepage");
  }


  /**
   * @When /^I visit "([^"]*)"$/
   */
  public function iVisit($path) {
    // Use the Mink Extenstion step definition.
    return new Given("I am on \"$path\"");
  }


  /**
   * @When /^I click "([^"]*)"$/
   */
  public function iClick($linkname) {
    // Use the Mink Extenstion step definition.
    return new Given("I follow \"$linkname\"");
  }

  /**
   * @Given /^for "([^"]*)" I enter "([^"]*)"$/
   * @Given /^I enter "([^"]*)" for "([^"]*)"$/
   */
  public function forIenter($fieldname, $formvalue) {
    // Use the Mink Extenstion step definition.
    return new Given("I fill in \"$fieldname\" with \"$formvalue\"");
  }

  /**
   * @When /^I press the "([^"]*)" button$/
   */
  public function iPressTheButton($button) {
    // Use the Mink Extenstion step definition.
    return new Given("I press \"$button\"");
  }

  /**
   * @Then /^I should see the link "([^"]*)"$/
   */
  public function iShouldSeeTheLink($linkname) {
    $element = $this->getSession()->getPage();
    $result = $element->findLink($linkname);
    if (empty($result)) {
      throw new Exception("No link to " . $linkname . " on " . $this->getSession()->getCurrentUrl());
    }
  }

  /**
   * @Then /^I should not see the link "([^"]*)"$/
   */
  public function iShouldNotSeeTheLink($linkname) {
    $element = $this->getSession()->getPage();
    $result = $element->findLink($linkname);
    if ($result) {
      throw new Exception("The link " . $linkname . " was present on " . $session->getCurrentUrl() . " and was not supposed to be.");
    }
  }

  /**
   * @Then /^I should see the heading "([^"]*)"$/
   */
  public function iShouldSeeTheHeading($headingname) {
    $element = $this->getSession()->getPage();
    foreach (array('h1', 'h2', 'h3', 'h4', 'h5', 'h6') as $heading) {
      $results = $element->findAll('css', $heading);
      foreach ($results as $result) {
        if ($result->getText() == $headingname) {
          return;
        }
      }
    }
    throw new Exception("The text " . $headingname . " was not found in any heading " . $session->getCurrentUrl());
  }

  /**
   * @Then /^(?:I|I should) see the text "([^"]*)"$/
   */
  public function iShouldSeeTheText($text) {
    // Use the Mink Extension step definition.
    return new Given("I should see text matching \"$text\"");
  }

  /**
   * @Then /^I should not see the text "([^"]*)"$/
   */
  public function iShouldNotSeeTheText($text) {
    // Use the Mink Extension step definition.
    return new Given("I should not see text matching \"$text\"");
  }

  /**
   * @Then /^I should get a "([^"]*)" HTTP response$/
   */
  public function iShouldGetAHttpResponse($status_code) {
    // Use the Mink Extension step definition.
    return new Given("the response status code should be $status_code");
  }

  /**
   * @Then /^I should not get a "([^"]*)" HTTP response$/
   */
  public function iShouldNotGetAHttpResponse($status_code) {
    // Use the Mink Extension step definition.
    return new Given("the response status code should not be $status_code");
  }

  /**
   * @Given /^I check the box "([^"]*)"$/
   */
  public function iCheckTheBox($checkbox) {
    // Use the Mink Extension step definition.
    return new Given("I check \"$checkbox\"");
  }

  /**
   * @Given /^I uncheck the box "([^"]*)"$/
   */
  public function iUncheckTheBox($checkbox) {
    // Use the Mink Extension step definition.
    return new Given("I uncheck \"$checkbox\"");
  }

  /**
   * @When /^I select the radio button "([^"]*)" with the id "([^"]*)"$/
   * @TODO convert to mink extension.
   */
  public function iSelectTheRadioButtonWithTheId($label, $id) {
    $element = $this->getSession()->getPage();
    $radiobutton = $element->findById($id);
    if ($radiobutton === NULL) {
      throw new Exception('Neither label nor id was found');
    }
    $value = $radiobutton->getAttribute('value');
    $labelonpage = $radiobutton->getParent()->getText();
    if ($label != $labelonpage) {
      throw new Exception("Button with $id has label $labelonpage instead of $label.");
    }
    $radiobutton->selectOption($value, FALSE);
  }

  /**
   * @} End of defgroup "mink extensions"
   */

  /**
   * @defgroup drupal.org
   * @{
   * Drupal.org-specific step definitions.
   */

  /**
   * @When /^I clone the repo$/
   */
  public function iCloneTheRepo() {
    //mypath stores the last path visited in another iAmAt  step.
    $element = $this->getSession()->getPage();
    $result = $element->find('css', '#content div.codeblock code');
    if (!empty($result)) {
      $this->repo = $result->getText();
    }
    $process = new Process($this->repo);
    $process->setTimeout(3600);
    $process->run();
    if (!$process->isSuccessful()) {
      throw new RuntimeException('The clone did not work. - ' . $process->getErrorOutput());
    }
  }

  /**
   * @Then /^I should have a local copy of "([^"]*)"$/
   */
  public function iShouldHaveALocalCopyOf($repo) {
    if (!is_dir($repo)) {
      throw new Exception('The repo could not be found.');
    }
    $old_directory = getcwd();
    chdir($repo);
    $process = new Process('git log');
    $process->run();
    if (!$process->isSuccessful()) {
      throw new RuntimeException('The history for the repository could  not be found.' . $process->getErrorOutput());
    }
    chdir($old_directory);
    $process = new Process('rm -rf ' . $repo);
    $process->run();
    if (!$process->isSuccessful()) {
      throw new Exception('ouch.' . $process->getErrorOutput());
    }
  }

  /**
   * @Then /^I should see the project$/
   */
  public function iShouldSeeTheProject() {
    $element = $this->getSession()->getPage();
    $result = $element->hasContent($this->project);
    if ($result === FALSE) {
      throw new Exception("The text " . $this->project . " was not found " . $session->getCurrentUrl());
    }
  }

  /**
   * @When /^I search for "([^"]*)"$/
   */
  public function iSearchFor($searchterm) {
    $element = $this->getSession()->getPage();
    $element->fillField('edit-text', $searchterm);
    $submit = $element->findById('edit-submit');
    if (empty($submit)) {
      throw new Exception('No submit button at ' . $session->getCurrentUrl());
    }
    $submit->click();
  }

  /**
   * @When /^I search sitewide for "([^"]*)"$/
   */
  public function iSearchSitewideFor($searchterm) {
    $element = $this->getSession()->getPage();
    $element->fillField('edit-search-theme-form-1', $searchterm);
    $submit = $element->findById('search-theme-form-submit');
    if (empty($submit)) {
      throw new Exception('No submit button at ' . $session->getCurrentUrl());
    }
    $submit->click();
  }

  /**
   * @} End of defgroup "drupal.org"
   */

  /**
   * @defgroup drupal extensions
   * @{
   * Drupal-specific step definitions.
   */

  /**
   * @Given /^I am an anonymous user$/
   */
  public function iAmAnAnonymousUser() {
    // Verify the user is logged out.
    if ($this->loggedIn()) {
      $this->logout();
    }
  }

  /**
   * Creates and authenticates a user with the given role via Drush.
   *
   * @Given /^I am logged in as a user with the "([^"]*)" role$/
   */
  public function iAmLoggedInWithRole($role) {
    // Check if a user with this role is already logged in.
    if ($this->user && isset($this->user->role) && $this->user->role == $role) {
      return TRUE;
    }

    // Create user (and project)
    $name = $this->randomString(8);
    $pass = $this->randomString(16);

    // Create a new user.
    $process = new Process("drush @{$this->drushAlias} user-create --password={$pass} --mail=$name@example.com $name");
    $process->setTimeout(3600);
    $process->run();
    if (!$process->isSuccessful()) {
      throw new RuntimeException($process->getErrorOutput());
    }

    $this->users[] = $this->user = (object) array(
      'name' => $name,
      'pass' => $pass,
      'role' => $role,
    );

    if ($role == 'authenticated user') {
      // Nothing to do.
    }
    else {
      // Assign the given role.
      $process = new Process("drush @{$this->drushAlias} user-add-role \"{$role}\" {$name}");
      $process->setTimeout(3600);
      $process->run();
      if (!$process->isSuccessful()) {
        throw new RuntimeException($process->getErrorOutput());
      }
    }

    // Login.
    $this->login();

    return TRUE;
  }

  /**
   * Authenticates a user.
   *
   * @Given /^I am logged in as "([^"]*)" with the password "([^"]*)"$/
   */
  public function iAmLoggedInAsWithThePassword($username, $passwd) {
    $user = $this->whoami();
    if (strtolower($user) == strtolower($username)) {
      // Already logged in.
      return;
    }

    $element = $this->getSession()->getPage();

    if ($user != 'User account') {
      // Logout.
      $this->getSession()->visit($this->locatePath('/user/logout'));
    }

    // Go to the user page.
    $this->getSession()->visit($this->locatePath('/user'));
    // Get the page title.
    $page_title = $element->findByID('page-title')->getText();
    if ($page_title == 'User account') {
      // If I see this, I'm not logged in at all so log in.
      $element->fillField('Username', $username);
      $element->fillField('Password', $passwd);
      $submit = $element->findButton('Log in');
      if (empty($submit)) {
        throw new Exception('No submit button at ' . $session->getCurrentUrl());
      }
      // Log in.
      $submit->click();
      $user = $this->whoami();
      if (strtolower($user) == strtolower($username)) {
        // Successfully logged in.
        return;
      }
    }
    else {
      throw new Exception("Failed to reach the login page.");
    }

    throw new Exception('Not logged in.');
  }

  /**
   * Authenticates a user with password from configuration.
   *
   * @Given /^I am logged in as "([^"]*)"$/
   */
  public function iAmLoggedInAs($username) {
    if (empty($this->drupal_users[$username])) {
      throw new Exception('No configured password for user "' . $username . '".');
    }
    $password = $this->drupal_users[$username];
    $this->iAmLoggedInAsWithThePassword($username, $password);
  }

  /**
   * @} End of defgroup "drupal extensions"
   */

  /**
   * @Given /^I execute the commands$/
   */
  public function iExecuteTheCommands() {
    throw new PendingException();
  }

  /**
   * @When /^I create a "([^"]*)"$/
   */
  public function iCreateA($type) {
    if ($type != 'module' && $type != 'theme') {
      throw new PendingException('Only modules and themes have been implemented.');
    }
    $element = $this->getSession()->getPage();
    $result = $element->hasField('Project title');
    $this->projectTitle = $this->randomString(16);

    $element->fillField('Project title', $this->projectTitle);
    $element->fillField('Maintenance status', '13028');
    $element->fillField('Development status', '9988');
    $this->iSelectTheRadioButtonWithTheId('Modules', 'edit-project-type-14');
    $element->fillField('Description', $this->randomString(1000));
    $element->pressButton('Save');
  }

  /**
   * @Then /^I should see the project title$/
   */
  public function iShouldSeeTheProjectTitle() {
    $element = $this->getSession()->getPage();
    $element = $element->find('css', 'h1#page-subtitle');
    $versionControlTabPath = $this->getSession()
      ->getPage()
      ->findLink('Version control')
      ->getAttribute('href');
    HackyDataRegistry::set('version control path', $versionControlTabPath);
    if (empty($element) || strpos($element->getText(), $this->projectTitle) === FALSE) {
      throw new Exception('Project title not found where it was expected.');
    }
  }

  /**
   * @Given /^I am on the Version control tab$/
   */
  public function iAmOnTheVersionControlTab() {
    $path = $this->locatePath(HackyDataRegistry::get('version control path'));
    $this->getSession()->visit($path);
  }

  /**
   * @When /^I execute the codeblock$/
   */
  public function iExecuteTheCodeblock() {
    $element = $this->getSession()->getPage()->find('css', 'div.codeblock');
    $rawCommand = $element->getHTML();
    $rawCommand = str_replace('<br/>', '', $rawCommand);
    $rawCommand = str_replace('&gt;', '>', $rawCommand);
    $command = preg_replace('/<code>(.*)?<\/code>/U', '\1 ; ', $rawCommand);
    $process = new Process($command);
    $process->setTimeout(5);
    $process->run();
    if (!$process->isSuccessful()) {
      throw new Exception('Intiializing repository failed - Command: ' . $command . ' Error: ' . $process->getErrorOutput());
    }
  }

  /**
   * @Then /^the repository should be initialized$/
   */
  public function theRepositoryShouldBeInitialized() {
    throw new PendingException();
  }

  /**
   * @defgroup sandbox integration
   * @{
   * Steps added for sandbox feature files integration
   * TODO Place in the right defgroups
   */

   /**
   * @Given /^I should not see the following <texts>$/
   */
  public function iShouldNotSeeTheFollowingTexts(TableNode $table) {
    $page = $this->getSession()->getPage();
    $table = $table->getHash();
    foreach ($table as $key => $value) {
      $text = $table[$key]['texts'];
      if(!$page->hasContent($text) === FALSE) {
        throw new Exception("The text '" . $text . "' was found");
      }
    }
  }

  /**
   * @Given /^I should see the following <texts>$/
   */
  public function iShouldSeeTheFollowingTexts(TableNode $table) {
    $page = $this->getSession()->getPage();
    $table = $table->getHash();
    foreach ($table as $key => $value) {
      $text = $table[$key]['texts'];
      if($page->hasContent($text) === FALSE) {
        throw new Exception("The text '" . $text . "' was not found");
      }
    }
  }

  /**
  * @Given /^I should see the following <links>$/
  */
  public function iShouldSeeTheFollowingLinks(TableNode $table) {
    $page = $this->getSession()->getPage();
    $table = $table->getHash();
    foreach ($table as $key => $value) {
      $link = $table[$key]['links'];
      $result = $page->findLink($link);
      if(empty($result)) {
        throw new Exception("The link '" . $link . "' was not found");
      }
    }
  }

  /**
   * @Given /^I should not see the following <links>$/
   */
  public function iShouldNotSeeTheFollowingLinks(TableNode $table) {
    $page = $this->getSession()->getPage();
    $table = $table->getHash();
    foreach ($table as $key => $value) {
      $link = $table[$key]['links'];
      $result = $page->findLink($link);
      if(!empty($result)) {
        throw new Exception("The link '" . $link . "' was found");
      }
    }
  }

  /**
   * @When /^I select "([^"]*)" from field "([^"]*)"$/
   * This step is to be used when a label for a field is not recognized
   */
  public function iSelectFromField($value, $field) {
    $field = strtolower($field);
    if ($field == 'change node created')
      $field = 'created_op';
    elseif ($field == 'comment count')
      $field = 'edit-comment-count-op';
    elseif ($field == 'top level book')
      $field = 'edit-title-op';
    $mainContext = $this->getMainContext();
    $page = $mainContext->getSession()->getPage();
    $page->selectFieldOption($field, trim($value));
    if (empty($page))
      throw new Exception("Unable to select the text");
  }

  /**
   * @Given /^I enter "([^"]*)" for field "([^"]*)"$/
   * This step is to be used when a label for a field is not recognized
   */
  public function iEnterForField($value, $field) {
    $field = strtolower($field);
    if ($field == "created date")
      $field = "edit-created-value";
    elseif ($field == "start date")
      $field = "edit-created-min";
    elseif ($field == "end date")
      $field = "edit-created-max";
    elseif ($field == "key modules/theme/distribution used")
      $field = "edit-field-module-0-nid-nid";
    elseif ($field == "issues")
      $field = "edit-field-issues-0-nid-nid";
    elseif ($field == "comment count")
      $field = "edit-comment-count-value";
    elseif ($field == "top level book")
      $field = "edit-title";
    elseif ($field == "comment count minimum")
      $field = "edit-comment-count-min";
    elseif ($field == "comment count maximum")
      $field = "edit-comment-count-max";
    return new Given("I fill in \"$field\" with \"$value\"");
  }

  /**
   * @When /^I click on page "([^"]*)"$/
   * Used to test pager links
   */
  public function iClickOnPage($pager) {
    $class = "";
    $page = $this->getSession()->getPage();
    $result = $page->findAll('css', '.pager .pager-item a');
    foreach ($result as $temp) {
      if (trim($temp->getText()) == trim($pager)) {
        $href = $temp->getAttribute("href");
        $this->getSession()->visit($href);
        return;
      }
    }
    // make sure we look at pager links only
    if ($pager == "first" || $pager == "previous" || $pager == "next" || $pager == "last") {
      $class = '.pager .pager-' . $pager . ' a';
    }
    else {
      throw new Exception("The page '" . $pager . "' was not found");
    }
    $result = $page->find('css', $class);
    $href = $result->getAttribute("href");
    $this->getSession()->visit($href);
  }

  /**
   * @When /^I click the table heading "([^"]*)"$/
   */
  public function iClickTheTableHeading($column) {
    // make sure we click on the table heading and not any other link
    $count = 0;
    $page = $this->getSession()->getPage();
    // all table headings of a view have this class - view -> views-table -> th
    $heading = $page->findAll('css', '.view table.views-table th a');
    if (sizeof($heading)) {
      foreach ($heading as $text) {
        if ($text->getText() == $column) {
          $count++;
          $href = $text->getAttribute("href");
          $this->getSession()->visit($href);
          break;
        }
      }
      if ($count == 0) {
        throw new Exception("The page does not have a table with the
         heading '" . $column . "'");
      }
    }
    else {
      throw new Exception("The page has no table headings");
    }
  }

  /**
   * @Then /^I should see "([^"]*)" sorted in "([^"]*)" order$/
   */
  public function iShouldSeeSortedInOrder($column, $order)
  {
    $column_class = "";
    $count = 0;
    $date = FALSE;
    $page = $this->getSession()->getPage();
    $heading = $page->findAll('css', '.view table.views-table th');
    foreach ($heading as $text) {
      if ($text->getText() == $column) {
        $count = 1;
        $class = $text->getAttribute("class");
        $temp = explode(" ", $class);
        $column_class = $temp[1];
        break;
      }
    }
    if ($count == 0) {
      throw new Exception("The page does not have a table with column '" . $column . "'");
    }
    $count = 0;
    $items = $page->findAll('css', '.view table.views-table tr td.'.$column_class);
    // make sure we have the data
    if (sizeof($items)) {
      // put all items in an array
      $loop = 1;
      //date_default_timezone_set ("UTC");
      foreach ($items as $item) {
        $text = $item->getText();
        if ($loop == 1) {
          // check if the text is date field
          if ($this->isStringDate($text)) {
            $date = TRUE;
          }
        }
        if ($date) {
          $orig_arr[] = $this->isStringDate($text);
        }
        else {
          $orig_arr[] = $text;
        }
        $loop = 2;
      }
      // create a temp array for sorting and comparing
      $temp_arr = $orig_arr;
      // sort
      if ($order == "ascending") {
        if ($date) {
          sort($temp_arr, SORT_NUMERIC);
        }
        else {
          sort($temp_arr);
        }
      }
      elseif ($order == "descending") {
        if ($date) {
          rsort($temp_arr, SORT_NUMERIC);
        }
        else {
          rsort($temp_arr);
        }
      }
      // after sorting, compare each index value of temp array & original array
      for ($i = 0; $i < sizeof($temp_arr); $i++) {
        if ($temp_arr[$i] == $orig_arr[$i]) {
          $count++;
        }
      }
      // if all indexs match, then count will be same as array size
      if ($count == sizeof($temp_arr)) {
       return true;
      }
      else {
        throw new Exception("The column '" . $column . "' is not sorted in " . $order . " order");
      }
    }
    else {
      throw new Exception("The column '" . $column . "' is not sorted in " . $order . " order");
    }
  }

  /**
   * Function to check whether the given string is a date or not
   * @param $string String The string to be checked for
   * @return $return String/Bool - Return timestamp if it is date, false otherwise
   */
  public function isStringDate($string) {
    $return = "";;
    $string = trim($string);
    if ($string) {
      $time = strtotime($string);
      if ($time === FALSE) {
        $return = FALSE;
      }
      elseif(is_numeric($time) && strlen($time) == 10) {
        return $time;
      }
      else {
        $return = FALSE;
      }
    }
    else {
      $return = FALSE;
    }
    return $return;
  }

  /**
   * @When /^I click on the feed icon$/
   * Works only with Goutte as ResponseHeaders are not supported by Selenium
   */
  public function iClickOnTheFeedIcon() {
    $page = $this->getSession()->getPage();
    $result = $page->find('css', '.feed-icon');
    if (empty($result)) {
      throw new Exception("This page does not have a feed icon");
    }
    $result->click();
    //use response headers to make sure we got the xml data and not html
    $responseHeaders = $this->getSession()->getResponseHeaders();
    if (strpos($responseHeaders['Content-Type'], "application/rss+xml") === FALSE) {
      throw new Exception("This page '" . $this->getSession()->getCurrentUrl() .
       "' does not provide xml data");
    }
    // Use goutedriver get content to get the complete xml data and store it
    //temporarily in a variable for use by function iShouldSeeTheTextInTheFeed()
    $this->xmlContent =
     $this->getSession()->getDriver()->getClient()->getResponse()->getContent();
  }
  /**
   * @Then /^I should see the text "([^"]*)" in the feed$/
   */
  public function iShouldSeeTheTextInTheFeed($text) {
    $xmlString = trim($this->xmlContent);
    if ($xmlString) {
      if (strpos($xmlString, trim($text)) === FALSE) {
        throw new Exception("The text '" . $text . "' was not found in the
         xml feed");
      }
    }
    else {
      throw new Exception("No xml data found");
    }
  }

  /**
   * @Given /^I should see at least "([^"]*)" feed items$/
   */
  public function iShouldSeeAtLeastFeedItems($count) {
    $count = (int) $count;
    $xmlString = trim($this->xmlContent);
    if ($xmlString) {
      $match = preg_match_all("/<item>/", $xmlString, $matches);
      // checks whether $count items were present in the xml feed or not
      // if count > 0, then match should be >= count
      if ($count) {
        if ($match < $count) {
          throw new Exception('The feed contains less than ' . $count .
           ' feed items');
        }
      }
      // if count = 0, then no feeds should be found
      elseif ($match > 0) {
        throw new Exception('The feed contains more than ' . $count .
         ' feed items');
      }
    }
  }

  /**
   * @Given /^I fill in "([^"]*)" with random text$/
   */
  public function iFillInWithRandomText($label)
  {
    // A @Tranform would be more elegant.
    $randomString = $this->randomString();
    $step = "I fill in \"$label\" with \"$randomString\"";
    return new Then($step);
  }

  /**
   * @Given /^I should see at least "([^"]*)" records$/
   */
  public function iShouldSeeAtLeastRecords($count) {
    $element = $this->getSession()->getPage();
    // counts the number of rows in the view table
    $records = $this->getViewDisplayRows($element);
    if ($records == "" || sizeof($records) < $count) {
        throw new Exception("The page (" . $this->getSession()->getCurrentUrl() .
         ") has less than " . $count . " records");
    }
  }

  /**
   * Function to get the array of records from the current view listing
   * @param $page Object The page object to look into
   * @return $result Array An array of items
  */
  private function getViewDisplayRows($page) {
    $result = "";
    $classes = array(
      'table' => '.view table.views-table tr',
      'grid' => '.view table.views-view-grid tr td',
      'row' => '.view div.views-row'
    );
    foreach ($classes as $type => $class) {
      $result = $page->findAll('css', $class);
      if (!empty($result)) {
        break;
      }
    }
    return $result;
  }

  /**
    * @When /^I press "([^"]*)" to filter$/
    * TODO this should work generically to exclude the sitewide search
    */
  public function iPressToFilter($arg1) {
    $element = $this->getSession()->getPage();
    $submit = $element->findById('edit-submit-project-issue-all-projects');
   /* if (empty($submit)) {
      throw new Exception('No submit button at ' . $session->getCurrentUrl());
    }*/
    if(!($submit->click())) {
      throw new Exception('No Click happened at ' . $this->getSession()->getCurrentUrl());
    }
   }

  /**
    * @When /^I press search to filter$/
    */
  public function iPressSearchToFilter()
   {
    $button = 'edit-submit-project-issue-all-projects';
    $element = $this->getSession()->getPage();
    $element->fillField('Project', $this->project_value);
    //$submit = $element->findById('edit-submit-project-issue-all-projects');
    $submit = $element->findButton($button);
    if (empty($submit)) {
      throw new Exception('No submit button at ' . $this->getSession()->getCurrentUrl());
    }
    $element->pressButton($button);

   }


   /**
    * @Then /^I wait for the suggestion box to appear$/
    */
  public function iWaitForTheSuggestionBoxToAppear() {
    $seconds = 1;
    $this->iWaitForSeconds($seconds, "$('#edit-search-term-results').children().length > 0");
  }

  /**
  * @Given /^(?:|I )wait (?:|for )"([^"]*)" second(?:|s)$/
  */
  public function iWaitForSeconds($seconds, $condition = "") {
    $milliseconds = (int) ($seconds * 1000);
    $this->getSession()->wait($milliseconds, $condition);
  }

  /**
  * @When /^I click on a case study image$/
  */
  public function iClickOnACaseStudyImage() {
    $page = $this->getSession()->getPage();
    $result = $page->find('css', '.view-content .col-first a');
    if (empty($result)) {
      throw new Exception("This page does not have any case study");
    }
    $result->click();
  }

 /**
   * @Given /^I should see the link "([^"]*)" at the "([^"]*)" in the right sidebar$/
   */
  public function iShouldSeeTheLinkAtTheInTheRightSidebar($link, $position) {
    $mainContext = $this->getMainContext();
    $page = $mainContext->getSession()->getPage();
    $error = 0;
    $curr_url = $mainContext->getSession()->getCurrentUrl();
    $message = "The page ".$curr_url." did not contain the specified texts";
    $nodes = $page->findAll("css", $mainContext->right_sidebar." .item-list a");
    if (sizeof($nodes)) {
      // get all the categories
      foreach ($nodes as $node) {
        $categories[] = $node->getText();
      }
      // check for firt element
      if ($position == "top") {
        if ($link != $categories[0]) {
          $error = 1;
        }
      }
      // check for last element
      elseif ($position == "bottom") {
        if($link != $categories[sizeof($categories) - 1]) {
          $error = 1;
        }
      }
      if ($error == 1) {
        $message = "The page " . $curr_url . " does not contain '" .
        $link . "' in " . $position . " position";
      }
      else {
        return true;
      }
    }
    throw new Exception($message);
  }

  /**
   * @Then /^I should see "([^"]*)" links on the right sidebar$/
   */
  public function iShouldSeeLinksOnTheRightSidebar($count) {
    $page = $this->getSession()->getPage();
    $nodes = $page->findAll("css", $this->right_sidebar." .item-list a");
    if (sizeof($nodes) == $count) return true;
      throw new Exception('Found ' . sizeof($nodes) . ' links instead of ' .
      $count . ' links on the right sidebar');
  }

  /**
  * @When /^I select the following <fields> with <values>$/
  */
  public function iSelectTheFollowingFieldsWithValues(TableNode $table)
  {
    $element = $this->getSession()->getPage();
    $table = $table->getHash();
    foreach ($table as $key => $value) {
      $element->selectFieldOption($table[$key]['fields'], $table[$key]['values']);
    }
  }

  /**
  * @When /^(?:|I )upload the following "([^"]*)" <files>$/
  */
  public function iUpdloadTheFollowingFiles($type, TableNode $table)
  {
    // Multiple file upload:
    // update the below 'if' if this function needs to be reused
    switch ($type) {
      // for Create Project image upload
      case 'project image':
        $addmore_id = 'edit-field-project-images-field-project-images-add-more';
        // upload field id
        $filefield_id   = 'edit-field-project-images-{index}-upload';
        // upload button id
        $uploadbutton_id  = 'edit-field-project-images-{index}-filefield-upload';
        // upload response id
        $responsebox_id = 'edit-field-project-images-{index}-data-description';
        // upload set wrapper
        $wrapperbox_id  = 'edit-field-project-images-{index}-ahah-wrapper';
        // parameters to be filled in after upload finishes
        $arr_postupload_params = array(
          // in description
          'description' => 'edit-field-project-images-{index}-data-description',
          // al tag
          'alt text' => 'edit-field-project-images-{index}-data-alt',
        );
        break;
      // for Create Case Study image upload
      case 'case study image':
        $addmore_id = 'edit-field-images-field-images-add-more';
        // upload field id
        $filefield_id   = 'edit-field-images-{index}-upload';
        // upload button id
        $uploadbutton_id  = 'edit-field-images-{index}-filefield-upload';
        // upload response id
        $responsebox_id = 'edit-field-images-{index}-data-description';
        // upload set wrapper
        $wrapperbox_id  = 'edit-field-images-{index}-ahah-wrapper';
        // parameters to be filled in after upload finishes
        $arr_postupload_params = array(
          // in description
          'description' => 'edit-field-images-{index}-data-description',
          // al tag
          'alt text' => 'edit-field-images-{index}-data-alt',
          // title
          'title' => 'edit-field-images-{index}-data-title',
        );
        break;
      default:
        throw new Exception('Type of files to be uploaded is not specified/correct. Eg: \'I updload the following "project image" <files>\'');
        break;
    }
    $session = $this->getSession();
    $page = $session->getPage();
    $table = $table->getHash();
    $total_files = count($table);
    $subcontext = $this->getSubcontext('subcontext_alias');
    $sele_handler = $session->getSelectorsHandler();

    // 'add more' button
    $add_more = $page->findById($addmore_id);
    $upload = 0;

    if ($total_files > 0) {
      // wait
      $subcontext->iWaitForSeconds(2);
      // loop through files and upload
      for($i=0; $i < $total_files; $i++) {
        // find newly inserted file and attach local file
        $file_id = str_replace('{index}', $i, $filefield_id);
        $file = $this->getSession()->getPage()->findById($file_id);
        //add more items
        if (!is_object($file)) {
          $subcontext->iWaitForSeconds(2);
          $wrapper_id = str_replace('{index}', $i, $wrapperbox_id);
          $add_more->click();
          $subcontext->iWaitForSeconds(10, "typeof($('#". $wrapper_id ."').html()) != 'undefined'");
          $subcontext->iWaitForSeconds(2);
          $file = $this->getSession()->getPage()->findById($file_id);
        }
        // attach again
        $file->attachFile($table[$i]['files']);
        // find upload button and click
        $button_id = str_replace( '{index}', $i, $uploadbutton_id);
        $submit = $this->getSession()->getPage()->findById($button_id);
        $submit->click();
        // wait for upload to finish: will wait untill the upload completes OR 300 seconds
        $box_id = str_replace('{index}', $i, $responsebox_id);
        $subcontext->iWaitForSeconds(300, "typeof($('#". $box_id . "').val()) != 'undefined'");

        // process post upload parameters
        if (!empty($arr_postupload_params)) {
          foreach ($arr_postupload_params as $param => $field_id) {
            if ( isset($table[$i][$param]) && !empty($table[$i][$param])) {
              $field_id = str_replace('{index}', $i, $field_id);
              $this->getSession()->getPage()->findById($field_id)->setValue($table[$i][$param]);
            }
          }
        }
        // mark as done
        $upload++;
      }
    }
    if (!$upload)
      throw new Exception('Upload failed');
  }

 /**
     * @When /^I select "([^"]*)" from Project Type on Create Project page$/
     */
  public function iSelectFromProjectTypeOnCreateProjectPage($option)
  {
    $field = "project_type";
    switch($option) {
      case 'Modules':
        $id = 'edit-project-type-14';
        break;
      case 'Themes':
        $id = 'edit-project-type-15';
        break;
      case 'Theme engines':
        $id = 'edit-project-type-32';
        break;
      case 'Distributions':
        $id = 'edit-project-type-96';
        break;
      case 'Drupal.org projects':
        $id = 'edit-project-type-22588';
        break;
      case 'Drupal core':
        $id = 'edit-project-type-13';
        break;

    }
    $main_context = $this->getMainContext();
    $session = $main_context->getSession();
    $page = $session->getPage();
    $radio = $page->findById($id);
    $radio->click();
    $this->iWaitForSeconds(1, "");
    $this->iShouldSeeTheText('Modules categories');
  }

  /**
   * @Given /^I should see "([^"]*)" under "([^"]*)"$/
   */
  public function iShouldSeeUnder($text, $column) {
    $result = $this->checkTextInColumn($text, $column, 1);
    if ($result)
      throw new Exception($result);
  }

  /**
   * @Given /^I should not see "([^"]*)" under "([^"]*)"$/
   */
  public function iShouldNotSeeUnder($text, $column) {
    $result = $this->checkTextInColumn($text, $column, 0);
    if ($result)
      throw new Exception($result);
 }

  /**
   * Function to check whether a particular text is present in the column or not
   * @param $text String The text to search for
   * @param $column String The column in which the search has to be performed
   * @param $flag Int A flag where 1 = Should see in all cols, 0 = should not see
   */
  private function checkTextInColumn($text, $column, $flag) {
    $message = "";
    $class = "";
    $check = FALSE;
    $mainContext = $this->getMainContext();
    $page = $mainContext->getSession()->getPage();
    // get the class name of the column
    $result = $page->findAll('css', '.view table.views-table tr th');
    if (!empty($result)) {
      foreach ($result as $res) {
        if ($res->getText() == $column) {
          $class = $res->getAttribute('class');
          // class will be like 'views-field views-field-status'
          $temp = explode(" ", $class);
          $class = $temp[1];
          break;
        }
      }
      if ($class) {
        // get the column value of each row
        $result = $page->findAll('css', '.view table.views-table tr td.'.$class);
        if (!empty($result)) {
          $text = strtolower($text);
          foreach ($result as $res) {
            $colText = strtolower($res->getText());
            // flag = 1 => The part of the text should be found in every row of the specified column
            if ($flag) {
              if (strpos($colText, $text) === FALSE) {
                $check = TRUE;
                break;
              }
            }
            // flag = 0 => The part of the text should not be found in any row of the specified column
            else {
              if (strpos($colText, $text) !== FALSE) {
                $check = TRUE;
                break;
              }
            }
          }
          if ($check) {
            if ($flag)
              $message = "The text '" . $text . "' was not found in all the rows of the column '" . $column . "'";
            else
              $message = "The text '" . $text . "' was found in atleast one row of the column '" . $column . "'";
          }
        }
        else {
          $message = "The column " . $column . " was not found in the page";
        }
      }
      else {
        $message = "The column " . $column . " was not found in the page";
      }
    }
    else {
      $message = "The column " . $column . " was not found in the page";
    }
    return $message;
  }

  /**
   * @Given /^I select "([^"]*)" from the suggestion "([^"]*)"$/
   */
  public function iSelectFromTheSuggestion($value, $locator)
  {
    $element = $this->getSession()->getPage();
    $element->fillField($locator, $value);
    $this->project_value = $value;
  }

  /**
   * @Given /^I download the "([^"]*)" file "([^"]*)"$/
   */
  public function iDownloadTheFile($type, $filename) {
    $href = "";
    $mainContext = $this->getMainContext();
    $page = $mainContext->getSession()->getPage();
    $result = $page->findAll('css', '.views-field a');
    // get the link to download
    if (!empty($result)) {
      foreach ($result as $res) {
        if ($res->getText() == $filename) {
          $href = $res->getAttribute("href");
          break;
        }
      }
      if ($href) {
        // this will work only on Goutte as Selenium does not support this
        $mainContext->getSession()->visit($href);
        $responseHeaders = $mainContext->getSession()->getResponseHeaders();
        if ((int) $responseHeaders['Content-Length'][0] > 10000) {
          if ($type != "tar" || $type != "zip" ||
           $responseHeaders['Content-Type'] != "application/x-gzip" ||
           $responseHeaders['Content-Type'] == "application/zip") {
            throw new Exception("The file '" . $filename. "' was not downloaded");
          }
        }
        else {
          throw new Exception("The file '" . $filename. "' was not downloaded");
        }
      }
      else {
        throw new Exception("The link '" . $filename. "' was not found on the page");
      }
    }
    else {
      throw new Exception("The link '" . $filename. "' was not found on the page");
    }
  }

    /**
     * @Then /^the md5 hash should match$/
     */
    public function theMdHashShouldMatch($arg1)
    {
        throw new PendingException();
    }


}
