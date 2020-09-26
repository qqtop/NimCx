import os,terminal,times,strutils,sequtils,random
import cxconsts

## ::
## 
##     Library     : nimcx.nim
##     
##     Module      : cxtime.nim
##
##     Status      : stable
##
##     License     : MIT opensource
##   
##     Latest      : 2020-09-26 
##
##     Compiler    : latest stable or devel branch
##
##     OS          : Linux
##
##     Description : provides most time related functions for the library
##              
## 


{.hint: " \x1b[38;2;154;205;50m ╭──────────────────────── NIMCX ─────────────────────────────────────╮ " .}
    
{.hint: " \x1b[38;2;154;205;50m \u2691  NimCx     " & "\x1b[38;2;255;215;0m Officially made for Linux only." & 
                spaces(23) & "\x1b[38;2;154;205;50m \u2691 ".}
                
{.hint: "\x1b[38;2;154;205;50m \u2691  Compiling " &
        "\x1b[38;2;255;100;0m cxtime.nim \xE2\x9A\xAB" &
        " " & "\xE2\x9A\xAB" & spaces(38) & "\x1b[38;2;154;205;50m \u2691 ".}
         
{.hint: "\x1b[38;2;154;205;50m ╰──────────────────────── CXTIME ────────────────────────────────────╯ " .}


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

randomize()

template cxprint(xpos:int,args:varargs[untyped]) =
    setCursorXPos(xpos)
    stdout.styledWrite(args)  
    
       
template cxprintLn(xpos:int, args: varargs[untyped]) =
    setCursorXPos(xpos)
    styledEcho(args)

                
template cxLocal*() : untyped = $now()
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

     
      
template cxNow*() : untyped = ($now()).replace("T",spaces(1))
     ## cxnow
     ## 
     ## formated datetime without the T 
     ## 
     ## eg: 2018-08-23 16:48:50+08.00
     ##
     
template cxToday* : untyped = getDateStr() 
     ## today
     ## 
     ## returns date string
     ## 
     ## eg : 2018-08-23
     ##          
        
template cxTime* : untyped = getClockStr()
     ## cxTime
     ## 
     ## eg : 16:48:50
     ##     

template loopy2(mi: int = 0, ma: int = 5, st: untyped) =
         for xloopy {.inject.} in mi ..< ma: st


template cxDateTime* : untyped = getDateStr() & " " & getClockStr()
     ## cxDateTime           
     ## 
     ## returns a date time string
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
      cxprintln(1,red,styleReverse,"Plusdays : ",yellowgreen,adate)
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
      cxprintln(1,red,styleReverse,"MinusDays : ",yellowgreen,adate)
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
            
             var mmd = $sample(toSeq(1..12))
             if mmd.len == 1:
                mmd = "0" & $mmd
            
             var ddd = $sample(toSeq(1..31))
             if ddd.len == 1:
                ddd = "0" & $ddd
            
             let nd = $sample(toSeq(mminyear..mmaxyear)) & "-" & mmd & "-" & ddd
             if validDate(nd) == false:
                 okflag = false
             else : 
                 okflag = true
                 result = nd
  

proc printTimeMsg*(atext:string = cxTime,xpos:int = 1):string {.discardable.} =
     cxprint(xpos,gold,darkslategraybg,"[Time  ]",lightgrey,spaces(1),atext)

proc printLnTimeMsg*(atext:string = cxTime,xpos:int = 1):string {.discardable.} =
     cxprintLn(xpos,gold,darkslategraybg,"[Time  ]",lightgrey,spaces(1),atext) 

proc printDTimeMsg*(atext:string = $toTime(now()),xpos:int = 1):string {.discardable.} =
     cxprint(xpos,gold,darkslategraybg,"[DTime ]",lightgrey,spaces(1),atext)

proc printLnDTimeMsg*(atext:string = $toTime(now()),xpos:int = 1):string {.discardable.} =
     cxprintLn(xpos,orange,darkslategraybg,"[DTime ]",lightgrey,spaces(1),atext)  

proc printDateMsg*(atext:string = getDateStr(),xpos:int = 1):string {.discardable.} =
     cxprint(xpos,gold,darkslategraybg,"[Date  ]",lightgrey,spaces(1),atext)
  
