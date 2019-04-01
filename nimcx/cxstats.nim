{.deadCodeElim: on , optimization: speed.}

## ::
## 
##     Library     : nimcx.nim
##     
##     Module      : cxstats.nim
##
##     Status      : stable
##
##     License     : MIT opensource
##   
##     Latest      : 2019-03-15 
##
##     Compiler    : Nim >= 0.19.x dev branch
##
##     OS          : Linux
##
##     Description : provides some functions pertaining to statistcs and calculations
## 

import cxconsts,cxglobal,cxprint,stats,math,algorithm
  
# proc returnStat(x:Runningstat,stat : seq[string]):float =
#      ## returnStat
#      ## WIP
#      ## returns any of following from a runningstat instance
#      ## 
#      discard

proc showStats*(x:Runningstat,n:int = 3,xpos:int = 1) =
     ## showStats
     ##
     ## quickly display runningStat data
     ## 
     ## adjust decimals default n = 3 as needed
     ##
     ##.. code-block:: nim
     ##     import nimcx
     ##     
     ##     var rsa:Runningstat
     ##     var rsb:Runningstat
     ##     for x in 1.. 100:
     ##        cleanscreen()
     ##        decho(2)
     ##        rsa.clear
     ##        rsb.clear
     ##        var a = createSeqint(500,0,100000)
     ##        var b = createSeqint(500,0,100000) 
     ##        rsa.push(a)
     ##        rsb.push(b)
     ##        showStats(rsa,5)
     ##        curup(14)
     ##        showStats(rsb,5,xpos = 40)
     ##        decho(2)
     ##        printLnBiCol("Regression Run  : " & $x)
     ##        showRegression(a,b,xpos = 20)
     ##        sleepy(0.05)
     ##        curup(4)
     ##     
     ##     curdn(6)  
     ##     doFinish()
     ##
     var sep = ":"
     printLnBiCol2("Sum     : " & ff(x.sum,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Mean    : " & ff(x.mean,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Var     : " & ff(x.variance,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Var  S  : " & ff(x.varianceS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Kurt    : " & ff(x.kurtosis,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Kurt S  : " & ff(x.kurtosisS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Skew    : " & ff(x.skewness,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Skew S  : " & ff(x.skewnessS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Std     : " & ff(x.standardDeviation,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Std  S  : " & ff(x.standardDeviationS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Min     : " & ff(x.min,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Max     : " & ff(x.max,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLn2("S --> sample\n",peru,xpos = xpos)

proc showRegression*(x,y: seq[float | int],n:int = 5,xpos:int = 1) =
     ## showRegression
     ##
     ## quickly display RunningRegress data based on input of two openarray data series
     ## 
     ##.. code-block:: nim
     ##    import nimcx
     ##    var a = @[1,2,3,4,5] 
     ##    var b = @[1,2,3,4,7] 
     ##    showRegression(a,b)
     ##
     ##
     var rr :RunningRegress
     rr.push(x,y)
     printLn("Regression Results",skyblue)
     printLnBiCol2("Intercept     : " & ff(rr.intercept(),n),yellowgreen,white,":",xpos = xpos,false,{})
     printLnBiCol2("Slope         : " & ff(rr.slope(),n),yellowgreen,white,":",xpos = xpos,false,{})
     printLnBiCol2("Correlation   : " & ff(rr.correlation(),n),yellowgreen,white,":",xpos = xpos,false,{})
    

proc showRegression*(rr: RunningRegress,n:int = 5,xpos:int = 1) =
     ## showRegression
     ##
     ## Displays RunningRegress data from an already formed RunningRegress
     ## 
     printLnBiCol2("Intercept     : " & ff(rr.intercept(),n),yellowgreen,white,":",xpos = xpos,false,{})
     printLnBiCol2("Slope         : " & ff(rr.slope(),n),yellowgreen,white,":",xpos = xpos,false,{})
     printLnBiCol2("Correlation   : " & ff(rr.correlation(),n),yellowgreen,white,":",xpos = xpos,false,{})

     

proc zscore*(data:seq[SomeNumber]):seq[float] {.inline.} =
    ## zscore
    ## 
    ## returns the z-score in a seq[float] for each data point
    ##  
    ##.. code-block:: nim
    ##  
    ##   import nimcx
    ##   printLn("DATA SERIES FLOAT",yellowgreen,xpos=2)     
    ##   let data = createSeqFloat(12)  
    ##   showSeq(data,maxitemwidth=8) 
    ##   printLn("ZSCORE",salmon,xpos=2) 
    ##   showSeq(zscore(data),maxitemwidth=8) 
    ##   decho(3)
    ##   printLn("DATA SERIES INTEGER",yellowgreen,xpos=2) 
    ##   let data2 = createSeqint(12,1,1000)    
    ##   showSeq(data2,maxitemwidth=8) 
    ##   printLn("ZSCORE",salmon,xpos=2) 
    ##   showSeq(zscore(data2),maxitemwidth=8) 
    ##   doFinish() 

    var okdata = newSeq[float]()
    for x in 0 ..< data.len: okdata.add(float(data[x]))
    var rsa:Runningstat
    rsa.clear
    rsa.push(okdata)
    for x in 0..<okdata.len:
         result.add((okdata[x] - rsa.mean) / rsa.standardDeviation )  # z-score


# 
# rolling_zscore is used to identify trends in data
# 
# http://stackoverflow.com/questions/787496/what-is-the-best-way-to-compute-trending-topics-or-tags/826509#826509
# http://vincent.is/finding-trending-things/
# http://sayrohan.blogspot.com/2013/06/finding-trending-topics-and-trending.html
# 
# (based on an old python implementation)
#  
# Added 2019-03-15
# 
# 

proc add_to_history(point:float , average:float, sq_average:float,decay:float):(float,float) =
        let average = average * decay + point * (1 - decay)  
        let sq_average = sq_average * decay + (point ^ 2) * (1 - decay)
        return (average, sq_average)
    
proc calculate_zscore(average:float, sq_average:float, value:float,avg:float):float =
        let std = round(sqrt(sq_average - avg ^ 2))
        if std == 0:
            return value - average
        return (value - average) / std

proc rolling_zscore*(data:seq[float],observed_window:seq[float],decay:float = 0.9):float =
    #
    # The lowest the decay, the more important the new points
    # Decay is there to ensure that new data is worth more than old data
    # in terms of trendiness
    #
 
    # Set the average to the first value of the history to start with
    var avg = data[0]
    var squared_average = data[0] ^ 2
    
    for apoint in 1 ..< data.len:
        let point = data[apoint]
        (avg, squared_average) = add_to_history(point, avg, squared_average,decay)

    var trends = newSeq[float]()
    # We recalculate the averages for each new point added to increase accuracy
    for point in observed_window:
        trends.add(calculate_zscore(avg, squared_average, point,avg))
        (avg, squared_average) = add_to_history(point, avg, squared_average,decay)

    # Close enough way to find a trend in the window
    
    if len(trends) != 0:
        return sum(trends) / float(len(trends))  
    else :
        return 0.0

# 
# # rolling_zscore and zscore testing
#  
# var data = newSeq[float]()
# data = @[0.0, 0.0, 3.0, 5.0, 4.0, 3.0, 6.0, 0.0, 2.0, 6.0, 8.0, 9.0, 0.0, 1.0, 3.0, 7.0, 5.0, 6.0, 4.0, 5.0, 0.0, 1.0, 3.0, 5.0, 0.0, 6, 4, 2, 3, 1]
# let window_not_trending = @[3.0, 4, 3, 0, 1, 4, 5]
# let window_trending = @[5.0, 8, 10, 12, 15, 17, 20]
# 
# printLn("Test 1")
# printLn(rolling_zscore(data, window_not_trending))
# # -0.02257907513690587
# # 
# printLn("Test 2")
# printLn(rolling_zscore(data, window_trending))
# # 2.185948961553206
# 
# # And now with different decay, not linear relation
# printLn("Test 3")
# printLn(rolling_zscore(data, window_trending, decay=0.5))
# # 1.857409885787915 
# 
# printLn("Test 4")
# printLn(rolling_zscore(data, window_trending, decay=0.1))
# # 2.934068545987708
# 
# printLn("Test 5")
# printLn(rolling_zscore(@[20.0, 20, 20, 20, 20, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], @[20.0]))
# # 2.03674495278704
# 
# printLn("Test 6")
# printLn(rolling_zscore(@[0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 20, 20, 20, 20, 20], @[20.0]))
# # 1.062882
# 
# printLn("Test 7")
# printLn(rolling_zscore(@[1.0, 1, 1, 1, 1, 1, 9, 9, 9, 9, 9, 9],window_not_trending))
# # -0.3688909393729522
# 
# printLn("Test 8")
# printLn(rolling_zscore(@[2.0, 4, 4, 4, 5, 5, 7, 9],@[11.0]))
# # 3.5163469
# 
# printLn("Test 9")
# printLn(rolling_zscore(@[1.0, 2, 0, 3, 1, 3, 1, 2, 9, 8, 7, 10, 9, 5, 2, 4, 1, 1, 0],@[8.69]))
# # 1.65463766240478
# 
# # zscore tests
# printLn("Test 10")
# echo()
# var dataf = @[1.0, 2, 0, 3, 1, 3, 1, 2, 9, 8, 7, 10, 9, 5, 2, 4, 1, 1, 0]
# var datai = @[1, 2, 0, 3, 1, 3, 1, 2, 9, 8, 7, 10, 9, 5, 2, 4, 1, 1, 0]
# printLn("DATA SERIES FLOAT",yellowgreen,xpos=2) 
# showSeq(dataf,maxitemwidth=8) 
# printLn("ZSCORE",salmon,xpos=2) 
# showSeq(zscore(dataf),maxitemwidth=8) 
# decho(3)
# printLn("DATA SERIES INTEGER",yellowgreen,xpos=2) 
# showSeq(datai,maxitemwidth=8) 
# printLn("ZSCORE",salmon,xpos=2) 
# showSeq(zscore(datai),maxitemwidth=8) 
# 

    
proc median*(xs: seq[float]): float =
  # median
  # 
  # ex rosetta code receipe
  # 
  var ys = xs
  sort(ys, system.cmp[float])
  0.5 * (ys[ys.high div 2] + ys[ys.len div 2])          
         
# end of cxstats.nim         
         
