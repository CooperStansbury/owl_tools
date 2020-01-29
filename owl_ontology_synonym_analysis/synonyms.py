import rdflib
import nltk
import operator
from collections import Counter

### Queries
slim_query = 'slim-extract.sparql'

# create text file from simple assertions from ontology
def make_nlp_text_file(file):
    g = rdflib.Graph()
    g = g.parse(file)
    qresults = g.query(open(slim_query))
    for row in qresults:
        with open('nlp_outut.txt', 'a') as the_file:
            the_file.write(str(" {} is {} ".format(row[1], row[2])))
        print(str("{} is {}".format(row[1], row[2])))

# tokenize the text file using NLP
def tokenize_text(file):
    f=open(file,'r')
    raw=f.read()
    tokens = nltk.word_tokenize(raw)
    text = nltk.Text(tokens)
    print(text)
    return text

# create FreqDist object from tokenized text
def find_most_common(tokenized_text, num):
    fdist = nltk.FreqDist(tokenized_text)
    return fdist.most_common(num)

# proc to sort 'important' monogram words by length into list for similarity comparisons
def build_dumb_toplist(freqdist, sortlength):
    top_list = []
    for word in freqdist:
        if len(word[0]) >= sortlength:
            top_list.append(word[0])
    return top_list

def flag_likely_monograms(word_list):
    flagged_words = []
    for word in word_list:
        synonyms = []
        for syn in wordnet.synsets(word):
            for l in syn.lemmas():
                synonyms.append(l.name())
                if l.name() in word_list:
                    flagged_words.append(word)
    freq_list = Counter(flagged_words)
    sorted_freq_list = sorted(freq_list.items(), key=operator.itemgetter(1))
    return list(flagged_words), sorted_freq_list

def get_similar_contexts(freq_list):
    idx = nltk.text.ContextIndex([word.lower( ) for word in text])
    similarframe = pd.DataFrame()
    count = 1
    for word in freq_list:
        similarframe.loc[count, 'Term'] = str(word)
        save = []
        save.append(idx.similar_words(word))
        similarframe.loc[count, 'Similar Contexts'] = str(save)
        count = count + 1
    similarframe.to_csv("Similarity_Results.csv")
    return similarframe

def get_bigrams_list(text):
    bigrm = list(nltk.bigrams(text))
    return bigrm
