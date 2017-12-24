import nimcx

# example for the Cxline object 
# can also be obtained via showCxTrueColorPalette()


if checktruecolorsupport() == true:
   # controll the size of our truecolor cache 
   # default max 888, increase by too much we may have memory issues
   # defaul step 12 , decrease by too much we may have memory issues  tested with steps 4 - 16 ,
   # lower steps longer compile time 
   #     rough run times on our test machine
   #     max 888  steps 4  21.72 secs  needs up to 4.3 gb mem  Palette has 22,179,134 to choose from
   #     max 888  steps 7   4.11 secs
   #     max 888  steps 8   2.75 secs
   #     max 888  steps 12  0.85 secs  default vals            Palette has 843,750 to choose from
   #     max 888  steps 16  0.37 secs
   #     max 888  steps 22  0.15 secs
   #     max 1280 steps 22  0.41 secs
   #     max 1280 steps 12  2.40 secs                          Palette has 2,450,086 to choose from
   cxTrueCol = getcxTrueColorSet(max = 888,step = 7)  
else:
   printLnBicol("Error : cxTrueCol truecolor scheme can not be used on this terminal/konsole",colLeft=red,styled = {stylereverse})
   dobyebye()

loopy2(1,100):
    var lcol  = color38(cxTrueCol)
    var tcol  = color38(cxTrueCol)
    var bcol  = color38(cxTrueCol)
    var dlcol = color38(cxTrueCol)
    var drcol = color38(cxTrueCol)
    var theline = newcxline()
    
    theline.startpos = 10  #getRndInt(3,50)
    theline.endpos = 100
    theline.linecolor        = cxTrueCol[lcol]
    theline.textbracketcolor = cxTrueCol[bcol]
    theline.dotleftcolor     = cxTrueCol[dlcol]
    theline.dotrightcolor    = cxTrueCol[drcol]
    theline.textpos = 8
    theline.text = fmtx([">8","","<16","<14",">12"] ,$xloopy," ",newword(5,10),"cxTruecolor : " ,$lcol)
    theline.textcolor = cxTrueCol[lcol]
    theline.textstyle = {styleReverse}
    theline.newline = "\L"                  # need a new line character here or we overwrite 
    printcxline(theline)
    
echo()
printLnBiCol("Palette length : " & ff2(cxTruecol.len),xpos = 10)   
doFinish()
