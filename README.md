
CONTENTS OF THIS FILE 
---------------------

 * Introduction
 * Installation
 * Running tests
 * Creating features and scenarios

INTRODUCTION
------------
Doobie is the home of Drupal.org Behavior Driven Development.

It's a collection of tests to verify the functionality of Drupal.org for pre-
deployment purposes. They are written in plain English as "Features" with
"Scenarios" beneath them, the outline how a piece of functionality is supposed
to work. Those English descriptions can then generate skeleton code for real
functionality testing.

For more background on Behat, see http://docs.behat.org

INSTALLATION
------------
Doobie requires a Linux-based system.

Helpful installation instructions are included on the project page:
http://drupal.org/project/doobie

When installation is complete, copy the default.behat.yml file to behat.yml and adjust the base url as needed.

RUNNING TESTS
-------------
To run tests, change into the doobie project directory and run:

bin/behat

This will cycle through all of the available features and scenarios and output
their results.

See http://docs.behat.org/guides/6.cli.html for other, fancier ways to run tests.

FEATURES AND SCENARIOS
----------------------
Human-readable features and scenarios are available in the features/ directory.
The actual code for each can be found in the 'bootstrap' directory within.

A tutorial on how to write features, scenarios, and tests can be found at http://docs.behat.org/guides/1.gherkin.html

RUNNING TESTS AGAINST THE STAGING SITES
----------------------------------------

Pre-created users should existing on the site; they must be made by hand at this time if the database has been refreshed. You'll find the users expected by the tests in the behat.local.yml.example
Website: http://git6site.devdrupal.org
Website: http://git7site.devdrupal.org

GIT TESTS
---------

Git tests based on the directions on the Version control tab will fail if Git instructions has not been configured through the interface to use the url
Git url.

  Git url: ssh://git6.devdrupal.org:2020/
  Git url: ssh://git7.devdrupal.org:2020/

@linux 
Features or scenarios tagged @linux will only run from Linux-based hosts. To exclude these, use 'bin/behat tags='~@linux' when executing your tests.

Password authenticated git push tests require the expect program to be installed on the host running the tests.

