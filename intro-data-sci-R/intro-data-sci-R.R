# Doing Data Science in R
# Companion Code
# Garrick Aden-Buie // April 11, 2014
# INFORMS Code & Data Boot Camp
# http://bit.ly/USFCodeCamp2014

## Intro

# In this project we'll do a simple data science project
# based on the [Kaggle Titanic Challenge][kaggle-titanic].

# [kaggle-titanic]: http://www.kaggle.com/c/titanic-gettingStarted

# **Overview**

# - Data Exploration
# - Data Cleaning
# - Training a Model
# - Fitting a Model

# *Big thanks*: Draws heavily from <http://statsguys.wordpress.com/2014/01/03/first-post/>
# and <https://github.com/wehrley/wehrley.github.io/blob/master/SOUPTONUTS.md>.
# Much more detail available there!


## Who survives the Titanic?


## Getting started

# - Download the CSV and R script file from <http://bit.ly/USFCodeCamp2014>
# - Open the R script
# - Set your working directory


#---- The data ----

## Loading the data

titanic <- read.csv('titanic.csv', header = TRUE,
                     na.strings=c('NA', ''))

titanic$Survived <- factor(titanic$Survived, 
                           labels=c('No', 'Yes'))
titanic$Pclass <- factor(titanic$Pclass)


## Quick look at the data

names(titanic)

# Also look at:

head(titanic)
summary(titanic)
str(titanic)

## Variable Meanings

# | Variable | Meaning                                          |
# |----------|--------------------------------------------------|
# | survival | Survival                                         |
# |          | (0 = No; 1 = Yes)                                |
# | pclass   | Passenger Class                                  |
# |          | (1 = 1st; 2 = 2nd; 3 = 3rd)                      |
# | name     | Name                                             |
# | sex      | Sex                                              |
# | age      | Age                                              |
# | sibsp    | Number of Siblings/Spouses Aboard                |
# | parch    | Number of Parents/Children Aboard                |
# | ticket   | Ticket Number                                    |
# | fare     | Passenger Fare                                   |
# | cabin    | Cabin                                            |
# | embarked | Port of Embarkation                              |
# |          | (C = Cherbourg; Q = Queenstown; S = Southampton) |

## Plotting age

require(ggplot2)
qplot(titanic$Age, geom='histogram')

## Plot Fare

qplot(titanic$Fare, geom='histogram')

## Take a look at everything

barplot(table(titanic$Survived),
        names.arg = c("Perished", "Survived"),
        main="Survived (passenger fate)", col="black")
barplot(table(titanic$Pclass), 
        names.arg = c("first", "second", "third"),
        main="Pclass (passenger traveling class)", col="firebrick")
barplot(table(titanic$Sex), main="Sex (gender)", col="darkviolet")
hist(titanic$Age, main="Age", xlab = NULL, col="brown")
barplot(table(titanic$SibSp), main="SibSp (siblings + spouse aboard)", 
        col="darkblue")
barplot(table(titanic$Parch), main="Parch (parents + kids aboard)", 
        col="gray50")
hist(titanic$Fare, main="Fare (fee paid for ticket[s])", xlab = NULL, 
     col="darkgreen")
barplot(table(titanic$Embarked), 
        names.arg = c("Cherbourg", "Queenstown", "Southampton"),
        main="Embarked (port of embarkation)", col="sienna")

## Survival by gender

table(titanic$Survived, titanic$Sex)

## Survival by gender plot

ggplot(titanic, aes(x=Sex, fill=Survived))+geom_histogram()

## Survival by Passenger Class

table(titanic$Survived, titanic$Pclass)

## Survival by Passenger Class plot

ggplot(titanic, aes(x=Pclass, fill=Survived))+
  geom_histogram(binwidth=1)

## Survival by Age

ggplot(titanic, aes(x=Survived, y=Age))+geom_boxplot()

## Survival by Fare

ggplot(titanic, aes(x=Survived, y=Fare))+geom_boxplot()

## Survival by Port

ggplot(titanic, aes(x=Embarked, fill=Survived))+geom_histogram()


## Thoughts?

require(Amelia)
missmap(titanic, col=c('blue', 'grey'))


#---- Cleaning the data ----

## Missing values

# Clearly we need to work on the missing values.
# Let's ignore cabin and drop missing Embarked.

names(titanic)
titanic <- titanic[, -11]
titanic <- titanic[!is.na(titanic$Embarked),]

# But we definitely need to fix `Age`

length(titanic[is.na(titanic$Age),'Age'])/dim(titanic)[1]

