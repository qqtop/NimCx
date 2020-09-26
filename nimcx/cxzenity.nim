import nimcx

# Experimental
#
# zenity driven interfaces 
# zenity can be installed on linux
# maybe will become part of nimcx
#
# Last  : 2020-09-26
#


proc cxZDialog*(title:string="cxZDialog",text:string="Demo Text",hideText:bool=false ):string =
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
  
proc cxLoginDialog*(title:string="Login Dialog",text:string="Login"):tuple[name:string,password:string] =
     ## cxloginDialog
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
     var forms = execCmdEx("""zenity --forms --add-entry=Username --add-password=Password --add-calendar=Date --text="WriteBash.com Demo Form" --separator=';' --forms-date-format=%Y/%m/%d""").output
     forms.removeSuffix('\n')
     if forms == "":
        printLnAlertMsg("Login failed ! Incorrect credentials supplied. ")
        doFinish()
     else:    
        var fs = forms.split(";")
        result.name = fs[0]
        result.password = fs[1] 
        result.date = fs[2] 
        
proc cxZInfo*(infotext:string="Yes Stay_calm_carry_on") = 
   discard  execCmdEx("""zenity --info --text="$1" --no-wrap""" % infotext)
   
proc cxZQuestion*(ask:string = "How Are you ?",cancel:string="No",ok:string="Yes"):bool =
    ## cxZQuestion
    ##
    ##
    var quest = execCmdEx("""zenity --question --title="Question" --text="$1"  --cancel-label="$2" --ok-label="$3" --no-wrap""" % [ask,cancel,ok])
    quest.output.removeSuffix('\n')  
    if quest.exitcode == 0: #yes
       result = true
    else:
       result = false

proc cxZWarn*(warntext:string=" This is a warning ! Hope you head it ! ") =
     ## cxZWarn   
     ##
     ## display a warning message
     discard execCmd("""zenity --warning --text="$1" --no-wrap"""  % warntext)
     
proc cxZError*(errortext:string=" An error has occured ")=    
     ## cxError
     ##
     ## display an error message 
     discard execCmdEx("""zenity --error --text="$1" --no-wrap"""  % errortext)


proc cxZDisplayFile*(filename:string):string=
  ## display text file , text can be edited and will be returned edited, file remains unchanged
  let res = execCmdEx("""zenity --text-info --title="$1" --filename=$1 --editable --no-wrap"""  % filename)
  result = res.output


proc cxZDisplayHtmlFile*(filename:string):string=
   ## display html file ,, text can be edited and will be returned edited, file remains unchanged
   var res = execCmdEx("""zenity --text-info --title="WriteBash.com - demo text-info dialog" --filename=/home/danie/Desktop/test.html --editable --no-wrap --html """)
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
  # simple entry dialog
  var cxz  = cxZDialog("Secret1","Enter a secret",false)
  echo cxz
  #var cxz1 = cxZDialog("Secret2","Enter a secret",true) 
  
  #echo cxZdialog("Hello","Say something nice today !",false)
    
  # name,password,date dialog
  #var login = cxLoginDateDialog()
  #echo "Name : ",login.name 
  #echo "Pwd  : ",login.password
  #echo "Date : ",login.date
  
  
  #var login1 = cxLoginDialog()
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
