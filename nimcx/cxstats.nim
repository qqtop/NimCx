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
##     Latest      : 2018-09-26 
##
##     Compiler    : Nim >= 0.18.x dev branch
##
##     OS          : Linux
##
##     Description : provides functions pertaining to statistcs and calculations
## 

import cxconsts,cxglobal,cxprint,stats
  
proc returnStat(x:Runningstat,stat : seq[string]):float =
     ## returnStat
     ## WIP
     ## returns any of following from a runningstat instance
     ## 
     discard

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
         
         
# end of cxstats.nim         
         
