library(tidyr)
library(tidyr)
library(tidytext)
library(dplyr)
library(e1071)
library(RTextTools)
library(tm)

training_the_data <-function(a){
traindataframe<-read.csv(a)
traindataframe1<-traindataframe[traindataframe$Sentiment==1,c(3,4)]
traindataframe2<-traindataframe[traindataframe$Sentiment==2,c(3,4)]
traindataframe3<-traindataframe[traindataframe$Sentiment==3,c(3,4)]
finalframe<-rbind(traindataframe1,traindataframe2,traindataframe3)
finalframe$Sentiment<-gsub("1","not3",finalframe$Sentiment)
finalframe$Sentiment<-gsub("2","not3",finalframe$Sentiment)
finalframe$Review_Text<-as.character(finalframe$Review_Text)
finalframe$Sentiment<-as.factor(finalframe$Sentiment)
finalframe<-data.frame(line=1:nrow(finalframe),Review_Text=finalframe$Review_Text,sentiment=finalframe$Sentiment)
finalframe1<-finalframe%>%unnest_tokens(bigram,Review_Text , token = "ngrams", n = 2)
finalframe2<-finalframe1%>%separate(bigram, c("word1", "word2"), sep = " ")
finalframe3<-finalframe2%>%filter(!word1 %in% stop_words$word) %>%
    filter(!word2 %in% stop_words$word)
finalframe4<-finalframe3[order(finalframe3$line,decreasing = F),]
finaltraindataframe<-data.frame(line=finalframe4$line,word1=finalframe4$word1,word2=finalframe4$word2,Sentiment=finalframe4$sentiment)
trainingthemodel<-naiveBayes(finaltraindataframe[,2:3],finaltraindataframe[,4])
return(trainingthemodel)



}


barplot_emotionalanalysis<-function(b){
    library(tidyr)
    library(tidyr)
    library(tidytext)
    library(dplyr)
    library(e1071)
    library(RTextTools)    
    dataframe<-data_frame(text=b)
    dataframe<-dataframe%>%unnest_tokens(bigram,text,token="ngrams",n=2)
    dataframe<-dataframe%>%separate(bigram,c("word1","word2"),sep=" ")
    dataframe<-as.data.frame(dataframe)
    dataframe$word1<-as.character(dataframe$word1)
    dataframe$word2<-as.character(dataframe$word2)
    newtestdataframe<-data.frame(word1=dataframe$word1,word2=dataframe$word2)
    predict<-predict(training_the_data("chennai_reviews.csv"),newtestdataframe)
    predictframe<-data.frame(Predict=predict)
    finalframe<-cbind(dataframe,predictframe)
plot<-barplot(table(predict))
return(plot)
}

barplot_emotionalanalysis("it was a worst day")
