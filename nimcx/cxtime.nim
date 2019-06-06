import cxglobal,cxprint,cxconsts
import os,terminal,times,parseutils,strutils

# cxtime.nim
# 
# time/date related procs including printDTimeMsg etc.
# 
# some of it similar to stdlib functions or in different output format
# 
# 
# 
# Last : 2019-06-06
# 
# 

type
  cxTz* = enum
    long,short


# types used in cxtimer
type
    CxTimer* {.packed.} =  object 
            name* : string
            start*: float
            stop  : float
            lap*  : seq[float]
      
     
# type used for cxtimer results
type
    Cxtimerres* = tuple[tname:string,
                        start:float,
                        stop :float,
                        lap  :seq[float]]

    Cxcounter* =  object
            value*: int                        

            
template cxLocal* : string = $now()
     ## cxLocal
     ## 
     ## returns local datetime in a string same as now()
     ## 
     ## Examples for var. cx time,date functions
     ## 
     ## .. code-block:: nim
     ##    printLnBiCol(["cxLocal           : ",cxLocal])
     ##    printLnBiCol(["cxNow             : ",cxNow])  
     ##    printLnBiCol(["cxTime            : ",cxTime]) 
     ##    printLnBiCol(["cxToday           : ",cxToday])
     ##    printLnBiCol(["cxTimeZone(long)  : ",cxTimezone(long)])
     ##    printLnBiCol(["cxTimeZone(short) : ",cxTimezone(short)])
     ##    

     
      
template cxNow* : string = cxLocal.replace("T",spaces(1))
     ## cxnow
     ## 
     ## formated datetime without the T 
     ## 
     ## eg: 2018-08-23 16:48:50+08.00
     ##
     
template cxToday* : string = getDateStr() 
     ## today
     ## 
     ## returns date string
     ## 
     ## eg : 2018-08-23
     ##          
        
template cxTime* : string = getClockStr()
     ## cxTime
     ## 
     ## eg : 16:48:50
     ##     

template cxDateTime* : string = getDateStr() & " " & getClockStr()
     ## cxDateTime           
     ## 
     ## restunrs a date time string
     ## 
     ## eg : 2018-08-23 16:48:50
     ## 

proc cxDuration*(tstart:int|float,tend:int|float):string =
     ## cxDuration
     ## 
     ## expects tstart and tend to be seconds
     ## 
     ##.. code-block:: nim
     ##    
     ##   echo "Duration: " ,cxDuration(epochTime() - 201235.32,epochTime())
     ##   echo "Duration: " ,cxDuration(0,567887)
     ##   
     ##   # output:
     ##   # Duration: 2 days, 7 hours, 53 minutes, and 55 seconds
     ##   # Duration: 6 days, 13 hours, 44 minutes, and 47 seconds
     ##   
     result = $(initduration(seconds = int(tend) - int(tstart)))
    

 
proc cxTimeZone*(amode:cxTz = long):string = 
   ## cxTimeZone
   ##
   ## returns a string with the actual timezone offset in hours as seen from UTC 
   ## 
   ## default long gives results parsed from getLocalTime 
   ## like : UTC +08:00
   ##
  
   case amode 
     of long:
        let ltt = $now()
        result = "UTC" & $ltt[(($ltt).len - 6) ..< ($ltt).len] 
     of short:
        result = cxnow()[19 .. ^1]       
         
     
     
