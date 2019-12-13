# This function measure the similarity between
# two concepts/ words
# You need to have python and NLTK installed.
# For each word there are few synonyms or meaning
# If we just get the first meaning, maybe that one
# will not be the one with the same meaning we meant!
# Therefore, we use a loop for all meaning for the both
# concepts.
# To find out how similar two concepts are, there are
# two way to do so:
# (https://aclweb.org/anthology/Y/Y15/Y15-1006.pdf)
#1- Wu-Palmer Similarity(this is chosen):
#   m1.wup_similarity(m2) or wordnet.wup_similarity(m1,m2)
#   Return a score denoting how similar two word senses
#   are, based on the depth of the two senses in the taxonomy
#   and that of their Least Common Subsumer (most specific
#   ancestor node). Note that at this time the scores given
#   do not always agree with those given by Pedersen's Perl
#   implementation of Wordnet Similarity.
# 2- path_similarity:
#   Return a score denoting how similar two word senses
#   are, based on the shortest path that connects the
#   senses in the is-a (hypernym/hypnoym) taxonomy. The
#   score is in the range 0 to 1, except in those cases
#   where a path cannot be found (will only be true for
#   verbs as there are many distinct verb taxonomies),
#   in which case -1 is returned. A score of 1 represents
#   identity i.e. comparing a sense with itself will return 1.


#import nltk
from nltk.corpus import wordnet

def calSimilarity(w1, w2):
    meanings_1 = wordnet.synsets(w1)
    # get first meaning-but maybe the first meaning is not what we want
    #w1= meanings_1[0]
    nm1 = len(meanings_1)

    meanings_2 = wordnet.synsets(w2)
    #w2= meanings_2[0]
    nm2 = len(meanings_2)

    
    similarity = 0
    for i in range(nm1):
            s1 = wordnet.synset(meanings_1[i].name())
            for j in range(nm2):      
                s2 = wordnet.synset(meanings_2[j].name())

                #sim = wordnet.path_similarity(m1, m2)
                sim = wordnet.wup_similarity(s1,s2)
                similarity = max(sim, similarity)
                                                    
    return similarity 









