{.deadCodeElim: on , optimization: speed.}
#  {.noforward: on.}   # future feature
## ::
##     Library     : nimcx.nim
##     
##     Module      : cxutils.nim
##
##     Status      : stable
##
##     License     : MIT opensource
##
##     Version     : 0.9.9
##
##     ProjectStart: 2015-06-20
##   
##     Latest      : 2017-09-30
##
##     Compiler    : Nim >= 0.17.x dev branch
##
##     OS          : Linux
##
##     Description :
##
##                   cxutils.nim is a collection of lesser used simple utility procs and templates
##
##                   moved here to avoid code bloat in cx.nim  it is imported with nimcx
##
##
##     Usage       : import nimcx
##
##     Project     : https://github.com/qqtop/NimCx
##
##     Docs        : https://qqtop.github.io/cxutils.html   
##
##     Tested      : OpenSuse Tumbleweed 
##  

import os,osproc,cx,math,stats,cpuinfo,httpclient,browsers
 
# some handmade font...
let a1 = "  ██   "
let a2 = " ██ █  "
let a3 = "██   █ "
let a4 = "██ █ █ "
let a5 = "██   █ "


let b1 = "███ █  "
let b2 = "██   █ "
let b3 = "███ █  "
let b4 = "██   █ "
let b5 = "███ █  "


let c1 = " █████ "
let c2 = "██     "
let c3 = "██     "
let c4 = "██     "
let c5 = " █████ "


let d1 = "███ █  "
let d2 = "██   █ "
let d3 = "██   █ "
let d4 = "██   █ "
let d5 = "███ █  "


let e1 = "█████  "
let e2 = "██     "
let e3 = "████   "
let e4 = "██     "
let e5 = "█████  "


let f1 = "█████  "
let f2 = "██     "
let f3 = "████   "
let f4 = "██     "
let f5 = "██     "


let g1 = " ████  "
let g2 = "██     "
let g3 = "██  ██ "
let g4 = "██   █ "
let g5 = " ████  "


let h1 = "██   █ "
let h2 = "██   █ "
let h3 = "██████ "
let h4 = "██   █ "
let h5 = "██   █ "


let i1 = "  ██   "
let i2 = "  ██   "
let i3 = "  ██   "
let i4 = "  ██   "
let i5 = "  ██   "


let j1 = "    ██ "
let j2 = "    ██ "
let j3 = "    ██ "
let j4 = " █  ██ "
let j5 = "  ██   "


let k1 = "██   █ "
let k2 = "██  █  "
let k3 = "██ █   "
let k4 = "██  █  "
let k5 = "██   █ "


let l1 = "██     "
let l2 = "██     "
let l3 = "██     "
let l4 = "██     "
let l5 = "██████ "


let m1 = "███ ██ "
let m2 = "██ █ █ "
let m3 = "██ █ █ "
let m4 = "██   █ "
let m5 = "██   █ "


let n1 = "██   █ "
let n2 = "███  █ "
let n3 = "██ █ █ "
let n4 = "██  ██ "
let n5 = "██   █ "


let o1 = " ████  "
let o2 = "██   █ "
let o3 = "██   █ "
let o4 = "██   █ "
let o5 = " ████  "


let p1 = "██ ██  "
let p2 = "██   █ "
let p3 = "██ ██  "
let p4 = "██     "
let p5 = "██     "


let q1 = " ████  "
let q2 = "██   █ "
let q3 = "██   █ "
let q4 = "██ █ █ "
let q5 = " ██ █  "


let r1 = "███ █  "
let r2 = "██   █ "
let r3 = "███ █  "
let r4 = "██   █ "
let r5 = "██   █ "


let s1 = "  █ ██ "
let s2 = " █     "
let s3 = "   █   "
let s4 = "     █ "
let s5 = " ██ █  "


let t1 = "██████ "
let t2 = "  ██   "
let t3 = "  ██   "
let t4 = "  ██   "
let t5 = "  ██   "


let u1 = "██   █ "
let u2 = "██   █ "
let u3 = "██   █ "
let u4 = "██   █ "
let u5 = "██████ "


let v1 = "██   █ "
let v2 = "██   █ "
let v3 = "██   █ "
let v4 = " █  █  "
let v5 = "  ██   "


let w1 = "██   █ "
let w2 = "██   █ "
let w3 = "██ █ █ "
let w4 = " █ █ █ "
let w5 = "  █ █  "


let x1 = "██   █ "
let x2 = "  █ █  "
let x3 = "   █   "
let x4 = "  █ █  "
let x5 = "██   █ "


let y1 = "██   █ "
let y2 = "  █ █  "
let y3 = "   █   "
let y4 = "   █   "
let y5 = "   █   "