proc toDateTime*(date:string = "2000-01-01"): DateTime =
   ## toDateTime
   ## 
   ## converts a date of format yyyy-mm-dd to DateTime
   ## time part still to be implemented
   ## 
   result = now() # needs to be initialized or we get a warning during compile
   var adate = date.split("-")
   var zyear = parseint(adate[0])
   var enzmonth = parseint(adate[1])
   var zmonth : Month
   case enzmonth 
      of   1: zmonth = mJan
      of   2: zmonth = mFeb
      of   3: zmonth = mMar
      of   4: zmonth = mApr
      of   5: zmonth = mMay
      of   6: zmonth = mJun
      of   7: zmonth = mJul 
      of   8: zmonth = mAug 
      of   9: zmonth = mSep 
      of  10: zmonth = mOct 
      of  11: zmonth = mNov 
      of  12: zmonth = mDec 
      else:
                 
         printLnBiCol("Wrong Month in : " & adate[1],colLeft=red,colRight=yellowgreen,styled={styleReverse})
         quit(0)
   
   let zday = parseint(adate[2])
   result.year = zyear
   result.month = zmonth
   result.monthday = zday
  
   
   
proc epochSecs*(date:string="2000-01-01"):auto =
   ## epochSecs
   ##
   ## converts a date into secs since unix time 0
   ##
   result  =  toUnix(toTime(toDateTime(date)))
   
proc sleepy*[T:float|int](secs:T) =
  ## sleepy
  ##
  ## imitates sleep but in seconds
  ## suitable for shorter sleeps
  ##
  var milsecs = (secs * 1000).int
  sleep(milsecs)

  
  
  
# Var. date and time handling procs mainly to provide convenience for
# date format yyyy-MM-dd handling

proc validDate*(adate:string):bool =
      ## validdate
      ##
      ## try to ensure correct dates of form yyyy-MM-dd
      ##
      ## correct : 2015-08-15
      ##
      ## wrong   : 2015-08-32 , 201508-15, 2015-13-10 etc.
      ##
      let m30 = @["04","06","09","11"]
      let m31 = @["01","03","05","07","08","10","12"]
      let xdate = parseInt(aDate.multiReplace(("-","")))
      # check 1 is our date between 1900 - 3000
      if xdate >= 19000101 and xdate < 30010101:
          let spdate = aDate.split("-")
          if parseInt(spdate[0]) >= 1900 and parseInt(spdate[0]) <= 3001:
              if spdate[1] in m30:
                  #  day max 30
                  if parseInt(spdate[2]) > 0 and parseInt(spdate[2]) < 31:
                    result = true
                  else:
                    result = false

              elif spdate[1] in m31:
                  # day max 31
                  if parseInt(spdate[2]) > 0 and parseInt(spdate[2]) < 32:
                    result = true
                  else:
                    result = false

              else:
                    # so its february
                    if spdate[1] == "02" :
                        # check leapyear
                        if isleapyear(parseInt(spdate[0])) == true:
                            if parseInt(spdate[2]) > 0 and parseInt(spdate[2]) < 30:
                              result = true
                            else:
                              result = false
                        else:
                            if parseInt(spdate[2]) > 0 and parseInt(spdate[2]) < 29:
                              result = true
                            else:
                              result = false


proc day*(aDate:string) : string =
   ## day,month year extracts the relevant part from
   ##
   ## a date string of format yyyy-MM-dd
   ##
   
   try:
     result = aDate.split("-")[2]
   except:
     result = ""

proc month*(aDate:string) : string =
    result = $(parseInt(aDate.split("-")[1]))
    if result.len < 2:
       result = "0" & result
    


proc year*(aDate:string) : string = aDate.split("-")[0]
     ## Format yyyy

          
proc compareDates*(startDate,endDate:string) : int =
     # dates must be in form yyyy-MM-dd
     # we want this to answer
     # s == e   ==> 0    # start s , end  e
     # s >= e   ==> 1
     # s <= e   ==> 2
     # -1 undefined , invalid s date
     # -2 undefined . invalid e and or s date
     if validDate(startDate) and validDate(enddate):
        let std = startDate.multiReplace(("-",""))
        let edd = endDate.multiReplace(("-",""))
        if std == edd: 
          result = 0
        elif std >= edd:
          result = 1
        elif std <= edd:
          result = 2
        else:
          result = -1
     else:
          result = -2




proc fx(nx:DateTime):string =
        result = nx.format("yyyy-MM-dd")


