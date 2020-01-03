import os
import re

folder_in = os.path.join(os.getcwd(), "only_body")
# The data should be extracted to a folder "only_body" in the working directory:
# this folder contains manually cleaned subsets (years)

folder_out = os.path.join(os.getcwd(), "pre_processed")

def preprocess_for_modeling(txt_as_lines):
    
    #Input txt is separated into lines. Output a single string (not lines).
    
    #First, get indices of lines that contain page numbers (created by Foxit Reader, saved pdf as txt)
    #RE search pattern in re.search does exactly this. Return list of indices

    pageline_idx = [i for i, item in enumerate(txt_as_lines) if re.search(r"^-* Page \d{1,3}-*\n", item)]
    
    #Go through indices, modify input txt by replacing headers
    #(line with page number + line with original header, which is two lines down from the header created by Foxit Reader)
    #with blank lines
    
    for index in pageline_idx:
        txt_as_lines[index] = " "
        txt_as_lines[index+1] = " "
        txt_as_lines[index+2] = " "
        
    #Finally, join the lines together to create a single string.
    text = " ".join(txt_as_lines)
    
    #Optionally, this function could perform lemmatization, strip stopwords and punctuation, etc.
    
    return text


#go through input files - yearly subsets - and process for topic modeling:
#strip headers (this step initially also included or was meant to include tokenization (included in stm),
# lemmatization and other possible steps (transforming case, removing digits, stopwords))

#Loops through files in the folder_in, where the input data is located
for file in os.listdir(folder_in):
    with open(os.path.join(folder_in, file), "r", encoding="utf-8-sig") as txtfile:
        text_to_process = txtfile.readlines()

        #the file is read (in lines), processed with the preprocessing function (input in lines, output single string)

        processed_text = preprocess_for_modeling(text_to_process)
        
        try:
            os.mkdir(folder_out)
        except FileExistsError:
            print("Folder already exists.")
        with open(os.path.join(folder_out, file), "w", encoding="utf-8") as outfile:
            outfile.write(processed_text)
