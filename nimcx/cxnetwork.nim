# cxnetwork.nim
# 
# Var. internet related utility procs and experiments 
# nmap , ip , lsof etc. needs to be installed if 
# relevant procs to be used.
# 
# 
# Last 2020-09-26
# 

import os,osproc,json,httpclient,strutils,strscans
import nativesockets,sets,terminal
import cxconsts,cxglobal,cxprint


{.hint: "\x1b[38;2;154;205;50m ╭──────────────────────── NIMCX ─────────────────────────────────────╮ " .}
    
{.hint: "\x1b[38;2;154;205;50m \u2691  NimCx     " & "\x1b[38;2;255;215;0m Officially made for Linux only." & 
                spaces(23) & "\x1b[38;2;154;205;50m \u2691 ".}
                
{.hint: "\x1b[38;2;154;205;50m \u2691  Compiling " &
        "\x1b[38;2;255;100;0m cxnetwork.nim \xE2\x9A\xAB" &
        " " & "\xE2\x9A\xAB" & spaces(35) & "\x1b[38;2;154;205;50m \u2691 ".}
         
{.hint: "\x1b[38;2;154;205;50m ╰──────────────────────── CXNETWORK ─────────────────────────────────╯ " .}



 
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

proc getWanIP*():string = 
     ## getWanIP
     ##
     ## using curl and ifconfig to get the wanip 
     ## alternatively use getWanIp2() .
     ##
     try:
       let res = execCmdEx("curl ifconfig.me").output.splitLines()
       result = res[res.len-2]
     except:
       result = "WanIp could not be retrieved . "  

proc getWanIp2*() : string =
    ## getWanIP2
    ## 
    ## get your wanip from api.ipify.org if curl and/or ifconfig 
    ## not installed
    ## 
    var cxip = newHttpClient()
    try:
       var eresult = parseJson(cxip.getcontent("https://api.ipify.org?format=json"))
       result = eresult["ip"].getStr
    except:
       result = "WanIp could not be retrieved . Check firewall or permissions."

  

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
        printLnBiCol(fmtx(["<15","",""],"Source"," : ","ip-api.com"),white,darkslategray,":",0,false,{})
      except:
          printLnBiCol("IpInfo   : unavailable",white,red,":",0,false,{})  


   
proc localIp*():seq[string] =
   # localIp
   # 
   # returns current machine ip , there maybe more lines like if we have wireguard
   # on 10.0.0.0/24 and the original 192.168.x.x , this routine returns both
   # 
   let ips = split(execCmdEx("ip route | grep src").output,"src")
   for ipsx in 0 .. ips.len - 1:
       if ips[ipsx].contains(" wg0 "):
           result.add(strip(ips[ipsx]).split(spaces(1))[0] & " wg0 ")
       else:    
           result.add(strip(ips[ipsx]).split(spaces(1))[0])
   
  
  
proc localRouterIp*():string = 
   # localRouterIp
   # 
   # returns current router ip
   # 
   result = (execCmdEx("ip route list | awk ' /^default/ {print $3}'")[0])
   

proc showLocalIpInfo*() =
     cxprintln(1,white,darkslategraybg,"Router  " ,stylereverse, cxpad(strip(localRouterIp()),16))
     for llipre in localIp():
         cxprintln(1,white,darkslategraybg,"Machine " ,styleReverse, cxpad(llipre,16))    
    
proc showWanIpInfo*() =     
     cxprintln(1,white,darkslategraybg,"Wan Ip  " ,stylereverse, cxpad(strip(getwanIp()),16))


proc pingy*(dest:string,pingcc:int = 3,col:string = termwhite,show:bool=true):int {.discardable.} = 
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
        if err > 0 and show == true:
            cxprintln(2,white,bgred,$err) 
        else: 
            if show == true:       
               printLnBiCol("Pinging : " & dest,white,truetomato,":",0,false,{})
               printLnBiCol("Expected: " & pingc & " pings")
               printLn("")
               let p = startProcess(outp2,args=["-c",pingc,dest] , options={poParentStreams})
               printLn($p.waitForExit(parseInt(pingc) * 1000 + 500),truetomato)
               decho(2)
               
        result = err   
            