proc plusDays*(aDate:string,days:int):string =
   ## plusDays
   ##
   ## adds days to date string of format yyyy-MM-dd  or result of getDateStr()  or today()
   ##
   ## and returns a string of format yyyy-MM-dd
   ##
   ## the passed in date string must be a valid date or an error message will be returned
   ## 
   ##.. code-block:: nim 
   ##   echo plusDays(cxtoday(),343) 
   ##
   if validDate(aDate) == true:
      var rxs = ""
      let tifo = parse(aDate,"yyyy-MM-dd") # this returns a DateTime type
      let myinterval =  initTimeInterval(days = days)
      rxs = fx(tifo + myinterval)
      result = rxs
   else:
      printLnBiCol("Plusdays : " & adate,colLeft=red,colRight=yellowgreen,styled={styleReverse})
      result = "Error"


proc minusDays*(aDate:string,days:int):string =
   ## minusDays
   ##
   ## subtracts days from a date string of format yyyy-MM-dd  or result of getDateStr() or today()
   ##
   ## and returns a string of format yyyy-MM-dd
   ##
   ## the passed in date string must be a valid date or an error message will be returned
   ##

   if validDate(aDate) == true:
      var rxs = ""
      let tifo = parse(aDate,"yyyy-MM-dd") # this returns a DateTime type
      let myinterval =  initTimeInterval(days = days)
      rxs = fx(tifo - myinterval)
      result = rxs
   else:
      printLnBiCol("MinusDays : " & adate,colLeft=red,colRight=yellowgreen,styled={styleReverse})
      result = "Error"

    

proc createSeqDate*(fromDate:string,toDate:string):seq[string] = 
     ## createSeqDate
     ## 
     ## creates a seq of dates in format yyyy-MM-dd 
     ## 
     ## fromDate and toDate must be a date in form yyyy-MM-dd eg. 2018-06-18
     ## 
     ## 
     ## .. code-block:: nim
     ##   showSeq(createseqdate(cxtoday(), "2022-05-25"),maxitemwidth=12)    
     ##  

     var aresult = newSeq[string]()
     var aDate = fromDate
     while compareDates(aDate,toDate) == 2 : 
         if validDate(aDate) == true: 
            aresult.add(aDate)
         aDate = plusDays(aDate,1)  
     result = aresult    
                     
            
            
proc createSeqDate*(fromDate:string,days:int = 1):seq[string] = 
     ## createSeqDate
     ## 
     ## creates a seq of continous dates in format yyyy-MM-dd 
     ## 
     ## from fromDate to fromDate + days
     ##
     ##.. code-block:: nim 
     ##   showSeq(createseqdate(cxToday, 60),maxitemwidth=12)  
     ##   
     ##   
     var aresult = newSeq[string]()
     var aDate = fromDate
     let toDate = plusDays(adate,days)
     while compareDates(aDate,toDate) == 2 : 
         if validDate(aDate) == true: 
            aresult.add(aDate)
         aDate = plusDays(aDate,1)  
     result = aresult    
         

proc getRndDate*(minyear:int = parseint(year(cxtoday())) - 50,maxyear:int = parseint(year(cxtoday())) + 50):string =  
         ## getRndDate
         ## 
         ## returns a valid rand date between 1900 and 3001 in format 2017-12-31
         ## 
         ## default currently set to  between  +/- 50 years of today
         ## 
         ##.. code-block:: nim
         ##    import nimcx
         ##    loopy2(0,100): echo getRndDate(2016,2025)
         ##    
         ##    
         var okflag = false
         var mminyear = minyear 
         var mmaxyear = maxyear + 1
         if mminyear < 1900: mminyear = 1900
         if mmaxyear > 3001: mmaxyear = 3001
                 
         while okflag == false:
            
             var mmd = $getRndInt(1,13)
             if mmd.len == 1:
                mmd = "0" & $mmd
            
             var ddd = $getRndInt(1,32)
             if ddd.len == 1:
                ddd = "0" & $ddd
            
             let nd = $getRndInt(mminyear,mmaxyear) & "-" & mmd & "-" & ddd
             if validDate(nd) == false:
                 okflag = false
             else : 
                 okflag = true
                 result = nd
  

