This maintenance folder contains files which will automatically run tag sets via Jenkins and output the results on bddtest.drupal.org

Example
=======

To run all of the features tagged @git:
* Create a file named git (no extension)
* Add the tagset to be run, with no quotation marks. Currently we'd put in something like: 

git&&~wip

So that all scenarios tests that are tagged @git but NOT tagged @wip will be run and the results will be available in a folder that matches the filename, e.g. http://bddtest.drupal.org/maintenance/git
