library(tidyr)
library(tidytext)
library(dplyr)
library(e1071)
library(RTextTools)
library(tm)
library(ggplot2)
emotion_library<-function(a){
emotiondataframe<-data_frame(Text=a)
emotiondataframe<-emotiondataframe%>%unnest_tokens(word,Text)
emotion<-emotiondataframe%>%inner_join(get_sentiments("nrc"))
plot2<-ggplot(emotion,aes(x=sentiment),fill=sentiment)+geom_bar()
return(plot2)
}

#Considering word followed by negation

emotion_library_improved<-function(a){
emotiondataframe<-data_frame(Text=a)
emotiondataframe<-emotiondataframe%>%unnest_tokens(word,Text,token="ngrams",n=2)
emotiondataframe<-emotiondataframe%>%separate(word,c("word1","word2"),sep=" ")
AFFIN<-get_sentiments("afinn")
emotiondataframe<-emotiondataframe%>%inner_join(AFFIN,by=c(word2="word"))
negation<-c("not", "no", "never","don't")
emotiondataframe[emotiondataframe$word1=="not"|| emotiondataframe$word1=="no"|| emotiondataframe$word1=="never",]$score= -(emotiondataframe[emotiondataframe$word1=="not"|| emotiondataframe$word1=="no"|| emotiondataframe$word1=="never",]$score)
emotiondataframe$score<-as.character(emotiondataframe$score)
plot3<-ggplot(emotiondataframe,aes(x=score),fill=score)+geom_bar()
return(plot3)
}