## Does Passenger Class Help?

ggplot(titanic, aes(x=Pclass, y=Age))+geom_boxplot()

# maybe...


## What about the passenger names?

rrows <- c(766, 490, 509, 384, 34, 
           126, 887, 815, 856, 851)
titanic[rrows, 'Name']

## Passenger Titles

# The following titles have at least one person missing `Age`

# - Dr.
# - Master.
# - Miss.
# - Mr.
# - Mrs.

# These titles are clearly correlated with passenger age.

## How we're going to do this

# Find indexes of Names that contain `Dr.`
dr <- grep('Dr.', titanic$Name, fixed=TRUE); dr

# Calculate median age for those passengers
m_age <- median(titanic[dr, 'Age'], na.rm=TRUE); m_age

# Select indexes that are both missing and have `Dr.`
dr[dr %in% which(is.na(titanic$Age))]


## Impute Age with median age for titles

titles <- c('Dr.', 'Master.', 'Miss.', 'Mr.', 'Mrs.')

for(title in titles){
	passengers <- grep(title, titanic$Name, fixed=TRUE)
	median_age <- median(titanic[passengers, 'Age'], na.rm=TRUE)
	titanic[passengers[passengers %in% which(is.na(titanic$Age))],
           'Age'] <- median_age
}


## Adding features: Child?

# Add a feature to indicate if the passenger is a child (<12)

titanic$Child <- 'No'
titanic[titanic$Age <= 12, 'Child'] <- 'Yes'
titanic$Child <- factor(titanic$Child)
summary(titanic$Child)


## Adding features: Mother?

# Add a feature to indicate if the passenger is a mother.
# Use the variable `Parch` and title `'Mrs.'`

# ...

titanic$Mother <- 'No'
mrs <- grep('Mrs.', titanic$Name, fixed=TRUE)
parent <- which(titanic$Parch > 0)
titanic[mrs %in% parent, 'Mother'] <- 'Yes'
titanic$Mother <- factor(titanic$Mother)
summary(titanic$Mother)


#---- Divide the data ----

## Divide the data into training and testing sets.

# We'll use the `caret` package for this.

require(caret)
require(pROC)
require(e1071)

# <http://caret.r-forge.r-project.org/>

# Can be used as a power tool to test and train models.

## Make a training and testing set

train_index <- createDataPartition(y=titanic$Survived,
                                   p=0.80,
                                   list=FALSE)

train <- titanic[ train_index,]
test  <- titanic[-train_index,]

dim(train)
dim(test)



#---- Build some models! ----

## Generalized Linear Model (logistic regression)

train.glm <- glm(Survived ~ Pclass + Sex + Age +
                      Child + Sex+Pclass + Mother +
                      Embarked + Fare,
                    family = binomial,
                    data = train)

## Model summary

train.glm

## Anova

anova(train.glm, test='Chisq')

## Set up caret to train models for us

# This just reduces repeated typing later
cv.ctrl <- trainControl(method = 'repeatedcv',
                        repeats = 3,
                        summaryFunction = twoClassSummary,
                        classProbs = TRUE)

## Train `glm` with caret

glm.train <- train(Survived ~ Pclass + Sex +
                     Age + Child + Embarked,
                   data = train,
                   method = 'glm',
                   metric = 'ROC',
                   trControl = cv.ctrl)

## Check results

glm.train

## More details

summary(glm.train)

## Random forest model

# Let's try the method known as *random forests*. 

set.seed(42)
rf.train <- train(Survived ~ Pclass + Sex +
                     Age + Child + Embarked,
                   data = train,
                   method = 'rf',
                   metric = 'ROC',
                   trControl = cv.ctrl)

## Random forests results

rf.train


#---- Compare performance ----

## Make our predictions

glm.pred <- predict(glm.train, test)
rf.pred  <- predict(rf.train, test)

glm.prob <- predict(glm.train, test, type='prob')
rf.prob  <- predict(rf.train, test, type='prob')

## glm prediction results

confusionMatrix(glm.pred, test$Survived)

## randomForest results

confusionMatrix(rf.pred, test$Survived)

## pROC objects for ROC curves

glm.ROC <- roc(response = test$Survived,
               predictor = glm.prob$Yes,
               levels = levels(test$Survived))

rf.ROC  <- roc(response = test$Survived,
               predictor = rf.prob$Yes,
               levels = levels(test$Survived))

## ROC Plot

plot(glm.ROC)
plot(rf.ROC, add=TRUE, col="red")


#---- Thanks! ----
# garrickadenbuie.com
# @grrrck