let z1 = "██████ "
let z2 = "    █  "
let z3 = "   █   "
let z4 = " █     "
let z5 = "██████ "


let hy1= "       "
let hy2= "       "
let hy3= " █████ "
let hy4= "       "
let hy5= "       "


let pl1= "       "
let pl2= "   █   "
let pl3= " █████ "
let pl4= "   █   "
let pl5= "       "


let ul1 = "      "
let ul2 = "      "
let ul3 = "      "
let ul4 = "      "
let ul5 = "██████"


let el1 = "      "
let el2 = "██████"
let el3 = "      "

let el4 = "██████"
let el5 = "      "


let clb1 = spaces(6)
let clb2 = spaces(6)
let clb3 = spaces(6)
let clb4 = spaces(6)
let clb5 = spaces(6)


let abx* = @[a1,a2,a3,a4,a5]
let bbx* = @[b1,b2,b3,b4,b5]
let cbx* = @[c1,c2,c3,c4,c5]
let dbx* = @[d1,d2,d3,d4,d5]
let ebx* = @[e1,e2,e3,e4,e5]
let fbx* = @[f1,f2,f3,f4,f5]
let gbx* = @[g1,g2,g3,g4,g5]
let hbx* = @[h1,h2,h3,h4,h5]
let ibx* = @[i1,i2,i3,i4,i5]
let jbx* = @[j1,j2,j3,j4,j5]
let kbx* = @[k1,k2,k3,k4,k5]
let lbx* = @[l1,l2,l3,l4,l5]
let mbx* = @[m1,m2,m3,m4,m5]
let nbx* = @[n1,n2,n3,n4,n5]
let obx* = @[o1,o2,o3,o4,o5]
let pbx* = @[p1,p2,p3,p4,p5]
let qbx* = @[q1,q2,q3,q4,q5]
let rbx* = @[r1,r2,r3,r4,r5]
let sbx* = @[s1,s2,s3,s4,s5]
let tbx* = @[t1,t2,t3,t4,t5]
let ubx* = @[u1,u2,u3,u4,u5]
let vbx* = @[v1,v2,v3,v4,v5]
let wbx* = @[w1,w2,w3,w4,w5]
let xbx* = @[x1,x2,x3,x4,x5]
let ybx* = @[y1,y2,y3,y4,y5]
let zbx* = @[z1,z2,z3,z4,z5]

let hybx* = @[hy1,hy2,hy3,hy4,hy5]
let plbx* = @[pl1,pl2,pl3,pl4,pl5]
let ulbx* = @[ul1,ul2,ul3,ul4,ul5]
let elbx* = @[el1,el2,el3,el4,el5]

let clbx* = @[clb1,clb2,clb3,clb4,clb5]

let bigLetters* = @[abx,bbx,cbx,dbx,ebx,fbx,gbx,hbx,ibx,jbx,kbx,lbx,mbx,nbx,obx,pbx,qbx,rbx,sbx,tbx,ubx,vbx,wbx,xbx,ybx,zbx,hybx,plbx,ulbx,elbx,clbx]

# a big block number set which can be used with printBigNumber
# for the newer experimental block font see printfont() in cx.nim

const number0 =
 @["██████"
  ,"██  ██"
  ,"██  ██"
  ,"██  ██"
  ,"██████"]

const number1 =
 @["    ██"
  ,"    ██"
  ,"    ██"
  ,"    ██"
  ,"    ██"]

const number2 =
 @["██████"
  ,"    ██"
  ,"██████"
  ,"██    "
  ,"██████"]

const number3 =
 @["██████"
  ,"    ██"
  ,"██████"
  ,"    ██"
  ,"██████"]

const number4 =
 @["██  ██"
  ,"██  ██"
  ,"██████"
  ,"    ██"
  ,"    ██"]

const number5 =
 @["██████"
  ,"██    "
  ,"██████"
  ,"    ██"
  ,"██████"]

const number6 =
 @["██████"
  ,"██    "
  ,"██████"
  ,"██  ██"
  ,"██████"]

const number7 =
 @["██████"
  ,"    ██"
  ,"    ██"
  ,"    ██"
  ,"    ██"]

const number8 =
 @["██████"
  ,"██  ██"
  ,"██████"
  ,"██  ██"
  ,"██████"]

const number9 =
 @["██████"
  ,"██  ██"
  ,"██████"
  ,"    ██"
  ,"██████"]

const colon =
 @["      "
  ,"  ██  "
  ,"      "
  ,"  ██  "
  ,"      "]

const plussign =
 @["      "
  ,"  ██  "
  ,"██████"
  ,"  ██  "
  ,"      "]

const equalsign =
 @["      "
  ,"██████"
  ,"      "
  ,"██████"
  ,"      "]
 
const minussign =
 @["      "
  ,"      "
  ,"██████"
  ,"      "
  ,"      "] 
 
