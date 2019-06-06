import os,osproc,json,httpclient,strutils,strscans,posix,net,nativesockets,sets,terminal
import cxconsts,cxglobal,cxprint
# cxnetwork.nim
# 
# Var. internet related procs and experiments
# nmap , ss needs to be installed if relevant procs to be used.
# 
# 
# Last 2019-06-06
# 

  
iterator parseIps*(soup: string): string =
  ##  parseIps  
  ##  for ipv4 addresses only
  ##  
  ##  ex nim documentation strscans module
  ##  
  const digits = {'0'..'9'}
  var a, b, c, d: int
  var buf = ""
  var idx = 0
  while idx < soup.len:
    if scanp(soup, idx, (`digits`{1,3}, '.', `digits`{1,3}, '.',
             `digits`{1,3}, '.', `digits`{1,3}) -> buf.add($_)):
      discard buf.scanf("$i.$i.$i.$i", a, b, c, d)
      if (a >= 0 and a <= 254) and
         (b >= 0 and b <= 254) and
         (c >= 0 and c <= 254) and
         (d >= 0 and d <= 254):
        yield buf
    buf.setLen(0) # need to clear `buf` each time, cause it might contain garbage
    idx.inc
    


proc getIpInfo*(ip:string):JsonNode =
     ## getIpInfo
     ##
     ## use ip-api.com free service limited to abt 250 requests/min
     ##
     ## exceeding this you will need to unlock your wan ip manually at their site
     ##
     ## the JsonNode is returned for further processing if needed
     ##
     ## and can be queried like so
     ##
     ##.. code-block:: nim
     ##   var jj = getIpInfo("208.80.152.201")
     ##   for x in mpairs(jj):
     ##      echo x
     ##   echo()
     ##   echo jj["city"].getstr
     ##
     ##
    
     var zcli = newHttpClient() 
     if ip != "":
        try: 
          result = parseJson(zcli.getContent("http://ip-api.com/json/" & ip))
        except OSError:
            discard

proc getWanIp*() : string =
    ## getWanIP
    ## 
    ## a way to get your wanip
    ## 
    var cxip = newhttpclient()
    try:
       var eresult = parseJson(cxip.getcontent("https://api.ipify.org?format=json"))
       result = eresult["ip"].getStr
    except:
       result = "Ip could not be retrieved . Check firewall or permissions."

proc showIpInfo*(ip:string) =
      ## showIpInfo
      ##
      ## Displays details for a given IP
      ##
      ## Example:
      ##
      ##.. code-block:: nim
      ##    showIpInfo("208.80.152.201")
      ##    showIpInfo(getHosts("bbc.com")[0])
      ##
      try:
        var jj:JsonNode = getIpInfo(ip)
        decho(2)
        printLn("Ip-Info for " & ip,lightsteelblue)
        dlineln(40,col = yellow)
        for x in jj.mpairs() :
            echo fmtx(["<15","",""],$x.key ," : " ,unquote($x.val))
        printLnBiCol(fmtx(["<15","",""],"Source"," : ","ip-api.com"),yellowgreen,salmon,":",0,false,{})
      except:
          printLnBiCol("IpInfo   : unavailable",lightgreen,red,":",0,false,{})  

proc localIp*():string =
   # localIp
   # 
   # returns current machine ip
   # 
   result = (strip(split(execCmdEx("ip route | grep src").output,"src")[1])).split(spaces(1))[0]
  
proc localRouterIp*():string = 
   # localRouterIp
   # 
   # returns current router ip
   # 
   result = (execCmdEx("ip route list | awk ' /^default/ {print $3}'")[0])
   

proc showLocalIpInfo*() =
     cxprintln(2,white,yellowgreenbg,"Machine " ,styleReverse, localIp())
     cxprintln(2,white,yellowgreenbg,"Router  " ,stylereverse, strip(localRouterIp()))
     echo()


