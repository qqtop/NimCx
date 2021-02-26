import nimcx

# Experimental
#
# zenity driven interfaces for gtk based messageboxes
# zenity can be installed on linux , comes with many gnome based distros
# has more options than whiptail a similar app
#
# Last  : 2020-11-29
#
# TODO
#
# https://funprojects.blog/2021/01/25/zenity-command-line-dialogs/
#
# zenity --info --text=$(top -n 1 | grep %Cpu | awk '{print $8}') --title="CPU Idle Time"
#
# zenity --warning --text='<span font="32" foreground="red">HIGH Temperature</span>' --title="HDD Check"
#
# ( for i in `seq 1 100`; do echo $i; echo "# $i";  sleep 1; done ) | zenity --progress
#
#zenity --list \  --title="2 Column Example" \   --column="Month" --column="Sales" \  Jan 100 Feb 95 Mar 77 Apr 110 May 111
#

proc cxZFileSelection():string =
     var zs = execCmdEx("""zenity --file-selection --title="Select a File" """)
     result = zs.output
     
proc cxZCombobox*(title:string="cxZComboBox",text:string="Selections available",cchoice:string="London|Birmingham|Paris|Dubai|Vienna|Hongkong",width:int=250):string = 
   ## cxZCombobox
   ##

   # in order to display a default value
   #var array="(a b c d e)"
   #let zs = """$(zenity --entry --title "Window title" --entry-text "${array["$1"]}" --text "Insert your choice.""" % [array]

   let zs = """zenity --width=$4 --forms --title "$1" --text "$2" --add-combo "Choose : " --combo-values "$3"  """  % [title,text,cchoice,$width]
   #echo zs
   var cbx = execCmdEx(zs)
   cbx.output.removeSuffix('\n')
   result = cbx.output


proc cxZDialog*(title:string="cxZDialog",text:string="Demo Text",hideText:bool=false ):string =
   ## cxZDialog
   ##
   if hideText == false:
      let zs = """zenity --entry --title="$1" --text="$2" """ % [title,text]
      var dialg = execCmdEx(zs)
      dialg.output.removeSuffix('\n')
      result = dialg.output
   else:
      let zs = """zenity --entry --title="$1" --text="$2" --hide-text""" % [title,text]
      var dialg = execCmdEx(zs)
      dialg.output.removeSuffix('\n')
      result = dialg.output
  
proc cxZLoginDialog*(title:string="Login Dialog",text:string="Login"):tuple[name:string,password:string] =
     ## cxZLoginDialog
     ##
     ## pressing cancel exits application
     ##
     var forms = execCmdEx("""zenity --forms --title="$1" --add-entry=Username --add-password=Password --text="$2" --separator=';' """ % [title,text]).output
     forms.removeSuffix('\n')
     if forms == "":
        printLnAlertMsg("Login failed ! Incorrect credentials supplied. ")
        doFinish()
     else:    
        let fs = forms.split(";")
        result.name = fs[0]
        result.password = fs[1] 

  
proc cxZSSHLoginDialog*(title:string="SSH Login Dialog",text:string="Login"):tuple[host:string,port:int,username:string,password:string,command:string] =
     ## cxZSSHLoginDialog
     ##
     ## pressing cancel exits application
     ##
     var forms = execCmdEx("""zenity --forms --title="$1" --add-entry=Host* --add-entry=Port* --add-entry=Username* --add-password=Password* --add-entry=Command --text="$2" --separator=';' """ % [title,text]).output
     forms.removeSuffix('\n')
     if forms == "":
        printLnAlertMsg("Login failed ! Incorrect credentials supplied. ")
        doFinish()
     else:    
        let fs = forms.split(";")
        result.host = fs[0]
        result.port = parseInt(fs[1])
        result.username = fs[2]
        result.password = fs[3]
        result.command = fs[4] 





proc cxZPwd*():string = 
    ## cxZPwd
    ##
    ## password input dialog box
    ##
    ##
    var result1 = ""
    result1 = execCmdEx("""zenity --password --title="Enter Password" """).output
    result1.removeSuffix('\n')
    return result1