const clrb =
 @["      "
  ,"      "
  ,"      "
  ,"      "
  ,"      "]
  
  
const bigdot =
 @["      "
  ,"      "
  ,"      "
  ,"      "
  ,"  ██  "]


const numberlen = 4

# big NIM in block letters
# see printNimSxR for how to print this sets and similar one you make up

let NIMX1 = "██     █    ██    ███   ██"
let NIMX2 = "██ █   █    ██    ██ █ █ █"
let NIMX3 = "██  █  █    ██    ██  █  █"
let NIMX4 = "██   █ █    ██    ██  █  █"
let NIMX5 = "██     █    ██    ██     █"

let nimsx* = @[NIMX1,NIMX2,NIMX3,NIMX4,NIMX5]


let NIMX6  = "███   ██  ██  ██     █  ██"
let NIMX7  = "██ █ █ █  ██  ██ █   █  ██"
let NIMX8  = "██  █  █  ██  ██  █  █  ██"
let NIMX9  = "██  █  █  ██  ██   █ █  ██"
let NIMX10 = "██     █  ██  ██     █  ██"

let nimsx2* = @[NIMX6,NIMX7,NIMX8,NIMX9,NIMX10]


proc fibonacci*(n: int):float =  
    ## fibonacci
    ## 
    ## calculate fibonacci values
    ##
    ## .. code-block:: nim
    ## 
    ##    for x in 0.. 20: quickList(x,fibonacci(x))
    ## 
    if n < 2: 
       result = float(n)
    else: 
       result = fibonacci(n-1) + fibonacci(n-2)

proc memCheck*(stats:bool = false) =
  ## memCheck
  ## 
  ## memCheck shows memory before and after a GC_FullCollect run
  ## 
  ## set stats to true for full GC_getStatistics
  ## 
  echo()
  printLn("MemCheck            ",yellowgreen,styled = {styleUnderscore},substr = "MemCheck            ")
  echo()
  printLnBiCol("Status    : Current ",colLeft=salmon)
  printLn(yellowgreen & "Mem " &  lightsteelblue & "Used  : " & white & ff2(getOccupiedMem()) & lightsteelblue & "  Free : " & white & ff2(getFreeMem()) & lightsteelblue & "  Total : " & white & ff2(getTotalMem() ))
  if stats == true:
    echo GC_getStatistics()
  GC_fullCollect()
  sleepy(0.5)
  printLnBiCol("Status    : GC_FullCollect executed",colLeft=salmon,colRight=pink)
  printLn(yellowgreen & "Mem " &  lightsteelblue & "Used  : " & white & ff2(getOccupiedMem()) & lightsteelblue & "  Free : " & white & ff2(getFreeMem()) & lightsteelblue & "  Total : " & white & ff2(getTotalMem() ))
  if stats == true:
     echo GC_getStatistics()


proc showCpuCores*() =
  ## showCpuCores
  ## 
  printLnBiCol("System CPU cores : " & $cpuInfo.countProcessors())
   

proc getRandomPointInCircle*(radius:float) : seq[float] =
    ## getRandomPointInCircle
    ##
    ## based on answers found in
    ##
    ## http://stackoverflow.com/questions/5837572/generate-a-random-point-within-a-circle-uniformly
    ##
    ##
    ##
    ## .. code-block:: nim
    ##    import nimcx,math,strfmt
    ##    # get randompoints in a circle
    ##    var crad:float = 1
    ##    for x in 0.. 100:
    ##       var k = getRandomPointInCircle(crad)
    ##       assert k[0] <= crad and k[1] <= crad
    ##       printLnBiCol(fmtx([">25","<6",">25"],ff2(k[0])," :",ff2(k[1])))
    ##    doFinish()
    ##
    ##

    let t = 2 * math.Pi * getRandomFloat()
    let u = getRandomFloat() + getRandomFloat()
    var r = 0.00
    if u > 1 :
      r = 2-u
    else:
      r = u
    var z = newSeq[float]()
    z.add(radius * r * math.cos(t))
    z.add(radius * r * math.sin(t))
    return z



