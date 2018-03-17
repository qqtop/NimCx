import
  "/data5/NimStuff/NimCx/nimcx/cxutils.nim"

import
  nimcx

block:
    clearUp(18)
    curSet()
    cxutils.drawRect(15, 24, frhLine = "+", frvLine = ".", frCol = randCol(), xpos = 8)
    curup(12)
    cxutils.drawRect(7, 19, frhLine = "=", frvLine = "|", frCol = randCol(), xpos = 10,
                     blink = true, dottype = smiley)
    curup(12)
    cxutils.drawRect(9, 20, frhLine = "=", frvLine = ".", frCol = randCol(), xpos = 35,
                     blink = true, dottype = "&")
    curup(10)
    cxutils.drawRect(6, 14, frhLine = "~", frvLine = "$", frCol = randCol(), xpos = 70,
                     blink = true, dottype = ".")
    decho(8)
    doFinish()
import
  nimcx

block:
    var b = cxutils.createSeqCJK()
    var col = 0
    for x in 0 ..< b.len:
      printbicol(fmtx(["<6", "", ""], $x, " : ", b[x]))
      inc col
      if col > 10:
        col = 0
        echo()
    echo()