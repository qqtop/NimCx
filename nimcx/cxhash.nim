import cxprint,hashes,strutils

## cxhashes.nim
## 
## convenience functions for hashes 
## 
## Last 2019-04-05
## 

export hashes

# activate if errormsg print ok        
proc checkHash*[T](kata:string,hsx:T)  =
  ## checkHash
  ## 
  ## checks hash of a string and print status
  ## 
  if hash(kata) == hsx:
        printLnPassMsg("Hash Status ok")
  else:
        printLnFailMsg("Hash Status failed")


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
   if githash.startswith("fatal") : discard
   else: result = githash    
   
   
# end of cxhash.nim   
