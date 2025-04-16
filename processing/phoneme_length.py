# get phoneme lengths of words
import nltk
#nltk.download('cmudict')

arpabet = nltk.corpus.cmudict.dict()

# put words into an array
words = ["no", "not", "nt", "yes", "and", "or", "if", "nor", "therefore", "none", "some", "each", "every", "all", "most", "few", "many", "several", "few", "both", 
         "everyone", "someone", "somebody", "everybody", "nonone", "everything", "something", "nowhere", "somewhere", "everywhere", "more", "less", "much", "most", 
         "least", "than", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "first", "second", "third", "fourth", "fifth", "sixth", 
         "seventh", "eighth", "nineth", "tenth", "last", "can", "could", "need", "may", "might", "should", "ought", "must", "maybe", "perhaps", "shall", "will", 
         "would", "won’t", "any", "anyone", "anything", "anywhere", "anything", "anyway", "anyways", "ever", "yet", "the", "a", "an", "this", "that", "these", "those", 
         "always", "usually", "seldom", "never", "sometimes", "often", "once", "twice", "now", "while", "after", "before", "then", "until", "since", "whenever", 
         "during", "who", "when", "what", "whose", "where", "how", "why", "whom", "on", "in", "out", "up", "down", "under", "above", "below", "along", "over", "behind", 
         "across", "beside", "between", "beyond", "into", "near", "onto", "toward", "here", "through", "here", "there", "because", "but", "although", "am", "is", "are", 
         "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "i", "you", "we", "he", "she", "they", "me", "us", "her", 
         "him", "them", "my", "your", "our", "his", "their", "its", "mine", "yours", "ours", "hers", "theirs", "myself", "yourself", "ourselves", "himself", "herself", 
         "yourselves", "themselves", "it", "itself", "again", "too", "also", "another", "other", "others", "still", "only", "just", "even", "indeed", "either", "neither", 
         "whether", "as", "else", "almost", "already", "except", "for", "from", "instead", "same", "different", "such", "with", "without", "about", "by", "very", 
         "unless", "to", "of", "would", "at", "against"]

# returns an array of phoneme lengths for each word in words
def get_phoneme_length(words, range):
    words_phoneme_length = []

    for word in words[:range]:
        if word not in arpabet:
            # have to manually handle exceptions for words not in cmudict
            if word == 'nt':
                words_phoneme_length.append(1)
            elif word == 'nonone':
                words_phoneme_length.append(5)
            elif word == 'nineth':
                words_phoneme_length.append(4)
            elif word == "won't":
                words_phoneme_length.append(3)
        else:
            words_phoneme_length.append(len(arpabet[word][0]))
            # arpabet breaks a word down into phonemes, so just how many phoneme parts it breaks it down into

    return words_phoneme_length

phoneme_lengths = get_phoneme_length(words, len(words))
print(phoneme_lengths)