proc printTimeMsg*(atext:string = cxTime,xpos:int = 1):string {.discardable.} =
     printBiCol("[Time  ]" & spaces(1) & atext , colLeft = lightblue ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})

proc printLnTimeMsg*(atext:string = cxTime,xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Time  ]" & spaces(1) & atext , colLeft = lightblue ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})

proc printDTimeMsg*(atext:string = $toTime(now()),xpos:int = 1):string {.discardable.} =
     printBiCol("[DTime ]" & spaces(1) & atext , colLeft = lightblue ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})

proc printLnDTimeMsg*(atext:string = $toTime(now()),xpos:int = 1):string {.discardable.} =
     printLnBiCol("[DTime ]" & spaces(1) & atext , colLeft = lightblue ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})

proc printDateMsg*(atext:string = getDateStr(),xpos:int = 1):string {.discardable.} =
     printBiCol("[Date  ]" & spaces(1) & atext , colLeft = lightblue ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})     

proc printLnDateMsg*(atext:string = getDateStr(),xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Date  ]" & spaces(1) & atext , colLeft = lightblue ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})
   

   
   
# cxtimer functions

# global used to store all cxtimer results 
var cxtimerresults* =  newSeq[Cxtimerres]()

proc saveTimerResults*(b:ref(CxTimer))  # Forward declaration

proc newCxtimer*(aname:string = "cxtimer"):ref(CxTimer) =
     ## newCxtimer
     ## 
     ## set up a new cxtimer
     ## 
     ## simple timer with starttimer,stoptimer,laptimer,resettimer functionality
     ##
     ## Example 
     ##
     ##.. code-block:: nim
     ##   
     ##  
     ##  var ct  = newCxtimer("TestTimer1")   # create a cxtimer with name TestTimer1
     ##  var ct2 = newCxtimer()               # create a cxtimer which will have default name cxtimer
     ##  ct.startTimer                        # start a timer
     ##  ct2.startTimer
     ##  loopy2(0,2):
     ##     sleepy(1)
     ##     ct2.laptimer                      # take a laptime for a timer
     ##  ct.stopTimer                         # stop a timer
     ##  ct2.stopTimer
     ##  saveTimerResults(ct)                 # save current state of a timer
     ##  saveTimerResults(ct2)
     ##  echo()
     ##  showTimerResults()                   # display status of all timers
     ##  ct2.resetTimer                       # reset a particular timer 
     ##  clearTimerResults()                  # clear timer result of default timer
     ##  clearTimerResults("TestTimer1")      # clear timer results of a particular timer
     ##  clearAllTimerResults()               # clear all timer results
     ##  showTimerResults()
     ##  dprint cxtimerresults                # dprint is a simple repr utility
     ## 
     ## 
     
     var aresult = (ref(CxTimer))(name:aname)
     aresult.start = 0
     aresult.stop = 0
     aresult.lap = @[]
     result = aresult
 
 
 
proc resetTimer*(co: ref(CxTimer)) = 
      co.start = 0.0
      co.stop = 0.0
      co.lap = @[] 
       
proc startTimer*(co:ref(CxTimer)) = co.start = epochTime()

proc lapTimer*(co:ref(CxTimer)):auto {.discardable.}  =
               var tdf = epochTime() - co.start
               co.lap.add(tdf)
               result = tdf
               
proc stopTimer*(co: ref(CxTimer))  = 
                co.stop = epochTime()
                saveTimerResults(co)
                resettimer(co)
                

proc duration*(co:ref(CxTimer)):float {.discardable.} = co.stop - co.start       