proc printLnDateMsg*(atext:string = getDateStr(),xpos:int = 1):string {.discardable.} =
     cxprintLn(xpos,gold,darkslategraybg,"[Date  ]",lightgrey,spaces(1),atext)
  
   
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
          cxprintLn(1,yellowgreen,"Timer    : " ,lightgrey, $(b.tname))
          cxprintLn(1,yellowgreen,"Start    : " ,lightgrey, $fromUnix(int(b.start)))
          cxprintLn(1,"Stop     : " ,lightgrey, $fromUnix(int(b.stop)))
          cxprintLn(1,yellowgreen,"Laptimes : ")
          if b.lap.len > 0:
             loopy2(0,b.lap.len):
                if strutils.strip(($b.lap[xloopy])) isNot "":
                    #cxprintLn(8,fmtx([">7","",""],$(xloopy + 1), " : " , $b.lap[xloopy]))
                    cxprintLn(8,$(xloopy + 1), " : " , $b.lap[xloopy])
                else:
                    cursorup(1)
                    cxprintLn(8,"none recorded")
                      
             echo()
          else:
              cursorup(1)
              cxprintLn(8,"none recorded")
          cxprintLn(1,yellowgreen,"Duration : " ,lightgrey, $(b.stop - b.start) & " secs.")   
                        
               
proc showTimerResults*() =  
     ## showTimerResults  
     ## 
     ## shows results for all timers
     ## 
     echo()
     loopy2(0,cxtimerresults.len - 1):
       var b = cxtimerresults[xloopy]
       echo()
       cxprintLn(1,yellowgreen,"Timer    : " ,lightgrey, $(b.tname))
       cxprintLn(1,yellowgreen,"Start    : " ,lightgrey, $fromUnix(int(b.start)))
       cxprintLn(1,"Stop     : " ,lightgrey, $fromUnix(int(b.stop)))
       cxprintLn(1,yellowgreen,"Laptimes : ")
       if b.lap.len > 0:
             loopy2(0,b.lap.len):
                if strutils.strip(($b.lap[xloopy])) isNot "":
                    #printLnBiCol(fmtx([">7","",""],$(xloopy + 1), " : " , $b.lap[xloopy]),xpos = 8)
                    cxprintLn(8,$(xloopy + 1), " : " , $b.lap[xloopy])
                else: # maybe not needed
                    cursorup(1)
                    cxprintLn(8, "none recorded")   
             echo()
       else:
              cursorup(1)
              cxprintLn(8,"none recorded")
       cxprintLn(1,yellowgreen,"Duration : " ,lightgrey, $(b.stop - b.start) & " secs.")
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
                  cxprintLn(xpos,goldenrod,"Timer deleted : " ,tomato,cxtimerresults[xloopy].tname)
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
   
   
proc cxHRTimer*(tstart:Time = getTime() ,tend:Time = getTime()):auto = 
   ## cxHRTimer
   ##
   ## Example
   ##
   ##.. code-block:: nim
   ##   let currenttime = getTime() 
   ##   sleep(2000)
   ##   let later = gettime()
   ##   echo cxHRTimer(currentime,later)  
   ##
   ##
   result = initDuration(seconds=tend.toUnix(), nanoseconds=tend.nanosecond) - initDuration(seconds=tstart.toUnix(), nanoseconds=tstart.nanosecond)

    
proc cxDayOfWeek*(datestr:string):string = 
    ## cxDayOfWeek
    ## 
    ## returns day of week from a date in format yyyy-MM-dd
    ## 
    ##.. code-block:: nim    
    ##    echo cxDayOfWeek(cxtoday())
    ##    echo getNextMonday("2017-07-15"),"  ",cxDayOfWeek(getNextMonday("2017-07-15"))

    if datestr.len==10:
       result = $(getDayOfWeek(parseInt(day(datestr)),parseInt(month(datestr)).Month,parseInt(year(datestr))))      
    else:
       cxprintln(5,white,bgred,"Invalid date received . Required format is yyyy-MM-dd. --> cxUtils : cxDayOfWeek")
       result=""
       

