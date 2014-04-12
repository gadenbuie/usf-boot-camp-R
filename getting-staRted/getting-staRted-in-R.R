# getting staRted in R
# Companion Code
# Garrick Aden-Buie // April 11, 2014
# INFORMS Code & Data Boot Camp
# http://bit.ly/USFCodeCamp2014

# All the links in one place: <http://bit.ly/1qjZg55>

#---- Take it for a quick spin ----

3+3
sqrt(4^4)
2==2


## Setting up RStudio
# - Under settings, move panes to where you want them to be
# - Change font colors, etc
# - Browse to downloaded companion script in **Files** pane
# - Open script and set working directory

## Where to get help

# - Every R packages comes with documentation and examples
#     - Try `?summary` and `??regression`
#     - RStudio + tab completion = FTW!

?summary
??regression


    
## Working directory

# Set working directory with

# setwd("path/to/directory/")


# Check to see where you are with
getwd()


## Packages

# Install packages[^1]

install.packages('ggplot2')

# Load packages

library(ggplot2)




#---- Basics of the language ----

## Basic Operators

2 + 2
2/2
2*2
2^2
2 == 2
42 >= 2
2 <= 42
2 != 42
23 %/% 2   # Integer division -> 11
23 %% 2    # Remainder -> 1


## Key Symbols

x <- 10         # Assigment operator
y <- 1:x        # Sequence
y[2]            # Element selection
"str" == 'str'  # Strings


## Functions

# Functions have the form `functionName(arg1, arg2, ...)` 
# and arguments always go inside the parenthesis.

# Define a function:

fun <- function(x=0){
  # Adds 42 to the input number
  return(x+42)
}
fun(8)


## Data types

1L          # integer
1.0         # numeric
'1'         # character
TRUE == 1   # logical
FALSE == 0  # logical
NA          # NA
factor()    # factor

# You can check to see what type a variable is with `class(x)` 
# or `is.numeric()` -- or is.*().
class(1L)
is.numeric('1')



#---- Data Structures ----

## Vectors

# Basic data type is a vector, built with `c()` for **concatenate**.

x <- c(1, 2, 3, 4, 5); x
y <- c(6:10); y


## Working with vectors

a <- sample(1:5, 10, replace=TRUE)
length(a)
unique(a)
length(unique(a))
a * 2


## Strings

# Strings use either the `' '` or the `" "` characters.

mystr <- 'Glad you\'re here'
print(mystr)

# Use `paste()` to concatenate strings, not `c()`.

paste(mystr, '!', sep='')
c(mystr, '!')


## Matrices: binding vectors

# Matrices can be built by row binding or column binding vectors:

cbind(x,y)   # 5 x 2 matrix
rbind(x,y)   # 2 x 5 matrix


## Matrices: matrix function

# Or you can build a matrix using the `matrix()` function:

matrix(1:10, nrow=2, ncol=5, byrow=TRUE)


## Coercion

# Vectors and matrices need to have elements of the same type, 
# so R pushes mismatched elements to the best common type.

c('a', 2)
c(1L, 1.0)
c(1L, 1.1)


## Recycling

# Recycling occurs when a vector has mismatched dimensions. 
# R will fill in dimensions by *repeating* a vector from the beginning.

matrix(1:5, nrow=2, ncol=5, byrow=FALSE)


## Factors

# Factors are a special (at times frustrating) data type in R.

x <- rep(1:3, 2)
x
x <- factor(x, levels=c(1, 2, 3), 
            labels=c('Bad', 'Good', 'Best'))
x

## Ordering factors

# Order of factors is important for things like plot type, output, etc. 
# Also factors are really two things tied together: the data itself 
# and the labels.

x[order(x)]
x[order(x, decreasing=T)]


## Ordering factor labels

# That reordered the elements of `x`, but not the factor levels.

# Compare:

factor(x, levels=c('Best', 'Good', 'Bad'))
factor(x, labels=c('Best', 'Good', 'Bad'))


## Squashing factors

# What if you want your drop the "factor" and keep the data?

# **Keep the numbers**
# Risky, order matters!

as.numeric(x)

# **Keep the labels**

as.character(x)


## Lists

# Lists are arbitrary collections of objects. They don't have to
# be the same type or element or have the same dimensions.

mylist <-  list(vec = 1:5, str = "Strings!")
mylist


## Finding list elements

# Use double brackets to return the list item or the `$` operator.

mylist[[1]]
mylist$str
mylist$vec[2]


## Data frames

# Data frames are like matrices, but better. Column vectors are *not* 
# required to be the same type, so they can handle diverse data.

require(ggplot2)
data(diamonds, package='ggplot2')
head(diamonds)


## Building a data frame

# Data frames require vectors of the same dimension, but not the same type.

mydf <- data.frame(My.Numbers = sample(1:10, 6),
                   My.Factors = x)
mydf

## Naming columns and rows

# Data frames and matrices can have named rows and columns.

names(mydf)
colnames(mydf) <- c('Num', 'Fak')  # Set column names
rownames(mydf)                     # Same for rows


# To find the dimensions of a matrix or data frame (*rows*, *cols*):

dim(mydf)



## Reading and writing data in data frames

# R works well with Excel and CSV files, among many others. 
# I usually work with CSV, but that's mostly personal preference.

# **Reading data**

mydata <- read.csv('filename.csv', header=T)

# **Writing data**

write.csv(mydata, 'filename.csv')



# Control structures

## `if`, `else if`, `else`

a <- 10
if(a > 11){
  print('Bigger!')
} else if(a < 9){
  print('Smaller!')
} else {
  print('On the money!')
}

## `for` loops

z <- c()

