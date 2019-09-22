## R function demo
## The result in function list should be:
##      a_thing, b_thing, Thing5, theThing, anotherThing, strangeThing
## The following should not appear:
##      function, var2, function5, FUN

a_thing<-function() {print("Hello")}

b_thing  <-  function(x){print("Hello")}

Thing5 = function(a=5, b=4)  a+b

## function <- function(function) ## not a function

theThing <- function(var1, var2=function5(), var3) { ## function5 is a function defined elsewhere
    var4 <- var1+var2
    print(var4)
}; anotherThing <- function() print("World")

## advanced examples - these may be too much effort
x <- cbind(x1 = 3, x2 = c(4:1, 2:5))
apply(x, 2, FUN=function(x) mean(x), trim = .2) ## nameless function, should not be listed

(function(x,y) {print(x+y)}) -> strangeThing



functionname1 <- function(arg1, arg2, ...){ # declare name of function and function arguments
    statements                              # declare statements
    return(object)                          # declare object data type
}

functionname2 <- function(                  # declare name of function
     arg1,                                  # function arguments
     arg2, 
     ...                                    #
    )
{ 
    statements                              # declare statements
    return(object)                          # declare object data type
}

