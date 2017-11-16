# Behavioural Analalysis

## Aim
The automated extraction of writer’s attitude from the text
## DataSet
We took a Hotel review dataset with three levels of emotions tagged(Positive , Negative, Neutral) for our model.
1-Negative
2-Neutral
3-Negative
![xyz](https://github.com/vgvinayak/behaviouralAnalysis/blob/master/Screenshot%20(53).png)
## Pre-processing
Pre-processing involves
* Converting Strings in to Tidy text .
![xyz](https://github.com/vgvinayak/behaviouralAnalysis/blob/master/Screenshot%20(55).png)
* Cleaning the data like removing punctuation,removing stopwords,stemming and Sparsing the document.
  Process involve converting the data to Document Term Matrix
![xyz](https://github.com/vgvinayak/behaviouralAnalysis/blob/master/Screenshot%20(58).png)
## Frequency Analysis
* Frequency analysis without Cleaning the data
```
chennai_reviews<-read.csv("chennai_reviews.csv",header=T)
text<-data_frame(Line=1:nrow(chennai_reviews),Text=chennai_reviews$Review_Text)
text$Text<-as.character(text$Text)
text<-text%>%unnest_tokens(word,Text)
Frequeny<-text%>%count(word,sort=T)
Frequencytop20<-Frequeny[1:20,]
plot<-ggplot(Frequencytop20,aes(x=reorder(word,-n),y=n,fill=word))+geom_bar(stat="identity")
```
![xyz](https://github.com/vgvinayak/behaviouralAnalysis/blob/master/Screenshot%20(25).png)

* Frequency analysis after Cleaning the data
```
corpus<-VCorpus(VectorSource(chennai_reviews$Review_Text))
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))
corpus = tm_map(corpus, stemDocument)
dtm<-DocumentTermMatrix(corpus)
dtm<-removeSparseTerms(dtm,.97)
dataframe<-as.data.frame(as.matrix(dtm))
dataframe<-rbind(dataframe,colSums(dataframe))
dataframe<-data.frame(Word=colnames(dataframe),Freq=as.numeric(as.vector(dataframe[nrow(dataframe),])))
dataframe<-dataframe[order(dataframe$Freq,decreasing = T),]
dataframetop20<-dataframe[1:20,]
plot1<-ggplot(dataframetop20,aes(x=reorder(Word,-Freq),y=Freq,fill=Word))+geom_bar(stat="identity")
```
![xyz](https://github.com/vgvinayak/behaviouralAnalysis/blob/master/Screenshot%20(25).png)
# Sentiment Libraray Method
* Mataching our data to Sentiment Liraray.
## Sentiment Library
![xyz](https://github.com/vgvinayak/behaviouralAnalysis/blob/master/Screenshot%20(59).png)
## Model1
```
emotion_library("Its really nice place to stay especially for business and tourist purpose.")
```
![xyz](https://github.com/vgvinayak/behaviouralAnalysis/blob/master/Screenshot%20(63).png)
```
emotion_library("Table and chair not clean. Not value for money. PC lan cable has so much dust but WiFi Internet speed is too good. Bar service is too bad only one waiter serving to all customer. Serving food like tandoori chicken is very salty.")
```
![xyz](https://github.com/vgvinayak/behaviouralAnalysis/blob/master/Screenshot%20(62).png)

## Model2(Improved Model)
```
emotion_library("Table and chair not clean. Not value for money. PC lan cable has so much dust but WiFi Internet speed is too good. Bar service is too bad only one waiter serving to all customer. Serving food like tandoori chicken is very salty.")
```
![xyz](https://github.com/vgvinayak/behaviouralAnalysis/blob/master/Screenshot%20(62).png)
```



