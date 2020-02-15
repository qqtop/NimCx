import nimcx

# cctest.nim
# creating new colors by mixing using colors.nim mix template
# 

import nimcx
hdx(println("Color Mixology",newcolor(200,255,57),truebluebg))
randomize()

# use random colors from cxconsts.nim  
var a:Color = sample(cxColorNames)[1]
var b:Color = sample(cxColorNames)[1] 


#var a = Color(0x0a6814)
#var b = Color(0x050a03)

#var a = Color(0x0a8814)
#var b = Color(0x020a03)

# we can add and subtract colors to make new colors
var c = a + b 
var d = a - b 

# we also can set the intensity 0.0 - 1.0
let ia = 0.70
let ib = 0.98
a = c.intensity(ia)
b = d.intensity(ib)
 
proc myMix(x, y: int): int =  x * 2 - y * 3 

   
proc doit(a,b:Color):auto =
  let tb:Color = mix(a, b, myMix)
  println("  Generated Color Details")
  echo "  Color 1 : ",parseColor($a),"  with intensity ", $ia
  echo "  Color 2 : ",parseColor($b),"  with intensity ", $ib
  echo "  Mixed   : ",parseColor($tb) 
    
  let tbb1 = extractrgb(tb)
  echo "  RGB     : ",tbb1
  if tbb1[0] > 0 xor tbb1[1] > 0 xor tbb1[2] > 0 == false:
        echo "  Only colors with rgb values > 0 will be shown."
        echo "  Rerun program several times for different effect. "
        
  echo()
        
  
  var tbb = extractrgb(tb)  # colors are not interesting if all 0 or 255
  var anewcol = newcolor(tbb[0],tbb[1],tbb[2])
  
  if tbb[0] > 0 and tbb[1] > 0 and tbb[2] > 0:
   if tbb[0] < 255 and tbb[1] < 255 and tbb[2] > 255:   
    #echo tbb
    hdx(printLn("       RGB               styleBright               Yaleblue Back unstyled          styleBright,styleReverse          styleDim,styleReverse",greenyellow))
    for x in countup(0,99,2):
         var tempcol = extractrgb(tb.intensity(float(x) / 100.0) )
         anewcol = newcolor(tempcol[0],tempcol[1],tempcol[2])
         print($tbb & " Bright Intensity"  & " " & ff2(float(x)/100,3) & spaces(1), anewcol,tomatobg,styled={styleBright},xpos = 1)
         print(" | ",lime)
         print(" unstyled Intensity" &  " " & ff2(float(x)/100,3) & spaces(1), anewcol,yalebluebg,styled={})  # colored font on colored background
         print(" | ",lime)
         print(" Bright & Reverse " & "Intensity" & " " & ff2(float(x)/100,3) & spaces(1), anewcol,styled={styleBright,styleReverse})
         print(" | ",lime)
         printLn(" Dim & Reverse " & "Intensity" & " " & ff2(float(x)/100,3) & spaces(1) , anewcol,styled={styleDim,styleReverse})
  result = (tb,tbb1)
           
# maybe add nice colors to our database
# #6495ED   a
# #00008B   b
# #C8FF39   tb
# (r: 200, g: 255, b: 57)  lemonyyellow  intensity 98


when isMainModule: 
 
     var natb0 = doit(a,b)
     var natb = natb0[0]
     var tbb1 = natb0[1]
     
     var atb = extractrgb(natb)
     if atb[0] > 0 xor atb[1] > 0 xor atb[2] > 0:
        echo() 
        var ac = newcolor(extractrgb(a)[0],extractrgb(a)[1],extractrgb(a)[2])
        var bc = newcolor(extractrgb(b)[0],extractrgb(b)[1],extractrgb(b)[2])
        let smik =  newcolor(extractrgb(natb.intensity(0.96))[0],extractrgb(natb.intensity(0.96))[1],extractrgb(natb.intensity(0.96))[2])
        cxprintln(2,"Mixed color :  " ,ac, fmtx(["<25"],$extractrgb(a)) , termwhite,getBg(bgdefault)," and  " ,bc, fmtx(["<25"],$extractrgb(b)) ,termwhite, " --> " , smik,cxBright,$tbb1 & " intensity 0.96 styledBright")
        cxprintLn(2,"Mixed color :  " ,ac, fmtx(["<25"],$extractrgb(a)) , termwhite,getBg(bgdefault)," and  " ,bc, fmtx(["<25"],$extractrgb(b)) ,termwhite, " --> " , smik,$tbb1 & " intensity standard")
        
     doFinish()      
