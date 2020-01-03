# Meth4DH2019 - Final Project for Methods in Digital Humanities, Fall 2019
This is a repository for a project on the diaries of John Quincy Adams (1867-1848). The project was the final project assignment for the course Introduction to methods in Digital Humanities at the University of Helsinki in the fall of 2019. The repository presents my work in going from a humanities question and a corresponding dataset to a computationally assisted answer to the question. The aim was to create a full pipeline from data to results, to present the choices made, and to discuss the reliability of the analysis and results. 
# Humanities Research Question
My general research question is: what distinguishes the different careers and periods in the life of John Quincy Adams in his own views, based on his diaries. In this project, I apply topic modeling and the more specific question is whether there are systematic changes in word use that would denote shifting concerns and the evolution of Adams's political thought over different periods in his life and career(s). The simplest way to explore this is to identify topics that distinguish the careers and periods. Because historical events naturally distinguish different periods via (historical) context-specific word use, ambiguity and continuity are more interesting than clearly delimited topics. The "careers" refer to his diplomatic and foreign policy career, and his congressional career after his presidency, when his political views on slavery, for instance, changed dramatically.
# Data
My data is the selection of Adams's diaries published by his son, Charles Francis Adams, in the 1870s, as these are openly available. The diaries were written from 1779 until his death and include approximately 15 000 pages of diary entries. The material is available online and has been relatively reliably digitized by Google: there are few errors in optical character recognition, for example. There are 12 volumes in this selection, 600 pages each, and my corpus contains some 2 million tokens. An initial historical description and exploration show that these first edited selections contain fewer entries concerning personal life, so there is a bias towards professional description of contemporary events. The corpus could theoretically be expanded by transcribing the parts currently available only in images, and the selection can be compared with other selections and editions of the diaries in the future.
# Process, clean-up, transformations
For the purposes of this project and getting a complete pipeline to work with, I ended up performing several pre-processing steps manually. Although the data is available in text-only versions in both Google Books and Hathitrust's collections, for example, it was much more difficult than I anticipated to get the plain text of the editions Google has digitized. I spent several days trying to get the data in a programmatic manner and to structure the data programmatically in the most obvious and useful way, i.e. structuring the data by the date of the diary entries, but in the end to attain something to analyse I took the following steps:
  1. I downloaded the files from Google books as pdfs, and renamed them: a single file contains a single volume, which contains between one and three chapters from the original diaries. A single chapter might be a specific congress or a diplomatic mission to Europe.
  2. I used Foxit Reader to open the pdfs and save them as txt files. Again, I spent several days trying Python libraries to process the pdfs (as well as epub files from Google Books) programmatically, but nothing worked even remotely as satisfactorily as copy/paste from pdf using Adobe Acrobat or Foxit. After several weeks of exploration I noticed the Adobe Acrobat approach was also missing large chunks of text, while Foxit seemed to capture all text: using Foxit to transform the files to txt created files with Foxit-generated headers, which made the subsequent steps easier.
  3a. I removed front and backmatter as well as most editorial content at the start of each chapter manually.
  3b. To identify and create subsets by calendar year I manually found the first and last entries for each year and created a txt file for each one (named YEAR.txt). First years are very short, the final years (1846-8) was merged into the last file (1846.txt) because of sparsity,
  4. I used Python to programmatically remove headers from the data: the headers appear in the edited volumes on all pages and thus appear in the middle of entries.
  5. Final processing and computational analysis in R using stm package - discussed separately below.