proc getRandomPoint*(minx:float = -500.0,maxx:float = 500.0,miny:float = -500.0,maxy:float = 500.0) : RpointFloat =
    ## getRandomPoint
    ##
    ## generate a random x,y float point pair and return it as RpointFloat
    ## 
    ## minx  min x  value
    ## maxx  max x  value
    ## miny  min y  value
    ## maxy  max y  value
    ##
    ## .. code-block:: nim
    ##    for x in 0.. 10:
    ##    var n = getRandomPoint(-500.00,200.0,-100.0,300.00)
    ##    printLnBiCol(fmtx([">4",">5","",">6",">5"],"x:",$n.x,spaces(7),"y:",$n.y),spaces(7))
    ## 

    var point : RpointFloat
    var rx:    float
    var ry:    float
      
      
    if minx < 0.0:   rx = minx - 1.0 
    else        :    rx = minx + 1.0  
    if maxy < 0.0:   rx = maxx - 1.0 
    else        :    rx = maxx + 1.0 
        
    if miny < 0.0:   ry = miny - 1.0 
    else        :    ry = miny + 1.0  
    if maxy < 0.0:   ry = maxy - 1.0 
    else        :    ry = maxy + 1.0         
        
    var mpl = abs(maxx) * 1000     
    
    while rx < minx or rx > maxx:
       rx =  getRandomSignF() * mpl * getRandomFloat()  
       
    mpl = abs(maxy) * 1000   
    while ry < miny or ry > maxy:  
          ry =  getRandomSignF() * mpl * getRandomFloat()
        
    point.x = rx
    point.y = ry  
    result =  point
      
  
proc getRandomPoint*(minx:int = -500 ,maxx:int = 500 ,miny:int = -500 ,maxy:int = 500 ) : RpointInt =
    ## getRandomPoint 
    ##
    ## generate a random x,y int point pair and return it as RpointInt
    ## 
    ## min    x or y value
    ## max    x or y value
    ##
    ## .. code-block:: nim
    ##    for x in 0.. 10:
    ##    var n = getRandomPoint(-500,500,-500,200)
    ##    printLnBiCol(fmtx([">4",">5","",">6",">5"],"x:",$n.x,spaces(7),"y:",$n.y),spaces(7))
    ## 
  
    var point : RpointInt
        
    point.x =  getRandomSignI() * getRndInt(minx,maxx) 
    point.y =  getRandomSignI() * getRndInt(miny,maxy)  
    result =  point


template getCard* :auto =
    ## getCard
    ##
    ## gets a random card from the Cards seq
    ##
    ## .. code-block:: nim
    ##    import nimcx
    ##    print(getCard(),randCol(),xpos = centerX())  # get card and print in random color at xpos
    ##    doFinish()
    ##
    cards[rndSample(rxCards)]

proc showRandomCard*(xpos:int = centerX()) = 
    ## showRandomCard
    ##
    ## shows a random card at xpos , default is centered
    ##
    print(getCard(),randCol(),xpos = xpos)


proc showRuler* (xpos:int=0,xposE:int=0,ypos:int = 0,fgr:string = termwhite,bgr:string = termblack , vert:bool = false) =
     ## ruler
     ##
     ## simple terminal ruler indicating dot x positions to give a feedback
     ##
     ## available for horizontal --> vert = false
     ##           for vertical   --> vert = true
     ##
     ## see cxDemo and cxTest for more usage examples
     ##
     ## .. code-block::nim
     ##   # this will show a full terminal width ruler
     ##   ruler(fgr=pastelblue)
     ##   decho(3)
     ##   # this will show a specified position only
     ##   ruler(xpos =22,xposE = 55,fgr=pastelgreen)
     ##   decho(3)
     ##   # this will show a full terminal width ruler starting at a certain position
     ##   ruler(xpos = 75,fgr=pastelblue)
     echo()
     var fflag:bool = false
     var npos  = xpos
     var nposE = xposE
     if xpos ==  0: npos  = 1
     if xposE == 0: nposE = tw - 1

     if vert == false :  # horizontalruler

          for x in npos.. nposE:

            if x == 1:
                curup(1)
                print(".",lime,bgr,xpos = 1)
                curdn(1)
                print(x,fgr,bgr,xpos = 1)
                curup(1)
                fflag = true

            elif x mod 5 > 0 and fflag == false:
                curup(1)
                print(".",goldenrod,bgr,xpos = x)
                curdn(1)

            elif x mod 5 == 0:
                if fflag == false:
                  curup(1)
                print(".",lime,bgr,xpos = x)
                curdn(1)
                print(x,fgr,bgr,xpos = x)
                curup(1)
                fflag = true

            else:
                fflag = true
                print(".",truetomato,bgr,xpos = x)


     else : # vertical ruler

            if  ypos >= th : curset()
            else: curup(ypos + 2)

            for x in 0.. ypos:
                  if x == 0: printLn(".",lime,bgr,xpos = xpos + 3)
                  elif x mod 2 == 0:
                         print(x,fgr,bgr,xpos = xpos)
                         printLn(".",fgr,bgr,xpos = xpos + 3)
                  else: printLn(".",truetomato,bgr,xpos = xpos + 3)
     decho(3)



proc centerMark*(showpos :bool = false) =
     ## centerMark
     ##
     ## draws a red dot in the middle of the screen xpos only
     ## and also can show pos
     ##
     centerPos(".")
     print(".",truetomato)
     if showpos == true:  print "x" & $(tw/2)


