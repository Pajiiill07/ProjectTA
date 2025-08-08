import re
from Sastrawi.Stemmer.StemmerFactory import StemmerFactory
from Sastrawi.StopWordRemover.StopWordRemoverFactory import StopWordRemoverFactory

stemmer = StemmerFactory().create_stemmer()
stopword_remover = StopWordRemoverFactory()
stopword_list = set(stopword_remover.get_stop_words())

def preprocess_text(text: str) -> str:
    if not text:
        return ""
    
    text = text.lower()
    text = re.sub(r'[^a-zA-Z0-9\s.,:;()%/\-]', '', text)
    words = text.split()
    words = [word for word in words if word not in stopword_list]
    words = [stemmer.stem(word) for word in words]
    
    return " ".join(words)