proc cxLoginEncDialog*(title:string="Login Dialog",text:string="Login",enckeytext:string = ""):tuple[name:string,password:string,enckey:string] =
     ## cxLoginEncDialog
     ##
     ## adds possibility to put in an encryption key
     ## pressing cancel exits application
     ##
     var forms = execCmdEx("""zenity --forms --title="$1" --add-entry=Username --add-password=Password --text="$2" --add-password=Enckey --text="$3" --separator=';' """ % [title,text,enckeytext]).output
     forms.removeSuffix('\n')
     if forms == "":
        printLnAlertMsg("Login failed ! Incorrect credentials supplied. ")
        doFinish()
     else:    
        let fs = forms.split(";")
        result.name = fs[0]
        result.password = fs[1] 
        result.enckey = fs[2]


proc cxLoginDateDialog*(title:string="Login Dialog",text:string="Login"):tuple[name:string,password:string,date:string]=
     ## cxLoginDateDialog
     ##
     ## username,password,date dialog
     ##
     var forms = execCmdEx("""zenity --forms --add-entry=Username --add-password=Password --add-calendar=Date --text=$1 --separator=';' --forms-date-format=%Y/%m/%d  % [text] """).output
     forms.removeSuffix('\n')
     if forms == "":
        printLnAlertMsg("Login failed ! Incorrect credentials supplied. ")
        doFinish()
     else:    
        let fs = forms.split(";")
        result.name = fs[0]
        result.password = fs[1] 
        result.date = fs[2] 
        
proc cxZInfo*(infotext:string="Stay_calm_, carry_on",width:int=300) = 
   discard  execCmdEx("""zenity --info --text="$1" --no-wrap --width=$2""" % [infotext,$width])
 

proc cxZYesNo*(text:string="",width:int=300):string =
    let rp = execCmdEx("""zenity --question --text "$1 ?" --ok-label "Yes" --cancel-label="No" --width=$2 """ % [text,$width])  #.output
    result = if rp.exitcode == 0: "yes" else: "no"  # yes = 0 no = 1 
   
   
proc cxZQuestion*(ask:string = "How Are you ?",cancel:string="Tired",ok:string="Energetic"):bool =
    ## cxZQuestion
    ##
    ##
    var quest = execCmdEx("""zenity --question --title="Question" --text="$1"  --cancel-label="$2" --ok-label="$3" --no-wrap""" % [ask,cancel,ok])
    quest.output.removeSuffix('\n')  
    if quest.exitcode == 0: #yes
       result = true
    else:
       result = false

proc cxZWarn*(warntext:string=" This is a warning ! Hope you head it ! ",width:int=250) =
     ## cxZWarn   
     ##
     ## display a warning message
     discard execCmd("""zenity --warning --text="$1" --no-wrap" --width=$2"""  % [warntext,$width])
     
proc cxZError*(errortext:string=" An error has occured ")=    
     ## cxError
     ##
     ## display an error message 
     discard execCmdEx("""zenity --error --text="$1" --no-wrap"""  % errortext)


proc cxZDisplayFile*(filename:string,height:int=400,width:int=500):string=
  ## display text file , text can be edited and will be returned edited, file remains unchanged
  let res = execCmdEx("""zenity --text-info --title="$1" --filename=$1 --editable --no-wrap --height=$2  --width=$3"""  % [filename,$height,$width])
  result = res.output


proc cxZDisplayHtmlFile*(filename:string,height:int=600,width:int=800):string=
   ## display html file , text can be edited and will be returned edited, file remains unchanged
   var res = execCmdEx("""zenity --text-info --title="WriteBash.com - demo text-info dialog" --filename=$1 --editable --no-wrap --html --height=$2  --width=$3"""  % [filename,$height,$width])
   result = res.output
        

proc cxZScale*(text:string="cxScale",value:int=20,min:int=0,max:int=100,step:int=5):int = 
   var scal = execCmdEx("""zenity --scale --text="$1" --value=$2 --min-value=$3 --max-value=$4 --step=$5""" % [text,$value,$min,$max,$step])
   scal.output.removeSuffix('\n')
   result = parseInt($(scal.output))  #returns value of scaler


proc cxZColorSelector*():string =
    ## colorselector box
    var colo = execCmdEx("""zenity --color-selection --show-palette""")
    result = colo.output

proc cxZIPort*():tuple[ip:string,port:string] =
   var multicast = execCmdEx("""zenity --forms --title="Add Friend" --text="Enter Multicast address" --separator="," --add-entry="IP address" --add-entry="PORT" """)
   if multicast.exitcode == 0:
      multicast.output.removeSuffix('\n')
      var mcs = multicast.output.split(",") 
      result.ip = mcs[0]
      result.port = mcs[1]
   else:
      discard
   