proc superHeaderA*(bb:string = "",strcol:string = white,frmcol:string = green,anim:bool = true,animcount:int = 1) =
      ## superHeaderA
      ##
      ## attempt of an animated superheader , some defaults are given
      ##
      ## parameters for animated superheaderA :
      ##
      ## headerstring, txt color, frame color, left/right animation : true/false ,animcount
      ##
      ## Example :
      ##
      ## .. code-block:: nim
      ##    import nimcx
      ##    cleanScreen()
      ##    let bb = "NIM the system language for the future, which extends to as far as you need !!"
      ##    superHeaderA(bb,white,red,true,1)
      ##    clearup(3)
      ##    superheader("Ok That's it for Now !",salmon,yellowgreen)
      ##    doFinish()

      for am in 0..<animcount:
          for x in 0..<1:
            cleanScreen()
            for zz in 0.. bb.len:
                  cleanScreen()
                  superheader($bb[0.. zz],strcol,frmcol)
                  sleep(500)
                  curup(80)
            if anim == true:
                for zz in countdown(bb.len,-1,1):
                      superheader($bb[0.. zz],strcol,frmcol)
                      sleep(100)
                      cleanScreen()
            else:
                cleanScreen()
            sleep(500)

      echo()

# Unicode random word creators

proc newWordCJK*(minwl:int = 3 ,maxwl:int = 10):string =
      ## newWordCJK
      ##
      ## creates a new random string consisting of n chars default = max 10
      ##
      ## with chars from the cjk unicode set
      ##
      ## http://unicode-table.com/en/#cjk-unified-ideographs
      ##
      ## requires unicode
      ##
      ## .. code-block:: nim
      ##    # create a string of chinese or CJK chars
      ##    # with max length 20 and show it in green
      ##    msgg() do : echo newWordCJK(20,20)
      # set the char set
      result = ""
      let c5 = toSeq(minwl.. maxwl)
      let chc = toSeq(parsehexint("3400").. parsehexint("4DB5"))
      for xx in 0..<rndSample(c5): result = result & $Rune(rndSample(chc))




proc newWord*(minwl:int=3,maxwl:int = 10 ):string =
    ## newWord
    ##
    ## creates a new lower case random word with chars from Letters set
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##

    if minwl <= maxwl:
        var nw = ""
        # words with length range 3 to maxwl
        let maxws = toSeq(minwl.. maxwl)
        # get a random length for a new word
        let nwl = rndSample(maxws)
        let chc = toSeq(33.. 126)
        while nw.len < nwl:
          var x = rndSample(chc)
          if char(x) in Letters:
              nw = nw & $char(x)
        result = normalize(nw)   # return in lower case , cleaned up

    else:
         cechoLn(red,"Error : minimum word length larger than maximum word length")
         result = ""



proc newWord2*(minwl:int=3,maxwl:int = 10 ):string =
    ## newWord2
    ##
    ## creates a new lower case random word with chars from IdentChars set
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##
    if minwl <= maxwl:
        var nw = ""
        # words with length range 3 to maxwl
        let maxws = toSeq(minwl.. maxwl)
        # get a random length for a new word
        let nwl = rndSample(maxws)
        let chc = toSeq(33.. 126)
        while nw.len < nwl:
          var x = rndSample(chc)
          if char(x) in IdentChars:
              nw = nw & $char(x)
        result = normalize(nw)   # return in lower case , cleaned up

    else:
         cechoLn(red,"Error : minimum word length larger than maximum word length")
         result = ""


proc newWord3*(minwl:int=3,maxwl:int = 10 ,nflag:bool = true):string =
    ## newWord3
    ##
    ## creates a new lower case random word with chars from AllChars set if nflag = true
    ##
    ## creates a new anycase word with chars from AllChars set if nflag = false
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##
    if minwl <= maxwl:
        var nw = ""
        # words with length range 3 to maxwl
        let maxws = toSeq(minwl.. maxwl)
        # get a random length for a new word
        let nwl = rndSample(maxws)
        let chc = toSeq(33.. 126)
        while nw.len < nwl:
          var x = rndSample(chc)
          if char(x) in AllChars:
              nw = nw & $char(x)
        if nflag == true:
           result = normalize(nw)   # return in lower case , cleaned up
        else :
           result = nw

    else:
         cechoLn(red,"Error : minimum word length larger than maximum word length")
         result = ""


proc newHiragana*(minwl:int=3,maxwl:int = 10 ):string =
    ## newHiragana
    ##
    ## creates a random hiragana word without meaning from the hiragana unicode set
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##
    if minwl <= maxwl:
        result = ""
        var rhig = toSeq(12353.. 12436)  
        var zz = rndSample(toSeq(minwl.. maxwl))
        while result.len < zz:
              var hig = rndSample(rhig)  
              result = result & $Rune(hig)
       
    else:
         cechoLn(red,"Error : minimum word length larger than maximum word length")
         result = ""

    

