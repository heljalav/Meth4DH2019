library(stm)
library(readtext)


folder_in <- "C:\\users\\lenovo\\documents\\JQA_modeling\\pre_processed"

#Using readtext library, opens the files in the input folder: the resulting object is a data frame with 
# columns doc_id (file name), text, and a variable name consisting of the year (created from the file name)
# This can then be used as input for the stm functions.
data <- readtext("C:\\users\\lenovo\\documents\\JQA_modeling\\pre_processed\\*.txt",  docvarsfrom = "filenames")

# 2 -----------------------------------------------------------------------

#First, stm offers utility functions to process the data for the topic model.
#textProcessor here removes stop words, for instance, but not case variation or word endings.
#It also creates a metadata variable, with which to utilize stm's covariate relationships.
processed <- textProcessor(data$text, metadata = data, lowercase = FALSE,
                           removestopwords = TRUE, removenumbers = FALSE, stem = FALSE)

#prepDocuments prepares the data by creating the necessary corpus and dictionary structure (Bag-of-Words).
out <- prepDocuments(processed$documents, processed$vocab,
                     processed$meta$docvar1)

#plotRemoved would visualize the amount of documents or vocabulary gets left out with specific
# cut-out rates: tokens that appear in less than a given percentage of documents, etc.
#plotRemoved(processed$documents, lower.thresh = seq(1, 2))

# 3 -----------------------------------------------------------------------

#stm does the actual modeling: Spectral initialization should (in my understanding) enable 
#reproducibility of the results. (An alternative is to set a specific seed manually.)

JQAtest <- stm(documents = out$documents, vocab = out$vocab,
               K = 20, max.em.its = 75,
               data = out$meta, init.type = "Spectral")

# 4 -----------------------------------------------------------------------

#LDAvis is tool which visualizes the topic distribution and presents ways to inspect representative
#words at different levels of relevance. toLDAvis creates an LDAvis visualization from stm.
library(toLDAvis)
toLDAvis(JQAtest, out$documents, R = 30, plot.opts = list(xlab = "PC1", ylab ="PC2"),
         lambda.step = 0.1, out.dir = tempfile(),
         open.browser = interactive(), as.gist = FALSE,
         reorder.topics = TRUE)            

