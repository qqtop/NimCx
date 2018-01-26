import cx,cxDemo

# another demo for sierpCarpet
# best viewed with terminal fontsize set to 6-8

let maxrun = 1
cleanscreen()
let sa = snowflake   #widedot # default"* "
let sb = smile      #skull    # default spaces(2)
let mm = 2
for x in 1.. maxrun:
   
   curset()
   sierpCarpetDemo2(2,1,sa=sa,sb=sb * mm)
   curSet()
   sierpCarpetDemo2(2,20,sa=sa,sb=sb * mm)
   curSet()
   sierpCarpetDemo2(2,40,sa=sa,sb=sb * mm)
   curSet()
   sierpCarpetDemo2(2,60,sa=sa,sb=sb * mm)
   curSet()
   sierpCarpetDemo2(2,80,sa=sa,sb=sb * mm)
   curSet()
   sierpCarpetDemo2(2,100,sa=sa,sb=sb * mm)
   curSet()
   sierpCarpetDemo2(2,120,sa=sa,sb=sb * mm)
   curSet()
   sierpCarpetDemo2(2,140,sa=sa,sb=sb * mm)
   curdn(1)
   sierpCarpetDemo2(3,1,sa=sa,sb=sb * mm)
   curup(27)
   sierpCarpetDemo2(3,122,sa=sa,sb=sb * mm)   # 104
   curdn(1)
   sierpCarpetDemo2(2,1,sa=sa,sb=sb * mm)
   curup(9)
   sierpCarpetDemo2(2,20,sa=sa,sb=sb * mm)
   curup(9)
   sierpCarpetDemo2(2,40,sa=sa,sb=sb * mm)
   curup(9)
   sierpCarpetDemo2(2,60,sa=sa,sb=sb * mm)
   curup(9)
   sierpCarpetDemo2(2,80,sa=sa,sb=sb * mm)
   curup(9)
   sierpCarpetDemo2(2,100,sa=sa,sb=sb * mm)
   curup(9)
   sierpCarpetDemo2(2,120,sa=sa,sb=sb * mm)
   curup(9)
   sierpCarpetDemo2(2,140,sa=sa,sb=sb * mm)
   echo()
   
   curup(38)
   printNimcx(51)
   curdn(9)
   #printNimcx(51)
   #printMadewithnim(19)
   printNim(61)
   curdn(9)
   printNimcx(51)
   curdn(50)
   printLnBiCol("Run : " & $x & " of : " & $maxrun)
   sleepy(0.001)
   