proc newKatakana*(minwl:int=3,maxwl:int = 10 ):string =
    ## newKatakana
    ##
    ## creates a random katakana word without meaning from the katakana unicode set
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##
    if minwl <= maxwl:
        result  = ""
        while result.len < rndSample(toSeq(minwl.. maxwl)):
              result = result & $Rune(rndSample(toSeq(parsehexint("30A0") .. parsehexint("30FF"))))
       
    else:
         cechoLn(red,"Error : minimum word length larger than maximum word length")
         result = ""


# proc getWanIp*():string =
#    ## getWanIp
#    ##
#    ## deprecated as Herokou seems to have stopped this service in April 2017 ,
#    ##
#    ## will try to find replacement
#    ## 
#    ## get your wan ip from heroku  
#    ##
#    ## problems ? check : https://status.heroku.com/
#    
#    var zcli = newHttpClient(timeout = 5000)
#    var z = "Wan Ip not established. "
#    try:
#       z = zcli.getContent(url = "http://my-ip.heroku.com")
#       z = z.replace(sub = "{",by = " ").replace(sub = "}",by = " ").replace(sub = "\"ip\":"," ").replace(sub = '"' ,' ').strip()
#    except HttpRequestError:
#        printLn("\nIp checking failed due to 404. Heroku does not provide Ip checking anymore !",red)
#    except OSError:
#        printLn("Ip checking failed. See if Heroku is still here or just to slow to respond",red)
#        printLn("Check Heroku Status : https://status.heroku.com",red)
#        printLn("Is your internet still working ?",lightseagreen)
#        try:
#            opendefaultbrowser("https://status.heroku.com")
#        except  OSError:
#             discard
#        discard  
#    result = z
#    
   
proc getWanIp2*():string =
            ## getWanIp2
            ## 
            ## another get wan ip function calling dyndns
            ## 
            ## 
            ## .. code-block:: nim
            ##    printLnBiCol(getwanip2())
            ## 
            ## Note : very slow so only use if getWanIp does not work , needs curl and awk
            ## 
            ## 
            let (outp, errC) = execCMDEx("""curl -s http://checkip.dyndns.org/ | awk -F'[a-zA-Z<>/ :]+' '{printf "External IP: %s\n", $2}'""")
            if errC == 0:
                result =  $outp
            else:
                result = "External IP errorcode : " & $errC & ". IP not established"



proc showWanIp*() =
     ## showWanIp
     ##
     ## show your current wan ip  , this service currently slow
     ##
     printBiCol("Current Wan Ip  : " & getWanIp2(),colLeft=yellowgreen,colRight=gray)



# large font printing, numbers are implemented

proc printBigNumber*(xnumber:string|int|int64,fgr:string = yellowgreen ,bgr:string = black,xpos:int = 1,fun:bool = false) =
    ## printBigNumber
    ##
    ## prints a string in big block font
    ##
    ## available 1234567890:
    ##
    ##
    ## if fun parameter = true then foregrouncolor will be ignored and every block
    ##
    ## element colored individually
    ##
    ##
    ## xnumber can be given as int or string
    ##
    ## usufull for big counter etc , a clock can also be build easily but
    ## running in a tight while loop just uses up cpu cycles needlessly.
    ##
    ## .. code-block:: nim
    ##    for x in 990.. 1105:
    ##         cleanScreen()
    ##         printBigNumber(x)
    ##         sleepy(3)
    ##
    ##    cleanScreen()
    ##
    ##    printBigNumber($23456345,steelblue)
    ##
    ## .. code-block:: nim
    ##    import nimcx
    ##    for x in countdown(9,0):
    ##         cleanScreen()
    ##         if x == 5:
    ##             for y in countup(10,25):
    ##                 cleanScreen()
    ##                 printBigNumber($y,tomato)
    ##                 sleepy(0.5)
    ##         cleanScreen()
    ##         printBigNumber($x)
    ##         sleepy(0.5)
    ##    doFinish()

    let anumber = $xnumber
    var asn = newSeq[string]()
    var printseq = newSeq[seq[string]]()
    for x in anumber: asn.add($x)
    for x in asn:
      case  x
        of "0": printseq.add(number0)
        of "1": printseq.add(number1)
        of "2": printseq.add(number2)
        of "3": printseq.add(number3)
        of "4": printseq.add(number4)
        of "5": printseq.add(number5)
        of "6": printseq.add(number6)
        of "7": printseq.add(number7)
        of "8": printseq.add(number8)
        of "9": printseq.add(number9)
        of ":": printseq.add(colon)
        of " ": printseq.add(clrb)
        of "+": printseq.add(plussign)
        of "-": printseq.add(minussign)
        of "=": printseq.add(equalsign)
        of ".": printseq.add(bigdot)
        else: discard

    for x in 0.. numberlen:
        curSetx(xpos)
        for y in 0..<printseq.len:
            if fun == false:
               print(" " & printseq[y][x],fgr,bgr)
            else:
                # we want to avoid black
                var funny = randcol()
                while funny == black: funny = randcol()
                print(" " & printseq[y][x],funny,bgr)
        echo()
    curup(5)