for(i in 1:10){
  z <- c(z, i^2)
}

z

## `while` loops

z <- c()
i <- 1

while(i <= 5){
  z <- c(z, i^3)
  i <- i+1
}

z



# Manipulating data

## `mtcars` data frame

# R includes a number of datasets in the package `datasets` including 
# `mtcars`. Try `?mtcars` to learn more. The data was extracted from 
# the 1974 issue of *Motor Trend*. 

# If entering `mtcars` doesn't work, run `data(mtcars)` first.

head(mtcars)

## Selecting rows and columns

# Rows and columns are selected using brackets:
# dataframe[<row conditions>, <column conditions>]

# For example, `mtcars[1,2]` returns row 1, column 2:

mtcars[1,2]


# Select a whole row by leaving the column blank

mtcars[1,]


# or similarly select a column by leaving the row condition blank

mtcars[,'qsec'][1:10]


## More ways to select rows and columns

mtcars[-1,]               # Drop first row
mtcars[, -2:-4]           # Drop columns 2-4
mtcars[, c('mpg', 'cyl')] # Only mpg and cyl columns
mtcars[c(1,5,8,10),'am']
mtcars['Valiant',]        # Works when rows have names
mtcars$mpg                # Select 'mpg' col
mtcars[[1]]               # Same
mtcars[['mpg']]           # Also the same
mtcars$mpg[1:5]           # == mtcars[1:5, 'mpg']


## Subsetting

# What if you want to look at the gas guzzlers only?

gas_guzzlers <- mtcars[mtcars$mpg < 20,]
gas_guzzlers

## Subsetting

# Or 6-cylinder gas guzzlers only...

gas_guzzlers <- mtcars[mtcars$mpg < 20 & mtcars$cyl == 6,]
gas_guzzlers

## Setting values based on subsets

# Create a new column for speed class based on quarter mile time.

mtcars[mtcars$qsec < 17, 'Class'] <- 'Slow'
mtcars[mtcars$qsec > 17, 'Class'] <- 'Medium'
mtcars[mtcars$qsec > 20, 'Class'] <- 'Fast'
table(mtcars$Class)


# Any expression that evaluates to `TRUE` or `FALSE` can be used 
# as a column or row condition.

mtcars$qsec[1:10] > 17


## Dealing with missing values

# Missing values show up as `NA`s, which is actually a data type.

foo <- c(1.2, NA, 2.4, 6.2, 8.3)
bar <- c(9.1, 7.6, NA, 1.1, 4.7)
fb <- cbind(foo, bar)
fb[complete.cases(fb),]
fb[!is.na(foo),]



#---- Base functions ----

## All around great functions: `summary`

# **Summarize just about anything**

summary(mtcars[,1:3])


## All around great functions: `str`

# **"Quick look" function**

str(mtcars)


## All around great functions: `attributes`

# **Learn more about the object**

attributes(mtcars[1:10,])


## All around great functions: `table`

# **Quick and dirty tables**

table(mtcars$cyl, mtcars$gear)


## Basic functions for vectors

sum(mtcars$wt)   
mean(mtcars$hp)  
sd(mtcars$hp)          # standard deviation
max(mtcars$disp)
min(mtcars$qsec)
median(mtcars$drat)
range(mtcars$mpg)
rev(rownames(mtcars))  # reverse
unique(mtcars$cyl)     # unique elements
length(mtcars[,1])


#---- Visualizing data ----

## Plotting points

plot(mtcars$wt, mtcars$mpg,
     xlab='Weight', ylab='MPG')


## Plotting lines

plot(presidents, type='l',
     xlab = 'Approval Rating')


## Histograms

par(mar=c(5,4,1,1), bg='white')
hist(mtcars$qsec, xlab='Quarter Mile Time')


## Bar plots

barplot(table(mtcars$Class))


#---- Base stats information ----

## `r*`, `p*`, `q*`, `d*` functions

# For all of the statistical distributions, R uses the 
# following naming conventions (incredible how useful this is!):

# - `d*` = density/mass function
# - `p*` = cumulative distribution function
# - `q*` = quantile function
# - `r*` = random variate generation

# There are quite a few distributions available in base R packages. 
# Just run `?Distributions` to see a full list.

?Distributions

## `rnorm()` example

hist(rnorm(100))


## Better than base packages

# - Manipulating data
#     - [ddply] and [plyr] and now [dplyr]

install.packages(c('ddply', 'plyr', 'dplyr'))

# - Visualizing data
#     - [ggplot2]

install.packages('ggplot2')

# - Reporting data
#     - [knitr]

install.packages('knitr')

# - Interactive online R sessions
#     - [shiny]

install.packages('shiny')
    
# [ddply]:   http://cran.r-project.org/web/packages/plyr/plyr.pdf
# [plyr]:    http://plyr.had.co.nz/
# [dplyr]:   http://blog.rstudio.org/2014/01/17/introducing-dplyr/
# [ggplot2]: http://ggplot2.org/
# [knitr]:   http://yihui.name/knitr/
# [shiny]:   http://www.rstudio.com/shiny/


# Go ExploR

## Resources for learning more

# - Advanced R Programming
#       http://adv-r.had.co.nz/
#       by one of the best and most important R developers.

# - TwoTorials
#       http://www.twotorials.com/
#       quick two minute videos on doing things in R.

# - An R Meta Book
#       http://blog.revolutionanalytics.com/2014/03/an-r-meta-book.html
#       a collection of online books

# - R Bloggers
#       http://www.r-bloggers.com/
#       a mailing list and central hub of all things online regarding R.

# ----- Thanks! ---- #

# garrickadenbuie.com
# @grrrck