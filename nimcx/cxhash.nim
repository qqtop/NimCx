import hashes,strutils

## cxhashes.nim
## 
## convenience functions for hashes 
## 
## Last 2019-12-06
## 

export hashes

{.hint: "\x1b[38;2;154;205;50m ╭──────────────────────── NIMCX ─────────────────────────────────────╮ " .}
    
{.hint: "\x1b[38;2;154;205;50m \u2691  NimCx     " & "\x1b[38;2;255;215;0m Officially made for Linux only." & 
                spaces(23) & "\x1b[38;2;154;205;50m \u2691 ".}
                
{.hint: "\x1b[38;2;154;205;50m \u2691  Compiling " &
        "\x1b[38;2;255;100;0m cxhash.nim \xE2\x9A\xAB" &
        " " & "\xE2\x9A\xAB" & spaces(38) & "\x1b[38;2;154;205;50m \u2691 ".}
         
{.hint: "\x1b[38;2;154;205;50m ╰──────────────────────── CXHASH ────────────────────────────────────╯ " .}



template cxprintLn(xpos:int, args: varargs[untyped]) =
    setCursorXPos(xpos)
    styledEcho(args)
      
proc checkHash*[T](kata:string,hsx:T)  =
  ## checkHash
  ## 
  ## checks hash of a string and print status
  ## 
  if hash(kata) == hsx:
        cxprintln(2,white,darkslategraybg,"Hash Status : Ok ")
  else:
        cxprintln(2,white,bgred,"Hash Status :  Failed ! ")


proc verifyHash*[T](kata:string,hsx:T):bool  =
  ## verifyHash
  ## 
  ## checks hash of a string and returns true or false
  ## 
  result = false
  if hash(kata) == hsx: result = true
       
        
proc createHash*(kata:string):auto = 
    ## createHash
    ## 
    ## returns hash of a string
    ##  
    ## Example
    ##  
    ##.. code-block:: nim
    ##    var zz = readLineFromStdin("Hash a string  : ")
    ##    # var zz = readPasswordFromStdin("Hash a string  : ")   # to do not show input string
    ##    var ahash = createHash(zz)
    ##    echo ahash
    ##    checkHash(zz, ahash)
    ##    
    ##    
    result = hash(kata)   


proc getGitHash*():string = 
   ## getGitHash
   ## to get the git hash during compile
   ## 
   const gitHash = strutils.strip(gorge("git log -n 1 --format=%H"))
   if githash.startswith("fatal") : result = ""
   else: result = githash    

   
# end of cxhash.nim   
