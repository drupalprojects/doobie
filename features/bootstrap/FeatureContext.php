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
    $value = "";
    if (isset(self::$data[$name])) {
      $value = self::$data[$name];
    }
    return $value;
  }
}

use Behat\Behat\Exception\PendingException,
    Behat\Gherkin\Node\TableNode;
use Drupal\DrupalExtension\Context\DrupalContext;
use Symfony\Component\Process\Process;

use Behat\Behat\Context\Step\Given;
use Behat\Behat\Context\Step\When;
use Behat\Behat\Context\Step\Then;
use Behat\Behat\Event\ScenarioEvent;

use Behat\Mink\Exception\ElementNotFoundException;

require 'vendor/autoload.php';

/**
 * Features context.
 */
class FeatureContext extends DrupalContext {

  /**
   *Store rss feed xml content
   */
  private $xmlContent = "";

  /**
   * Store project value
   */
  private $project_value = '';

  /**
   * Store the md5 hash of a downloaded file.
   */
  private $md5Hash = '';

  /**
   * Store a post title value
   */
  private $postTitle = '';

  /**
   * Store the file name of a downloaded file
   */
  private $downloadedFileName = '';
  /**
   * Initializes context.
   *
   * Every scenario gets its own context object.
   *
   * @param array $parameters.
   *   Context parameters (set them up through behat.yml or behat.local.yml).
   */
  public function __construct(array $parameters) {
    $this->default_browser = $parameters['default_browser'];
    if (isset($parameters['drupal_users'])) {
      $this->drupal_users = $parameters['drupal_users'];
    }
    if (isset($parameters['git_users'])) {
      $this->git_users = $parameters['git_users'];
    }
    if (isset($parameters['post title'])) {
      $this->postTitle= $parameters['post title'];
    }
  }

  /**
   * @defgroup helper functions
   * @{
   */

  /**
   * Helper function to fetch user passwords stored in behat.local.yml.
   *
   * @param string $type
   *   The user type, e.g. drupal or git.
   *
   * @param string $name
   *   The username to fetch the password for.
   *
   * @return string
   *   The matching password or FALSE on error.
   */
  public function fetchPassword($type, $name) {
    $property_name = $type . '_users';
    try {
      $property = $this->$property_name;
      $password = $property[$name];
      return $password;
    } catch (Exception $e) {
      throw new Exception("Non-existant user/password for $property_name:$name please check behat.local.yml.");
    }
  }



  /**
   * Helper function to fetch previously generated random strings stored by randomString().
   *
   * @param string $name
   *   The name of the random string.
   *
   * @return string
   *   The stored string.
   */
  public function fetchRandomString($name) {
    return HackyDataRegistry::get('random:' . $name);
  }

  /**
   * Helper function to check if the `expect` library is installed.
   */
  public function checkExpectLibraryStatus() {
    $process = new Process('which expect');
    $process->run();
    if (!$process->isSuccessful()) {
      throw new RuntimeException('This feature requires that the `expect` library be installed');
    }
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
   * @Given /^(?:that I|I) am (?:on|at) the homepage$/
   */
  public function thatIAmOnTheHomepage() {
    // Use the Mink Extenstion step definition.
    return new Given("I am on homepage");
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
   * Clone a project repository
   *
   * @When /^I clone the(?:| "([^"]*)") repo$/
   * @param string $repo
   *   project
   *     Read code block from version control tab and clone repo
   *   promoted sandbox
   *     Read git endpoint from saved variable and clone a promoted sandbox repo
   */
  public function iCloneTheRepo($repo = "project") {
    // Check for the `expect` library.
    $this->checkExpectLibraryStatus();
    // Initialise the password as "" to consider anonymous user
    $password = "\"\"";
    $url = "";
    $user = $this->getLoggedinUsername();
    switch ($repo) {
      // Follow version control tab and read code block
      case 'project':
        $element = $this->getSession()->getPage();
        $currUrl = $this->getSession()->getCurrentUrl();
        if (empty($element)) {
          throw new Exception("No page was found");
        }
        // Make sure you are on the version control tab
        if (strpos($this->getSession()->getCurrentUrl(), "git-instructions") === FALSE) {
          throw new Exception("The page should be on the Version control tab in order to clone the repo");
        }
        // Get the code block
        $result = $element->find('css', '#content div.codeblock code');
        if (empty($result)) {
          throw new Exception("The page does not contain any codeblock");
        }
        $this->repo = $result->getText();
        break;
      //This is to clone a sandbox repo once it is promoted and this should not clone the repository
      case 'promoted sandbox':
        $this->repo = '';
        $endpoint = HackyDataRegistry::get('sandbox git endpoint');
        if (empty($endpoint)) {
          throw new Exception('Sandbox git end point is empty');
        }
        // If anonymous user, adjust the end point to match http endpoint
        if (!$user) {
          $components = parse_url($endpoint);
          $endpoint = '';
          $components['scheme'] = 'http';
          if (isset($components['host'])) {
            $endpoint .= $components['host'];
          }
          if (isset($components['port'])) {
            $endpoint .= ':' . $components['port'];
          }
          if (isset($components['path'])) {
            // Remove username from path
            // if host is drupal.org. $components['path'] will have username too
            $components['path'] = preg_replace(array("/(.+)@/", "/:sandbox/"), array("", "/sandbox"), $components['path']);
            $endpoint .= $components['path'];
          }
          $endpoint = $components['scheme'] . '://' . $endpoint;
        }
        $this->repo = $endpoint;
        break;
      default:
        throw new Exception("Invalid repo is given");
        break;
    }
    // Get user data only if a user is logged in. Even anonymous user can clone.
    if ($user) {
    	$userData = $this->getGitUserData($this->repo);
    	$password = $userData['password'];
    }
    // Back to version control page
    if ($repo != 'promoted sandbox') {
      $this->getSession()->visit($currUrl);
    }
    sleep(1);
    $tempArr = explode(" ", $this->repo);
    foreach ($tempArr as $key => $value) {
      if (strpos($tempArr[$key], ".git") !== FALSE) {
        $url = trim($tempArr[$key]);
        break;
      }
    }
    if (!$url || trim($url) == "" ) {
      throw new Exception("Could not find the url to the repository. Initialize the repository before cloning");
    }
    // Get the project folder name and make sure there is a clone
    $project = strtolower(HackyDataRegistry::get('project_short_name'));
    if (!$project || $project == "") {
      if (!$project = strtolower(HackyDataRegistry::get('project title'))) {
        // Find project short name from git endpoint        
        $arr_url = explode('/', $url);
        $project = str_replace('.git', '', end($arr_url));
      }
    }
    if(empty($project)) {
      throw new Exception("No project found to push");
    }
    $command = "./bin/gitwrapper $password $url $project";
    $process = new Process($command);
    $process->setTimeout(100000);
    $process->run();
    // If sandbox, skip checking errors
    if ($repo == 'promoted sandbox') {
      // Save output for later use
      $this->process_output = $process->getOutput();
      $process = new Process('rm -rf ' . $project);
      $process->run();
      return;
    }
    // Continue with normal cloning
    if (!$process->isSuccessful()) {
      throw new RuntimeException("The clone did not work " .
        "\n Error: 2" . $process->getErrorOutput() .
        "\n Output: 3" . $process->getOutput()
      );
    }
    // If clone is successfull, then a directory must be created
    if (!is_dir(getcwd() . "/" . $project)) {
      throw new RuntimeException('The clone did not work ' . $process->getOutput());
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
      throw new Exception("The text " . $this->project . " was not found " . $this->getSession()->getCurrentUrl());
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
      throw new Exception('No submit button at ' . $this->getSession()->getCurrentUrl());
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
      throw new Exception('No submit button at ' . $this->getSession()->getCurrentUrl());
    }
    $submit->click();
  }

  /**
   * @} End of defgroup "drupal.org"
   */

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
    if (empty($element)) {
        throw new Exception('Page not found');
    }
    if ($user != 'User account') {
      // Logout.
      $this->getSession()->visit($this->locatePath('/logout'));
    }

    // Go to the user page.
    $this->getSession()->visit($this->locatePath('/user'));
    // Get the page title.
    $title_element = $element->findByID('page-title');
    if (empty($title_element)) {
        throw new Exception ('No page title found at ' . $this->getSession()->getCurrentUrl());
    }
    $page_title = $title_element->getText();

    if ($page_title == 'User account') {
      // If I see this, I'm not logged in at all so log in.
      $element->fillField('Username', $username);
      $element->fillField('Password', $passwd);
      $submit = $element->findButton('Log in');
      if (empty($submit)) {
        throw new Exception('No submit button at ' . $this->getSession()->getCurrentUrl());
      }
      // Log in.
      $submit->click();
      $user = $this->whoami();
      if (strtolower($user) == strtolower($username)) {
        HackyDataRegistry::set('username', $username);
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
    $password = $this->fetchPassword('drupal', $username);
    $this->iAmLoggedInAsWithThePassword($username, $password);
  }

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
    if (!$element->hasField('Project title')) {
      throw new Exception("The field Project title was not found on the page");
    }
    $this->projectTitle = $this->randomString(16);
    HackyDataRegistry::set('project title', $this->projectTitle);
    $element->fillField('Project title', $this->projectTitle);
    $element->fillField('Maintenance status', '13028'); /* Actively Maintained */
    $element->fillField('Development status', '9988'); /* Under Active Development */
    $this->iSelectTheRadioButtonWithTheId('Modules', 'edit-project-type-14');
    $element->fillField('Description', $this->randomString(1000));
    $element->pressButton('Save');
    sleep(2);
    HackyDataRegistry::set('sandbox_url', $this->getSession()->getCurrentUrl());
  }

  /**
   * @Then /^I (?:|should )see the project title$/
   */
  public function iShouldSeeTheProjectTitle() {
    $page = $this->getSession()->getPage();
    $element = $page->find('css', 'h1#page-subtitle');
    if (empty($element)) {
      throw new Exception("No title was found on the page");
    }
    // Get link to Version control tab
    $vcLink = $page->findLink('Version control');
    if (empty($vcLink)) {
      throw new Exception("Link to version control tab was not found on the page");
    }
    $versionControlTabPath = $vcLink->getAttribute('href');
    HackyDataRegistry::set('version control path', $versionControlTabPath);
    // Get link to Maintainers tab
    $maintainersTabLink = $page->findLink('Maintainers');
    // For anonymous users this link is not accessible
    if (!empty($maintainersTabLink)) {
      $maintainersTabPath = $maintainersTabLink->getAttribute('href');
      HackyDataRegistry::set('maintainers tab path', $maintainersTabPath);
    }
    // Get the path of the current project
    HackyDataRegistry::set('project path', $this->getSession()->getCurrentUrl());
    if (empty($element) || strpos($element->getText(), $this->projectTitle) === FALSE) {
      throw new Exception('Project title not found where it was expected.');
    }
  }

  /**
   * @Given /^I am on the Version control tab$/
   * @When /^I visit the Version control tab$/
   */
  public function iAmOnTheVersionControlTab() {
    $path = trim(HackyDataRegistry::get('version control path'));
    if (!$path || $path == "") {
      // If directly coming from project page
      $element = $this->getSession()->getPage()->findLink('Version control');
      if (!empty($element)) {
        $path = $element->getAttribute('href');
      }
      else {
        throw new Exception("The path to Version control tab was not found");
      }
    }
    $path = $this->locatePath($path);
    return new Given("I am at \"$path\"");
  }

  /**
   * Requires the Expect library to supply password to ssh on the command line.
   *
   * @When /^I initialize the repository$/
   */
  public function iInitializeTheRepository() {
    // Check for the `expect` library.
    $this->checkExpectLibraryStatus();

    $element = $this->getSession()->getPage()->find('css', 'div.codeblock');
    if (empty($element)) {
      throw new Exception("Initialization of repository failed. The page did not contain any code block to run");
    }
    $rawCommand = $element->getHTML();
    $matches = array();
    preg_match('|add origin ssh://([^@]*)@|', $rawCommand, $matches);
    $username = $matches[1];
    $password = $this->fetchPassword('git', $username);
    $rawCommand = str_replace('<br/>', '', $rawCommand);
    $rawCommand = str_replace('&gt;', '>', $rawCommand);
    $rawCommand = str_replace('&#13;', '', $rawCommand);
    $rawCommand = str_replace('git push origin master', "../bin/gitwrapper $password", $rawCommand);
    $command = preg_replace('/<code>(.*)?<\/code>/U', '\1 ; ', $rawCommand);
    # var_dump($command);
    $process = new Process($command);
    $process->setTimeout(10);
    $process->run();
    if (!$process->isSuccessful() || stripos($process->getOutput(), "error") !== FALSE) {
      throw new Exception("Initializing repository failed" .
      "\nCommand: " . $fullCommand .
      "\nError: " . $process->getErrorOutput() .
      "\nOutput: " . $process->getOutput()
      );
    }
    // Pause for front end to catch up.
    sleep(10);
  }

  /**
   * @AfterScenario @gitrepo
   */
  public function cleanGitRepos(ScenarioEvent $event) {
    $this->deleteFolder(strtolower(HackyDataRegistry::get('project title')));
    // If there is a promoted project, then short name will be set
    $this->deleteFolder(strtolower(HackyDataRegistry::get('project_short_name')));
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
    if ($field == 'change node created') {
      $field = 'created_op';
    }
    elseif ($field == 'comment count') {
      $field = 'edit-comment-count-op';
    }
    elseif ($field == 'top level book') {
      $field = 'edit-title-op';
    }
    elseif ($field == 'select...') {
      $field = 'edit-objects-selector';
    }
    elseif ($field == 'issue tags') {
      $field = 'edit-issue-tags-op';
    }
    $page = $this->getSession()->getPage();
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
    // @todo this would be great to implement as a custom selector (see Drupal
    // Extension's region selector).
    if ($field == "created date") {
      $field = "edit-created-value";
    }
    elseif ($field == "start date") {
      $field = "edit-created-min";
    }
    elseif ($field == "end date") {
      $field = "edit-created-max";
    }
    elseif ($field == "key modules/theme/distribution used") {
      $field = "edit-field-module-0-nid-nid";
    }
    elseif ($field == "issues") {
      $field = "edit-field-issues-0-nid-nid";
    }
    elseif ($field == "comment count") {
      $field = "edit-comment-count-value";
    }
    elseif ($field == "top level book") {
      $field = "edit-title";
    }
    elseif ($field == "comment count minimum") {
      $field = "edit-comment-count-min";
    }
    elseif ($field == "comment count maximum") {
      $field = "edit-comment-count-max";
    }
    elseif ($field == "enter your keywords") {
      $field = "edit-keys";
    }
    elseif ($field == "add new e-mail") {
      $field = "edit-email";
    }
    elseif ($field == "issue tags") {
      $field = "edit-issue-tags";
    }
    elseif ($field == "maintainer user name") {
      $field = "edit-new-maintainer-user";
    }
    elseif ($field == "search again") {
      $field = "edit-query";
    }
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
    if(empty($result)) {
    throw new Exception("The page '" . $pager . "' was not found");
    }
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
    sleep(5);
    $result->click();
    //use response headers to make sure we got the xml data and not html
    sleep(5);
    $responseHeaders = $this->getSession()->getResponseHeaders();
    // Use goutedriver get content to get the complete xml data and store it
    //temporarily in a variable for use by function iShouldSeeTheTextInTheFeed()
    $this->xmlContent =
     $this->getSession()->getDriver()->getClient()->getResponse()->getContent();
    if (strpos($responseHeaders['Content-Type'], "application/rss+xml") === FALSE) {
      if (strpos($this->xmlContent, "<?xml version=") === FALSE && strpos($this->xmlContent, "<rss version=") === FALSE) {
        throw new Exception("This page '" . $this->getSession()->getCurrentUrl() . "' does not provide xml data");
      }
    }
  }

  /**
   * @Then /^I should see the (?:issue|text )(?:|"([^"]*)") in the feed$/
   */
  public function iShouldSeeTheTextInTheFeed($text = null) {
    if ($issue = HackyDataRegistry::get('issue title')) {
      $text = $issue;
    }
    $xmlString = trim($this->xmlContent);
    if ($xmlString) {
      if (strpos($xmlString, trim($text)) === FALSE) {
        throw new Exception("The text '" . $text . "' was not found in the xml feed");
      }
    }
    else {
      throw new Exception("No xml data found");
    }
  }

  /**
   * @Given /^I should see at least "([^"]*)" feed item(?:|s)$/
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
  public function iFillInWithRandomText($label) {
    // A @Tranform would be more elegant.
    $randomString = $this->randomString(10);
    // Save this for later retrieval.
    HackyDataRegistry::set('random:' . $label, $randomString);
    $step = "I fill in \"$label\" with \"$randomString\"";
    return new Then($step);
  }

  /**
   * @Then /^I should see the random "([^"]*)" text$/
   */
  public function iShouldSeeTheRandomText($label) {
    $text = $this->fetchRandomString($label);
    if (!$text) {
      throw new Exception("No random text stored for $label.");
    }
    $step = "I should see \"$text\"";
    return new Then($step);
  }

  /**
   * @When /^I see "([^"]*)"$/
   */
  public function iSee($text) {
    $step = "I should see \"$text\"";
    return new Then($step);
  }

  /**
   * @Given /^I should see at least "([^"]*)" record(?:|s)$/
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
      'row' => '.view div.views-row',
      'row li' => '.view li.views-row',
      'sitewide search' => 'dl.search-results dt',
      'emails table' => '#multiple-email-manage table tbody tr'
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
   * @Given /^I should see the link "(?P<link>[^"]*)" at the "(?P<position>[^"]*)" in the "(?P<region>[^"]*)"(?:| region)$/
   */
  public function iShouldSeeTheLinkAtTheInTheRightSidebar($link, $position, $region) {
    $page = $this->getSession()->getPage();
    $error = 0;
    $curr_url = $this->getSession()->getCurrentUrl();
    $message = "The page " . $curr_url . " did not contain the specified texts";
    $region = $page->find('region', $region);
        if (empty($region)) {
      throw new Exception("Right sidebar region was not found");
    }
    $nodes = $region->findAll('css', '.item-list a');
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
   * @Then /^I should see(?:| at least) "(?P<count>\d+)" links in the "(?P<region>[^"]*)"(?:| region)$/
   */
  public function iShouldSeeAtLeastLinksInThe($count, $regionSelector = "right sidebar") {
    $page = $this->getSession()->getPage();
    $region = $page->find('region', $regionSelector);
    if (empty($region)) {
      throw new Exception("Right sidebar region was not found");
    }
    $links = $region->findAll('css', '.item-list a');
    if (sizeof($links) < $count) {
      throw new Exception("The page has less than '" . $count . "' links in the region '" . $regionSelector . "'");
    }
  }

  /**
   * @When /^I select the following <fields> with <values>$/
   */
  public function iSelectTheFollowingFieldsWithValues(TableNode $table) {
    $multiple = true;
    $table = $table->getHash();
    foreach ($table as $key => $value) {
      $select = $this->getSession()->getPage()->findField($table[$key]['fields']);
      if(empty($select)) {
        throw new Exception('The page does not have the field with label');
      }
      // if multiple is always true we get "value cannot be an array" error for single select fields
      $multiple = $select->getAttribute('multiple') ? true : false;
      $this->getSession()->getPage()->selectFieldOption($table[$key]['fields'], $table[$key]['values'], $multiple);
    }
  }

