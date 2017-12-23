import cx,cxutils

# example for the Cxline object 

let cxTrueCol = getcxTrueColorSet(max = 888,step = 12)  

loopy2(1,100):
    var lcol  = color38(cxTrueCol)
    var tcol  = color38(cxTrueCol)
    var bcol  = color38(cxTrueCol)
    var dlcol = color38(cxTrueCol)
    var drcol = color38(cxTrueCol)
    var theline = newcxline()
    
    theline.startpos = 10  #getRndInt(3,50)
    theline.endpos = 86
    theline.linecolor        = cxTrueCol[lcol]
    theline.textbracketcolor = cxTrueCol[bcol]
    theline.dotleftcolor     = cxTrueCol[dlcol]
    theline.dotrightcolor    = cxTrueCol[drcol]
    theline.textpos = 8
    theline.text = fmtx([">8","","<16","<14",">7"] ,$xloopy," ",newword(5,10),"cxTruecolor : " ,$lcol)
    theline.textcolor = cxTrueCol[lcol]
    theline.textstyle = {styleReverse}
    theline.newline = "\L"                  # need a new line character here or we overwrite 
    printcxline(theline)
    
   
doFinish()
