import nimcx

# example usage of cxHelp()
 
cxHelp(["Help system for my application",
     "Read the book","use more data",
     cxcodestart,
     "Example 1",
     "abc = @[1,2,3]",
     "    ",
     "xfg = mysupergenerator(abc,3)",
     "",
     cxcodeend,
     "this should be help style again",
     cxcodestart,
     "Example 2  ",
     "for x in 0..<n:",
     """   printLn("Something Nice",blue)"""",
     "",
     cxcodeend,   
     "Have a nice day"])