# Below WIP
proc cxZCheckbox*():string = 
    ## with checkbox
    var list2 = execCmdEx("""zenity --list column=Check --column="Column name 1" --column="Column name 2" TRUE "Text row 1" "Value row 1" FALSE "Text row 2" "Value row 2" --checklist""")
    list2.output.removeSuffix('\n')
    result = list2.output


proc cxZList*():string=
   var list = execCmdEx("""zenity --list --column="Column name 1" --column="Column name 2" "Text row 1" "Value row 1" "Text row 2" "Value row 2" """)
   list.output.removeSuffix('\n')
   result = list.output


proc cxZRadio*():string = 
    ##with radiobutton
    var list3 = execCmdEx("""zenity --list column=Check --column="Column name 1" --column="Column name 2" TRUE "Text row 1" "Value row 1" FALSE "Text row 2" "Value row 2" --radiolist""")
    list3.output.removeSuffix('\n')
    result = list3.output

proc cxProgress*():string =
# below a script of a zenity progress bar 
# need to translate to nim
# #!/bin/sh
#(
#echo "10" ; sleep 1
#echo "# Updating mail logs" ; sleep 1
#echo "20" ; sleep 1
#echo "# Resetting cron jobs" ; sleep 1
#echo "50" ; sleep 1
#echo "This line will just be ignored" ; sleep 1
#echo "75" ; sleep 1
#echo "# Rebooting system" ; sleep 1
#echo "100" ; sleep 1
#) |
#zenity --progress \
  #--title="Update System Logs" \
  #--text="Scanning mail logs..." \
  #--percentage=0

#if [ "$?" = -1 ] ; then
        #zenity --error \
          #--text="Update canceled."
#fi
   printLnStatusMsg("Not yet implemented")
   discard



proc cxZprogress():string =
     # nice but how to use with nim is not clear
     var p = execCmd("(for i in `seq 1 100`;do echo $i;sleep 0.1;done ) | zenity --progress")
     

# larger example for further customisation
proc formExample():seq[string] =       
    var forms2 = execCmdEx("""zenity --forms --title="Add Friend" \
        --text="Enter information about your friend." \
        --separator="," \
        --add-entry="First Name" \
        --add-entry="Family Name" \
        --add-entry="Email" \
        --add-calendar="BirthDay" \
        --no-wrap \
        --forms-date-format=%Y/%m/%d         
        """)
    forms2.output.removeSuffix('\n')
    var fs = forms2.output.split(";")
    result = fs   
    
    
    

if isMainModule:
  # test var functions
  
  #var yn = cxZYesNo("Overwrite the existing database.fdb file ")
  #echo yn
  
  #echo cxZprogress()
  
  echo cxZComboBox(cchoice="123|1124|Bangkok")
  
  echo cxZFileSelection()
  
  
  # simple entry dialog
  #var cxz  = cxZDialog("Secret1","Enter a secret",false)
  #echo cxz
  #var cxz1 = cxZDialog("Secret2","Enter a secret",true) 
  
  #echo cxZdialog("Hello","Say something nice today !",false)
    
  # name,password,date dialog
  #var login = cxLoginDateDialog()
  #echo "Name : ",login.name 
  #echo "Pwd  : ",login.password
  #echo "Date : ",login.date
  
  
  #var login1 = cxZLoginDialog()
  #echo "Name : ",login1.name 
  #echo "Pwd  : ",login1.password
  
  # small pop ups  
  #cxZinfo()
  #cxZinfo("Howdy, You made it")
  
  #cxZWarn()
  #cxZWarn("Be more careful")
  
  #cxZError()
  #cxZError("Error B202, execution halted !")

  # questions
  #echo cxZQuestion(cancel="Bad",ok="Good")
  #echo cxZQuestion("What's up","Nothing","Everything")

  # formsExample like use for a database input etc
  #echo formExample()

  # display a file editable in a textbox
  #echo cxZDisplayFile("//home/lxuser/Sync/dbprivate/notes.txt")

  #echo cxZScale()
  #echo cxZScale(text="cxScale Test",value=100,min=0,max=1000,step=50)
    
  #let cip = cxZIPort()
  #echo "Ip  : ",cip.ip
  #echo "Port: ",cip.port
  
  
  
  #echo cxZDisplayFile(tmpFilename())
  
  # still WIP
  #echo cxZCheckbox()
  #echo cxZlist()