proc cxPortCheck*(cmd:string = "lsof -i") =
     ## cxPortCheck
     ##
     ## shows the list of all network connections which are
     ##
     ## listening and established.
     ##
     ## This runs a linux system command to see what the ports are listening to
     ##
     ## if no or partial output at all run your program with sudo 
     ## 
     cxprintln(0,white,darkslategraybg,cxpad("cxPortCheck",60))
     if not cmd.startsWith("lsof") :  # do not allow any old command here
        printLnBiCol("cxPortCheck Error: Wrong command --> $1" % cmd,colLeft=red)
        printLn("Exiting now ...")
        quit 0
     let pc = execCmdEx(cmd)  
     let pcl = pc[0].splitLines()
         
     if pcl.len > 1:
         printLn(pcl[0],yellowgreen,styled=cxUnderscore)
         for x in 1..pcl.len - 1:
            if pcl[x].contains("UDP "):
               var pclt = pcl[x].split(spaces(1))
               echo()
               print(pclt[0] & spaces(1),sandybrown)
               for xx in 1 ..< pclt.len:
                 try:
                   if pclt[xx].contains("IPv4") :
                      print(pclt[xx],trueblue,styled=cxReverse)
                      print(spaces(1))
                   elif pclt[xx].contains("IPv6") :
                      print(pclt[xx],truetomato,styled=cxReverse)
                      print(spaces(1))   
                   elif pclt[xx].contains("UDP") :
                      print(pclt[xx],sandybrown,styled=cxReverse)
                      print(spaces(1))
                   elif pclt[xx].contains("root") :
                      print(pclt[xx],darkred,styled=cxReverse)
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
                      print(pclt[xx],dodgerblue,styled=cxReverse)
                      print(spaces(1))
                   elif pclt[xx].contains("IPv6") :
                      print(pclt[xx],truetomato,styled=cxReverse)
                      print(spaces(1))   
                   elif pclt[xx].contains("TCP") :
                      print(pclt[xx],pastelblue,styled=cxReverse)
                      print(spaces(1))
                   elif pclt[xx].contains("root") :
                      print(pclt[xx],darkred,styled=cxReverse)
                      print(spaces(1))   
                   else:
                      print(pclt[xx],pastelpink)
                      print(spaces(1))
                      
                   if xx == pclt.len: echo()   
                   
                 except:
                      discard
           
     else:
            discard
     echo()       
     cxprintln(0,white,darkslategraybg,cxpad("cxPortCheck completed",60))      
     
     
     
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
     ## cxDns
     ## 
     ## also see showHosts()
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
        let z = cxDig(hostip)
        let zz = z.output.splitLines()
        let zze = z.exitCode
        cxprintLn(2,white,darkslategraybg,"HostIp ",hostip & spaces(10))
        echo()
        for x in 0 ..< zz.len:
          if strutils.strip(zz[x]).len() > 0:
            let zzz = zz[x].replace(";;","").replace(";","")
            cxprintLn(2,yellow,darkslategraybg,(fmtx(["<4","","","",""],$x," :",white,blackbg,spaces(2) & zzz)))
        decho(1)
        if zze > 0:
            cxprintLn(8,black,satbluebg,"Exitcode   ",fmtx(["<8"],$zze))


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

        cxprintLn(2,white,darkslategraybg,"HostDns",hostdns & spaces(10))
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
                    inc cc
                    s.add('.')
              s.add($int(c))
          var ss = s.split(",")
          for x in 0 ..< ss.len:
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
         

proc wifiStatus*() =
    # experimental
    # runs nmcli wifi scanner if installed and shows found wifi connections
    # requires nmcli installed and wifi  interface available
    # on many systems this may require to be run under sudo to show
    # other access point
    var (output,error) = execCmdEx("sudo nmcli -p -c yes  -m multiline -f ALL dev wifi")
    echo output
    if error > 0: echo error



when isMainModule:
    echo()
    cxportCheck()
    echo()
    cxprintln(0,white,darkslategraybg,cxpad("System IP Information",60))
    echo()
    showLocalIpInfo()
    showWanIpInfo()
    echo "WanIp2 : ",getWanIP2()
    echo()
    echo()
    cxprintln(0,white,darkslategraybg,cxpad("Wifi Scanner (password required) ",60))
    if cxYesNo() == true: # function in cxglobal
       echo()
       wifiStatus()
       echo()
    echo()
    
         
# end of cxnetwork.nim          
