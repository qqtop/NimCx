import nimcx

# example usage of CXRGB type declared in cxtruecolor.nim
# 
# 2018-05-15
# 

let xpos = 5
       
proc cxRGBTest(acol:CXRGB) =       
   let aline = fmtx([">6","",">6","",">6","",">100"],$acol[0]," ",$acol[1]," ",$acol[2]," :"," Test Line  123456789  我感觉很好。  " & efb2 * 10 & "  " & efs2 * 8)
   printLnBiCol2(aline & "  styleReverse             ",colLeft=yellowgreen,colright=cxRGBcol(acol),xpos = xpos ,styled=cxReverse)  
   printLnBiCol2(aline & "                           ",colLeft=yellowgreen,colright=cxRGBcol(acol),xpos = xpos ,styled=cxnostyle)  
   printLnBiCol2(aline & "  styleReverse,styleBright ",colLeft=yellowgreen,colright=cxRGBcol(acol),xpos = xpos ,styled=cxReverseBright) 
   printLnBiCol2(aline & "               styleBright ",colLeft=yellowgreen,colright=cxRGBcol(acol),xpos = xpos ,styled=cxBright) 
   echo()

decho(3)   
hdx(println("cxRGBTest", cxRGBcol((41307,47510,20198,"")),xpos = xpos))  
loopy2(0,10): 
  cxRGBTest((getrndint(500,50000),getrndint(500,50000),getrndint(500,50000),""))
hdx(println("cxRGBTest  Finished   - Rerun for more fun", cxRGBcol((1513,13357,47975,"")),xpos = xpos))       
doFinish()       
       
       