  /**
   * @When /^I select "([^"]*)" from Project Type on Create Project page$/
   *
   * @throws ElementNotFoundException
   */
  public function iSelectFromProjectTypeOnCreateProjectPage($option) {
    $field = "project_type";
    $check_category = false;
    switch($option) {
      case 'Modules':
        $id = 'edit-project-type-14';
        $check_category = true;
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
      default:
        throw new Exception('The option: "' . $option .'" doesn\'t exist' );
        break;
    }
    $radio = $this->getSession()->getPage()->findById($id);
    if (!$radio) {
      throw new ElementNotFoundException(
        $this->getSession(), 'radio', 'id', $id
      );
    }
    $radio->click();
    // Check Modules categories if Modules is selected
    if ($check_category) {
      $this->iWaitForSeconds(1, "");
      $this->iShouldSeeTheText('Modules categories');
    }
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
    $page = $this->getSession()->getPage();
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
  public function iSelectFromTheSuggestion($value, $locator) {
    $element = $this->getSession()->getPage();
    if (strtolower($locator) == "key modules/theme/distribution used") {
      $locator = "edit-field-module-0-nid-nid";
    }
    $element->fillField($locator, $value);
    $this->project_value = $value;
	  //In order to close the autocomplete dropdown, otherwise button click does not work
	  sleep(3);
	  $this->getSession()->executeScript("$('#autocomplete').hide();");
  }

  /**
   * @Given /^I download the "([^"]*)" file "([^"]*)"$/
   */
  public function iDownloadTheFile($type, $filename) {
    $href = "";
    $page = $this->getSession()->getPage();
    $result = $page->findAll('css', '.views-field a');
    // Get the link to download.
    if (!empty($result)) {
      foreach ($result as $res) {
        if ($res->getText() == $filename) {
          // Get the link to download.
          $href = $res->getAttribute("href");
          // Get parent row $res = <a>, $res->getParent() = <td>
          // $res->getParent()->getParent() = <tr>.
          $parent = $res->getParent()->getParent();
          // From parent row get the file hash column and its contents.
          $md5Hash = $parent->find('css', '.views-field-filehash')->getText();
          // Set the temporary variable for use in "the md5 hash should match".
          $this->md5Hash = $md5Hash;
          break;
        }
      }
      if ($href) {
        $this->getSession()->visit($href);
        // Will work only on Goutte. Selenium does not support responseHeaders.
        $responseHeaders = $this->getSession()->getResponseHeaders();
        if ((int) $responseHeaders['Content-Length'][0] > 10000) {
          // If "tar" is requested, then chk corresponding content type.
          if ($type == "tar") {
            if ($responseHeaders['Content-Type'] != "application/x-gzip") {
              throw new Exception("The file '" . $filename. "' was not downloaded");
            }
          }
          // If "zip" is requested, then chk corresponding content type.
          elseif ($type == "zip") {
            if ($responseHeaders['Content-Type'] != "application/zip") {
              throw new Exception("The file '" . $filename. "' was not downloaded");
            }
          }
          // If any thing other than tar or zip is requested, throw error.
          else {
            throw new Exception("Only 'tar' and 'zip' files can be downloaded");
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
   * @Then /^the md5 hash should match "(?P<md5hash>[^"]*)"$/
   */
  public function theMd5HashShouldMatch($md5hash) {
    if ($md5hash != $this->md5Hash) {
      throw new Exception("The md5 hash does not match");
    }
  }

  /**
  * @Then /^I should see assorted links under "([^"]*)"$/
  */
  public function shouldSeeAssortedLinksUnder($category) {
    // find grid container
    $page = $this->getSession()->getPage();
    $grids = $page->findAll('css', 'div.grid-2');
    $count = 0;
    if (empty($grids)) {
      throw new Exception('No categories found on the page.');
    }
    // loop through the grid to identify appropriate DIV
    foreach ( $grids as $grid) {
      // check main category
      if (is_object($h3 = $grid->find('css', 'h3')) &&  $h3->getText() == $category) {
        // find sub-category links
        $links = $grid->findAll('css', 'ul > li > a');
        if (!empty($links)) {
          //$visible = false;
          foreach($links as $a) {
            // if visible
            if (!('display: none;' == $a->getParent()->getAttribute('style'))) {
              $text = $a->getText();
              if (empty($text) || in_array($text, array('Show more', 'Show fewer'))) {
                continue;
              }
              // Check link text pattern: Eg: Development (49)
              if (!preg_match('#(.*) \((\d+)\)#', $text)) {
                throw new Exception('Invalid pattern found for the link:' . $text);
              }
              $count++;
            }
          }
        }
        break;
      }
    }
    if (!$count) {
      throw new Exception('Subcategory links could not be found for: "' . $category . '"');
    }
  }

  /**
   * @Then /^I should see the following <(?:subcategories|links)> under "([^"]*)"$/
   */
  public function iShouldSeeTheFollowingSubcategoriesUnder($category, TableNode $table) {
    $page = $this->getSession()->getPage();
    $temp_table = $table->getHash();
    $temp_array = array_keys($temp_table[0]);
    $resVal = $temp_array[0];
    switch($resVal) {
      //To get the grid headings and switch to the headings
      case 'subcategories':
        $grid_path = 'div.grid-2';
        $index  = 'subcategories';
        $h_tag = 'h3';
        $grids = $page->findAll('css', $grid_path);
        $type_text = "subcategor";
        break;
        //To find the appropriate heading
      case 'links':
        $index  = 'links';
        $arr_path = array(
          'h5' => 'div.narrow-box-list',
          'h2' => 'div.grid-12 .drupal-modules-facets .grid-3',
        );
        $type_text = "link";
        foreach ($arr_path as $h_tag => $path) {
          $grids = $page->findAll('css', $path);
          if (!empty($grids)) {
            break;
          }
        }
        break;
      default:
        throw new Exception('The option: "' . $resVal .'" doesn\'t exist' );
        break;
    }
    // find grid container
    if (!empty($grids)) {
      $table = $table->getHash();
      $arr_subcats = array();
      $arr_visiblecats = array();
      if(!empty($temp_table)) {
        foreach($temp_table as $subcat) {
          $arr_subcats[] = $subcat[$index];
        }
        // loop through the grid to identify appropriate DIV
        foreach ($grids as $grid) {
          // check main category
          if (is_object($head_tag = $grid->find('css', $h_tag)) &&  $head_tag->getText() == $category) {
            $links = $grid->findAll('css', 'ul > li > a');
            if (!empty($links)) {
              //$visible = false;
              foreach($links as $a) {
                // if visible
                if (!('display: none;' == $a->getParent()->getAttribute('style'))) {
                  // remove count with parenthasis
                  if($text = trim(preg_replace('~\(.*?\)~', "", $a->getText()))) {
                    $arr_visiblecats[] = $text;
                  }
                }
              }
            }
            break;
          }
        }
        //check presence of given subcategories in visible subcategories
        if (count($arr_np = array_diff($arr_subcats, $arr_visiblecats))) {
          $catcount = count($arr_np);
          throw new Exception('The ' . $type_text . ((strlen($type_text) > 4) ? ($catcount == 1 ? 'y' : 'ies') : (($catcount == 1 ? '' : 's'))) . ': "' . ($np = implode('", "', $arr_np)).'" cannot be found.');
        }
      }else {
        throw new Exception('"' . $resVal . '" are not given.');
      }
    }else {
      throw new Exception('"' . $resVal . '" are not given.');
    }
  }

  /**
  * @Then /^I should not see the following <subcategories> under "([^"]*)"$/
  */
  public function iShouldNotSeeTheFollowingSubcategoriesUnder($category, TableNode $table)
  {
    // find grid container
    $page = $this->getSession()->getPage();
    $grids = $page->findAll('css', 'div.grid-2');
    if (!empty($grids)) {
      $table = $table->getHash();
      $arr_subcats = array();
      $arr_hiddencats = array();
      if(!empty($table)) {
        foreach($table as $subcat) {
          $arr_subcats[] = $subcat['subcategories'];
        }

        foreach ( $grids as $grid) {
          // check main category
          if (is_object($h3 = $grid->find('css', 'h3')) &&  $h3->getText() == $category) {
            // find sub-category links
            $links = $grid->findAll('css', 'ul > li > a');
            if (!empty($links)) {
              foreach($links as $a) {
                // check the links are hidden
                if (('display: none;' == $a->getParent()->getAttribute('style'))) {
                // remove count with parenthasis
                  if($text = trim(preg_replace('~\(.*?\)~', "", $a->getText()))) {
                    $arr_hiddencats[] = $text;
                  }
                }
              }
            }
            break;
          }
        }
        //check presence of given subcategories in hidden subcategories
        if (count($arr_np = array_diff($arr_subcats, $arr_hiddencats))) {
          $catcount = count($arr_np);
          throw new Exception('The subcategor' . ($catcount == 1 ? 'y' : 'ies') . ': "' . ($np = implode('", "', $arr_np)).'" ' .($catcount == 1 ? 'is' : 'are') . ' present on the page.');
        }
      }else {
      throw new Exception('Subcategories are not given.');
      }
    }else {
      throw new Exception('Subcategories are not given.');
    }
  }

  /**
   * @Then /^I expand the category "([^"]*)"$/
   */
  public function iExpandTheCategory($category)
  {
    // find grid container
    $expanded = 0;
    $category_found = 0;
    $page = $this->getSession()->getPage();
    $grids = $page->findAll('css', 'div.grid-2');
    if (!empty($grids)) {
      foreach ( $grids as $grid) {
        // check main category
        if (is_object($h3 = $grid->find('css', 'h3')) &&  $h3->getText() == $category) {
          $category_found++;
          // find sub-category links
          $links = $grid->findAll('css', 'ul > li > a');
          if (!empty($links)) {
            foreach ($links as $a) {
              // find show more link to expand
              if ($a->getText() == 'Show more') {
                $a->click();
                $expanded++;
                break;
              }
            }
          }
        }
      }
    }
    if (!$category_found) {
      throw new Exception('The category:"' . $category .  '" cannot be found.');
    }
    if (!$expanded) {
      throw new Exception('The category: "' . $category. ' cannot be expanded');
    }
  }

  /**
   * @Then /^I collapse the category "([^"]*)"$/
   */
  public function iCollapseTheCategory($category)
  {
    // find grid container
    $collapsed = 0;
    $category_found = 0;
    $page = $this->getSession()->getPage();
    $grids = $page->findAll('css', 'div.grid-2');
    if (!empty($grids)) {
      foreach ( $grids as $grid) {
        // check main category
        if (is_object($h3 = $grid->find('css', 'h3')) &&  $h3->getText() == $category) {
          $category_found++;
          // find sub-category links
          $links = $grid->findAll('css', 'ul > li > a');
          if (!empty($links)) {
            foreach ($links as $a) {
              // find Show fewer link to collapse
              if ($a->getText() == 'Show fewer') {
                $a->click();
                $collapsed++;
                break;
              }
            }
          }
        }
      }
    }
    if (!$category_found) {
      throw new Exception('The category:"' . $category .  '" cannot be found.');
    }
    if (!$collapsed) {
      throw new Exception('The category: "' . $category. ' cannot be collapsed');
    }
  }

  /**
   * Function to check whether the links exists under the news/specific tab
   *
   * @Then /^(?:I|I should) see at least "(?P<count>\d+)" link(?:|s) under the "(?P<tab>[^"]*)" tab$/
   *
   * @param string $tab
   *   The tab to be selected for.
   * @param integer $count
   *   Counts the number of links exists.
   */
  public function iShouldSeeAtleastLinksUnderTab($count, $tab) {
    $tab = strtolower($tab);
    switch($tab) {
      case 'news':
        $id = '#fragment-1';
        $selector = $id . ' a';
        break;
      case 'docs updates':
        $id = '#fragment-2';
        $selector = $id . ' h6 a';
        break;
      case 'forum posts':
        $id = '#fragment-3';
        $selector = $id . ' h6 a';
        break;
      case 'commits':
        $id = '#fragment-4';
        $selector = $id . ' h6 a';
        break;
      default:
        throw new Exception('The tab "' . ucfirst($tab) . '" was not found on the page');
    }
    $region = $this->getSession()->getPage()->find('region', 'bottom right');
    if (!$region) {
      throw new Exception('Region "bottom right" not found');
    }
	  $nodes = $region->findAll("css", $selector);
    if (sizeof($nodes) < $count) {
      throw new Exception("The tab '" . ucfirst($tab) . "' has less than '" . $count . "' links");
    }
  }

  /**
  * @When /^I select <option> from "([^"]*)" results will contain <text>$/
  */
  public function iSelectOptionFromResultsWillContainText($select, TableNode $table)
  {
    if (!empty($table)) {
      $arr_return  = array();
      $table = $table->getHash();
      // loop through page
      for ($i = 0,$count = count($table); $i < $count; $i++) {
        if (!empty($table[$i]['option']) && !empty($table[$i]['text']) ) {
          $arr_return[] = new When("I select ". $table[$i]['option'] ." from \"" . $select ."\"");
          $arr_return[] = new Then("I should see " . $table[$i]['text']);
        }
      }

      return $arr_return;
    }else {
      throw new Exception("No options/texts specified");
    }
  }

  /**
   * @When /^I click on "([^"]*)" of a commit$/
   * Function to click on various links present in a commit
   * @param $linkType String The type of link to click
   * This function is specific to /commitlog screen
   */
  public function iClickOnOfACommit($linkType) {
    $page = $this->getSession()->getPage();
    $href = "";
    $project = "";
    $result = $this->getPostTitleObject($page);
    if (empty($result)) {
      $results = $page->findAll("css", ".commit-global h3 a");
      foreach ($results as $result) {
        if ($result->hasAttribute('href')) {
          $project = $result;
          break;
        }
      }
      if (empty($project)) {
        throw new Exception("The page did not contain any projects.");
      }
    }
    else {
      $project = $result;
    }
    // a > h3 > div.commit-global
    $commitGlobal = $project->getParent()->getParent();
    switch ($linkType) {
      case 'user name':
        $temp = $commitGlobal->find("css", ".attribtution a");
        if (!empty($temp)) {
          $href = $temp->getAttribute('href');
        }
        else {
          $temp = $commitGlobal->find("css", ".commit-global .attribution a");
          if (!empty($temp)) {
            $href = $temp->getAttribute('href');
          }
        }
      break;
      case 'project title':
        $href = $project->getAttribute('href');
      break;
      case 'sandbox project title':
        $links = $page->findAll("css", ".commit-global h3 a");
        if (!empty($links)) {
          foreach ($links as $link) {
            $temp = $link->getAttribute('href');
            // check if this is sandbox project. If not, then check for next link
            if (strpos($temp, '/sandbox/') !== FALSE) {
              $href = $temp;
              break;
            }
          }
        }
      break;
      case 'date':
        $links = $commitGlobal->findAll("css", "h3 a");
        if (!empty($links)) {
          foreach ($links as $link) {
            // get the second link from h3 tag
            if ($link->hasAttribute('href')) {
              $href = $link->getAttribute('href');
            }
          }
        }
      break;
      case 'commit info':
        // this is the 8 digit hash
        $temp = $commitGlobal->find("css", ".commit-info a");
        if (!empty($temp)) {
          $href = $temp->getAttribute('href');
        }
      break;
      case 'file name':
        // this is the file name that got committed and can be seen in individual commit message
        $temp = $page->findAll("css", ".view-vc-git-individual-commit .view-commitlog-commit-items .views-field-nothing span a");
        if (!empty($temp)) {
          foreach ($temp as $tempLinks) {
            $href = $tempLinks->getAttribute('href');
            break;
          }
        }
      break;
      default:
        throw new Exception("Link type '" . $linkType . "' is not valid.");
      break;
    }
    if (trim($href) == "") {
      throw new Exception("No link for '" . $linkType . "' was found on the page");
    }
    $this->getSession()->visit($this->locatePath($href));
  }

  /**
   * @Given /^I should see at least "([^"]*)" file(?:|s) in the list$/
   */
  public function iShouldSeeAtLeastFilesInTheList($count) {
    $page = $this->getSession()->getPage();
    $temp = $page->findAll("css", ".view-vc-git-individual-commit .view-commitlog-commit-items .views-field-nothing span.field-content");
    if (sizeof($temp) < $count) {
      throw new Exception("The page has less than '" . $count . "' files in the list");
    }
  }

  /**
   * @Given /^I should see at least "([^"]*)" "([^"]*)" symbol(?:|s)$/
   */
  public function iShouldSeeAtLeastSymbol($count, $symbol) {
    $page = $this->getSession()->getPage();
    $temp = $page->findAll("css", ".versioncontrol-diffstat .".$symbol);
    // If an image is committed, + or - does not appear, so check if its empty first.
    if (empty($temp)) {
      throw new Exception("The page does not have any '" . $symbol . "' symbols");
    }
    if (sizeof($temp) < $count) {
      throw new Exception("The page has less than '" . $count . "' symbols for '" . $symbol . "'");
    }
  }

  /**
   * @Given /^I should see the commit message$/
   */
  public function iShouldSeeTheCommitMessage() {
    $page = $this->getSession()->getPage();
    $temp = $page->find("css", ".view-vc-git-individual-commit .views-field-nothing-1 span.field-content");
    // check whether message is present or not before calling getText(), otherwise it will throw error
    if (empty($temp)) {
      throw new Exception("The page does not contain any commit message");
    }
    $text = $temp->getText();
    if (trim($text) == "") {
      throw new Exception("The page does not contain any commit message");
    }
  }

  /**
   * Function to press the particular button on the specified region
   * Note: The function looks for input type = 'submit' and not
   * input type = 'button' or 'image'
   *
   * @Given /^I press "(?P<button>[^"]*)" in the "(?P<region>[^"]*)" region$/
   *
   * @param string $button
   *   The value of the button to be pressed.
   * @param string $region
   *   The region (right sidebar, content) where.  the button is located
   *
   * @return object
   *   Given class object.
   */
  public function iPressInTheRegion($button, $region) {
    $buttonId = "";
    $page = $this->getSession()->getPage();
    $region = $page->find('region', $region);
    if (empty($region)) {
      throw new Exception($region . " region was not found");
    }
    // Get all the buttons present within a form in that region.
    $inputs = $region->findAll('css', 'form input[type=submit]');
    foreach ($inputs as $input) {
      // Just to make sure we press the right button.
      if ($input->getAttribute("value") == $button) {
        $buttonId = $input->getAttribute("id");
        break;
      }
    }
    if ($buttonId) {
      return new Given("I press \"$buttonId\"");
    }
    return new Exception("No '" . $button . "' was found in the region '" . $region . "'");
  }

  /**
   * @When /^I follow a post$/
   * Function to get the link from a table's first row
   */
  public function iFollowAPost() {
    $page = $this->getSession()->getPage();
    $temp = $this->getPostTitleObject($page);
    if (empty($temp)) {
      throw new Exception("No posts found to follow");
    }
    $this->getSession()->visit($this->locatePath($temp->getAttribute('href')));
  }

  /**
   * @When /^I follow "([^"]*)" for a post$/
   * Get the link $link from the table's first row
   */
  public function iFollowForAPost($link) {
    $page = $this->getSession()->getPage();
    $links = $page->findAll("css", ".views-table .views-row-first td a");
    if (empty($links)) {
      throw new Exception("No posts found to follow");
    }
    foreach ($links as $temp) {
      if (trim($temp->getText()) == $link) {
        $this->getSession()->visit($this->locatePath($temp->getAttribute('href')));
      }
    }
  }

  /**
   * Verifies that all checkboxes in a VBO view are selected.
   *
   * @Given /^all the checkboxes are selected$/
   */
  public function allTheCheckboxesAreSelected($flag = true) {
    $page = $this->getSession()->getPage();
    $chks = $page->findAll("css", ".views-table .form-item input[type=checkbox]");
    if (empty($chks)) {
      throw new Exception("No checkboxes were found on the page");
    }
    foreach ($chks as $chk) {
      // If flag is true then all checkboxes must be checked.
      if ($flag && !$chk->getAttribute('checked')) {
        throw new Exception("Not all checkboxes are selected");
      }
      // If flag is false then no checkboxes must be checked.
      elseif (!$flag && $chk->getAttribute('checked')) {
        throw new Exception("Some of the checkboxes are selected");
      }
    }
  }

  /**
   * @Then /^none the checkboxes are selected$/
   */
  public function noneTheCheckboxesAreSelected() {
    $this->allTheCheckboxesAreSelected(false);
  }

  /**
   * @When /^I check "([^"]*)" checkboxes to "([^"]*)"$/
   */
  public function iCheckCheckboxesTo($count, $context) {
    // Wait for the page to load
    sleep(4);
    $i = 1;
    $page = $this->getSession()->getPage();
    // Get all checkboxes
    $chks = $page->findAll("css", ".views-table .form-item input[type=checkbox]");
    if (empty($chks)) {
      throw new Exception("No checkboxes were found on the page");
    }
    // If more checkboxes are requested than available, then throw error
    if (count($chks) < $count) {
      throw new Exception("There are only '" . count($chks) . "' checkboxes, but requested '" . $count . "'");
    }
    // If only one checkboxis required, check the first one
    if ($count == 1) {
      $chks = $page->find('css', '.form-checkbox');
      if (empty($chks)) {
        throw new Exception("No checkboxes were found on the page");
      }
      $chks->click();
      return;
    }
    // If all the checkboxes are requested, then use the Select.... dropdown
    if ($count == count($chks)) {
      return new Given("I select \"All (this page)\" from field \"Select...\"");
    }
    foreach ($chks as $chk) {
      // check only the requested no. of checkboxes
      if ($i > $count) {
        return;
      }
      if ($context == "unpublish") {
        // if a post is already unpublished, then take next.
        // checkbox > label > div > td > tr
        $tr = $chk->getParent()->getParent()->getParent()->getParent();
        $tds = $tr->findAll("css", "td.views-field");
        if (empty($tds)) {
          continue;
        }
        $td = "";
        // 'Published' is present in the last column, so get the last 'td'
        foreach ($tds as $td) {
          $td = $td->getText();
        }
        if ($td == "Yes") {
          // 'check()' checked the checkbox but when 'unpublish' button was pressed, the values were not considered
          $chk->click();
          $i++;
        }
      }
      elseif($context == "delete") {
        $chk->click();
        $i++;
      }
      if ($i > $count) {
        return;
      }
    }
    throw new Exception("No checkboxes were selected on the page");
  }

  /**
   * @Given /^I should see at least "([^"]*)" committer(?:|s)$/
   */
  public function iShouldSeeAtLeastCommitters($count) {
    $page = $this->getSession()->getPage();
    // parse until anchor tag because there are empty <li>s as well
    $result = $page->findAll('css', "#block-versioncontrol_project-project_maintainers div.item-list ul li a");
    if (empty($result)) {
      throw new Exception("Unable to find the block of committers");
    }
    if (sizeof($result) < $count) {
      throw new Exception("The project has less than '" . $count . "' committers");
    }
  }

  /**
   * @Given /^I should see at least "([^"]*)" commit(?:|s)$/
   */
  public function iShouldSeeAtLeastCommits($count) {
    $total = 0;
    $page = $this->getSession()->getPage();
    // Parse until the <span> tag, since it contains text 'xx commits'.
    $result = $page->findAll('css', "#block-versioncontrol_project-project_maintainers div.item-list ul li div span");
    if (empty($result)) {
      throw new Exception("Unable to find the block of committers");
    }
    foreach ($result as $commit) {
      // Get the text and make sure it has the string 'commits'.
      $text = trim($commit->getText());
      if (strpos($text, "commits") !== FALSE) {
        $temp = explode(" ", $text);
        // temp[0]=xx, temp[1]=commits. Convert to integer before adding to total.
        $total = $total + (int) trim($temp[0]);
      }
    }
    if ($total < $count) {
      throw new Exception("The project has less than '" . $count . "' commits");
    }
  }

  /**
   * @Given /^I click the edit link for the sandbox project$/
   */
  public function iClickTheEditLinkForTheSandboxProject() {
    // Find the first title link from sandbox table.
    $first_a = $this->getSession()->getPage()->find('css', '#content-inner > table.projects.sandbox > tbody td.project-name > a');
    if (!empty($first_a)) {
      // Fetch the <TR>, the link belongs to.
      $tr = $first_a->getParent()->getParent();
      if (!empty($tr)) {
        $edit = $tr->findLink('Edit');
        if (!empty($edit)) {
          $edit->click();
        } else {
          throw new Exception('Edit link can not be found');
        }
      } else {
        throw new Exception('Edit link can not be found');
      }
    } else {
      throw new Exception('Sand box project doesn\'t exist for the user');
    }
  }

  /**
   * @Given /^I should see that the project short name is readonly$/
   */
  public function iShouldSeeThatTheProjectShortNameIsReadonly()
  {
    $field = $this->getSession()->getPage()->findField('Short project name:');
    if (!empty($field) && !$field->getAttribute('disabled')) {
      throw new Exception('Short project name form field exists on Edit Project page and is editable');
    }
  }

  /**
   * @Given /^I should see project name in the first part of the heading$/
   * Function to check whether project name is present in the commit heding or not
   * This function is specific to /commitlog screen
   */
  public function iShouldSeeProjectNameInTheFirstPartOfTheHeading() {
    $chk = "";
    $page = $this->getSession()->getPage();
    $project = "";
    $results = $page->findAll("css", ".commit-global h3 a");
    foreach ($results as $result) {
      if ($result->hasAttribute('href')) {
        $project = $result;
        break;
      }
    }
    if (empty($project)) {
      throw new Exception("The page did not contain any projects.");
    }
    // a > h3
    $links = $project->getParent();
    // get all anchor tags under h3 tag
    $links = $links->findAll("css", "a");
    foreach ($links as $link) {
      if ($link->hasAttribute('href')) {
        $chk = $link->getAttribute('href');
        // check for '/project/' or '/sandbox/', if available - success
        if (strpos($chk, '/project/') === FALSE && strpos($chk, '/sandbox/') === FALSE) {
          throw new Exception("Project title was not found in the first part of the heading");
        }
        // as we are looking only for project name, we need only the first link
        return;
      }
    }
    throw new Exception("Project title was not found in the first part of the heading");
  }

  /**
   * @Then /^the "([^"]*)" field should be "([^"]*)"$/
   * Function to find the state of a field. Here disabled/enabled is supported
   * @param $field String The field name to check for
   * @param $state String The expected state of the field.
   */
  public function theFieldShouldBe($field, $state) {
    $page = $this->getSession()->getPage();
    $fieldObj = $page->findField($field);
    if (empty($fieldObj)) {
      throw new Exception("The field '" . $field . "' was not found on the page");
    }
    switch ($state) {
      case 'disabled':
      case 'disable':
        if (!$fieldObj->hasAttribute("disabled")) {
          throw new Exception("The field '" . $field . "' is not '" . $state . "'");
        }
        break;

      case 'enabled':
      case 'enable':
        if ($fieldObj->hasAttribute("disabled")) {
          throw new Exception("The field '" . $field . "' is not '" . $state . "'");
        }
        break;

      default:
        throw new Exception("The field '" . $field . "' is not '" . $state . "'");
        break;
    }
  }

  /**
   * @Then /^I should see at least "([^"]*)" email (?:address|addresses)$/
   * Function to count the no. of records in the email address table
   * @param $count Integer The minimum no. of records expected
   */
  public function iShouldSeeAtLeastEmailAddress($count) {
    $page = $this->getSession()->getPage();
    $trs = $this->getViewDisplayRows($page);
    if (empty($trs)) {
      throw new Exception('The page does not have any email addresses');
    }
    // the table has extra non-data row at the bottom, so exclude it
    if (sizeof($trs)-1 < $count) {
      throw new Exception('The page has less than "' . $count . '" email addresses');
    }
  }

  /**
   * @Then /^I should see at least "([^"]*)" confirmed email (?:address|addresses)$/
   * Function to count no. of emails that have confirmed
   * @param $count Integer The minimum no. of records expected
   */
  public function iShouldSeeAtLeastConfirmedEmailAddress($count) {
    $i = 0;
    $page = $this->getSession()->getPage();
    $trs = $this->getViewDisplayRows($page);
    if (empty($trs)) {
      throw new Exception('The page does not have any email addresses');
    }
    // narrowing down to "table tbody tr" becoz, we do not want that string to be anywhere else
    foreach ($trs as $tr) {
      // using 'xpath' to find the string
      // $el = $page->find('xpath', '//div[@id="myid14"]/div/div[2]/a');
      $td = $tr->find("xpath", '//td[text()="Yes"]');
      if (!empty($td)) {
        // not all email addresses will be confirmed, so take the count
        $i++;
      }
    }
    if ($i < $count) {
      throw new Exception('The page has less than "' . $count .'" confirmed email addresses');
    }
  }

  /**
   * Function to check if an option is not present in the dropdown
   *
   * @Then /^I should not see "([^"]*)" in the dropdown "([^"]*)"$/
   *
   * @param string $value
    *  The option string to be searched for
   * @param string $field
   *   The dropdown field label
   */
  public function iShouldNotSeeInTheDropdown($value, $field) {
    $page = $this->getSession()->getPage();
    // get the object of the dropdown field
    $dropDown = $page->findField($field);
    if (empty($dropDown)) {
      throw new Exception('The page does not have the dropdown with label "' . $field . '"');
    }
    // get all the texts under the dropdown field
    $options = $dropDown->getText();
    if (strpos($value, $options) !== FALSE) {
      throw new Exception('The dropdown "' . $field . '" has the option "' . $value . '", but it should not be.');
    }
  }

  /**
   * @When /^I click the Sandbox project link$/
   */
  public function iClickTheSandboxProjectLink()
  {
    // Find the first title link from sandbox table
    $first_a = $this->getSession()->getPage()->find('css', '#content-inner > table.projects.sandbox > tbody td.project-name > a');
    if (!empty($first_a)) {
      $this->getSession()->visit($first_a->getAttribute('href'));
      return;
    }
    throw new Exception('Sandbox project link cannot be found');
  }

  /**
   * @Given /^I click the Full project link$/
   */
  public function iClickTheFullProjectLink() {
      // Find the first title link from full project table
    $first_a = $this->getSession()->getPage()->find('css', '#content-inner > table.projects > tbody td.project-name > a');
    if (!empty($first_a)) {
      $this->getSession()->visit($first_a->getAttribute('href'));
      return;
    }
    throw new Exception('Full project link cannot be found');
   }
    /**
   * Multiple File Upload
   */
  private function uploadMultipleFiles($type, TableNode $files) {
    // Multiple file upload:
    // update the below 'switch' if this function needs to be reused
    switch ($type) {
      // for Create Project image upload
      case 'project image':
        $addmore_id = 'edit-field-project-images-field-project-images-add-more';
        // upload field id
        $filefield_id 	= 'edit-field-project-images-{index}-upload';
        // upload button id
        $uploadbutton_id 	= 'edit-field-project-images-{index}-filefield-upload';
        // upload response id
        $responsebox_id	= 'edit-field-project-images-{index}-data-description';
        // upload set wrapper
        $wrapperbox_id 	= 'edit-field-project-images-{index}-ahah-wrapper';
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
        $filefield_id 	= 'edit-field-images-{index}-upload';
        // upload button id
        $uploadbutton_id 	= 'edit-field-images-{index}-filefield-upload';
        // upload response id
        $responsebox_id	= 'edit-field-images-{index}-data-description';
        // upload set wrapper
        $wrapperbox_id 	= 'edit-field-images-{index}-ahah-wrapper';
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
        throw new Exception('Type of files to be uploaded is not specified/correct. Eg: \'I upload the following "project image" <files>\'');
        break;
    }
    $session = $this->getSession();
    $page = $session->getPage();
    $files = $files->getHash();
    $total_files = count($files);

    // 'add more' button.
    $add_more = $page->findById($addmore_id);
    $upload = 0;
    $ds = '/';
    if ($total_files > 0) {
      // Wait.
      // @TODO why?
      $this->iWaitForSeconds(2);

      // Loop through files and upload.
      for ($i = 0; $i < $total_files; $i++) {
        // find newly inserted file and attach local file
        $file_id = str_replace('{index}', $i, $filefield_id);
        $file = $this->getSession()->getPage()->findById($file_id);
        //add more items
        if (!is_object($file)) {
          $this->iWaitForSeconds(2);
          $wrapper_id = str_replace('{index}', $i, $wrapperbox_id);
          $add_more->click();
          $this->iWaitForSeconds(10, "typeof($('#". $wrapper_id ."').html()) != 'undefined'");
          $this->iWaitForSeconds(2);
          $file = $this->getSession()->getPage()->findById($file_id);
        }
        if (empty($file)) {
          throw new Exception('The file: "' . $files[$i]['files'] . '" cannot be attached.');
        }
        // Attach again.
        $filepath = getcwd() . DIRECTORY_SEPARATOR . 'files' . DIRECTORY_SEPARATOR . $files[$i]['files'];

        if (!file_exists($filepath)) {
          throw new Exception('The file: "' . $files[$i]['files'] . '" cannot be found.');
        }
        $file->attachFile($filepath);
        // find upload button and click
        $button_id = str_replace( '{index}', $i, $uploadbutton_id);
        $submit = $this->getSession()->getPage()->findById($button_id);
        if (empty($submit)) {
          throw new Exception('The file: "' . $files[$i]['files'] . '" cannot be uploaded.');
        }
        $submit->click();
        // wait for upload to finish: will wait until the upload completes OR 300 seconds
        $box_id = str_replace('{index}', $i, $responsebox_id);
        $this->iWaitForSeconds(300, "typeof($('#". $box_id . "').val()) != 'undefined'");

        // process post upload parameters
        if (!empty($arr_postupload_params)) {
          foreach ($arr_postupload_params as $param => $field_id) {
            if (isset($files[$i][$param]) && !empty($files[$i][$param])) {
              $field_id = str_replace('{index}', $i, $field_id);
              $this->getSession()->getPage()->findById($field_id)->setValue($files[$i][$param]);
            }
          }
        }
        // mark as done
        $upload++;
      }
    }
    if (!$upload) {
      throw new Exception('Upload failed');
    }
  }

  /**
   * @Given /^I upload the following "([^"]*)" <files>$/
   */
  public function iUploadTheFollowingFiles($type, TableNode $files)
  {
    $this->uploadMultipleFiles($type, $files);
  }

  /**
   * @Given /^I check the project is created$/
   */
  public function iCheckTheProjectIsCreated()
  {
    $success = false;
    $lis = $this->getSession()->getPage()->findAll('css', 'div.messages.messages-status.clear-block.messages-multiple > ul > li');
    if (!empty($lis)) {
      foreach ($lis as $li) {
        $msg = $li->getText();
        if (preg_match("/has been created/", $msg)) {
          $success = true;
          break;
        }
      }
    }
    if (!$success) {
      throw new Exception("Project Creation failed");
    }
    // Store project url for later use
    HackyDataRegistry::set('project_url', $this->getSession()->getCurrentUrl());
  }

    /**
   * @Given /^I should see that the Sandbox checkbox is "([^"]*)"$/
   */
  public function iShouldSeeThatTheSandboxCheckboxIs($attribute)
  {
    $attribute = strtolower($attribute);
    $field = $this->getSession()->getPage()->findField('Sandbox');
    if (empty($field)) {
      throw new Exception('Sandbox checkbox cannot be found');
    }
    $disabled = $field->getAttribute('disabled');
    // Return true if checking for enabled and the checkbox is already enabled
    if (!$disabled && $attribute == 'enabled') {
      return;
    }
    if ($attribute != $disabled) {
      throw new Exception('Sandbox checkbox is not '. $attribute);
    }
  }

  /**
   * Function to check if the field specified is outlined in red or not
   *
   * @Given /^the field "([^"]*)" should be outlined in red$/
   *
   * @param string $field
   *   The form field label to be checked.
   */
  public function theFieldShouldBeOutlinedInRed($field) {
    $page = $this->getSession()->getPage();
    // get the object of the field
    $formField = $page->findField($field);
    if (empty($formField)) {
      throw new Exception('The page does not have the field with label "' . $field . '"');
    }
    // get the 'class' attribute of the field
    $class = $formField->getAttribute("class");
    // we get one or more classes with space separated. Split them using space
    $class = explode(" ", $class);
    // if the field has 'error' class, then the field will be outlined with red
    if (!in_array("error", $class)) {
      throw new Exception('The field "' . $field . '" is not outlined with red');
    }
  }

  /**
   * @Given /^I should see at least "([^"]*)" (?:reply|replies) for the post$/
   */
  public function iShouldSeeAtLeastRepliesForThePost($count) {
    $page = $this->getSession()->getPage();
    $result = $this->getIssueTiteObj($page);
    $postTitle = $result->getText();
    // Get the row in which the post resides. a > td > tr.
    $trow = $result->getParent()->getParent();
    // If there is a new reply, we get an anchor tag.
    $replies = $trow->find('css', '.replies');
    if (empty($replies)) {
      throw new Exception('Could not find any replies for this post');
    }
    $replies_new = $replies->getText();
    // The replies text will be in the format "2 new" or "11 new".
    $temp = explode(" ", $replies_new);
    // temp[0] = xx, temp[1] = "new".
    $newreplies_count = trim($temp[0]);
    if($newreplies_count < $count) {
      throw new Exception("The post '" . $postTitle . "' has less than '" . $count . "' new replies");
    }
  }

  /**
   * @Given /^I should see at least "([^"]*)" new (?:reply|replies) for the post$/
   */
  public function iShouldSeeAtLeastNewRepliesForThePost($count) {
	  $page = $this->getSession()->getPage();
    $result = $this->getIssueTiteObj($page);
    $postTitle = $result->getText();
    // Get the row in which the post resides. a > td > tr.
    $trow = $result->getParent()->getParent();
    // If there is a new reply, we get an anchor tag.
    $replies = $trow->find('css', '.replies a');
    if(empty($replies)) {
      throw new Exception("Could not find any new replies for this '" . $postTitle . "'post");
    }
    $replies_new = $replies->getText();
    // The replies text will be in the format "2 new" or "11 new".
    $temp = explode(" ", $replies_new);
    // temp[0] = xx, temp[1] = "new".
    $newreplies_count = trim($temp[0]);
    if($newreplies_count < $count) {
      throw new Exception("The post '" . $postTitle . "' has less than '" . $count . "' new replies");
    }
  }

  /**
   * @Given /^I should see updated for the post$/
   */
  public function iShouldSeeUpdatedForThePost($postUpdated= TRUE) {
	  $page = $this->getSession()->getPage();
    $result = $this->getIssueTiteObj($page);
    $postTitle = $result->getText();
    // Get the row in which the post resides. span > td.
    $td = $result->getParent();
    // If there is a update message, we get the status message.
    $stat_message = $td->find('css', '.marker');
    if ($postUpdated) {
      if (empty($stat_message)) {
        throw new Exception("The post '" . $postTitle . "' does not have updated status message");
      }
    }
    else {
      if(!empty($stat_message)) {
        throw new Exception("The post '" . $postTitle . "' has an updated status message");
      }
    }
  }

  /**
   * @Given /^I should not see updated for the post$/
   */
	public function iShouldNotSeeUpdatedForThePost() {
		$this->iShouldSeeUpdatedForThePost(FALSE);
	}

  /**
   * Function to get the Title for Post of type Issue
   */
  function getPostTitleObject($page) {
    $flag = 0;
    $result = "";
    // Try to get title from HackyDataRegistry.
    $temp = HackyDataRegistry::get('project title');
    if ($temp) {
      $result = $page->findLink($temp);
      if (!empty($result)) {
        return $result;
      }
    }
    // If not avalilable from Hacky, then get from yml.
    if(!empty($this->postTitle)) {
      $postTitle = $this->postTitle;
      $result = $page->findLink($postTitle);
      if (!empty($result)) {
        return $result;
      }
    }
    // If not available from yml then take the first item from table.
    if ($flag == 0) {
      $result = $page->find("css", "table tbody tr td a");
      if (!empty($result)) {
        return $result;
      }
    }
    return $result;
  }

  /**
   * @Then /^I should see the following <tabs>$/
   */
  public function iShouldSeeTheFollowingTabs(TableNode $table) {
    // Fetch tab links.
    $tab_links = $this->getSession()->getPage()->findAll('css', '#nav-content ul.links > li > a');
    if (empty($tab_links)) {
      throw new Exception('No tabs found');
    }
    $arr_tabs = array();
    foreach ($tab_links as $tab) {
      $arr_tabs[] = $tab->getText();
    }
    if (empty($table)) {
      throw new Exception('No tabs specified');
    }
    // Loop through table and check tab is present.
    foreach ($table->getHash() as $t) {
      if (!in_array($t['tabs'], $arr_tabs)) {
        throw new Exception('The tab: "' . $t['tabs'] . '" cannot be found' );
      }
    }
  }

  /**
   * Function to check the status of a book page.
   *
   * @Then /^the page status should be "([^"]*)"$/
   *
   * @param string $status
   *   String The status of the page.
   */
  public function thePageStatusShouldBe($status) {
    $page = $this->getSession()->getPage();
    $currStatus = $page->find("css", "#block-drupalorg_handbook-meta-sidebar .page-status");
    if (empty($currStatus)) {
      throw new Exception("The status of the page is not '" . $status . "'");
    }
    if (trim($status) != trim($currStatus->getText())) {
      throw new Exception("The status of the page is not '" . $status . "'");
    }
  }

  /**
   * @Then /^I should see that the tab "([^"]*)" is highlighted$/
   */
  public function iShouldSeeThatTheTabIsHighlighted($tab) {
    $ul = $this->getSession()->getPage()->find('css', '#nav-content ul.links');
    if (empty($ul)) {
      throw new Exception('No tabs found');
    }
    $tablink = $ul->findLink($tab);
    if (empty($tablink)) {
      throw new Exception('The tab: "' . $tab . '" cannot be found' );
    }
    if ('active active' != $tablink->getAttribute('class')) {
      throw new Exception('The tab: "' . $tab . '" is not highlighted' );
    }
  }

  /**
   * @Given /^I should see the following <blocks> in the right sidebar$/
   */
  public function iShouldSeeTheFollowingBlocksInTheRightSidebar(TableNode $table) {
    $region = $this->getSession()->getPage()->find('region', 'right sidebar');
    if (empty($region)) {
      throw new Exception('Right sidebar region was not found');
    }
    $blocks = $region->findAll('css', '#column-right-region > div');
    if (empty($blocks)) {
      throw new Exception('No blocks found in the right sidebar');
    }
    $arr_headings = array();
    foreach ($blocks as $block) {
       $h2 = $block->find('css', 'h2');
       if (!empty($h2)) {
         $arr_headings[] = $h2->getText();
       }else {
         $link = $block->find('css', 'a');
         if (!empty($link)) {
           $arr_headings[] = $link->getText();
         }
       }
    }
    if (empty($table)) {
      throw new Exception('No blocks specified');
    }
    // Loop through table and check tab is present.
    foreach ($table->getHash() as $t) {
      if (!in_array($t['blocks'], $arr_headings)) {
        throw new Exception('The block: "' . $t['blocks'] . '" cannot be found in the right sidebar' );
      }
    }
  }

  /**
   * Function to check the background color of the status message on a book page.
   *
   * @Given /^the background color of the status should be "([^"]*)"$/
   *
   * @param string $color
   *   The color of the status.
   */
  public function theBackgroundColorOfTheStatusShouldBe($color) {
    $flag = FALSE;
    $colorCode = array('red' => '#EBCCCC', 'green' => '#D4EFCC', 'yellow' => '#FFE69F');
    // Get the background color of an element using javascript and then compare with above array.
    $this->getSession()->executeScript("
      var currColorCode = $('.page-status').css('background-color');
      if (currColorCode == '".$colorCode[$color]."') {
        var flag = ".($flag = TRUE).";
      }
    ");
    if (!$flag) {
      throw new Exception("The background of the status is not '" . $color . "' on the page " . $this->getSession()->getCurrentUrl());
    }
  }

  /**
   * @Given /^I should see the copyright statement in the right sidebar$/
   */
  public function iShouldSeeTheCopyrightStatementInTheRightSidebar() {
    $region = $this->getSession()->getPage()->find('region', 'right sidebar');
    if (empty($region)) {
      throw new Exception("Right sidebar region was not found");
    }
    $block = $region->find('css', '#column-right-region > #block-drupalorg_handbook-license div.block-inner div.block-content');
    if (empty($block)) {
      throw new Exception('No blocks found in the right sidebar');
    }
    $copyright = 'Drupal&rsquo;s online documentation is &copy; 2000-2012 by the individual contributors and can be used in accordance with the';
    $contents = htmlentities(trim($block->getText()));
    if (!strstr($contents, $copyright)) {
      throw new Exception('Copyright statement cannot be found in the right sidebar');
    }
  }

  /**
   * @Given /^"([^"]*)" should not contain an input element$/
   */
  public function shouldNotContainAnImputElement($id) {
    $div = $this->getSession()->getPage()->findById($id);
    if (!$div) {
      throw new Exception("The page does not have any div with the id '" . $id . "'");
    }
    $input = $div->find('css', 'input');
    if ($input) {
      throw new Exception("The element with the id '" . $id . "' contains an input element.");
    }
  }

  /**
   * Function to check the slide texts on the page.
   *
   * @Given /^I should see the following <slides>$/
   *
   * @param $table
   *   Array List of texts that should appear on the page.
   */
  public function iShouldSeeTheFollowingSlides(TableNode $table) {
    $page = $this->getSession()->getPage();
    if (empty($table)) {
      throw new Exception("No slides were provided");
    }
    $table = $table->getHash();
    if (empty($table)) {
      throw new Exception("No slides were provided");
    }
    // Loop through all the texts provided in the table.
    foreach ($table as $key => $value) {
      $text = $table[$key]['slides'];
      // Use xpath to get the "alt" value of the image in 'slideshow' div.
      $temp = $page->find('xpath', '//div[@class="slideshow"]/img[@alt="' . $text . '"]');
      if (empty($temp)) {
        throw new Exception("The text '" . $text . "' was not found in the slideshow");
      }
    }
  }

  /**
   * @Given /^I should see the following <blocks> in the "([^"]*)" column$/
   */
  public function iShouldSeeTheFollowingBlocksInTheColumn($position, TableNode $table) {
    // Validate empty arguements.
    $this->validateBlankArgs(func_get_args());
    // Define order for columns.
    $arr_order = array( 'left' => 1,'center' => 2,'right' => 3,);
    $this->iShouldSeeTheBelowBlocksInColumn($arr_order[$position], $table);
  }

  /**
   * Validate against blank function arguments.
   * Usage: $this->validateBlankArgs(func_get_args());
   */
  private function validateBlankArgs($args) {
    foreach ($args as $arg) {
      $arg = trim($arg);
      if (empty($arg)) {
        throw new Exception("Missing Input value(s)");
        break;
      }
    }
  }

  /**
   * @Then /^I should see the following <blocks> in column "([^"]*)"$/
   *
   * @param int $column
   * @param TableNode object $table
   */
  public function iShouldSeeTheBelowBlocksInColumn($column, TableNode $table)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    if (empty($table)) {
      throw new Exception('Block list cannot be empty.');
    }
    // Find block with header, for the column.
    $blocks_h3 = $this->getSession()->getPage()->findAll('css', '#homebox-column-' . $column . ' h3.portlet-header > span.portlet-title');
    if (empty($blocks_h3)) {
      throw new Exception('The column "' . $column . '" is empty.');
    }
    $arr_boxes = array();
    // Store box names
    foreach ($blocks_h3 as $header_span) {
      if ($boxname = $header_span->getText()) {
        $arr_boxes[] = $boxname;
      }
    }
    // Check boxes exist or not
    if (empty($arr_boxes)) {
      throw new Exception('The column "' . $column . '" is empty.');
    }
    foreach ($table->getHash() as $item) {
      // Check the box exists in column boxes
      if (!in_array($item['blocks'], $arr_boxes)) {
        throw new Exception('The box "' . $item['blocks'] . '" cannot be found in the column "' . $column . '".');
        break;
      }
    }
  }

  /**
   * Check the existence of "Add links" for blocks
   *
   * @Then /^I should see the following <blocklinks> in small boxes$/
   *
   * @param TableNode object $table
   */
  public function iShouldSeeTheFollowingBlocklinksInSmallBoxes(TableNode $table)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    $block_links = $this->getSession()->getPage()->findAll('css', '#homebox-add > div.item-list > ul > li > a');
    if (empty($block_links)) {
      throw new Exception('The link for the blocks cannot be found.');
    }
    $arr_blocks = array();
    // Loop through and check the block name
    foreach ($block_links as $a) {
      if ($a_label = $a->getText()) {
        $arr_blocks[] = $a_label;
      }
    }
    if (empty($arr_blocks)) {
      throw new Exception('The link for the blocks cannot be found.');
    }
    foreach ($table->getHash() as $t) {
      if (!in_array($t['blocklinks'], $arr_blocks)) {
        throw new Exception('The link for the block "' . $t['blocklinks'] . '" cannot be found.');
        break;
      }
    }
  }

  /**
   * Check number of rows in a table - Add more cases if table/row class is different
   *
   * @Given /^I should see at least "([^"]*)" record(?:|s) in "([^"]*)" table$/
   * @param string $tableType : "Projects"/"Sandbox Projects"/"Project Issues"
   */
  public function iShouldSeeAtLeastRecordsInTable($count, $tableType)
  {
    // Find the table element object and other data
    $arr_table = $this->getTableElement($tableType);
    if (!isset($arr_table['element'])) {
      throw new Exception('The table: "' . $tableType . '" cannot be found');
    }
    $records = 0;
    // Find the <TR>s
    $trs = $arr_table['element']->findAll('css', 'tbody > tr');
    if (empty($trs)) {
      throw new Exception('No records found.');
    }
    foreach ($trs as $tr) {
      $tds = $tr->findAll('css', 'td');
      if (empty($tds)) {
        throw new Exception('No columns found.');
      }
      // Select the column the main link belongs to
      $column = !empty($arr_table['link_column']) ? $arr_table['link_column'] - 1 : 0;
      foreach ($tds as $index => $td) {
        if ($index == $column) {
          // Find the links inside the <TD>
          $link = $td->find('css', 'a');
          if (!empty($link)) {
            $text = $link->getText();
            // Bypass exceptions
            if (in_array($text, $arr_table['link_exceptions'])) {
              continue;
            }
            $records++;
          }
        }
      }
    }
    if ( $records < $count ) {
      throw new Exception('The table has less than ' . $count . ' records only.');
    }
  }

  /**
   * Checks the links displayed in a column for the tables of the type: Project/Sandbox Project/Project Issue
   *
   * @Then /^I should see the following <links> in column "([^"]*)" in "([^"]*)" table$/
   */
  public function iShouldSeeTheFollowingLinksInColumnInTable($column, $tableType, TableNode $links)
  {
    $column_class = $this->getColumnClasses($column);
    if (empty($column_class)) {
      throw new Exception('The column cannot be found.');
    }
    // Find the table element object
    $arr_table = $this->getTableElement($tableType);
    if (empty($arr_table['element'])) {
      throw new Exception('The table: "' . $tableType . '" cannot be found.');
    }
    $projectTitle = HackyDataRegistry::get('project title');
    $project_a = $arr_table['element']->findLink($projectTitle);
    if (empty($project_a)) {
      throw new Exception('The project "' . $projectTitle . '" is not found in "' . $tableType .'"');
    }
    $first_tr = $project_a->getParent()->getParent();
    if (empty($first_tr)) {
      throw new Exception('No records found.');
    }
    $arr_a = $first_tr->findAll('css', 'td.' . $column_class . ' a');
    if (empty($arr_a)) {
      throw new Exception('No links exist in column: "' . $column . '"');
    }
    $arr_links = array();
    foreach ($arr_a as $a) {
      $arr_links[] = $a->getText();
    }
    foreach ($links->getHash() as $link) {
      if (!in_array($link['links'], $arr_links)) {
        throw new Exception('The link: "' . $link['links'] . '" cannot be found in column: "' . $column . '"');
      }
    }
  }

  /**
   * Visits the link inside a column of a table
   * @Given /^I click "([^"]*)" from "([^"]*)" table$/
   */
  public function iClickFromTable($link, $tableType)
  {
    // Find column for the Link
    switch ($link) {
      // Issue links column of "Projects"/"Projects Sandbox"
      case 'View':
      case 'Search':
      case 'Create':
        $column = 'Issue links';
        break;
      // Project links column of "Projects"/"Projects Sandbox"
      case 'Edit':
      case 'Add release':
        $column = 'Project links';
        break;
      // Project column of Project issues Table
      case 'Project':
        $column = 'Project Issue';
         break;
      case 'Summary':
        $column = 'Issue Summary';
        break;
    }
    if (empty($column)) {
      throw new Exception('The column cannot be found.');
    }
    // Find column class from column name
    $column_class = $this->getColumnClasses($column);
    // Find the table element object
    $arr_table = $this->getTableElement($tableType);
    if (empty($arr_table['element'])) {
      throw new Exception('The table: "' . $tableType . '" cannot be found.');
    }
    $projectTitle = HackyDataRegistry::get('project title');
    $project_a = $arr_table['element']->findLink($projectTitle);
    if (empty($project_a)) {
      throw new Exception('The project "' . $projectTitle . '" is not found in "' . $tableType .'"');
    }
    $first_tr = $project_a->getParent()->getParent();
    if (empty($first_tr)) {
      throw new Exception('No records found');
    }
    // Find the first link
    $a_first = $first_tr->find('css', 'td a');
    if (!empty($a_first)) {
      // Store the link label to use afterwards.
      HackyDataRegistry::set('project name', $a_first->getText());
    }
    // Find all links inside a column
    $arr_a = $first_tr->findAll('css', 'td.' . $column_class . ' a');
    if (empty($arr_a)) {
      throw new Exception('No links exist in column: "'. $column .'".');
    }
    $visited = false;
    foreach ($arr_a as $a) {
      if (in_array($link, array('Project', 'Summary')) || $link == $a->getText()) {
        // Store issue name if it is a "Summary column" from "Project Issues" table.
        if ($link == 'Summary') {
          HackyDataRegistry::set('issue name', $a->getText());
        }
        // Visit the link to make sure it actually exists
        $this->getSession()->visit($a->getAttribute('href'));
        $visited = true;
        break;
      }
    }
    if (!$visited) {
      throw new Exception('The link couldn\'t be visited.');
    }
  }

  /**
   * Identify the page.
   *
   * @Given /^I should see "([^"]*)" page$/
   */
  public function iShouldSeePage($page) {
    $project_name = HackyDataRegistry::get('project name');
    switch ($page) {
      case 'Project Issue':
        $heading = 'Issues for' . ($project_name ? ' ' . $project_name : '');
        break;
      case 'Advanced Search':
        $heading = 'Search issues for' . ($project_name ? ' ' . $project_name : '');
        break;
      case 'Create Issue':
        $heading = 'Create Issue';
        break;
      case 'Project Edit':
        $heading = $project_name ? $project_name : '';
        break;
      case 'Create Project Release':
        $heading = 'Create Project release';
        break;
      case 'Issue':
        $issue_name = HackyDataRegistry::get('issue name');
        $heading = $issue_name ? $issue_name : '';
        break;
    }
    return array(
      new Given('I should see the heading "' . $heading . '"'),
      new Given('I move backward one page'),
    );
  }

  /**
   * @Given /^I fill in "([^"]*)" with issue name$/
   */
  public function iFillInWithIssueName($label)
  {
    // Find project from Projects table
    $table_type = 'Project Issues';
    // Find the table element object
    $arr_table = $this->getTableElement($table_type);
    if (empty($arr_table['element'])) {
      throw new Exception('The table: "' . $table_type . '" cannot be found');
    }
    $first_tr = $arr_table['element']->find('css', 'tbody tr');
    if (empty($first_tr)) {
      throw new Exception('No records found');
    }
    // Find the first link
    $a_first = $first_tr->findAll('css', 'td a');
    // $a_first[0] : Project link
    // $a_first[1] : Issue link
    if (empty($a_first)) {
      // Store the link label to use afterwards
      throw new Exception('Project/Issue link cannot be found');
    }
    HackyDataRegistry::set('project name', $a_first[0]->getText());
    return new Given('I fill in "' . $label . '" with "' . $a_first[1]->getText() .'"');
  }

  /**
   * @Given /^I select project name from "([^"]*)"$/
   */
  public function iSelectProjectNameFrom($label) {
    if ($project_name = HackyDataRegistry::get('project name')) {
      return new Given('I select "' . $project_name . '" from "' . $label .'"');
    }
    else {
      // Find project from Projects table.
      $table_type = 'Projects';
      // Find the table element object
      $arr_table = $this->getTableElement($table_type);
      if (empty($arr_table['element'])) {
        throw new Exception('The table: "' . $table_type . '" cannot be found.');
      }
      $first_tr = $arr_table['element']->find('css', 'tbody tr');
      if (empty($first_tr)) {
        throw new Exception('No records found.');
      }
      // Find the first link
      $a_first = $first_tr->find('css', 'td a');
      if (empty($a_first)) {
        // Store the link label to use afterwards
        throw new Exception('Project link cannot be found.');
      }
       return new Given('I select "' . $a_first->getText() . '" from "' . $label .'"');
    }
  }

  /**
   * Gets Table Element for the specified type
   * Update the switch to consider other tables as well
   */
  private function getTableElement($type) {
    $arr_table = array();
    switch ($type) {
      case 'Projects':
        // Class name(s) of the table. Multiple classnames are specified as getAttribute('class') returns different values with and without Goutte
        $arr_table['table_class'] = array('projects sticky-enabled', 'projects sticky-enabled sticky-table');
        // In which column, the main link is placed - Optional
        $arr_table['link_column'] = '1';
        // If any link(s) need not be considered, gice it here seperated bby comma - Optional
        $arr_table['link_exceptions'] = array('Add a new project');
        break;
      case 'Sandbox Projects':
        $arr_table['table_class'] = array('projects sandbox sticky-enabled', 'projects sandbox sticky-enabled sticky-table');
        $arr_table['link_column'] = '1';
        $arr_table['link_exceptions'] = array('Add a new project');
        break;
      case 'Project Issues':
        $arr_table['table_class'] = array(
          'views-table sticky-enabled project-issue',
          'views-table sticky-enabled project-issue sticky-table',
        );
        $arr_table['link_column'] = '1';
        $arr_table['link_exceptions'] = array();
        break;
    }
    if (empty($arr_table)) {
      throw new Exception('Table details are not given for: "' . $type . '"');
    }
    // find the tables
    $tables = $this->getSession()->getPage()->findAll('css','#content-inner table');
    if (empty($tables)) {
      $this->getSession()->getCurrentUrl();
      throw new Exception('No tables found');
    }
    foreach ($tables as $table) {
     // find the Table class
      $table_class = $table->getAttribute('class');
      // Remove cols-10/cols-11 class if any
      $table_class = preg_replace("/ cols-(\d*) /", " ", $table_class);
      // Consider only the required table
      if (in_array($table_class, $arr_table['table_class'])) {
        $arr_table['element'] = $table;
        return $arr_table;
      }
    }
    return null;
  }

  /**
   * Gets class names of columns of "Projects"/"Sandbox Projects"/"Project Issues" tables
   *
   */
  private function getColumnClasses($column = null) {
    $arr_td_classes = array(
      'Project' => 'project-name',
      'Issue links' => 'project-issue-links',
      'Project links' => 'project-project-links',
      'Project Issue' => 'views-field-project-issue-queue',
      'Issue Summary' => 'views-field-title',
    );
    if (is_null($column)) {
      return $arr_td_classes;
    }else {
      return $arr_td_classes[$column];
    }
  }

  /**
   * @Then /^I should see at least "([^"]*)" blocks(?: in column "([^"]*)"|)$/
   *
   * @param int $count
   * @param null/int $column
   */
  public function iShouldSeeAtLeastBlocks($count, $column = null)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    // Find divs with the class 'homebox-portlet' inside #homebox div
    $boxes = $this->getSession()->getPage()->findAll('css', ($column ? '#homebox div.homebox-column-wrapper-' . $column . ' div.homebox-portlet' :
      '#homebox div.homebox-portlet'));
    if (empty($boxes) || count($boxes) < $count) {
      throw new Exception(($column ? 'Column ' . $column : 'Dashboard') . ' has only less than ' . $count . ' block' . ($count > 1 ? 's' : ''));
    }
  }

  /**
   * @Then /^I should see at least "([^"]*)" items in block "([^"]*)"$/
   *
   * @param int $count
   * @param string $block
   */
  public function iShouldSeeAtLeastItemsInBlock($count, $block)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    $obj_block = $this->getBlockInnerContainer($block);
    if (!empty($obj_block)) {
      $items = $obj_block->findAll('css', '.portlet-content > .item-list ul > li');
      if (empty($items) || count($items) < $count) {
        throw new Exception('The block: ' . $block . ' has only less than ' . $count . ' item' . ($count > 1 ? 's' : ''));
      }
    }else {
      throw new Exception('The block: ' . $block . ' couldn\'t be found on Dashboard.');
    }
  }

  /**
   * @Then /^I should see the item "([^"]*)" in the block "([^"]*)"$/
   */
  public function iShouldSeeTheItemInTheBlock($item, $block)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    $obj_block = $this->getBlockInnerContainer($block);
    if (!empty($obj_block)) {
      $found = false;
      // Find <li> tags in item-list div
      $lis = $obj_block->findAll('css', '.portlet-content > .item-list ul > li');
      if (!empty($lis)) {
        foreach ($lis as $li) {
          // Check <li> text
          if ($item == $li->getText()) {
            $found = true;
            break;
          }
        }
      }
      if (!$found){
        throw new Exception('The item: '. $item . ' cannot be found in block: ' . $block);
      }
    }else {
      throw new Exception('The block: '. $block . ' couldn\'t be found on Dashboard');
    }
  }

