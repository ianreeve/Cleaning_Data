## Creating a Tidy Data File

The files in this repo have been generated to meet the requirements of the Getting and Cleaning Data course project.

The objective of the assignment was to take data from observations of humans wearing waist-mounted smartphones and to output a tidy data file. The experimentation and measurement collection process are described here http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Repo contents:
* igr_tidy_data_file.txt <- the tidy data file
* readme.md <- this file
* run_analysis.R <- the script needed to create the tidy data file
* codebook.md <- a list of the fields and their descriptions
* run_analysis_download_code_included.R <- an alternative script which contains additional code to download and unzip the data directly from the web [This wasn't asked for]

I'll now describe what run_analysis.R does:
* All the data is contained in https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* It is assumed this file has been downloaded, unzipped and the contents of the UCI HAR Dataset folder copied to the working directory. This includes two sub-folders Train and Test. Data collected has been split between the two sub-folders [70/30 to facilitate model building]
* First, read the 8 files required for the assignment into separate tables.
	- test/X_test.txt and train/X_train.txt <- the measurements
	- test/subject_test.txt and train/subject_train.txt <- the subject ID for each record
	- test/y_test.txt and train/y_train.txt <- the activity ID for each record
	- features.txt <- labels for the 561 measurements made for each observation
	- activity_labels.txt <- labels for the 6 activities
* Glue the train and test data back together in single tables (task 1 of the assignment)
* We're only interested in the measurements that are means or standard deviations. Therefore search the feature labels for the sub-strings "mean()" and "std()". These are the required fields (there appears to be 66). I created a new table containing only the required fields (task 2)
* I have used the feature labels to name the fields in this table (task 4 - nb change of sequence)
* To help produce the codebook, a file of the selected labels is created (not asked for)
* A join appends the activity labels to the activity ID data, which then is appended to the main data (task 3). The subject IDs are also appended. NB it is assumed that the observation, subject and activity data are all in the same sequential order as there is no references to link the sets together.
* The main data table is now 68 columns (66 metrics + Subject ID + Activity) x 10,299 observations
* Based on this, a "long, skinny" table containing one row for each Subject/Activity combo (180 of them, i.e. 30x6). Each of the metrics is a mean of the total observations of that combo.
* Finally, this is output as a text file (task 5)









