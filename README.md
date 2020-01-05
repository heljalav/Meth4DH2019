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
  3. I removed front and backmatter as well as most editorial content at the start of each chapter manually.
  To identify and create subsets by calendar year I manually found the first and last entries for each year and created a txt file for each one (named YEAR.txt). First years are very short, the final years (1846-8) was merged into the last file (1846.txt) because of sparsity,
  4. I used Python to programmatically remove headers from the data: the headers appear in the edited volumes on all pages and thus appear in the middle of entries. [See code here.](python_to_preprocess.py)
  5. Final processing and computational analysis in R using stm package - discussed separately below. Pre-processing in this step includes removing stopwords (using the default list in the stm package). I did not remove numbers/digits or transform everything to lowercase: I wanted to see whether including digits (all entries start with a date, so I assume the distribution to be even) would provide any information through the topic model, and I wanted to preserve information about proper nouns (upper case) even though I could not account for sentence case (sentence-initial upper case).
 
 # Analysis & results
 Due to a not wholly unexpected lack of time, which resulted from problems in all previous steps, proper analysis as well as proper utilization of the stm possibilities is almost completely lacking. The test model with a default of 20 topics yielded little results, expect some notable possibilities indicated by an inspection of the results of the modeling with LDAvis. Figure 5 shows the summary created by stm, which makes in evident that a better pre-processing of the data for the model might on the hand hand remove possible stop word candidates from making the results less salient, while on the other they might hide the fact that the model with 20 topics produces topics that combine various different aspects of the texts into combined topics without that much semantic coherence.
 In LDAvis, there is indication that a PCA reveals a division and clustering along some lines, possibly related to different stages in his career: topic 4 in Figure 1 (LDAvis might have changed the topic indices - I could not confirm this yet) superficially relates to later career in congress (last years and the question of annexation of Texas and spread of slavery); in Figure two, topic 7 superficially relates to the Treaty of Ghent and the preceding war of 1812; the cluster in the middle showing topics 1, 10, 15, etc. seems to represent 1820s and the growing importance of Latin America for John Quincy Adams. Importantly, they are clustered separatedly. However, as Figures 3 and 4 show, there are topics that seem more clearly either a combination of different common terms (to do with congress and legislation in Fig. 4), or a specific kind of writing in Fig. 3.  
 
 Using stm's findThoughts to find the three most representative documents of all topics reveals that mostly the documents that most likely form topics are quite near each other in time. This would seem to show that with this crude division of data in to subsets, words that refer to events near each other in time make up the topics. (See representative_documents_findThoughts.txt). The exceptions, which would be interesting to inspect further, are topics 2, 7, and 13, which contain years that are not immediately adjacent to each other.
 
 
 # Critical Analysis of Pipeline
  1. Data and processing.
  Using the selection by Charles Francis Adams means that the selection is biased in a specific way, which on the other hand has been discussed in previous research, and which can be compared with other selections (that are extremely smaller, however). The way I have quickly and crudely processed the data means for instance that tokens are cut at the end of the line with missing hyphens to enable easy computational correction. Thus, longer tokens have a larger probability of being cut into pieces, which might skew the prorabilistic modeling method. Moreover, not all editorial content such as footnotes (which appear in the first couple of volumes, but not really in all later volumes) have been removed, meaning that my data is not only written by John Quincy Adams, but also by the editor, his son. The few OCR problems have not really been addressed either.
  2. Concept and research question.
  In order to be able to say that topics derived by the method are useful in an analysis of Adams's political thinking and distinguishing periods in his career, I would have to prove that the topics refer to something that reflects his thinking in a systematic way: perhaps I would argue that specific topics represent different dimensions or aspects (changing or varying) of his thinking - and other topics would also not include aspects that mess up this analysis - and show how the model is able to point to interesting patterns. However, with the structure I have currently been able to use it is not likely: looking at entries by year is a very general division, and I would need a more detailed temporal division, or otherwise most years appear much the same, meaning that any differences in the topics reflect mainly difference in highly context-related terms (that do not stay in Adams's writing in later periods). The subsets of the data would therefore definitely have to be constructed and explained better (congressional sessions, administrations did not change in January, but in in March, for instance).
  3. Analysis.
  Analysis is lacking: it only includes superficial focus on individual tokens and words, not on the documents. On the other hand, the documents are so large that they include a wide distribution of different kinds of entries and professional situations and meetings, making closer inspection of them quite time-consuming, to the point of removing the use of topic models entirely.
  The implementation of the topic model method would need more work, and I would need to try stm's functions to find the number of topics, for instance, if only as a starting point to better exploration. Additionally, the model I created still exhibits problems that pre-processing might help with: the top words (which are not good indicators of quality, however) are very similar and include the definite article. This might point towards topics that include various aspects of the writing, for example, meaning that a larger model with different prior settings might be more useful.
  
# Concluding notes on the work done
I started working with Python and aiming for Mallet, but ended up using R. I learned to actually use R in my own work. not only to read it, and I also got acquainted with stm, which meant finding out new things about the possibilities of topic models. The changes and problems in my approach meant, however, that a majority of my effort was in vain, as pre-processing in Python was in the end not needed, as stm in R did the required operations, at least for the test run. The work I put into in trying different regexes, approaches to divide the data according to the date in the diary entries (regex, NER, etc.), tokenization, encoding & decoding problems, footnoes and cleaning, and so on, are not displayed in this final result, but that is always the case. However, I do feel the concept of aiming for a full pipeline is very useful, as it allows quick progress towards analysis while revealing why interpretation and analysis is made difficult because of the shortcuts taken.
  