  /**
   * Drag one block onto another one
   * As Mink-extension API methods are not working as expected, currently this function throws error while running
   *
   * @Then /^I drag the block "([^"]*)" onto "([^"]*)"$/
   *
   * @param string $origin
   *   Block name
   * @param string $destination
   *   Block name
   */
  public function iDragTheBlockOnto($origin, $destination)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    $block_ele = $this->getBlockInnerContainer($origin);
    if (!empty($block_ele) && $draggable = $block_ele->getParent()) {
      $droppable = $this->getBlockInnerContainer($destination)->getParent()->getParent();
      if ($droppable) {
        $this->getSession()->wait(1, '');
        $draggable->dragTo($droppable);
        $this->getSession()->wait(1, '');
      }else {
        throw new Exception('The block: ' . $destination . ' cannot be found on Dashboard');
      }
    }else {
      throw new Exception('The block: ' . $origin . ' cannot be found on Dashboard');
    }
  }

  /**
   * @Then /^I drag the block "([^"]*)" onto column "([^"]*)"$/
   */
  public function iDragTheBlockOntoColumn($origin, $destination)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    $block_ele = $this->getBlockInnerContainer($origin);
    if (!empty($block_ele) && $draggable = $block_ele->getParent()) {
      $droppable = $this->getSession()->getPage()->find('css', '#homebox-column-'. $destination );
      if ($droppable) {
        $this->getSession()->wait(1, '');
        $draggable->dragTo($droppable);
        $this->getSession()->wait(1, '');
      }else {
        throw new Exception('The column: ' . $destination . ' cannot be found on Dashboard');
      }
    }else {
      throw new Exception('The block: ' . $origin . ' cannot be found on Dashboard');
    }
  }

  /**
   * @Then /^I should not see the below <blocks> in column "([^"]*)"$/
   */
  public function iShouldNotSeeTheBelowBlocksInColumn($column, TableNode $table)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    $table = $table->getHash();
    if (!empty($table)) {
      $page = $this->getSession()->getPage();
      // Find block with header, for the column
      $blocks_h3 = $page->findAll('css', '#homebox-column-' . $column . ' h3.portlet-header > span.portlet-title');
      if (!empty($blocks_h3)) {
        $arr_boxes = array();
        foreach ($blocks_h3 as $header_span) {
          if ($boxname = $header_span->getText()) {
            $arr_boxes[] = $boxname;
          }
        }
        // Check box exists
        if (!empty($arr_boxes)) {
          foreach ($table as $item) {
            // Check the box exists in column boxes
            if (in_array($item['blocks'], $arr_boxes)) {
              throw new Exception('The box: ' . $item['blocks'] .' is present in column '. $column);
              break;
            }
          }
        }else {
          throw new Exception('The column '. $column . ' is empty');
        }
      }else {
        throw new Exception('The column '. $column . ' is empty');
      }
    }else {
      throw new Exception('Block list cannot be empty');
    }
  }

  /**
   * @Then /^I should see the block "([^"]*)" in column "([^"]*)" just "([^"]*)" the block "([^"]*)"$/
   *
   * @param string $blockToFind
   *   Block name
   * @param int $column
   * @param string $position
   *   "above" / "below"
   * @param string $blockNearBy
   *   Block name
   */
  public function iShouldSeeTheBlockInColumnJustTheBlock($blockToFind, $column, $position, $blockNearBy )
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    $arr_exporder = array();
    // Expected order
    if ($position == 'above') {
      $arr_exporder[0] = $blockToFind;
      $arr_exporder[1] = $blockNearBy;
    }elseif($position == 'below') {
      $arr_exporder[0] = $blockNearBy;
      $arr_exporder[1] = $blockToFind;
    }
    // Find blocks from the column
    $blocks_h3 = $this->getSession()->getPage()->findAll('css', '#homebox-column-' . $column . ' h3.portlet-header > span.portlet-title');
    if (!empty($blocks_h3)) {
      $arr_order = array();
      foreach ($blocks_h3 as $header_span) {
        if ($boxname = $header_span->getText()) {
          if (in_array($boxname ,$arr_exporder)) {
            $arr_order[] = $boxname;
          }
        }
      }
      // Check for errors
      if (($count = count($arr_order)) < 2) {
        throw new Exception('The box'.( $count == 1 ? '' : 'es' ) . ': "' . (implode('"," ', (!empty($arr_order) ? $arr_order : $arr_exporder))) . '" cannot be found in column: "' . $column . '"');
      }elseif($arr_order != $arr_exporder) {
        throw new Exception('The block: "' . $blockToFind . '" couldn\'t be found "' . $position . '" the block "' . $blockNearBy . '" in Column "' . $column . '"') ;
      }
    }else {
      throw new Exception('The column "' . $column . '" is empty');
    }
  }

  /**
   * @Then /^I change the setting "([^"]*)" to "([^"]*)" for the block "([^"]*)" and save$/
   *
   * @param string $setting
   * @param int $value
   * @param string $block
   */
  public function iChangeTheSettingToForTheBlockAndSave($setting, $value, $block)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    $block_inner = $this->getBlockInnerContainer($block);
    if (!empty($block_inner)) {
      $setting_link = $block_inner->find('css', 'h3.portlet-header > a.portlet-icon.portlet-settings');
      if (!empty($setting_link)) {
        // Click Settings click
        $setting_link->click();
        // Find Setting with label
        $setting_textfield = $block_inner->findField($setting);
        if (!empty($setting_textfield)) {
          $setting_textfield->setValue($value);
          // Find save button and submit
          $setting_submit = $block_inner->find('css', 'div.portlet-config > form .form-submit');
          if (!empty($setting_submit)) {
            // Submit
            $setting_submit->press();
            $block_container_id = $block_inner->getParent()->getAttribute('id');
            // Wait for the result until it is loaded through ajax
            $this->getSession()->wait(1, "typeof($('#" . $block_container_id . " > div.ahah-progress.ahah-progress-throbber').html()) == 'undefined'");
          }else {
            throw new Exception('The setting cannot be saved for the block "' . $block . '"');
          }
        }else {
          throw new Exception('The setting "' . $setting . '" cannot be found for the block: "' . $block . '"');
        }
      }else {
        throw new Exception('No Setting Icon found for the block "' . $block . '"');
      }
    }else {
      throw new Exception('The block "' . $block . '" cannot be found.');
    }
  }

  /**
   * @Then /^I close the block "([^"]*)"$/
   *
   * @param string $block
   */
  public function iCloseTheBlockFromDashboard($block)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    // Find the block inner div
    $block_inner = $this->getBlockInnerContainer($block);
    if (!empty($block_inner)) {
      // Find the close link
      $close_link = $block_inner->find('css', 'h3.portlet-header > a.portlet-icon.portlet-close');
      if (!empty($close_link)) {
        $title_span = $block_inner->find('css', 'h3.portlet-header > span.portlet-title');
        // Store the block name to temp variable
        if (!empty($title_span)) {
          HackyDataRegistry::set('block name', $title_span->getText());
        }
        // Click it
        $close_link->click();
      }else {
        throw new Exception('Close Icon cannot be found for the block "'  . $block . '"');
      }
    }else {
      throw new Exception('The block "'  . $block . '" cannot be found.');
    }
  }

  /**
   * @Then /^I should not see the block$/
   */
  public function iShouldNotSeeTheBlock() {
    $block_name = HackyDataRegistry::get('block name');
    if (!$block_name) {
      throw new Exception('Block name is empty');
    }
    $block_inner = $this->getBlockInnerContainer($block_name);
    if (!empty($block_inner)) {
      throw new Exception('The block exists on Dashboard');
    }
  }

  /**
   * @When /^I click the link "([^"]*)" to add$/
   *
   * @param string $blockLink
   */
  public function iClickTheLinkToAdd($blockLink)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    // Loop through the links
    $ul_ele = $this->getSession()->getPage()->find('css', '#homebox-add > div.item-list > ul' );
    if (!empty($ul_ele)) {
      $link = $ul_ele->findLink($blockLink);
      if (!empty($link)) {
        $link->click();
        $this->iWaitForSeconds(5);
      }else {
        $message = true;
      }
    }else {
      $message = true;
    }
    if(isset($message)) {
      throw new Exception('The link "' . $blockLink . '" cannot be found.');
    }
  }

  /**
   * @Then /^I should see the block "([^"]*)" in column "([^"]*)"(?:a|)$/
   *
   * @param string $block
   * @param int $column
   */
  public function iShouldSeeTheBlockInColumn($block, $column)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    // Find blocks from the column
    $blocks_h3 = $this->getSession()->getPage()->findAll('css', 'div#homebox-column-' . $column . ' h3.portlet-header > span.portlet-title');
    if (!empty($blocks_h3)) {
      $found = false;
      foreach ($blocks_h3 as $header_span) {
        // Find the exact block
        if ($block = $header_span->getText()) {
          $found = true;
          break;
        }
      }
      if(!$found) {
        throw new Exception('The block "' . $block . '" cannot be found');
      }
    }else {
      throw new Exception('The column ' . $column . ' is empty');
    }
  }

  /**
   * @Given /^I should see the following <icons> on the block "([^"]*)"$/
   *
   * @param string $block
   * @param TableNode object $table
   */
  public function iShouldSeeTheFollowingOnTheBlock($block, TableNode $table)
  {
    // Validate empty arguments
    $this->validateBlankArgs(func_get_args());
    // Classes for icons
    $arr_iconclasses = array(
      'settings' => 'a.portlet-icon.portlet-settings',
      'close' => 'a.portlet-icon.portlet-close',
    );
    // Find the block inner div
    $block_inner = $this->getBlockInnerContainer($block);
    if (!empty($table)) {
      foreach ($table->getHash() as $icon) {
        if (!empty($arr_iconclasses[strtolower($icon['icons'])])) {
          $icon_link = $block_inner->find('css', 'h3.portlet-header > ' . $arr_iconclasses[strtolower($icon['icons'])]);
          if (empty($icon_link)) {
            throw new Exception('The icon "' . $icon['icons'] . '" cannot be found in the block');
            break;
          }
        }else {
          throw new Exception('The icon "' . $icon['icons'] . '" cannot be found in the block');
          break;
        }
      }
    }else {
      throw new Exception('Icon list should not be empty');
    }
  }

  /**
   * Find dashboard block inner container div
   */
  private function getBlockInnerContainer($block = null) {
    $page = $this->getSession()->getPage();
    // Find blocks with header
    if (is_null($block)) {
      $blocks_h3 = array( 0 => $page->find('css', 'h3.portlet-header > span.portlet-title'));
    }else {
      $blocks_h3 = $page->findAll('css', 'h3.portlet-header > span.portlet-title');
    }
    if (!empty($blocks_h3)) {
      foreach ($blocks_h3 as $header_span) {
        if (!empty($header_span) && (is_null($block) || $block == $header_span->getText())) {
          return $header_span->getParent()->getParent();
        }
      }
    }
    return null;
  }

  /**
   * @Then /^I should see the submitted user "([^"]*)"$/
   */
  public function iShouldSeeTheSubmittedUser($submUser) {
    $result = $this->getSession()->getPage()->find('css', '.node .submitted a');
    if (!empty($result)) {
      $findUser = $result->getText('link');
      if (trim($findUser) != trim($submUser)) {
        throw new Exception('The user "' . $submUser .  '"  was not the submitted user for this issue.');
      }
    }
  }

  /**
   * @Given /^I should see the advertisment in the right sidebar$/
   */
  public function iShouldSeeTheAdvertismentInTheRightSidebar() {
    $region = $this->getSession()->getPage()->find('region', 'right sidebar');
    if (empty($region)) {
      throw new Exception("Right sidebar region was not found");
    }
    $result = $region->find('css', '#column-right-region .block-inner .block-content #gam-holder-HostingForumBlock');
    if (empty($result)) {
      throw new Exception('No advertisement exists in the right sidebar');
    }
    return $result;
  }

  /**
   * Create a book page and store the title and URL
   *
   * @Given /^I create a book page$/
   */
  public function iCreateABookPage() {
    $page = $this->getSession()->getPage();
    $this->documentTitle = $this->randomString(8);
    $page->fillField("Title:", $this->documentTitle);
    $page->fillField("Body:", "The body of the book page having more than ten words");
    HackyDataRegistry::set('book page title', $this->documentTitle);
    $page->pressButton('Save');
    sleep(2);
    HackyDataRegistry::set('document url', $this->getSession()->getCurrentUrl());
  }

  /**
   * Use the title stored in the above function and follow the link
   *
   * @When /^I follow a random book page$/
   */
  public function iFollowARandomBookPage() {
    $title = HackyDataRegistry::get('book page title');
    if ($title == "") {
      throw new Exception("Book page was not found");
    }
    return new Given("I follow \"$title\"");
  }

  /**
   * @When /^I am on the Maintainers tab$/
   */
  public function iAmOnTheMaintainersTab() {
    $path = trim(HackyDataRegistry::get('maintainers tab path'));
    if (!$path || $path == "") {
      throw new Exception("The path to Maintainers tab was not found.");
    }
    $path = $this->locatePath($path);
    return new Given("I am on \"$path\"");
  }

  /**
   * @When /^I follow "([^"]*)" for the maintainer "([^"]*)"$/
   */
  public function iFollowForTheMaintainer($link, $maintainer) {
    $page = $this->getSession()->getPage();
    $userLink = $page->findLink($maintainer);
    if (empty($userLink)) {
      throw new Exception("The maintainer '" . $maintainer . "' was not found on the page");
    }
    // Get the row in which the maintainer resides
    // a > td > tr
    $tr = $userLink->getParent()->getParent();
    // Get the $link from the row
    $link = $tr->findLink($link);
    if (empty($link)) {
      throw new Exception("The link '" . $link . "' was not found for the maintainer '" . $maintainer . "'");
    }
    $this->getSession()->visit($this->locatePath($link->getAttribute('href')));
  }

  /**
   * @When /^I assign the following <permissions> to the maintainer "([^"]*)"$/
   */
  public function iAssignTheFollowingPermissionsToTheMaintainer($maintainer, TableNode $permissions, $assign = TRUE) {
    if (empty($permissions)) {
      throw new Exception("No permissions were provided");
    }
    $permissions = $permissions->getHash();
    if (empty($permissions)) {
      throw new Exception("No permissions were provided");
    }
    // Loop through all the permissions provided and assign/unassign the permission
    foreach ($permissions as $value) {
      $permission = $value['permissions'];
      // If $assign is TRUE then "assign" permission otherwise "unassign"
      $this->iAssignToTheMaintainer($permission, $maintainer, $assign);
    }
  }

  /**
   * @When /^I assign "([^"]*)" to the maintainer "([^"]*)"$/
   */
  public function iAssignToTheMaintainer($permission, $maintainer, $assign = TRUE) {
    $page = $this->getSession()->getPage();
    // Find the row in which the $maintainer exists
    $userLink = $page->findLink($maintainer);
    if (empty($userLink)) {
      throw new Exception("The maintainer '" . $maintainer . "' was not found on the page");
    }
    // Get the user id of the maintainer
    $href = $userLink->getAttribute('href');
    // The pattern of 'href' - /user/<uid>
    $user = explode("/", $href);
    // 0 => "", 1 => "user", 2 => <uid>
    $uid  = $user[2];
    // Convert permission to lowercase
    $tempPerm = strtolower($permission);
    // Convert spaces into hyphens (-)
    $tempPerm = str_replace(" ", "-", $tempPerm);
    // Get the checkbox id using the above uid and permission
    // Format of checkbox id - edit-maintainers-2244103-permissions-maintain-issues
    $chkbxId = "edit-maintainers-" . $uid . "-permissions-" . $tempPerm;
    // Make sure the field with the above ID exists on the page
    $chkbx = $page->findField($chkbxId);
    if (empty($chkbx)) {
      throw new Exception("The permission '" . $permission . "' for the user '" . $maintainer . "' was not found on the page");
    }
    if ($assign) {
      // If a checkbox with the above id exists and it is not checked, then 'check' it
      if (!$chkbx->isChecked()) {
        $chkbx->check();
      }
    }
    else {
      // If a checkbox with the above id exists and it is checked, then 'uncheck' it
      if ($chkbx->isChecked()) {
        $chkbx->uncheck();
      }
    }
  }

  /**
   * @When /^I unassign the following <permissions> from the maintainer "([^"]*)"$/
   */
  public function iUnassignTheFollowingPermissionsFromTheMaintainer($maintainer, TableNode $permissions) {
    $this->iAssignTheFollowingPermissionsToTheMaintainer($maintainer, $permissions, FALSE);
  }

  /**
   * @When /^I unassign "([^"]*)" from the maintainer "([^"]*)"$/
   */
  public function iUnassignThePermissionFromTheMaintainer($permission, $maintainer) {
    $this->iAssignToTheMaintainer($permission, $maintainer, FALSE);
  }

  /**
   * @Given /^I am on the project page$/
   * @When /^I visit the project page$/
   */
  public function iAmOnTheProjectPage() {
    $path = $this->locatePath(HackyDataRegistry::get('project path'));
    if (!$path) {
      throw new Exception("Project was not found");
    }
    return new Given("I am on \"$path\"");
  }

  /**
   * @When /^I create a full project$/
   */
  public function iCreateAFullProject() {
    $element = $this->getSession()->getPage();
    // First check if the user has permission to create full project
    $chk = $element->findField("Sandbox");
    if (empty($chk)) {
      throw new Exception("No Sandbox checkbox was found");
    } 
    if ($chk->hasAttribute("disabled")) {
      throw new Exception("You do not have permissions to create a full project");
    }
    $this->projectTitle = strtolower($this->randomString(16));
    HackyDataRegistry::set('project title', $this->projectTitle);

    $element->fillField('Project title', $this->projectTitle);
    $element->fillField('Maintenance status', '13028'); /* Actively Maintained */
    $element->fillField('Development status', '9988'); /* Under Active Development */
    $this->iSelectTheRadioButtonWithTheId('Modules', 'edit-project-type-14');
    $element->fillField('Description', $this->randomString(32));
    $chk->uncheck();
    $this->projectShortName = strtolower($this->randomString(6));
    HackyDataRegistry::set('project_short_name', $this->projectShortName);
    $element->fillField('Short project name', $this->projectShortName);
    $element->pressButton('Save');
    sleep(2);
    HackyDataRegistry::set('project_url', $this->getSession()->getCurrentUrl());
  }

  /**
   * @Then /^I create a new issue$/
   */
  public function iCreateANewIssue() {
    $element = $this->getSession()->getPage();
    $this->issueTitle = $this->randomString(12);
		$field = $this->getSession()->getPage()->findField('Version');
		if(!empty($field)) {
		$element->selectFieldOption("Version", "6.x-1.0");
		}
    $element->selectFieldOption("Component", "Code");
    $element->selectFieldOption("Category", "task");
    $element->selectFieldOption("Component", "Code");
    $element->fillField("Title:", $this->issueTitle);
    $element->fillField("Description:", $this->randomString(18));
    HackyDataRegistry::set('issue title', $this->issueTitle);
    $element->pressButton("Save");
    sleep(2);
    HackyDataRegistry::set('issue_url', $this->getSession()->getCurrentUrl());
  }

  /**
   * @Given /^I follow an issue of the project$/
   */
  public function iFollowAnIssueOfTheProject() {
    $issueTitle = HackyDataRegistry::get('issue title');
    if (!$issueTitle) {
      throw new Exception("No issue was found");
    }
    return new Given("I follow \"$issueTitle\"");
  }

  /**
   * Step definition to be called immediately after initializing repo or cloning a repo
   *
   * @Then /^I should be able to push (?:a|one more) commit to the repository$/
   */
  public function iShouldBeAbleToPushACommitToTheRepository($canCommit = TRUE) {
    // Get the project folder name and make sure there is a clone
    $projectTitle = strtolower(HackyDataRegistry::get('project_short_name'));
    if (!$projectTitle) {
      $projectTitle = strtolower(HackyDataRegistry::get('project title'));
    }
    if (!$projectTitle) {
      throw new Exception("No project found to push");
    }
    // Make sure the project directory exists before any step is taken
    $cwd = getcwd();
    if (!is_dir($cwd . '/' . $projectTitle)) {
      throw new Exception("The folder '" . $projectTitle . "' does not exist. Please clone the repository");
    }
    $page = $this->getSession()->getPage();
    $currUrl = $this->getSession()->getCurrentUrl();
    // Get the git username from the code block
    $codeBlock = $page->find('css', '.codeblock code');
    $code = $codeBlock->getText();
    $userData = $userData = $this->getGitUserData($code);
    if (!$userData) {
      throw new Exception("Git username was not found on the page");
    }
    $gitUsername = $userData['username'];
    $password = $userData['password'];
    // Move into the project folder
    chdir($projectTitle);
    // Set the git config user.email and user.name
    if (!$this->setGitConfig($gitUsername)) {
      throw new Exception("Unable to set the git config value");
    }
    // Come back to the current page
    $this->getSession()->visit($currUrl);
    // Edit the info file present in the folder
    $fh = fopen($projectTitle . ".info", "a");
    fwrite($fh, "Test data for BDD");
    fclose($fh);
    // Git add
    $process = new Process('git add ' . $projectTitle . '.info');
    $process->run();
    if (!$process->isSuccessful()) {
      throw new RuntimeException('Git add failed - ' . $process->getErrorOutput());
    }
    // Git commit
    $process = new Process('git commit -m "by ' . $gitUsername . ': From the step definition"');
    $process->run();
    if (!$process->isSuccessful()) {
      throw new RuntimeException('Git commit failed - ' . $process->getErrorOutput());
    }
    // Git push
    $password = $this->fetchPassword('git', $gitUsername);
    $process = new Process("../bin/gitwrapper $password");
    $process->run();
    if($canCommit) {
      if (!$process->isSuccessful()) {
        throw new RuntimeException('Git push failed - ' . $process->getErrorOutput());
      }
    }
    else {
      // User should not be able to push. This will be successfull if he pushes
      $output = $process->getOutput();
      if (strpos($output, "You are required to accept the Git Access Agreement") === FALSE) {
        throw new RuntimeException('User is able to push the commit to the repository');
      }
    }
    // Move out of the project folder
    chdir("../");
  }

  /**
   * Function to check if an option is present in the dropdown
   *
   * @Then /^I should see "([^"]*)" in the dropdown "([^"]*)"$/
   *
   * @param string $value
   *   The option string to be searched for
   * @param string $field
   *   The dropdown field label
   */
  public function iShouldSeeInTheDropdown($value, $field) {
    $page = $this->getSession()->getPage();
    // Get the object of the dropdown field
    $dropDown = $page->findField($field);
    if (empty($dropDown)) {
      throw new Exception('The page does not have the dropdown with label "' . $field . '"');
    }
    // Get all the texts under the dropdown field
    $options = $dropDown->getText();
    if (strpos(trim($options), trim($value)) === FALSE) {
      throw new Exception('The dropdown "' . $field . '" does not have the option "' . $value . '", but it should be.');
    }
  }

  /**
   * @When /^I follow "([^"]*)" for version "([^"]*)"$/
   */
  public function iFollowForVersion($link, $version) {
    $result = $this->getRowOfLink($this->getSession()->getPage(), $version, $link);
    if (empty($result)) {
      throw new Exception("The link '" . $link . "' was not found for the version '" . $version . "' on the page.");
    }
    $href = $result->getAttribute('href');
    return new Given("I am at \"$href\"");
  }

  /**
   * @When /^I download the "([^"]*)" file for version "([^"]*)"$/
   */
  public function iDownloadTheFileForVersion($format, $version) {
    $flag = 0;
    $noDownloadMsg = "The '" . $format. "' file for version '" . $version . "' was not downloaded";
    $result = $this->getRowOfLink($this->getSession()->getPage(), $version, $format);
    if (empty($result)) {
      throw new Exception("The format '" . $format . "' was not found for the version '" . $version . "' on the page.");
    }
    $href = $result->getAttribute('href');
    $this->getSession()->visit($href);

    // Will work only on Goutte. Selenium does not support responseHeaders
    $responseHeaders = $this->getSession()->getResponseHeaders();
    if ((int) $responseHeaders['Content-Length'][0] > 10000) {
      // If "tar" is requested, then check corresponding content type
      if ($format == "tar") {
        if ($responseHeaders['Content-Type'] != "application/x-gzip") {
          throw new Exception($noDownloadMsg);
        }
      }
      // If "zip" is requested, then check corresponding content type
      elseif ($format == "zip") {
        if ($responseHeaders['Content-Type'] != "application/zip") {
          throw new Exception($noDownloadMsg);
        }
      }
      // If any thing other than tar or zip is requested, throw error
      else {
        throw new Exception("Only 'tar' and 'zip' files can be downloaded");
      }
    }
    else {
      throw new Exception($noDownloadMsg);
    }
    // Verify that the current url has FTP
    if (strpos($href, "http://ftp.drupal.org") === FALSE) {
      throw new Exception($noDownloadMsg);
    }
    else {
      // Get the filename and store it for use in the next step
      $temp = explode("/", $href);
      $filename = $temp[sizeof($temp) - 1];
      $this->downloadedFileName = trim($filename);
    }
  }

  /**
   * @Then /^the downloaded file name should be "([^"]*)"$/
   */
  public function theDownloadedFileNameShouldBe($filename) {
    if ($filename != $this->downloadedFileName) {
      throw new Exception("The filename did not match");
    }
  }

  /**
   * Function to get the link corresponding to a particular row based on selector
   *
   * @param object $page
   *   The page object in which the link is present
   * @param string $linkRow
   *   The link to find in the page
   * @param string $link
   *   The link to find in the row obtained by $linkRow
   * @return object $result
   *   The link object found in the selected row
   */
  private function getRowOfLink($page, $linkRow, $link) {
    // Find the link corresponding to the version specified
    $result = $page->findLink($linkRow);
    if (empty($result)) {
      throw new Exception("The link '" . $linkRow . "' was not found on the page");
    }
    // Navigate above to read the row. a > td > tr
    $tr = $result->getParent()->getParent();
    if (empty($tr)) {
      throw new Exception("No rows were found on the page for the link '" . $linkRow . "'");
    }
    // Find the link $link in the current row
    $result = $tr->findLink($link);
    if (empty($result)) {
      throw new Exception("The link '" . $link . "' was not found for the row '" . $linkRow . "' on the page.");
    }
    return $result;
  }

	/**
   * @Given /^(?:that I|I) create(?:|d) a sandbox project$/
   */
  public function iCreatedASandboxProject() {
    $session = $this->getSession();
    $session->visit($this->locatePath('/node/add/project-project'));
    $page = $this->getSession()->getPage();
    $this->iCreateA('theme');
    HackyDataRegistry::set('sandbox_url', $this->getSession()->getCurrentUrl());
    return new Given('I check the project is created');

  }

  /**
   * Promote a sandbox project:
   * @When /^I promote the project$/
   */
  public function iPromoteTheProject() {
    // Read sandbox code block and save for later use
    $this->saveSandboxGitEndpoint();
    $page = $this->getSession()->getPage();
    $page->clickLink('Edit');
    $page = $this->getSession()->getPage();
    $page->clickLink('Promote');
    $page->checkField('confirm');
    $this->projectShortName = $this->randomString(10);
    HackyDataRegistry::set('project_short_name', $this->projectShortName);
    $page->fillField('Short project name:', $this->projectShortName);
    $page->pressButton('Promote to full project');
    $page = $this->getSession()->getPage();
    // Confirm promote
    $page->pressButton('Promote');
  }

  /**
   * @Then /^I should have a local copy of (?:the|([^"]*)") project$/
   */
  public function iShouldHaveALocalCopyOfTheProject($project = null) {
    $project_shortname = $project ? $project : HackyDataRegistry::get('project_short_name');
    if (empty($project_shortname)) {
      throw new Exception('The project cannot be found.');
    }
    if (!is_dir($project_shortname)) {
      $project_shortname = strtolower($project_shortname);
    }
    return new Then('I should have a local copy of "' . $project_shortname . '"');
  }

  /**
   * @Then /^I should see an error$/
   */
  public function iShouldSeeAFatalError() {
    if (empty($this->process_output)) {
      throw new Exception("Process output is not found");
    }
    // Look for error in the output
    if (!preg_match("/(?:fatal: |warning: )/", $this->process_output)) {
      throw new Exception("The error did not happen as expected");
    }
  }

  /**
   * Get logged in username if user session exists
   *
   */
  private function getLoggedinUsername() {
    // Return saved username if the user is logged in
    // This is to make sure the already saved username is not used if there is no user session
    if ($this->getSession()->getPage()->findLink('Log out')) {
      return HackyDataRegistry::get('username');
    }
    return null;
  }

	/**
   * @Then /^I should see the <users> with the following <permissions>$/
   */
  public function iShouldSeeTheUsersWithTheFollowingPermissions(TableNode $table, $assign = TRUE) {
    $message = '';
    $table = $table->getHash();
    if (empty($table)) {
      throw new Exception("No maintainers for this project");
    }
    $ths = $this->getSession()->getPage()->findAll('css', '#project-maintainers-form table thead tr th');
	  if (empty($ths)) {
      throw new Exception("Could not find project maintainers desired permissions for this project");
    }
    $arr_th = array();
    foreach ($ths as $th) {
      if ('User' != ($header = $th->getText())) {
        $arr_th[] = $header;
      }
    }
    foreach ($table as $data) {
      $user = $data['users'];
      $permission = $data['permissions'];
			$userLink = $this->getSession()->getPage()->findLink($user);
      if (empty($userLink)) {
        $message .= 'The page does not have the following user "' . $user . '" '. "\n";
      }
			// a -> td -> tr In order to find the maintainers link for checking his permissons.
      else {
        $tr = $userLink->getParent()->getParent();
        $vcsCheckboxes = $tr->findAll('css', 'td .form-item .form-checkbox');
        if (empty($vcsCheckboxes)) {
          throw new Exception('The page could not find any checkboxes');
        }
				$index = array_search($permission, $arr_th);
				// Find the checkbox corresponding to the header column.
        $chk = $vcsCheckboxes[$index];
				if ($assign) {
          // If a checkbox with the above id exists and it is not checked, then 'check' it.
					if (!($chk->hasAttribute('checked'))) {
					  // The error messages will be concatenated and message will be thrown at the end.
					 	$message .= 'The user "' . $user . '" does not have "' . $permission . '" permissions' . "\n";
					}
				}
				else {
					if (($chk->hasAttribute('checked'))) {
					  // The error messages will be concatenated and message will be thrown at the end.
						$message .= 'The user "' . $user . '" already have the mentioned "' . $permission . '" permissions' . "\n";
					}
				}
			}
    }
    if (($message)) {
      throw new Exception($message);
    }
  }

  /**
   * @Given /^I should see the <users> without the following <permissions>$/
   */
  public function iShouldSeeTheUsersWithoutTheFollowingPermissions(TableNode $table) {
    $this->iShouldSeeTheUsersWithTheFollowingPermissions($table, FALSE);
  }

  /**
   * @Then /^I (?:|should )see the (?:issue|document) title$/
   */
  public function iShouldSeeTheTitle() {
    $page = $this->getSession()->getPage();
    $element = $page->find('css', 'h1#page-subtitle');
    $title = $type
           = "";
    if (isset($this->issueTitle)) {
      $title = $this->issueTitle;
      $type = 'Issue';
    }elseif ($title = HackyDataRegistry::get('book page title')) {
      $type = 'Document';
    }

    if (empty($title) || empty($element) || strpos($element->getText(), $title) === FALSE) {
      throw new Exception($type . ' title not found where it was expected.');
    }
  }

  /**
   * Function to get the email address of the currently logged in user
   * @return string/FALSE
   *   Return the email address if user is logged in or return FALSE otherwise
   */
  private function getMyEmail() {
    $session = $this->getSession();
    $session->visit($this->locatePath('/user'));
    $page = $session->getPage();
    // Find the Edit link and click on it
    if ($editLink = $page->findLink("Edit")) {
      $editLink->click();
      $page = $session->getPage();
      // Get the value from Email address field
      if ($emailField = $page->findField("E-mail address:")) {
        return $emailField->getAttribute("value");
      }
    }
    throw new Exception("Unable to get current user's email address");
  }

  /**
   * Function to get the Title for Post of type Issue
   */
  function getIssueTiteObj($page) {
    $temp = HackyDataRegistry::get('issue title');
    $result = $page->findLink($temp);
    if (!empty($result)) {
     return $result;
	}
  }

	/**
   * @Given /^I add (?:a|one more) comment to the issue$/
   */
  public function iAddACommentToTheIssue() {
    $page = $this->getSession()->getPage();
    $this->comment = $this->randomString(12);
    $page->fillField("Comment:", $this->comment);
    $page->pressButton("Save");
  }

  /**
   * Function to set the git config user.name and user.email
   * @param string $gitUsername
   *   Git username to supply for user.name
   * @return boolean True/Exception
   *   Return True if success, exception otherwise
   */
  private function setGitConfig($gitUsername = "") {
    $email = $this->getMyEmail();
    if ($email) {
      $process = new Process('git config user.email "' . $email . '"');
      $process->run();
      if (!$process->isSuccessful()) {
        throw new Exception("Unable to set user.email '" . $email . "' in git config");
      }
      if ($gitUsername == "") {
        $gitUsername = $this->whoami();
      }
      $process = new Process('git config user.name "' . $gitUsername . '"');
      $process->run();
		  if (!$process->isSuccessful()) {
    	  throw new Exception("Unable to set user.name '" . $gitUsername . "' in git config");
      }
    }
    return TRUE;
  }

  /**
   * @Then /^I should see the project link$/
   */
  public function iShouldSeeTheProjectLink() {
    $projectTitle = HackyDataRegistry::get('project title');
    $link = $this->getSession()->getPage()->findLink($projectTitle);
    if (empty($link)) {
      throw new Exception("The project title '" . $projectTitle . "' was not found on the page");
    }
  }

  /**
   * @Given /^I should see "([^"]*)" commit(?:|s) for the project$/
   */
  public function iShouldSeeCommitsForTheProject($count) {
    $projectTitle = HackyDataRegistry::get('project title');
    if (!$projectTitle) {
      throw new Exception("No project found");
    }
    $page = $this->getSession()->getPage();
    $prjLink = $page->findLink($projectTitle);
    if (empty($prjLink)) {
      throw new Exception("Project '" . $projectTitle . "' was not found on the page");
    }
    // a > li
    $li = $prjLink->getParent();
    $text = $li->getText();
    // Fomat <a href='link'>text</a> (5 commits)
    $temp = explode("(", $text);
    // Array here [0] = <a href='link'>text</a> [1] = 5 commits)
    $temp = explode(" commits", $temp[1]);
    // Array here [0] = 5
    $commits = (int) trim($temp[0]);
    if ($commits != $count) {
      throw new Exception("Found '" . $count . "' commit(s) instead of '" . $commits . "'");
    }
  }

  /**
   * Function to delete the repository folder
   * @param string $folderName
   *   Name of the folder to delete
   */
  private function deleteFolder($folderName) {
    // Repos on drupal.org never contain capital letters.
    if (!empty($folderName)) {
      if (strpos($folderName, '/') === FALSE) {
        if (file_exists($folderName) && is_dir($folderName)) {
          $process = new Process("rm -Rf $folderName");
          $process->setTimeout(10);
          $process->run();
        }
      }
    }
  }

  /**
   * @Given /^I fill in "([^"]*)" with a "([^"]*)" ssh key$/
   */
  public function iFillInWithASshKey($field, $validity) {
    if ($validity == "valid") {
      $key = HackyDataRegistry::get('sshkey');
    }
    elseif ($validity == "invalid") {
      $key = substr(HackyDataRegistry::get('sshkey'), 10);
    }
    if (trim($key) == "") {
      throw new Exception("No SSH Key was found");
    }
    return new Given("I fill in \"$field\" with \"$key\"");
  }

  /**
   * @When /^I follow "([^"]*)" for a key$/
   */
  public function iFollowForAKey($link) {
    $column = "";
    $page = $this->getSession()->getPage();
    $title = HackyDataRegistry::get('sshkey title');
    if (trim($title) == "") {
      throw new Exception("SSH key title was not found");
    }
    // Get all the columns
    $text = $page->find("xpath", '//td[text()="' . $title . '"]');
    if (empty($text)) {
      throw new Exception("Could not find the title '" . $title . "'");
    }
    // Get the row of the title -- text > td > tr
    $tr = $text->getParent()->getParent();
    if (!$tr) {
      throw new Exception("Could not find the title '" . $title . "'");
    }
    $linkResult = $tr->findLink($link);
    if (empty($linkResult)) {
      throw new Exception("Could not find '" . $link . "' for the title '" . $title . "'");
    }
    $href = $this->locatePath($linkResult->getAttribute('href'));
    return new Given("I am at \"$href\"");
  }

  /**
   * @Given /^I generate a ssh key$/
   */
  public function iGenerateASshKey() {
    // Give a title for this key
    $title = $this->randomString(8);
    $pass = $this->randomString(10);
    $sshFile = "files/$title";
    $pubFile = "files/$title.pub";
    $command = "ssh-keygen -f \"$sshFile\" -N \"$pass\" -t rsa -C \"$title\"";
    $process = new Process($command);
    $process->run();
    if (!$process->isSuccessful()) {
      throw new RuntimeException('No key was generated - ' . $process->getErrorOutput());
    }
    // If the file does not exist, then key has not generated
    if (!file_exists($pubFile)) {
      throw new Exception("No key was generated");
    }
    // Open the file and read the key
    $fh = fopen($pubFile, "r");
    $key = fread($fh, filesize($pubFile));
    if (trim($key) == "") {
      throw new Exception("No key was generated");
    }
    // Store the key and title for other step definitions to use
    HackyDataRegistry::set('sshkey', $key);
    HackyDataRegistry::set('sshkey title', $title);
    // Delete the files as they are no longer required after this function
    $process = new Process("rm -Rf $sshFile");
    $process->run();
    $process = new Process("rm -Rf $pubFile");
    $process->run();
  }

  /**
   * @AfterScenario @clean_data
   *
   * Delete test project/issue nodes
   */
  public function cleanData() {
    // Read stored project url and delete
    $arr_nodeurl = array();
    if ($project_url = HackyDataRegistry::get('project_url')) {
      $arr_nodeurl[] = $project_url;
    }
    if ($issue_url = HackyDataRegistry::get('issue_url')) {
      $arr_nodeurl[] = $issue_url;
    }
    if ($sandbox_url = HackyDataRegistry::get('sandbox_url')) {
      $arr_nodeurl[] = $sandbox_url;
    }
    if ($project_path = HackyDataRegistry::get('project path')) {
      $arr_nodeurl[] = $project_path;
    }
    // Test Document/Book page
    if ($document_url = HackyDataRegistry::get('document url')) {
      $arr_nodeurl[] = $document_url;
    }
    if (empty($arr_nodeurl)) {
      return;
    }
    $arr_nodeurl = array_unique($arr_nodeurl);
    // Log in as admin to perform node deletion
    $this->iAmLoggedInAs('admin test');
    $session = $this->getSession();
    foreach ($arr_nodeurl as $url) {
      $session->visit($this->locatePath($url));
      sleep(1);
      $editLink = $session->getPage()->findLink('Edit');
      if (empty($editLink)) {
        continue;
      }
      if (!$editLink->hasAttribute("href")) {
        continue;
      }
      $session->visit($this->locatePath($editLink->getAttribute('href')));
      sleep(1);
      $page = $session->getPage();
      $page->fillField("Log message:", 'Deleted');
      $page->pressButton("Delete");
      sleep(1);
      // Confirm delete
      $page->pressButton("Delete");
    }
  }

  /**
   * Function to get the username and password from the git url
   *
   * @param string $repo
   *   The repository URL
   *
   * @return array/false
   *   Return an array containing username and password or return false
   */
  private function getGitUserData($repo) {
    // If user is not logged in, then return false
    if (!$this->getLoggedinUsername()) {
      return FALSE;
    }
    $gitUsername = "";
    $password = "";
	  $code = explode("@", $repo);
	  $code = explode(" ", $code[0]);
  	$gitUsernameTemp = trim(end($code));
    $gitUsername = str_replace("ssh://", "", $gitUsernameTemp);
	  if (!isset($this->git_users[$gitUsername])) {
  	  $gitUsernameTemp = trim($code[sizeof($code) - 2]);
      $gitUsername = str_replace("ssh://", "", $gitUsernameTemp);
    }
    if (!isset($this->git_users[$gitUsername])) {
      return FALSE;
    }
    $password = $this->git_users[$gitUsername];
	  return array('username' => $gitUsername, 'password' => $password);
  }

  /**
   * @Given /^I push "([^"]*)" commit(?:|s) to the repository$/
   * @Given /^I (?:|should be able to) push "([^"]*)" commit(?:|s) to the repository$/
   */
  public function iPushCommitsToTheRepository($count) {
    if (!$count || $count == 0 || $count == "") {
      throw new Exception("The number of commits required should be greater than zero");
    }
    for ($i = 0; $i < $count; $i++) {
      $this->iShouldBeAbleToPushACommitToTheRepository();
      // take some rest!
      sleep(1);
    }
  }

  /**
   * @Then /^I should not be able to push a commit to the repository$/
   */
  public function iShouldNotBeAbleToPushACommitToTheRepository() {
    $this->iShouldBeAbleToPushACommitToTheRepository(FALSE);
  }

  /**
   * @Given /^I am on the document page$/
   */
  public function iAmOnTheDocumentPage() {
    $doc_url = HackyDataRegistry::get('document url');
    if (empty($doc_url)) {
      throw new Exception('There is no url for the document');
    }
    $this->getSession()->visit($this->locatePath($doc_url));
    sleep(2);
    // Find and save metdata string
    $updates = $this->getSession()->getPage()->find('css', 'div.node-content > p.updated > em');
    if (empty($updates)) {
      throw new Exception(ucwords($type) . ' cannot be found on the document');
    }
    $this->updates = $updates->getText();
    return new Then("I should see the document title");
  }

  /**
   * @When /^I edit the document$/
   */
  public function iEditTheDocument() {
    sleep(2);
    $page = $this->getSession()->getPage();
    $body = $page->findField('Body:');
    if (empty($body)) {
      throw new Exception('The body field is not found in the page. Make sure you are on the document edit page');
    }
    // Attach some strings to document body
    $text = $body->getText() . "\n" . chunk_split($this->randomString(50), 5, " ");
    $body->setValue($text);
    $page->fillField('Log message:', 'Updated document');
    $page->pressButton('Save');
  }

  /**
   * @Given /^I should not see "([^"]*") in editor usernames$/
   * Creator user name should not be included with editors even if the document is edited by creator
   * Editor usernames should not have duplicates
   */
  public function iShouldNotSeeInEditorUsernames($type) {
    if ($type == 'creator usernames') {
      $created_user = HackyDataRegistry::get('document creator');
      if (empty($created_user)) {
        throw new Exception('Created username cannot be found');
      }
      if (true === strpos($this->edited_users, $created_user)) {
        throw new Exception('Editor usernames contains Document creator');
      }
    }
    elseif ($type == 'repeated usernames') {
      // Check for duplicates in editor usernames
      // Find usernames between "Edited by " and ". You can edit"
      $editors = substr($this->updates, strpos($this->updates, 'Edited by ') + 10,  (strlen($this->updates) - strpos($this->updates, '. You can edit')) * -1);
      $arr_editors = explode(',', $editors);
      if ($arr_editors != array_unique($arr_editors)) {
        throw new Exception('Editor usernames has duplicate values');
      }
    }
  }

  /**
   * Verify necessary data from Revisions tab
   *
   * last updated date
   * @Then /^the "([^"]*)" should match the (?:latest|first|usernames in the) revision(?:|s)$/
   *
   * @param string $type
   *   The type of value to be verified. Valid values "created by username, created date, last updated date, editor usernames"
   *
   */
  public function theShouldMatchTheRevision($type) {
    switch ($type) {
      // First 4 editors
      case 'editor usernames':// old: latest four unique entries
        if (!$this->edited_users = $this->readDataFromRevisions('edited_users')) {
          throw new Exception('Edited usernames cannot be found');
        }
        $string = 'Edited by ' . $this->edited_users;
        if (empty($this->edited_users) || false === strpos($this->updates, $string)) {
          throw new Exception('Editor usernames don\'t match with the latest unique entries in revisions');
        }
        break;
      // Last updated date: First row
      case 'last updated date'://old: date for current
        if (!$updated_date = $this->readDataFromRevisions('updated_date')) {
          throw new Exception('Last updated date cannot be found');
        }
        $string = 'Last updated ' . $updated_date;
        if (empty($updated_date) || false === strpos($this->updates, $string)) {
          throw new Exception('Last updated date doesn\'t match with latest revision date');
        }
        break;
      // The first entry made to reisions will be for creator
      case 'created date'://old: last entry
        if (!$created_date = $this->readDataFromRevisions('created_date')) {
          throw new Exception('Created date cannot be found');
        }
        $string = 'on ' . $created_date;
        if (empty($created_date) || false === strpos($this->updates, $string)) {
          throw new Exception('Created date doesn\'t match with the last entry in revisions');
        }
        break;
      case 'created by username':
        if (!$created_user = $this->readDataFromRevisions('created_user')) {
          throw new Exception('Created username cannot be found');
        }
        $string = 'Created by ' . $created_user;
        if (empty($created_user) || false === strpos($this->updates, $string)) {
          throw new Exception('Creator username doesn\'t match with the last entry in revisions');
        }
        break;
    }
  }

  /**
   * Parse revision tab and read data
   * @param string $type
   *   type of data required from revisions
   * @return string
   *   date/usernames
   *
   */
  private function readDataFromRevisions($type) {
    $session = $this->getSession();
    $current_url = $session->getCurrentUrl();
    // Visit revisions tab
    $session->visit($this->locatePath($current_url . '/revisions'));
    switch($type) {
      case 'updated_date':
        // Last updated date will be date showing in the first row of revisions table
        $tables = $session->getPage()->findAll('css', 'form#diff-node-revisions > div > table');
        if (empty($tables)) {
          throw new Exception('Revisions table cannot be found.');
        }
        // Point to the last table
        $table = end($tables);
        $link = $table->find('css', 'tbody > tr > td > a');
        if (empty($link)) {
          throw new Exception('Updated date link cannot be found.');
        }
        $arr_date = explode(" ", $link->getText());
        // Move back to previous page
        $session->visit($this->locatePath($current_url));
        // Convert date to the date format: 'F d, Y' (January 1, 2012)
        return $this->formatSiteDate($arr_date[0]);
        break;
      case 'created_user':
      case 'created_date':
        if ($session->getPage()->hasLink('Go to last page')) {
          $session->visit($this->locatePath($session->getPage()->findLink('Go to last page')->getAttribute('href')));
          $go_back = $session->getCurrentUrl();
        }
        $tables = $session->getPage()->findAll('css', 'form#diff-node-revisions div table');
        if (empty($tables)) {
          throw new Exception('Revisions table cannot be found.');
        }
        // Point to the last table
        $table = end($tables);
        $trs = $table->findAll('css', 'tbody tr');
        if (empty($trs)) {
          throw new Exception('Revisions entries cannot be found.');
        }
        $tr = end($trs);
        $links = $tr->find('css', 'td')->findAll('css', 'a');
        if (empty($links)) {
          throw new Exception('Created date/Username cannot be found.');
        }
        $created_date = $this->formatSiteDate(substr($links[0]->getText(), 0, 10));
        $username = $links[1]->getText();
        if ($type == 'created_user') {
          $string = $username;
        }
        elseif ($type == 'created_date') {
          $string = $created_date;
        }
        if (isset($go_back)) {
          $session->visit($this->locatePath($go_back));
        }
        HackyDataRegistry::set('document creator', $username);
        // Move back to the previous page
        $session->visit($this->locatePath($current_url));
        return $string;
        break;
      case 'edited_users':
        $tables = $session->getPage()->findAll('css', 'form#diff-node-revisions div table');
        // Point to the last table
        $table = end($tables);
        $trs = $table->findAll('css', 'tbody tr');
        $arr_users = array();
        $created_user = HackyDataRegistry::get('document creator');
        foreach ($trs as $tr) {
          $links = $tr->find('css', 'td')->findAll('css', 'a');
          $username = $links[1]->getText();
          // Exclude creator username and already included editors
          if ($username != $created_user && !in_array($username, $arr_users)) {
            $arr_users[] = $username;
          }
          if (count($arr_users) == 4) {
            break;
          }
        }
        // Move back to the previous page
        $session->visit($this->locatePath($current_url));
        return implode(', ', $arr_users);
        break;
    }
  }

  /**
   * Convert d/m/Y to the given date format
   * @param string $date
   *   date
   * @param string $format
   *   date format
   */
  private function formatSiteDate($date, $format = 'F d, Y') {
    list($date, $month, $year) = explode('/', $date);
    return date($format, strtotime("$year-$month-$date"));
  }

  /**
   * @Given /^I follow "([^"]*)" tab$/
   */
  public function iFollowTab($link) {
    $tabLink = "";
    $page = $this->getSession()->getPage();
    // Get all the links from the tabs
    $tabs = $page->findAll('css', '#tabs .tabs li a');
    if (empty($tabs)) {
      throw new Exception('The page does not have any tabs');
    }
    // Loop throught each link and find the one required
    foreach($tabs as $tab) {
      if (trim($tab->getText()) == $link) {
        $tabLink = $tab;
        break;
      }
    }
    // Make sure you have the link
    if (!$tabLink || $tabLink == "") {
      throw new Exception('The tab "' . $link . '" was not found on the page');
    }
    $tabLink->click();
    sleep(2);
  }

  /**
   * Function to check for the issue link
   * @Then /^I (?:|should )see the issue link$/
   */
  public function iShouldSeeTheIssueLink() {
    $page = $this->getSession()->getPage();
    $link = $this->getIssueTiteObj($page);
	if (empty($link)) {
      throw new Exception('Could Not find the link in the current page');
    }
  }

  /**
   * Custom step definition to click a link that follows specific actions
   *
   * @When /^I click "([^"]*)" link$/
   * @param string $link
   *   Link title
   * @param boolean $throw
   *   Whether to show exception message
   */
  public function iClickLink($link, $throw = true) {
    sleep(2);
    $page = $this->getSession()->getPage();
    $clicked = false;
    // Perform some operations specific to the link, after clicking the link
    //Homepage preference settings links
    if (in_array($link, array('Make this your Homepage', 'Use Default Homepage'))) {
      // Reset homepage setting value
      if (!HackyDataRegistry::get('homepage setting')) {
        $this->changeDefaultHomepageSetting('reset');
      }
      $element = $page->findLink($link);
      if (!empty($element)) {
        $element->click();
        // As the operation is done through ajax, wait until the link disappears from the dom or for 3 seconds
        $this->iWaitForSeconds(1, "$('a:contains(\"" . $link . "\")').text() == \"\"");
        $clicked = true;
      }
    }
    // Drupal banner in the header
    elseif($link == 'drupal banner') {
      $element = $page->find('css', 'div#header-left-inner > div#site-name > a');
      if (!empty($element)) {
        $element->click();
        $clicked = true;
      }
    }
    // Other links fall here
    else {
      $element = $page->findLink($link);
      if (!empty($element)) {
        $element->click();
        $clicked = true;
      }
    }
    if (!$clicked) {
      $message = '"' . ucfirst($link) . '" link is not found on the page';
      //Either throw exception or print it depending on the passed value.
      //As this function is called from @revert_homepage_setting as well, throwing exception is controlled here
      if ($throw) {
        throw new Exception($message);
      }
      else {
        echo $message;
      }
    }
  }

  /**
   * @When /^I click the drupal banner in the header$/
   *
   */
  public function iClickTheDrupalBannerInTheHeader() {
    return new When('I click "drupal banner" link');
  }

  /**
   * Change home page setting value on user dashboard
   *
   * @Given /^I "([^"]*)" the default homepage setting$/
   * @param string $action
   *   reset:  Reset setting to "Make this your Homepage"
   *   revert:  Revert setting to the original value
   */
  public function changeDefaultHomepageSetting($action) {
    $page = $this->getSession()->getPage();
    // Reset setting to 'Use Default Homepage'
    if ($action == 'reset') {
      $link = $page->findLink('Use Default Homepage');
      if ($link) {
        // Since Dashboard is already selected as homepage, save 'Use Default Homepage' for later use
        HackyDataRegistry::set('homepage setting', 'Use Default Homepage');
        $this->iClickLink("Use Default Homepage");
      }
      else {
        HackyDataRegistry::set('homepage setting', 'Make this your Homepage');
      }
    }
    // Revert setting to saved default setting
    elseif($action == 'revert') {
      $setting = HackyDataRegistry::get('homepage setting');
      if (empty($setting)) {
        // Assume that revert is not required
        return;
      }
      // Find setting link
      $link = $page->find('css','form#drupalorg-set-home div a');
      if (empty($link)) {
        echo "\n" . 'Homepage setting link is not found. Revert failed';
        return;
      }
      // Compare current setting with saved default setting
      if ($setting != $link->getText()) {
        HackyDataRegistry::set('homepage setting', '');
        // Use the click statement to make sure ajax request is complete
        $this->iClickLink($link->getText(), false);
      }
    }
  }

  /**
   * Revert user dashboard home page setting to original value
   *
   * @afterScenario @revert_homepage_setting
   * @return object When
   */
  public function revertHomepageSetting() {
    $session = $this->getSession();
    $page = $session->getPage();
    // Visit dashboard page to find the setting link
    $link = $page->findLink("Your Dashboard");
    if (empty($link)) {
      echo "\n" . '"Your Dashboard" link is not found. Revert failed';
      return;
    }
    $session->visit($this->locatePath($link->getAttribute('href')));
    // Revert the setting
    $this->changeDefaultHomepageSetting('revert');
  }

  /**
   * Clear blocks from user dashboard
   *
   * @Given /^there are no blocks on my dashboard$/
   *
   */
  public function removeDashboardBlocks() {
    $close_links = $this->getSession()->getPage()->findAll('css', 'a.portlet-icon.portlet-close');
    // Assume there are no blocks on dashboard
    if (empty($close_links)) {
      return;
    }
    foreach ($close_links as $link) {
      $link->click();
    }
    // Wait to get the dom updated
    sleep(3);
  }

  /**
   * @Then /^the count of "([^"]*)" should be greater than zero$/
   */
	public function theCountOfShouldBeGreaterThanZero($gitActivity) {
    $total = 0;
	  $page = $this->getSession()->getPage();
    $result = $page->findAll('css', "#block-drupalorg-drupalorg_activity div.item-list ul li");
    if (empty($result)) {
      throw new Exception("Unable to find activity block");
    }
    foreach ($result as $commit) {
      $text = trim($commit->getHtml());
      $fullText = explode("</strong>", $text);
      if (strpos($fullText[1], $gitActivity) !== FALSE) {
        $resultCount = explode('>', $fullText[0]);
        $repTemp =  str_replace(",", "", $resultCount[1]);
        if(empty($repTemp)) {
          throw new Exception("Could not find any records for this  '" . $gitActivity . "' activity");
        }
        $total = $total + (int) trim($repTemp);
      }
    }
    if ($total <= 0) {
      throw new Exception("The records for the activity '" . $gitActivity . "' cannot be less than zero");
    }
  }

  /**
   * @Given /^I should see community member photo$/
   */
  public function iShouldSeeCommunityMemberPhoto() {
    $page = $this->getSession()->getPage();
	  $result = $page->find('css', '.view-drupalorg-community-spotlight .node-content img');
    if (empty($result)) {
      throw new Exception('No Photo Id exists for the user');
    }
  }

  /**
   * @Then /^the <user> should have at least <count> commits$/
   */
  public function theUserShouldHaveAtLeastCountCommits(TableNode $table) {
    $page = $this->getSession()->getPage();
    $table = $table->getHash();
    foreach ($table as $key => $value) {
      $user = trim($value['user']);
      $count = trim($value['count']);
      // Get the anchor tag for the username in the maintainers block
      $userLink = $page->find("xpath", "//div[@id=\"block-versioncontrol_project-project_maintainers\"]//a[text()=\"" . $user . "\"]");
      if (empty($userLink)) {
        throw new Exception("The user '" . $user . "' was not found in the maintainers block");
      }
      // a > div.vc-user
      $parent = $userLink->getParent();
      // Get the commit count
      $commit = $parent->find('css', '.vc-commits');
      if (empty($commit)) {
        throw new Exception("The user '" . $user . "' does not have any commits");
      }
      $commit = trim($commit->getText());
      // Possible formats: 1 commit,  7 commits
      //$commit = (int) str_replace("s", "", str_replace(" commit", "", $commit));
      $commit = (int) preg_replace("/ commit(?:s|)/", "", $commit);
      if (!$commit || $commit < $count) {
        throw new Exception("The commit count for user '" . $user . "' is less than '" . $count . "'");
      }
    }
  }

  /**
   * @Then /^the project should have the following <committers>$/
   */
  public function theProjectShouldHaveTheFollowingCommitters(TableNode $table) {
    $page = $this->getSession()->getPage();
    $table = $table->getHash();
    foreach ($table as $value) {
      $committer = trim($value['committers']);
      $committerLink = $page->find("xpath", "//div[@id=\"block-versioncontrol_project-project_maintainers\"]//a[text()=\"" . $committer . "\"]");
      if (empty($committerLink)) {
        throw new Exception("The committer '" . $committer . "' was not found for the project");
      }
    }
  }

  /**
   * @Given /^I should not see the slideshow case studies in the view content$/
   */
  public function iShouldNotSeeTheSlideshowCaseStudiesInTheViewContent() {
    $page = $this->getSession()->getPage();
    // Get all the slide titles
    $slides = $page->findAll('css', '#block-views-drupalorg_casestudies-block_3 ul li h2');
    if (empty($slides)) {
      throw new Exception("The page does not contain any slides");
    }
    // Check each title is present in the view content or not
    $slideTexts = array();
    foreach ($slides as $slide) {
      $slideTexts[] = trim($slide->getText());
    }
    $cases = $page->findAll('css', '#content h2');
    if (empty($cases)) {
      throw new Exception("No case studies were found on the page");
    }
    foreach ($cases as $case) {
      if (in_array(trim($case->getText()), $slideTexts)) {
        throw new Exception("The case study '" . trim($case->getText()) . "' appears in the view content but it should not");
      }
    }
  }

  /**
   * @When /^I follow the tag "([^"]*)"$/
   */
  public function iFollowTheTag($tag) {
    $page = $this->getSession()->getPage();
    $tagLink = $page->find('xpath', '//div[@id="content"]//div[@class="views-field-tid"]//a[text()="' . $tag . '"]');
    if (empty($tagLink)) {
      throw new Exception("The tag '" . $tag . "' was not found in the view content");
    }
    $tagLink->click();
  }

  /**
   * Save Sandbox code block from revision tab
   *
   */
  private function saveSandboxGitEndpoint() {
    $current_url = $this->getSession()->getCurrentUrl();
    $link = $this->getSession()->getPage()->findLink('Version control');
    // If no link found, do not harm promote project. so return
    if (empty($link)) {
      $this->getSession()->visit($this->locatePath($current_url));
      return;
    }
    $this->getSession()->visit($this->locatePath($link->getAttribute('href')));
    // Get the code block
    $element = $this->getSession()->getPage()->find('css', '#content div.codeblock');
    if (empty($element)) {
      $this->getSession()->visit($this->locatePath($current_url));
      return;
    }
    $code = $element->getText();
    // If sandbox repo is already initiated
    // Eg: git clone --recursive --branch master ssh://gitvetteduser@git6.devdrupal.org:2020/sandbox/gitvetteduser/1788043.git
    $end_point = '';
    if (preg_match('#git clone --recursive --branch (.+)\.git#', $code, $matches)) {
      $arr_ep = explode(" ", $matches[1]);
      $end_point = end($arr_ep) . ".git";
    }
    elseif (preg_match('#git remote add origin (.+)\.git#', $code, $matches)) {
       $end_point = $matches[1] . ".git";
    }
    HackyDataRegistry::set('sandbox git endpoint', $end_point);
    $this->getSession()->visit($this->locatePath($current_url));
  }

  /**
   * @When /^I clik on link "([^"]*)" under section "([^"]*)"$/
   */
  public function iClikOnLinkUnderSection($link, $section) {
    $page = $this->getSession()->getPage();
    // Verify that the section exists
    $result = $page->find('xpath', '//form[@id="lists-subscribe-form"]//h2[text()="' . $section . '"]');
    if (empty($result)) {
      throw new Exception("The section '" . $section . "' was not found on the page");
    }
    // Get all the links with the link name
    $links = $page->findAll('xpath', '//form[@id="lists-subscribe-form"]//p//a[text()="' . $link . '"]');
    if (empty($links)) {
      throw new Exception("The link '" . $link . "' was not found on the page");
    }
    $href = "";
    foreach ($links as $anch) {
      $href = $anch->getAttribute('href');
      // Check if the links url contains the section name
      if (strpos($href, strtolower($section)) !== FALSE) {
        break;
      }
    }
    if ($href == "") {
      throw new Exception("The link '" . $link . "' was not found for the section '" . $section . "'");
    }
    $anch->click();
  }

  /**
   * @Given /^I follow the result under "([^"]*)"$/
   */
  public function iFollowTheResultUnder($heading) {
    $id = "";
    switch($heading) {
      case 'New Modules':
        $id = '#block-drupalorg_order_facet-sort_created .item-list ul > li > a';
        break;
      case 'Module Index':
        $id = '.drupal-modules-facets .grid-3.omega .item-list ul > li > a';
        break;
      default:
        throw new Exception('The heading "' . ucfirst($heading) . '" was not found on the page');
        break;
    }
    $links = $this->getSession()->getPage()->find("css", $id);
    if (empty($links)) {
      throw new Exception("No Results found to follow");
    }
    $this->getSession()->visit($this->locatePath($links->getAttribute('href')));
  }

  /**
   * @Given /^I should see at least "([^"]*)" code commits$/
   */
  public function iShouldSeeAtLeastCodeCommits($count) {
    // Get the 'Code commits' link
    $temp = $this->getSession()->getPage()->findLink('Code commits');
    if (empty($temp)) {
      throw new Exception("The link 'Code commits' was not found on the page");
    }
    // Move to parent selector
    // a > td > tr
    $parent = $temp->getParent()->getParent();
    $temp = $parent->find('css', 'td');
    if (empty($temp)) {
      throw new Exception("The page did not contain code commits");
    }
    // Extract the number and convert to integer
    $commitCount = (int) trim(str_replace(",", "", trim($temp->getText())));
    if ($commitCount < $count) {
      throw new Exception("The 'Code commits' is less than '" . $count . "'");
    }
  }

  /**
   * @Then /^I should see the newest commits from commitlog$/
   */
  public function iShouldSeeTheNewestCommitsFromCommitlog() {
    $page = $this->getSession()->getPage();
    // Get links from the Commit tab
    $temp = $page->findAll('css', '#fragment-4 h6 a');
    if (empty($temp)) {
      throw new Exception("The page did not contain the commit tab");
    }
    $commitTabLinks = array();
    foreach ($temp as $link) {
      $commitTabLinks[] = $link->getAttribute('href');
    }
    // Get links from the /commitlog screen
    $this->getSession()->visit($this->locatePath('/commitlog'));
    sleep(2);
    $temp = $page->findAll('css', '.commit-global h3 a');
    if (empty($temp)) {
      throw new Exception("The page did not contain the commit information");
    }
    $commitLogLinks = array();
    $count = 0;
    foreach ($temp as $link) {
      $href = $link->getAttribute('href');
      if (strpos($href, "/commit/") !== FALSE) {
        if ($count == sizeof($commitTabLinks)) {
          break;
        }
        $commitLogLinks[] = $href;
        $count++;
      }
    }
    // Check if both the arrays are same
    if ($commitTabLinks !== $commitLogLinks) {
      throw new Exception("The commit tab does not contain the newest commits from commitlog");
    }
  }

  /**
   * @Given /^I follow a commit from the list$/
   */
  public function iFollowACommitFromTheList() {
    // Get links from the Commit tab
    $link = $this->getSession()->getPage()->find('css', '#fragment-4 h6 a');
    if (empty($link)) {
      throw new Exception("The commit tab did not contain any link");
    }
    $link->click();
  }

  /**
   * @Given /^I should see at least "([^"]*)" git developers$/
   */
  public function iShouldSeeAtLeastGitDevelopers($count) {
    // Get the 'Developers' link
    $temp = $this->getSession()->getPage()->findLink('Developers');
    if (empty($temp)) {
      throw new Exception("The link 'Developers' was not found on the page");
    }
    // Move to parent selector
    // a > td > tr
    $parent = $temp->getParent()->getParent();
    $temp = $parent->find('css', 'td');
    if (empty($temp)) {
      throw new Exception("The page did not contain code commits");
    }
    // Extract the number and convert to integer
    $commitCount = (int) trim(str_replace(",", "", trim($temp->getText())));
    if ($commitCount < $count) {
      throw new Exception("The 'Git developers' is less than '" . $count . "'");
    }
  }

  /**
   * @When /^I create a case study$/
   */
  public function iCreateACaseStudy() {
    $page = $this->getSession()->getPage();
    $this->caseStudyTitle = $this->randomString(8);
    $page->fillField("Project name:", $this->caseStudyTitle);
    $image = $page->findField("Primary screenshot");
    if (!$image) {
      throw new Exception("Image field is missing from the page");
    }
    $filepath = getcwd() . DIRECTORY_SEPARATOR . 'files' . DIRECTORY_SEPARATOR . 'koala.jpg';
    $image->attachFile($filepath);
    $page->fillField("Why Drupal was chosen", $this->randomString(9));
    $page->fillField("Completed Drupal site or project URL", "http://example.com");
    $page->fillField("edit-field-module-0-nid-nid", "Views");
    $page->fillField("Why these modules/theme/distribution were chosen", $this->randomString(10));
    HackyDataRegistry::set('random:Project name', $this->caseStudyTitle);
    $page->pressButton('Save');
    sleep(2);
  }

  /**
   * @Given /^I am on the case study page$/
   * @When /^I visit the case study page$/
   */
  public function iAmOnTheCaseStudyPage() {
    $path = HackyDataRegistry::get('project_url');
    if (!$path) {
      throw new Exception("Case study page not found");
    }
    $path = $this->locatePath($path);
    return new Given("I am on \"$path\"");
  }

  /**
   * @Then /^I (?:|should )see the case study page$/
   */
  public function iShouldSeeTheCaseStudyPage() {
    // Wait for the page and the image in the page to load, otherwise, current url will be node/add/casestudy
    sleep(5);
    HackyDataRegistry::set('project_url', $this->getSession()->getCurrentUrl());
    return new Given("I should see \"has been created\"");
  }

  /**
   * @Given /^I (?:select|check) "([^"]*)" radio button$/
   */
  public function iSelectRadioButton($radioLabel) {
    $page = $this->getSession()->getPage();
    // Get all the radio button fields
    $temp = $page->findAll('xpath', '//input[@type="radio"]');
    if (empty($temp)) {
      throw new Exception("The page does not contain any radio buttons");
    }
    foreach ($temp as $radio) {
      // input > label
      $parent = $radio->getParent();
      if (!empty($parent)) {
        // Check if label matches
        if (trim($parent->getText()) == $radioLabel) {
          $page->fillField($radio->getAttribute('id'), $radio->getAttribute('value'));
          return;
        }
      }
    }
    throw new ElementNotFoundException($this->getSession(), 'form field', 'id|name|label|value', $field);
  }

  /**
   * @Then /^I should not see the random "([^"]*)" text$/
   */
  public function iShouldNotSeeTheRandomText($label) {
    $text = $this->fetchRandomString($label);
    if (!$text) {
      throw new Exception("No random text stored for $label.");
    }
    $step = "I should not see \"$text\"";
    return new Then($step);
  }

  /**
   * @Then /^I should see the breadcrumb "([^"]*)"$/
   * @param string $breadcrumb
   *   Breadcrumb link on the current page
   * @param boolean $present
   *   Return True if success, false otherwise
   */
  public function checkBreadcrumb($breadcrumb, $present = true) {
    $result = $this->getSession()->getPage()->find('xpath', '//div[@id="page-heading"]//div[@class="breadcrumb"]//a[text()="' . $breadcrumb . '"]');
    if ($present && empty($result)) {
      throw new Exception("The breadcrumb \"" . $breadcrumb . "\" was not found on the page");
    }
    elseif (!$present && !empty($result)) {
      throw new Exception("The breadcrumb \"" . $breadcrumb . "\" was found on the page which should not be");
    }
  }

  /**
   * @Given /^I should not see the breadcrumb "([^"]*)"$/
   */
  public function iShouldNotSeeTheBreadcrumb($breadcrumb) {
    //To check for the breadcrumb link exists
    $this->checkBreadcrumb($breadcrumb, false);
  }

  /**
   * @When /^I uncheck sandbox$/
   */
  public function iUncheckSandbox() {
    $element = $this->getSession()->getPage()->findField('project[sandbox]');
    if (empty($element)) {
      throw new Exception('The checkbox: "project[sandbox]" is not found on the page');
    }
    // Click the element to make sure click event executes
    $element->click();
    if ($element->isChecked()) {
      $element->uncheck();
    }
  }

  /**
   * @Given /^I create "([^"]*)" page(?:|s)$/
   */
  public function iCreatePages($count) {
    for ($i = 0; $i < $count; $i++ ) {
      // Visit the page again if more than 1 page is to be created
      if ($i > 0) {
        $this->getSession()->visit($this->locatePath("/node/add/page"));
      }
      $page = $this->getSession()->getPage();
      if (empty($page)) {
        throw new Exception("The current page is not valid");
      }
      $page->fillField("Title:", $this->randomString(10));
      $page->pressButton('Save');
      sleep(2);
      // Store the url of the page if only 1 page is created
      if ($count == 1) {
        HackyDataRegistry::set('project_url', $this->getSession()->getCurrentUrl());
      }
    }
  }

  /**
   * @When /^I (?:follow|click) "([^"]*)" on the "([^"]*)"$/
   */
  public function iFollowOnThe($link, $region) {
    // Find the region requested
    $regionObj = $this->getSession()->getPage()->find('region', $region);
    if (empty($regionObj)) {
      throw new Exception("The region '" . $region . "' is not configured");
    }
    // Find the link within the region
    $linkObj = $regionObj->findLink($link);
    if (empty($linkObj)) {
      throw new Exception("The link '" . $link . "' was not found on the region '" . $region . "'");
    }
    $linkObj->click();
  }

  /**
   * @Given /^I should see at least "([^"]*)" record(?:|s) for each filter$/
   */
  public function iShouldSeeAtLeastRecordForEachFilter($count) {
    // Get all the links under the block
    $links = $this->getSession()->getPage()->findAll('css', '#block-drupalorg_search-meta_type ul li a');
    if (empty($links)) {
      throw new Exception("The page did not contain any filters");
    }
    // For every link, extract the number and compare
    foreach ($links as $link) {
      // text format - All (xx)
      preg_match('#(.*) \((\d+)\)#', trim($link->getText()), $match);
      // 0 = All (xx), 1 = All, , 2 = xx
      if (!$match[2] || $match[2] < $count) {
        throw new Exception("The filter '" . trim($match[1]) . "' has less than '" . $count . "' records");
      }
    }
  }

  /**
   * @Given /^I add "([^"]*)" comment(?:|s)$/
   */
  public function iAddComment($count) {
    for ($i = 0; $i < $count; $i++) {
      if ($i > 0) {
        $link = $this->getSession()->getPage()->findLink("Add new comment");
        if (empty($link)) {
          throw new Exception("The link 'Add new comment' was not found on the page");
        }
        $link->click();
        sleep(3);
      }
      $this->iAddACommentToTheIssue();
    }
  }

  /**
   * Hold the execution until the page is completely loaded
   *
   * @Given /^I wait until the page (?:loads|is loaded)$/
   */
  public function iWaitUntilThePageLoads() {
    $session = $this->getSession();
    // If selenium is loaded, wait for the page to completely load
    if ($session->getDriver() instanceof Behat\Mink\Driver\Selenium2Driver) {
      $session->wait(1, "document.readyState == 'interactive' || document.readyState == 'complete'");
    }
  }

  /**
   * Attaches files/'file' to field with specified id|name|label|value. The file provided should just be the file name that is already present in 'files' folder
   *
   * @param $file
   *   string The file to be attached. The file must be present in the 'files' folder
   * @param $field
   *   string The field to which the file is to be attached
   *
   * @Then /^(?:I )attach the local file "([^"]*)" to "([^"]*)"$/
   */
  public function attachLocalFile($file, $field) {
    $filePath = getcwd() . DIRECTORY_SEPARATOR . 'files' . DIRECTORY_SEPARATOR . $file;
    if (!file_exists($filePath)) {
      throw new Exception("The file '" . $file . "' could not be found in the 'files' folder");
    }
    return new Then('I attach the file "' . $filePath . '" to "' . $field . '"');
  }

  /**
   * Function to add a new organization for setting up the training session
   * @Given /^I create a new organization$/
   */
  public function iCreateANewOrganization() {
    $element = $this->getSession()->getPage();
    $this->issueTitle = $this->randomString(12);
		$element->fillField("Organization name:", $this->issueTitle);
    $element->fillField("Website:", $this->randomString(18));
    $element->fillField("Drupal contributions:", $this->randomString(18));
    $chk = $element->findField("Request listing in the Training section");
    $chk->check();
    $this->iSelectTheRadioButtonWithTheId('Enterprise & Managed', 'edit-field-organization-hosting-categ-value-Enterprise-&-Managed');
    HackyDataRegistry::set('issue title', $this->issueTitle);
    $element->pressButton("Save");
    sleep(2);
    HackyDataRegistry::set('issue_url', $this->getSession()->getCurrentUrl());
  }
}
