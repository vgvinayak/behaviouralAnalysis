library(dplyr)
library(tidytext)
library(tidyr)
library(ggplot2)
library(tm)
#Term frequeny analysis wihout any pre-processing
chennai_reviews<-read.csv("chennai_reviews.csv",header=T)
text<-data_frame(Line=1:nrow(chennai_reviews),Text=chennai_reviews$Review_Text)
text$Text<-as.character(text$Text)
text<-text%>%unnest_tokens(word,Text)
Frequeny<-text%>%count(word,sort=T)
Frequencytop20<-Frequeny[1:20,]
plot<-ggplot(Frequencytop20,aes(x=reorder(word,-n),y=n,fill=word))+geom_bar(stat="identity")
#Term frequency analysis after pre=processing
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