proc saveTimerResults*(b:ref(CxTimer)) =
     ## saveTimerResults
     ## 
     ## saves the current state of a cxtimer
     ## 
     var bb:Cxtimerres
     var c = b
     if  b.name == "": c.name = "cxtimer"   # give it a default name
     bb.tname = c.name
     bb.start = c.start
     bb.stop = c.stop
     bb.lap = c.lap
     cxtimerresults.add(bb)

proc showTimerResults*(aname:string) =  
     ## showTimerResults  
     ## 
     ## shows results for a particular timer name
     ## 
     var bname = aname
     if bname == "": bname = "cxtimer"    # if no name given we assume defaultname cxtimer 
     echo()
     loopy2(0,cxtimerresults.len - 1):
       var b = cxtimerresults[xloopy]
       if b.tname == bname:
          printLnBiCol("Timer    : " & $(b.tname))
          printLnBiCol("Start    : " & $fromUnix(int(b.start)))
          printLnBiCol("Stop     : " & $fromUnix(int(b.stop)))
          printLnBiCol("Laptimes : ")
          if b.lap.len > 0:
             loopy2(0,b.lap.len):
                if strutils.strip(($b.lap[xloopy])) <> "":
                    printLnBiCol(fmtx([">7","",""],$(xloopy + 1), " : " , $b.lap[xloopy]),xpos = 8)
                else:
                    curup(1)
                    printLnBiCol(fmtx(["","",""],"", " : " , "none recorded"),xpos = 8)    
             echo()
          else:
              curup(1)
              printLnBiCol(fmtx(["","",""],"", " : " , "none recorded"),xpos = 8)
          printLnBiCol("Duration : " & $(b.stop - b.start) & " secs.")   
               
             
               
proc showTimerResults*() =  
     ## showTimerResults  
     ## 
     ## shows results for all timers
     ## 
     echo()
     loopy2(0,cxtimerresults.len - 1):
       var b = cxtimerresults[xloopy]
       echo()
       printLnBiCol("Timer    : " & $(b.tname))
       printLnBiCol("Start    : " & $fromUnix(int(b.start)))
       printLnBiCol("Stop     : " & $fromUnix(int(b.stop)))
       printLnBiCol("Laptimes : ")
       if b.lap.len > 0:
             loopy2(0,b.lap.len):
                if strutils.strip(($b.lap[xloopy])) <> "":
                    printLnBiCol(fmtx([">7","",""],$(xloopy + 1), " : " , $b.lap[xloopy]),xpos = 8)
                else: # maybe not needed
                    curup(1)
                    printLnBiCol(fmtx(["","",""],"", " : " , "none recorded"),xpos = 8)    
             echo()
       else:
              curup(1)
              printLnBiCol(fmtx(["","",""],"", " : " , "none recorded"),xpos = 8)
       printLnBiCol("Duration : " & $(b.stop - b.start) & " secs.")
       echo()
       
proc clearTimerResults*(aname:string = "",quiet:bool = true,xpos:int = 3) =
     ## clearTimerResults
     ## 
     ## clears cxtimerresults of one named timer or if aname == "" of timer cxtimer
     ## 
     ##  
     var bname = aname
     if bname == "": bname = "cxtimer"    # if no name given we assume defaultname cxtimer 
     loopy2(0,cxtimerresults.len):
        if cxtimerresults[xloopy].tname == bname:
               if quiet == false:
                  echo()
                  print("Timer deleted : " ,goldenrod,xpos = xpos)
                  printLn(cxtimerresults[xloopy].tname ,tomato)
                  echo()
               cxtimerresults.delete(xloopy)  
        else:
               discard
       
proc clearAllTimerResults*(quiet:bool = true,xpos:int = 3) =
     ## clearAllTimerResults
     ## 
     ## clears cxtimerresults for all timers , set quiet to false to show feedback
     ## 
     ##  
     cxtimerresults = @[] 
     echo()
     if quiet == false:
          cxprint(xpos,white,yellowgreenbg,"Info   : ",pastelWhite,"Alltimers deleted")
   
   
   
# end of module cxtime.nim   
