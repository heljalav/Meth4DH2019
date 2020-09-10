library(stm)
library(readtext)
library(tidyverse)


#Assuming the data is in a folder "pre_processed" in the current working directory:
folder_in <- file.path(getwd(), "pre_processed")

#Using readtext library, opens the files in the input folder: the resulting object is a data frame with 
# columns doc_id (file name), text, and a variable name consisting of the year (created from the file name)
# This can then be used as input for the stm functions.
data <- readtext(file.path(folder_in,"*.txt"),  docvarsfrom = "filenames")

# 2 -----------------------------------------------------------------------

#First, stm offers utility functions to process the data for the topic model.
#textProcessor here removes stop words, for instance, but not case variation or word endings.
#It also creates a metadata variable, with which to utilize stm's covariate relationships.
processed <- textProcessor(data$text, metadata = data %>% select(year=docvar1), lowercase = TRUE,
                           removestopwords = TRUE, removenumbers = TRUE, stem = FALSE,customstopwords = c("upon","one","two","three","said"))

#prepDocuments prepares the data by creating the necessary corpus and dictionary structure (Bag-of-Words).
out <- prepDocuments(processed$documents, processed$vocab,
                     processed$meta)

#plotRemoved would visualize the amount of documents or vocabulary gets left out with specific
# cut-out rates: tokens that appear in less than a given percentage of documents, etc.
#plotRemoved(processed$documents, lower.thresh = seq(1, 2))

# 3 -----------------------------------------------------------------------

#stm does the actual modeling: Spectral initialization should (in my understanding) enable 
#reproducibility of the results. (An alternative is to set a specific seed manually.)

#The test presented here is made with the dreadful default of 20 topics (= K)

JQAtest <- stm(documents = out$documents, vocab = out$vocab,
               K = 20, max.em.its = 500,
               data = out$meta, init.type = "Spectral", prevalence = ~ s(year))

JQAtest2 <- stm(documents = out$documents, vocab = out$vocab,
                K = 40, max.em.its = 500,
                data = out$meta, init.type = "Spectral", prevalence = ~ s(year))

# 4 -----------------------------------------------------------------------

#LDAvis is tool which visualizes the topic distribution and presents ways to inspect representative
#words at different levels of relevance. toLDAvis creates an LDAvis visualization from stm.
toLDAvis(JQAtest, out$documents, R = 30, plot.opts = list(xlab = "PC1", ylab ="PC2"),
         lambda.step = 0.1, out.dir = tempfile(),
         open.browser = interactive(), as.gist = FALSE,
         reorder.topics = TRUE)            

toLDAvis(JQAtest2, out2$documents, R = 30, plot.opts = list(xlab = "PC1", ylab ="PC2"),
         lambda.step = 0.1, out.dir = tempfile(),
         open.browser = interactive(), as.gist = FALSE,
         reorder.topics = TRUE)

prep <- estimateEffect(1:20 ~ s(year), JQAtest, meta = out2$meta, uncertainty = "Global")
prep2 <- estimateEffect(1:40 ~ s(year), JQAtest2, meta = out2$meta, uncertainty = "Global")

# plot topic temporal correlations
plot(prep,covariate="year", method = "continuous",topics=1:10,ci.level=0.0)
plot(prep,covariate="year", method = "continuous",topics=11:20,ci.level=0.0)

# run STMinsights. May not work if you have too new a version of Shiny currently (https://github.com/cschwem2er/stminsights/issues/16)
save.image("JQA_STM.RData")
library(stminsights)
run_stminsights()