proc pingy*(dest:string,pingcc:int = 3,col:string = termwhite) = 
        ## pingy
        ## 
        ## small utility to ping some server
        ## 
        ##.. code-block:: nim 
        ##    pingy("yahoo.com",4,dodgerblue)   # 4 pings and display progress in some color
        ##    pingy("google.com",8,aqua)
        ##    pingy("ping.sunet.se",4,lime)
 
        let pingc = $pingcc
        let (outp,err) = execCmdEx("which ping")
        let outp2 = quoteshellposix(strutils.strip(outp,true,true))
        if err > 0:
            cxprintln(2,white,bgred,$err) 
        else:        
            printLnBiCol("Pinging : " & dest,yellowgreen,truetomato,":",0,false,{})
            printLnBiCol("Expected: " & pingc & " pings")
            printLn("")
            let p = startProcess(outp2,args=["-c",pingc,dest] , options={poParentStreams})
            printLn($p.waitForExit(parseInt(pingc) * 1000 + 500),truetomato)
            decho(2)
            
            
proc cxPortCheck*(cmd:string = "lsof -i") =
     ## cxPortCheck
     ## 
     ## runs a linux system command to see what the ports are listening to
     ##
     ## if no or partial output at all run your program with sudo 
     ## 
     cxprintln(2,yellowgreen,pastelwhitebg,stylereverse,"cxPortCheck")
     if not cmd.startsWith("lsof") :  # do not allow any old command here
        printLnBiCol("cxPortCheck Error: Wrong command --> $1" % cmd,colLeft=red)
        printLn("Exiting now ...")
        quit 0
     let pc = execCmdEx(cmd)  
     let pcl = pc[0].splitLines()
     printLn(pcl[0],yellowgreen,styled={styleUnderscore})
     for x in 1..pcl.len - 1:
        if pcl[x].contains("UDP "):
           var pclt = pcl[x].split(" ")
           echo()
           print(pclt[0] & spaces(1),sandybrown)
           for xx in 1..<pclt.len:
             try:
               if pclt[xx].contains("IPv4") :
                  print(pclt[xx],dodgerblue,styled={styleReverse})
                  print(spaces(1))
               elif pclt[xx].contains("IPv6") :
                  print(pclt[xx],truetomato,styled={styleReverse})
                  print(spaces(1))   
               elif pclt[xx].contains("UDP") :
                  print(pclt[xx],sandybrown,styled={styleReverse})
                  print(spaces(1))
               elif pclt[xx].contains("root") :
                  print(pclt[xx],darkred,styled={styleReverse})
                  print(spaces(1))   
               else:
                  print(pclt[xx],skyblue)
                  print(spaces(1))
               if xx == pclt.len: echo() 
             except:
                 discard
                 
        elif pcl[x].contains("TCP "):
           var pclt = pcl[x].split(" ")
           echo()
           print(pclt[0] & spaces(1),lime)
           for xx in 1..<pclt.len:
             try:
               if pclt[xx].contains("IPv4") :
                  print(pclt[xx],dodgerblue,styled={styleReverse})
                  print(spaces(1))
               elif pclt[xx].contains("IPv6") :
                  print(pclt[xx],truetomato,styled={styleReverse})
                  print(spaces(1))   
               elif pclt[xx].contains("TCP") :
                  print(pclt[xx],pastelblue,styled={styleReverse})
                  print(spaces(1))
               elif pclt[xx].contains("root") :
                  print(pclt[xx],darkred,styled={styleReverse})
                  print(spaces(1))   
               else:
                  print(pclt[xx],pastelpink)
                  print(spaces(1))
                  
               if xx == pclt.len: echo()   
               
             except:
                 echo()
                 discard
 
        else:
           echo()
           discard
     cxprintln(2,white,yellowgreenbg,"cxPortCheck Finished.")      
     
     
     
# Experimental section with procs may or maynot return expected data     
     
proc cxDig*(ipadd:string):tuple = 
     ## cxDig
     ##
     ## returns reverse DNS of an ip address
     ## 
     ## needs dig command available on system
     ## 
     ## may or may not return expected data
     ## 
     ## see showDig() for display
     ## 
     let acmd = "dig -x " & ipadd #& " +short"
     result = execCmdEx(acmd)

    
