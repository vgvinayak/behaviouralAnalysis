library(tidyr)
library(tidyr)
library(tidytext)
library(dplyr)
library(e1071)
library(RTextTools)
trainsvmmodel<-function(a){
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
svmmatrix<-create_matrix(finalframe[,2], language="english", 
                         removeStopwords=FALSE, removeNumbers=TRUE, 
                         stemWords=FALSE)
svmcontainer<- create_container(svmmatrix,finalframe[,3],trainSize = 1:nrow(finalframe),virgin = F)
svmmodelss<-train_models(svmcontainer, algorithms=c("SVM"))
return(svmmodelss)
}
svmmatrix<-function(a){

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
    svmmatrix<-create_matrix(finalframe[,2], language="english", 
                             removeStopwords=FALSE, removeNumbers=TRUE, 
                             stemWords=FALSE)
    return(svmmatrix)
}
svmanalysis<-function(a){
    svmtestframe<-data.frame(Text=a)
    testmat= create_matrix(svmtestframe[,1], language="english", 
                           removeStopwords=FALSE, removeNumbers=TRUE, 
                           stemWords=FALSE, tm::weightTfIdf,originalMatrix =svmmatrix("chennai_reviews.csv"))
    testcontainer = create_container(testmat, testSize=1,virgin=FALSE,label=0)  
    svmresults = classify_models(testcontainer,trainsvmmodel("chennai_reviews.csv"))    
return(svmresults)
}
svmanalysis("worst hotel")