# get phoneme lengths of words
import nltk
#nltk.download('cmudict')

arpabet = nltk.corpus.cmudict.dict()

# put words into an array
contracted_words = ["no", "not", "nt", "yes", "and", "or", "if", "nor", "therefore", "none", "some", "each", "every", "all", "most", "few", "many", "several", "few", "both", 
         "everyone", "someone", "somebody", "everybody", "nonone", "everything", "something", "nowhere", "somewhere", "everywhere", "more", "less", "much", "most", 
         "least", "than", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "first", "second", "third", "fourth", "fifth", "sixth", 
         "seventh", "eighth", "nineth", "tenth", "last", "can", "could", "need", "may", "might", "should", "ought", "must", "maybe", "perhaps", "shall", "will", 
         "would", "won't", "any", "anyone", "anything", "anywhere", "anything", "anyway", "anyways", "ever", "yet", "the", "a", "an", "this", "that", "these", "those", 
         "always", "usually", "seldom", "never", "sometimes", "often", "once", "twice", "now", "while", "after", "before", "then", "until", "since", "whenever", 
         "during", "who", "when", "what", "whose", "where", "how", "why", "whom", "on", "in", "out", "up", "down", "under", "above", "below", "along", "over", "behind", 
         "across", "beside", "between", "beyond", "into", "near", "onto", "toward", "here", "through", "here", "there", "because", "but", "although", "am", "is", "are", 
         "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "i", "you", "we", "he", "she", "they", "me", "us", "her", 
         "him", "them", "my", "your", "our", "his", "their", "its", "mine", "yours", "ours", "hers", "theirs", "myself", "yourself", "ourselves", "himself", "herself", 
         "yourselves", "themselves", "it", "itself", "again", "too", "also", "another", "other", "others", "still", "only", "just", "even", "indeed", "either", "neither", 
         "whether", "as", "else", "almost", "already", "except", "for", "from", "instead", "same", "different", "such", "with", "without", "about", "by", "very", 
         "unless", "to", "of", "would", "at", "against"]

non_contracted_words = [
    "no", "not", "i'm", "you're", "he's", "she's", "it's", "we're", "they're","i've", "you've", "we've", "they've", "i'd", "you'd", "he'd", "she'd", "we'd", "they'd", 
    "i'll", "you'll", "he'll", "she'll", "we'll", "they'll", "don't", "doesn't", "didn't", "isn't", "aren't", "wasn't", "weren't", "haven't", "hasn't", "hadn't","can't", 
    "couldn't", "won't", "wouldn't", "shouldn't", "yes", "and", "or", "if", "nor", "therefore", "none", "some", "each", "every", "all", "most", "few", "many", "several", 
    "few", "both", "everyone", "someone", "somebody", "everybody", "nonone", "everything", "something", "nowhere", "somewhere", "everywhere", "more", "less", "much", 
    "most", "least", "than", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "first", "second", "third", "fourth", "fifth", "sixth", 
    "seventh", "eighth", "nineth", "tenth", "last", "can", "could", "need", "may", "might", "should", "ought", "must", "maybe", "perhaps", "shall", "will", "would", 
    "won't", "any", "anyone", "anything", "anywhere", "anything", "anyway", "anyways", "ever", "yet", "the", "a", "an", "this", "that", "these", "those", "always", 
    "usually", "seldom", "never", "sometimes", "often", "once", "twice", "now", "while", "after", "before", "then", "until", "since", "whenever", "during", "who", 
    "when", "what", "whose", "where", "how", "why", "whom", "on", "in", "out", "up", "down", "under", "above", "below", "along", "over", "behind", "across", "beside", 
    "between", "beyond", "into", "near", "onto", "toward", "here", "through", "here", "there", "because", "but", "although", "am", "is", "are", "was", "were", "be", 
    "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "i", "you", "we", "he", "she", "they", "me", "us", "her", "him", "them", "my", "your", 
    "our", "his", "their", "its", "mine", "yours", "ours", "hers", "theirs", "myself", "yourself", "ourselves", "himself", "herself", "yourselves", "themselves", "it", 
    "itself", "again", "too", "also", "another", "other", "others", "still", "only", "just", "even", "indeed", "either", "neither", "whether", "as", "else", "almost", 
    "already", "except", "for", "from", "instead", "such", "with", "without", "about", "by", "very", "unless", "to", "of", "would", "at", "against"
]
# returns an array of phoneme lengths for each word in words
def get_phoneme_length(words):
    words_phoneme_length = []
    IPA_rep = []

    range = len(words)

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
            IPA_rep.append(arpabet[word][0])
            # arpabet breaks a word down into phonemes, so just how many phoneme parts it breaks it down into

    print(IPA_rep)
    return words_phoneme_length

phoneme_lengths_contracted = get_phoneme_length(contracted_words)
print("phoneme legnths contracted: ", phoneme_lengths_contracted)

phoneme_lengths = get_phoneme_length(contracted_words)
print("phoneme_lengths: ", phoneme_lengths)

# modified 5/28/2025, 4:08pm