proc printBigLetters*(aword:string,fgr:string = yellowgreen ,bgr:string = black,xpos:int = 1,k:int = 7,fun:bool = false) =
  ## printBigLetters
  ##
  ## prints big block letters in desired color at desired position
  ##
  ## note position must be specified as global in format :   var xpos = 5
  ##
  ## if fun parameter = true then foregrouncolor will be ignored and every block
  ##
  ## element colored individually
  ##
  ## k parameter specifies character distance reasonable values are 7,8,9,10 . Default = 7
  ##
  ## also note that depending on terminal width only a limited number of chars can be displayed
  ##
  ##
  ##
  ## .. code-block:: nim
  ##       printBigLetters("ABA###RR#3",xpos = 1)
  ##       printBigLetters("#",xpos = 1)   # the '#' char is used to denote a blank space or to overwrite
  ##       printBigLetters("Nim#DOES#IT#AGAIN",xpos = 1,fun=true)

  var xpos = xpos
  template abc(s:typed,xpos:int) =
      # abc
      #
      # template to support printBigLetters
      #

      for x in 0.. 4:
        if fun == false:
           printLn(s[x],fgr = fgr,bgr = bgr ,xpos = xpos)
        else:
           # we want to avoid black
           var funny = randcol()
           while funny == black:
               funny = randcol()
           printLn(s[x],fgr = funny,bgr = bgr ,xpos = xpos)
      curup(5)
      xpos = xpos + k

  for aw in aword:
      let aws = $aw
      var ak = aws.toLowerAscii()
      case ak
      of "a" : abc(abx,xpos)
      of "b" : abc(bbx,xpos)
      of "c" : abc(cbx,xpos)
      of "d" : abc(dbx,xpos)
      of "e" : abc(ebx,xpos)
      of "f" : abc(fbx,xpos)
      of "g" : abc(gbx,xpos)
      of "h" : abc(hbx,xpos)
      of "i" : abc(ibx,xpos)
      of "j" : abc(jbx,xpos)
      of "k" : abc(kbx,xpos)
      of "l" : abc(lbx,xpos)
      of "m" : abc(mbx,xpos)
      of "n" : abc(nbx,xpos)
      of "o" : abc(obx,xpos)
      of "p" : abc(pbx,xpos)
      of "q" : abc(qbx,xpos)
      of "r" : abc(rbx,xpos)
      of "s" : abc(sbx,xpos)
      of "t" : abc(tbx,xpos)
      of "u" : abc(ubx,xpos)
      of "v" : abc(vbx,xpos)
      of "w" : abc(wbx,xpos)
      of "x" : abc(xbx,xpos)
      of "y" : abc(ybx,xpos)
      of "z" : abc(zbx,xpos)
      of "-" : abc(hybx,xpos)
      of "+" : abc(plbx,xpos)
      of "_" : abc(ulbx,xpos)
      of "=" : abc(elbx,xpos)
      of "#" : abc(clbx,xpos)
      of "1","2","3","4","5","6","7","8","9","0",":":
               printBigNumber($aw,fgr = fgr , bgr = bgr,xpos = xpos,fun = fun)
               curup(5)
               xpos = xpos + k
      of " " : xpos = xpos + 2
      else: discard




proc printNimSxR*(nimsx:seq[string],col:string = yellowgreen, xpos: int = 1) =
    ## printNimSxR
    ##
    ## prints large Letters or a word which have been predefined
    ##
    ## see values of nimsx1 and nimsx2 above
    ##
    ##
    ## .. code-block:: nim
    ##    printNimSxR(nimsx,xpos = 10)
    ##
    ## allows x positioning
    ##
    ## in your calling code arrange that most right one is printed first
    ##

    var sxpos = xpos
    var maxl = 0

    for x in nimsx:
      if maxl < x.len:
          maxl = x.len

    var maxpos = cx.tw - maxl div 2

    if xpos > maxpos:
          sxpos = maxpos

    for x in nimsx :
          printLn(" ".repeat(xpos) & x,randcol())


