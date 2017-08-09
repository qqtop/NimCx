import cx,strutils

# Attention ! Gnu traffic ahead !
# The absolute must have gnu's ! Currently busy running about .

var ct = 0

proc unpa(s:seq):string =
        result = ""
        for x in 0.. <s.len:
            result = result & s[x]


proc gnuMe(j:int,xpos:int = 10) =
      clearup()
     
      rainbow2("\n WWWWWW||WWWWWW",xpos = xpos)
      echo()
      rainbow2("   W W W||W W W ",xpos = xpos)
      echo()
      rainbow2("        || ",xpos = xpos)
      echo()
      rainbow2("      ( OO )__________  ",xpos=xpos)
      echo()
      rainbow2("       /  |            \\ ",xpos = xpos)
      echo()
      rainbow2("      /o o| Niminator   \\   *",xpos = xpos)
      echo()
      rainbow2("      \\___/|| _||__|| _ ||-'",xpos = xpos)
      echo()
      rainbow2("            ||  ||  ||  || ",xpos = xpos)
      echo()
      rainbow2("           _|| _|| _|| _|| ",xpos = xpos)
      echo()
      rainbow2("          (__|(__|(__|(__| ",xpos = xpos) 
       
      # gnu2      
      var nxpos = j  
      curup(12)
      rainbow2("\n        WWWWWW||WWWWWW",xpos = nxpos)
      echo()
      rainbow2("           W W W||W W W ",xpos = nxpos)
      echo()
      rainbow2(unpa(reverseMe("         ||                ")),xpos = nxpos)
      echo()
      rainbow2(unpa(reverseMe("  ) OO (__________     ")),xpos = nxpos)
      echo()
      rainbow2(unpa(reverseMe("        \\   |             // ")),xpos = nxpos)
      echo()
      rainbow2(unpa(reverseMe(" \\ o o| xirtanimiN // *")),xpos = nxpos)
      echo()
      rainbow2(unpa(reverseMe("   //___\\|| _||__|| _||-'")),xpos = nxpos)
      echo()
      rainbow2(unpa(reverseMe("            ||  ||  ||  ||  ")),xpos = nxpos)
      echo()
      rainbow2(unpa(reverseMe("           _|| _|| _|| _||  ")),xpos = nxpos)
      echo()
      rainbow2(unpa(reverseMe("          )__|)__|)__|)__|  ")),xpos = nxpos) 
      echo()       
      
       
      decho(5)
      print(" Professional Gnu Sightings :  ",lightsalmon)
      curup(2)
      inc ct
      printSlim($ct,brightwhite,brightblue,xpos = 35)
      echo()
      sleepy(0.15)
     
for m in 1.. 3:
  for j in 1.. tw - 20: gnuMe(j * m + 1,xpos = tw - 20 - j )
doFinish()