proc getNextMonday*(adate:string):string =
    ## getNextMonday
    ##
    ##.. code-block:: nim
    ##    echo  getNextMonday(getDateStr())
    ##
    ##
    ##.. code-block:: nim
    ##      import nimcx
    ##      # get next 10 mondays
    ##      var dw = getdatestr()
    ##      echo dw
    ##      for x in 1..10:
    ##         dw = getnextmonday(dw)
    ##         echo dw
    ##         dw = plusDays(dw,1)
    ##
        
    var ndatestr = ""
    if adate == "" :
        cxprintln(2,black,redbg,"Received an invalid date.")
    else:
        if validdate(adate) == true:
            var z = cxdayofweek(adate)
            if z == "Monday":
                # so the datestr points to a monday we need to add a
                # day to get the next one calculated
                ndatestr = plusDays(adate,1)
            ndatestr = adate
            for x in 0..<7:
                if validdate(ndatestr) == true:
                    z =  cxDayOfWeek(ndatestr)
                if strutils.strip(z) != "Monday":
                    ndatestr = plusDays(ndatestr,1)
                else:
                    result = ndatestr
  

proc getAmzDateString*():string =
    ## getAmzDateString
    ## 
    ## get current GMT date time in amazon format  
    ## 
    return format(utc(getTime()), iso_8601_aws) 
    
  
## iso week number
## borrowed from https://gist.github.com/pietroppeter/e6afa43318b202ef2a2a32e0fd3844bf
## see https://en.wikipedia.org/wiki/ISO_week_date#Calculating_the_week_number_of_a_given_date

type
  WeekRange = range[1 .. 53]

proc lastWeek(year: int): WeekRange =
  ## The long years, with 53 weeks in them, can be described as any year starting on Thursday and any leap year starting on Wednesday
  let firstWeekDay = initDateTime(1.MonthDayRange, mJan, year, 0, 0, 0).weekday
  if firstWeekDay == dThu or (year.isLeapYear and firstWeekDay == dWed):
    53
  else:
    52

proc isoweek*(dt: DateTime): WeekRange =
  ## returns isoweek for a given date
  let
    od = getDayOfYear(dt.monthday, dt.month, dt.year) + 1  # ordinal date
    week = (od - dt.weekday.ord + 9) div 7
  if week < 1:
    lastWeek(dt.year - 1)
  elif week > lastWeek(dt.year):
    1
  else:
    week  
  
    
when isMainModule:
    echo()
    cxprintLn(0,"Display some usage of cxtime functions")
    let currenttime = getTime() 
    cxprintLn(1,"cxLocal           : ",cxLocal)
    cxprintLn(1,"cxNow             : ",cxNow) 
    let idt = isDst(now())
    cxprintLn(1,"DST Time          : ",$idt)
    cxprintLn(1,"cxTime            : ",cxTime) 
    cxprintLn(1,"cxToday           : ",cxToday)
    cxprintLn(1,"cxTimeZone(long)  : ",cxTimezone(long))
    cxprintLn(1,"cxTimeZone(short) : ",cxTimezone(short))
    cxprintLn(1,"Date in 20 days   : ",plusDays(cxtoday(),20),yellowgreen)
    cxprintLn(1,"Date 20 days ago  : ",minusDays(cxtoday(),20),yellowgreen)
    assert plusDays(minusDays(cxtoday(),20),20) == cxtoday() 
    cxprintLn(1,"Running Time      : ",$cxHRTimer(currenttime,getTime()))
    cxprintLn(1,"Next Monday       : ",getNextMonday(cxtoday())," = ",cxDayOfWeek(getNextMonday(cxtoday())))
    printLnDTimeMsg()  # datetime message
    doAssert initDateTime(23, mDec, 2019, 0, 0, 0).isoweek == 52
    doAssert initDateTime(30, mDec, 2019, 0, 0, 0).isoweek == 1
    doAssert initDateTime(2, mFeb, 2020, 0, 0, 0).isoweek == 5
    doAssert initDateTime(3, mFeb, 2020, 0, 0, 0).isoweek == 6
    cxprintLn(1,"Current Isoweek   : ", $now().isoweek)
    echo()
      

      
# end of module cxtime.nim   