proc doNimUp*(xpos = 5, rev:bool = true) = 
      ## doNimUp
      ## 
      ## A Nim dumbs up logo 
      ## 
      ## 
      cleanScreen()
      decho(2)
      if rev == true:
          
          printLn("        $$$$               ".reversed,randcol(),xpos = xpos)
          printLn("       $$  $               ".reversed,randcol(),xpos = xpos)
          printLn("       $   $$              ".reversed,randcol(),xpos = xpos)
          printLn("       $   $$              ".reversed,randcol(),xpos = xpos)
          printLn("       $$   $$             ".reversed,randcol(),xpos = xpos)
          printLn("        $    $$            ".reversed,randcol(),xpos = xpos)
          printLn("        $$    $$$          ".reversed,randcol(),xpos = xpos)
          printLn("         $$     $$         ".reversed,randcol(),xpos = xpos)
          printLn("         $$      $$        ".reversed,randcol(),xpos = xpos)
          printLn("          $       $$       ".reversed,randcol(),xpos = xpos)
          printLn("    $$$$$$$        $$      ".reversed,randcol(),xpos = xpos)
          printLn("  $$$               $$$$$  ".reversed,randcol(),xpos = xpos)
          printLn(" $$    $$$$            $$$ ".reversed,randcol(),xpos = xpos)
          printLn(" $   $$$  $$$            $$".reversed,randcol(),xpos = xpos)
          printLn(" $$        $$$            $".reversed,randcol(),xpos = xpos)
          printLn("  $$    $$$$$$            $".reversed,randcol(),xpos = xpos)
          printLn("  $$$$$$$    $$           $".reversed,randcol(),xpos = xpos)
          printLn("  $$       $$$$           $".reversed,randcol(),xpos = xpos)
          printLn("   $$$$$$$$$  $$         $$".reversed,randcol(),xpos = xpos)
          printLn("    $        $$$$     $$$$ ".reversed,randcol(),xpos = xpos)
          printLn("    $$    $$$$$$    $$$$$$ ".reversed,randcol(),xpos = xpos)
          printLn("     $$$$$$    $$  $$      ".reversed,randcol(),xpos = xpos)
          printLn("       $     $$$ $$$       ".reversed,randcol(),xpos = xpos)
          printLn("        $$$$$$$$$$         ".reversed,randcol(),xpos = xpos)

      else:
        
          printLn("        $$$$               ",randcol(),xpos=60)
          printLn("       $$  $               ",randcol(),xpos=60)
          printLn("       $   $$              ",randcol(),xpos=60)
          printLn("       $   $$              ",randcol(),xpos=60)
          printLn("       $$   $$             ",randcol(),xpos=60)
          printLn("        $    $$            ",randcol(),xpos=60)
          printLn("        $$    $$$          ",randcol(),xpos=60)
          printLn("         $$     $$         ",randcol(),xpos=60)
          printLn("         $$      $$        ",randcol(),xpos=60)
          printLn("          $       $$       ",randcol(),xpos=60)
          printLn("    $$$$$$$        $$      ",randcol(),xpos=60)
          printLn("  $$$               $$$$$  ",randcol(),xpos=60)
          printLn(" $$    $$$$            $$$ ",randcol(),xpos=60)
          printLn(" $   $$$  $$$            $$",randcol(),xpos=60)
          printLn(" $$        $$$            $",randcol(),xpos=60)
          printLn("  $$    $$$$$$            $",randcol(),xpos=60)
          printLn("  $$$$$$$    $$           $",randcol(),xpos=60)
          printLn("  $$       $$$$           $",randcol(),xpos=60)
          printLn("   $$$$$$$$$  $$         $$",randcol(),xpos=60)
          printLn("    $        $$$$     $$$$ ",randcol(),xpos=60)
          printLn("    $$    $$$$$$    $$$$$$ ",randcol(),xpos=60)
          printLn("     $$$$$$    $$  $$      ",randcol(),xpos=60)
          printLn("       $     $$$ $$$       ",randcol(),xpos=60)
          printLn("        $$$$$$$$$$         ",randcol(),xpos=60)

      curup(15)
      printBigLetters("NIM",fgr=randcol(),xpos = xpos + 33)
      curdn(15)

proc dayOfWeekJulian*(datestr:string): string =
   ## dayOfWeekJulian
   ##
   ## returns the day of the week of a date given in format yyyy-MM-dd as string
   ##
   ## actually starts to fail with 2100-03-01 which shud be a monday but this proc says tuesday
   ## 
   ## due to shortcomings in the julian calendar .
   ##
   ## 
   result = $(getdayofweekjulian(parseInt(day(datestr)),parseInt(month(datestr)),parseInt(year(datestr))))

   
proc clearScreen*():int {.discardable.} =
     ## clearScreen
     ## 
     ## slow clear screen proc using call to Os
     ## 
     execShellCmd("clear")
   
# END OF CXUTILS.NIM #
