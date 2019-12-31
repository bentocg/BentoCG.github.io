---
title       : 
subtitle    : 
author      : 
job         : 
framework   : html5slides   # {io2012, html5slides, shower, dzslides, ...}
highlighter : prettify      # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Find out the gender of your abalone!
_A comprehensive tool for sexing your abalone_
* * *

---

### Have you ever wondered about which name you would give to your pet abalone but couldn't figure out if it was a 'he' or a 'she'?
* * *
<br><br>
### Your problems are now (rather unsuccesfully) solved!

> Measure your abalone carefully, input the values in the application and you should have a good idea about its gender.

---

## Dataset used
* * *

> This predictive model is based on the famous 'Abalone' dataset, found in the UCI machine learning
repository.
> To take a peek at the dataset, execute the following code chunk on R:

```r
require(AppliedPredictiveModeling)
data(abalone)
summary(abalone)
```

---

## Prediction model
* * *
> The model uses a boosting method on the caret package to predict the gender based on 5 other parameters (though the dataset has 3 more parameters, I decided to remove them from the model because it is necessary to
kill the abalone before measuring them, and we don't want them killed.)

```r
#Separate data into training and test sets.
inTrain = createDataPartition(abalone$Type, p = 0.9, list = FALSE)
training = abalone[inTrain,]
testing = abalone[-inTrain,]
#set the seed for reproducibility
set.seed(132)
#I've tried several methods and boosting was the most efficient.
trControl = trainControl(method = "cv", number = 4, allowParallel =TRUE)
modFit = train(Type ~ ., method = "gbm", data = training,trControl = trControl, 
verbose = FALSE)
```

---

## Evaluated expression
* * *
> This is the expression that gets evaluated in  server.R when you input your measurements on the sliders:

```r
#createRow is a helper function that transforms the input into suitable data for the model 
   t = reactive({x = as.character(predict(modFit, createRow(c(input$LongestShell, input$Diameter, 
                                               input$Height, input$WholeWeight, input$Rings))))                                             
   if( x == "M"){
       z = "it's probably a boy!"}
   else if( x == "F"){
       z = "it's probably a girl!"}
   else{
       z = "it's probably still an imature."}
   })
   output$gender = renderText({t()})
```

