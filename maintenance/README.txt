This maintenance folder contains files which will automatically run tag sets via Jenkins and output the results on bddtest.drupal.org/test-output/maint  

Example
=======

To run all of the features tagged @git:
* Create a file named git (no extension)
* Add the tagset to be run, with no quotation marks. Currently we'd put in something like: 

git&&~wip

This tag set runs all tests that are tagged @git but NOT tagged @wip. The results are available in a folder that matches the filename, e.g. http://bddtest.drupal.org/test-output/maint/git

NOTE: At this time the file names are being manually added to runall_doobie7_maint, which is located on Jenkin's CI tab. New files won't be auto-discovered. However, the tag sets inside the existing files *are* being used dynamically in run_doobie7_maint