proc cxDns*(dns:string):tuple =    
     ## cxHost
     ## 
     ## see showHost()
     ## 
     let acmd = "host " & dns
     result = execCmdEx(acmd) 


proc showDig*(hostip:string = $"172.217.5.14") =
        ## showDig
        ## 
        ## reverse dns lookup , default a google ip
        ## 
        ## 
        decho(2)
        var z = cxDig(hostip)
        var zz = z.output.splitLines()
        var zze = z.exitCode
        cxprintLn(2,white,yellowgreenbg,"HostIp ",hostip & spaces(10))
        echo()
        for x in 0 ..< zz.len:
          if strutils.strip(zz[x]).len() > 0:
            let zzz = zz[x].replace(";;","").replace(";","")
            cxprintLn(2,white,yellowgreenbg,(fmtx(["<4","",""],$x," : ",zzz)))
        decho(1)
        if zze > 0:
            cxprintLn(8,white,yellowgreenbg,"Exitcode   ",fmtx(["<8"],$zze))


proc showDns*(hostdns:string = "google.com") =   
        ## showDns
        ## 
        ## ip and connected hosts look up for a domain name
        ## 
        ## default = google.com
        ## 
        ##.. code-block:: nim
        ##   showDns("bbc.com")
        ## 

        decho(2)
        var h = cxDns(hostdns)
        var hh = h.output.splitlines()
        var hhe = h.exitCode

        cxprintLn(2,white,yellowgreenbg,"HostDns",hostdns & spaces(10))
        echo()
        for x in 0 ..< hh.len:
          if strutils.strip(hh[x]).len() > 0:
             printLnBiCol(fmtx(["<4","",""],$x," : ",hh[x]),xpos = 2)
        decho(1)
        if hhe > 0:
            cxprintLn(8,white,yellowgreenbg,"Exitcode   ",fmtx(["<8"],$hhe))
    
proc getHosts*(dm:string):seq[string] =
    ## getHosts
    ##
    ## returns IP addresses inside a seq[string] for a domain name and
    ##
    ## may resolve multiple IP pointing to same domain
    ##
    ##.. code-block:: Nim
    ##    import nimcx
    ##    var z = getHosts("bbc.co.uk")
    ##    for x in z:
    ##      echo x
    ##    doFinish()
    ##
    ##
    var rx = newSeq[string]()
    try:
      for i in getHostByName(dm).addrList:
        if i.len > 0:
          var s = ""
          var cc = 0
          for c in i:
              if s != "":
                  if cc == 3:
                    s.add(",")
                    cc = 0
                  else:
                    cc += 1
                    s.add('.')
              s.add($int(c))
          var ss = s.split(",")
          for x in 0..<ss.len:
              rx.add(ss[x])

        else:
          rx = @[]
    except:
           rx = @[]
    var rxs = rx.toHashSet # removes doubles
    rx = @[]
    for x in rxs:
        rx.add(x)
    result = rx


proc showHosts*(dm:string) =
    ## showHosts
    ##
    ## displays IP addresses for a domain name and
    ##
    ## may resolve multiple IP pointing to same domain
    ##
    ##.. code-block:: Nim
    ##    import nimcx
    ##    showHosts("bbc.co.uk")
    ##    doFinish()
    ##
    ##
    printLn("Hosts Data for " & dm,yellowgreen)
    let z = getHosts(dm)
    if z.len < 1:
         printLn("Nothing found or not resolved",red)
    else:
       for x in z:
         printLn(x)    
         

proc ssService*():seq[string] = 
   ## ssService
   ## 
   ## WIP to provide color formated output to ss commands
   ## like : ss --query=tcp -r
   ## 
   ## 
   let (ss,err) = execCmdEx("ss --options --extended --memory --processes --info")
   if err <> 0:
       result = @["Error occured in ss execution"]
   else:    
       result = ss.splitLines()
         
         
# end of cxnetwork.nim          
