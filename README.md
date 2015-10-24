# data-clean
Repository created for the course in Coursera.

In this repository there is a source called run_analysis.R.
This source is a function that was developed for the project.

How to use?
In R:
> source("run_analysis.R")
> table <- run_analysis()
The result of the function is a data frame containing the average of all columns, subjects and activities.

Description of the columns?
The description of the columns are most of them presented in the file features.txt, extracted from the Dataset.zip.
Three columns were added for this analysis:
a) id_activity: represent an id for an activity. See the file activity_labels.txt;
b) subject: the subject of the research; and
c) activity: explained in the files features.txt and activity_labels.txt.
For the others columns, they represent the average of the means and standards deviations of the measurements.

