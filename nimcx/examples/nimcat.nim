import nimcx

# nimcat   
# a cat for nim :)
# usage : nimcat test4 sometext somenumbers someothertext
# file ext other than .nim  need the full filename like e.g. notes.txt
if paramCount() > 0:
        var cp1 = newseq[TaintedString]()
        cp1 = commandLineParams()
        if cp1.len > 0:
            nimcat(paramStr(1),countphrase = cp1[1 ..< cp1.len])
        else:
            nimcat(paramStr(1))
else:
     printLnErrorMsg("No Filename to list specified                       ")
     printLnBErrorMsg("Usage : nimcat filename  <optional someword number> ")

doFinish()
