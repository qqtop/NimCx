{.deadCodeElim: on , optimization: speed.}

##     Library     : nimcx.nim
##     
##     Module      : cxconsts.nim
##
##     Status      : stable
##
##     License     : MIT opensource
##
##     Version     : 0.9.9
##
##     ProjectStart: 2015-06-20
##   
##     Latest      : 2017-11-26
##
##     Compiler    : Nim >= 0.17.x dev branch
##
##     OS          : Linux
##
##     Docs        : https://qqtop.github.io/cxconsts.html
##
##     Description : this file is part of nimcx and contains all public const declarations
## 
##                   it is automatically imported and exported by cx.nim
## 
## 
## 

import terminal,sequtils, strutils
 
proc getfg(fg:ForegroundColor):string =
    var gFG = ord(fg)
    result = "\e[" & $gFG & 'm'

proc getbg(bg:BackgroundColor):string =
    var gBG = ord(bg)
    result = "\e[" & $gBG & 'm'

proc fbright(fg:ForegroundColor): string =
    var gFG = ord(fg)
    inc(gFG, 60)
    result = "\e[" & $gFG & 'm'

proc bbright(bg:BackgroundColor): string =
    var gBG = ord(bg)
    inc(gBG, 60)
    result = "\e[" & $gBG & 'm' 
 
 
const
      # block chars for font building 
      efb1* = "▀"
      efb2* = "▒"
      efb3* = "▃"
      efl1* = "▍"
      efr1* = "▇"
      efr2* = "⛆"
      efs2* = "▨"   
      
const
      cfb2* = "△"
      # circles
      cfb4* = "⭕"    # shadowed circle
      cfb5* = "⬤"   # black circle

const

      # Terminal consts for bash terminal cleanup
      # mileage may very on your system
      #
      # usage : print clearbol
      #         printLn(cleareol,green,red,xpos = 20)
      #
      clearbol*      =   "\x1b[1K"         ## clear to begin of line
      cleareol*      =   "\x1b[K"          ## clear to end of line
      clearscreen*   =   "\x1b[2J\x1b[H"   ## clear screen
      clearline*     =   "\x1b[2K\x1b[G"   ## clear line
      clearbos*      =   "\x1b[1J"         ## clear to begin of screen
      cleareos*      =   "\x1b[J"          ## clear to end of screen
      resetcols*     =   "\x1b[0m"         ## reset colors

const

      # Terminal consts for bash movements ( still testing )
      cup*      = "\x1b[A"      # ok
      cdown*    = "\x1b[B"      # ok
      cright*   = "\x1b[C"      # ok
      cleft*    = "\x1b[D"      # ok
      cend*     = "\x1b[F"      # no effect
      cpos1*    = "\x1b[H"      # ok moves cursor to screen position 0/0
      cins*     = "\x1b[2~"     # no effect
      cdel*     = "\x1b[3~"     # no effect
      cpgup*    = "\x1b[5~"     # no effect
      cpgdn*    = "\x1b[6~"     # no effect
      csave*     = "\x1b[s"     # ok saves last xpos (but not ypos)
      crestore*  = "\x1b[u"     # ok restores saved xpos
      chide*     = "\x1b[?25l"  # ok hide cursor
      cshow*     = "\x1b[?25h"  # ok show cursor


const
      # Terminal ForegroundColor Normal

      termred*              = getfg(fgRed)
      termgreen*            = getfg(fgGreen)
      termblue*             = getfg(fgBlue)
      termcyan*             = getfg(fgCyan)
      termyellow*           = getfg(fgYellow)
      termwhite*            = getfg(fgWhite)
      termblack*            = getfg(fgBlack)
      termmagenta*          = getfg(fgMagenta)

      # Terminal ForegroundColor Bright

      brightred*            = fbright(fgRed)
      brightgreen*          = fbright(fgGreen)
      brightblue*           = fbright(fgBlue)
      brightcyan*           = fbright(fgCyan)
      brightyellow*         = fbright(fgYellow)
      brightwhite*          = fbright(fgWhite)
      brightmagenta*        = fbright(fgMagenta)
      brightblack*          = fbright(fgBlack)

      clrainbow*            = "clrainbow"

      # Terminal BackgroundColor Normal

      bred*                 = getbg(bgRed)
      bgreen*               = getbg(bgGreen)
      bblue*                = getbg(bgBlue)
      bcyan*                = getbg(bgCyan)
      byellow*              = getbg(bgYellow)
      bwhite*               = getbg(bgWhite)
      bblack*               = getbg(bgBlack)
      bmagenta*             = getbg(bgMagenta)

      # Terminal BackgroundColor Bright

      bbrightred*           = bbright(bgRed)
      bbrightgreen*         = bbright(bgGreen)
      bbrightblue*          = bbright(bgBlue)
      bbrightcyan*          = bbright(bgCyan)
      bbrightyellow*        = bbright(bgYellow)
      bbrightwhite*         = bbright(bgWhite)
      bbrightmagenta*       = bbright(bgMagenta)
      bbrightblack*         = bbright(bgBlack)
      
     

      # Pastel color set

      pastelgreen*          =  "\x1b[38;2;179;226;205m"
      pastelorange*         =  "\x1b[38;2;253;205;172m"
      pastelblue*           =  "\x1b[38;2;203;213;232m"
      pastelpink*           =  "\x1b[38;2;244;202;228m"
      pastelyellowgreen*    =  "\x1b[38;2;230;245;201m"
      pastelyellow*         =  "\x1b[38;2;255;242;174m"
      pastelbeige*          =  "\x1b[38;2;241;226;204m"
      pastelwhite*          =  "\x1b[38;2;204;204;204m"
      
      # WIP  background escape seqs colors
      # Note colornames ending with bg or Ibg are currently only available via echo command
      pastelgreenbg*        = "\x1b[48;2;179;226;205m"
      pastelorangebg*       = "\x1b[48;2;253;205;172m"
      pastelbluebg*         = "\x1b[48;2;203;213;232m"
      pastelpinkbg*         = "\x1b[48;2;244;202;228m"
      pastelyellowgreenbg*  = "\x1b[48;2;230;245;201m"
      pastelyellowbg*       = "\x1b[48;2;255;242;174m"
      pastelbeigebg*        = "\x1b[48;2;241;226;204m"
      pastelwhitebg*        = "\x1b[48;2;204;204;204m"
      
      
      # a few colors with intensity bit set , but used only for testing as the results are confusing
      pastelgreenIbg*       = "\x1b[48;5;179;226;205m"    # intense bit set gives some unexpected colors
      pastelorangeIbg*      = "\x1b[48;5;253;205;172m"
      pastelblueIbg*        = "\x1b[48;5;203;213;232m"
      pastelpinkIbg*        = "\x1b[48;5;244;202;228m"
      
      
      # TODO :  more colors
      
      # other colors of interest
      # https://www.w3schools.com/colors/colors_trends.asp
      # http://www.javascripter.net/faq/hextorgb.htm
      truetomato*           =   "\x1b[38;2;255;100;0m"
      bigdip*               =   "\x1b[38;2;156;37;66m"
      greenery*             =   "\x1b[38;2;136;176;75m"     
      bluey*                =   "\x1b[38;2;41;194;102m"    # not displaying , showing default bluishgreen
      
      # other colors of interest with background bit set
      
      truetomatobg*         =   "\x1b[48;2;255;100;0m"
      greenerybg*           =   "\x1b[48;2;136;176;75m"
      blueybg*              =   "\x1b[48;2;41;194;102m"
      
      # colors lifted from colors.nim and massaged into rgb escape seqs

      aliceblue*            =  "\x1b[38;2;240;248;255m"
      antiquewhite*         =  "\x1b[38;2;250;235;215m"
      aqua*                 =  "\x1b[38;2;0;255;255m"
      aquamarine*           =  "\x1b[38;2;127;255;212m"
      azure*                =  "\x1b[38;2;240;255;255m"
      beige*                =  "\x1b[38;2;245;245;220m"
      bisque*               =  "\x1b[38;2;255;228;196m"
      black*                =  "\x1b[38;2;0;0;0m"
      blanchedalmond*       =  "\x1b[38;2;255;235;205m"
      blue*                 =  "\x1b[38;2;0;0;255m"
      blueviolet*           =  "\x1b[38;2;138;43;226m"
      brown*                =  "\x1b[38;2;165;42;42m"
      burlywood*            =  "\x1b[38;2;222;184;135m"
      cadetblue*            =  "\x1b[38;2;95;158;160m"
      chartreuse*           =  "\x1b[38;2;127;255;0m"
      chocolate*            =  "\x1b[38;2;210;105;30m"
      coral*                =  "\x1b[38;2;255;127;80m"
      cornflowerblue*       =  "\x1b[38;2;100;149;237m"
      cornsilk*             =  "\x1b[38;2;255;248;220m"
      crimson*              =  "\x1b[38;2;220;20;60m"
      cyan*                 =  "\x1b[38;2;0;255;255m"
      darkblue*             =  "\x1b[38;2;0;0;139m"
      darkcyan*             =  "\x1b[38;2;0;139;139m"
      darkgoldenrod*        =  "\x1b[38;2;184;134;11m"
      darkgray*             =  "\x1b[38;2;169;169;169m"
      darkgreen*            =  "\x1b[38;2;0;100;0m"
      darkkhaki*            =  "\x1b[38;2;189;183;107m"
      darkmagenta*          =  "\x1b[38;2;139;0;139m"
      darkolivegreen*       =  "\x1b[38;2;85;107;47m"
      darkorange*           =  "\x1b[38;2;255;140;0m"
      darkorchid*           =  "\x1b[38;2;153;50;204m"
      darkred*              =  "\x1b[38;2;139;0;0m"
      darksalmon*           =  "\x1b[38;2;233;150;122m"
      darkseagreen*         =  "\x1b[38;2;143;188;143m"
      darkslateblue*        =  "\x1b[38;2;72;61;139m"
      darkslategray*        =  "\x1b[38;2;47;79;79m"
      darkturquoise*        =  "\x1b[38;2;0;206;209m"
      darkviolet*           =  "\x1b[38;2;148;0;211m"
      deeppink*             =  "\x1b[38;2;255;20;147m"
      deepskyblue*          =  "\x1b[38;2;0;191;255m"
      dimgray*              =  "\x1b[38;2;105;105;105m"
      dodgerblue*           =  "\x1b[38;2;30;144;255m"
      firebrick*            =  "\x1b[38;2;178;34;34m"
      floralwhite*          =  "\x1b[38;2;255;250;240m"
      forestgreen*          =  "\x1b[38;2;34;139;34m"
      fuchsia*              =  "\x1b[38;2;255;0;255m"
      gainsboro*            =  "\x1b[38;2;220;220;220m"
      ghostwhite*           =  "\x1b[38;2;248;248;255m"
      gold*                 =  "\x1b[38;2;255;215;0m"
      goldenrod*            =  "\x1b[38;2;218;165;32m"
      gray*                 =  "\x1b[38;2;128;128;128m"
      green*                =  "\x1b[38;2;0;128;0m"
      greenyellow*          =  "\x1b[38;2;173;255;47m"
      honeydew*             =  "\x1b[38;2;240;255;240m"
      hotpink*              =  "\x1b[38;2;255;105;180m"
      indianred*            =  "\x1b[38;2;205;92;92m"
      indigo*               =  "\x1b[38;2;75;0;130m"
      ivory*                =  "\x1b[38;2;255;255;240m"
      khaki*                =  "\x1b[38;2;240;230;140m"
      lavender*             =  "\x1b[38;2;230;230;250m"
      lavenderblush*        =  "\x1b[38;2;255;240;245m"
      lawngreen*            =  "\x1b[38;2;124;252;0m"
      lemonchiffon*         =  "\x1b[38;2;255;250;205m"
      lightblue*            =  "\x1b[38;2;173;216;230m"
      lightcoral*           =  "\x1b[38;2;240;128;128m"
      lightcyan*            =  "\x1b[38;2;224;255;255m"
      lightgoldenrodyellow* =  "\x1b[38;2;250;250;210m"
      lightgrey*            =  "\x1b[38;2;211;211;211m"
      lightgreen*           =  "\x1b[38;2;144;238;144m"
      lightpink*            =  "\x1b[38;2;255;182;193m"
      lightsalmon*          =  "\x1b[38;2;255;160;122m"
      lightseagreen*        =  "\x1b[38;2;32;178;170m"
      lightskyblue*         =  "\x1b[38;2;135;206;250m"
      lightslategray*       =  "\x1b[38;2;119;136;153m"
      lightsteelblue*       =  "\x1b[38;2;176;196;222m"
      lightyellow*          =  "\x1b[38;2;255;255;224m"
      lime*                 =  "\x1b[38;2;0;255;0m"
      limegreen*            =  "\x1b[38;2;50;205;50m"
      linen*                =  "\x1b[38;2;250;240;230m"
      magenta*              =  "\x1b[38;2;255;0;255m"
      maroon*               =  "\x1b[38;2;128;0;0m"
      mediumaquamarine*     =  "\x1b[38;2;102;205;170m"
      mediumblue*           =  "\x1b[38;2;0;0;205m"
      mediumorchid*         =  "\x1b[38;2;186;85;211m"
      mediumpurple*         =  "\x1b[38;2;147;112;216m"
      mediumseagreen*       =  "\x1b[38;2;60;179;113m"
      mediumslateblue*      =  "\x1b[38;2;123;104;238m"
      mediumspringgreen*    =  "\x1b[38;2;0;250;154m"
      mediumturquoise*      =  "\x1b[38;2;72;209;204m"
      mediumvioletred*      =  "\x1b[38;2;199;21;133m"
      midnightblue*         =  "\x1b[38;2;25;25;112m"
      mintcream*            =  "\x1b[38;2;245;255;250m"
      mistyrose*            =  "\x1b[38;2;255;228;225m"
      moccasin*             =  "\x1b[38;2;255;228;181m"
      navajowhite*          =  "\x1b[38;2;255;222;173m"
      navy*                 =  "\x1b[38;2;0;0;128m"
      oldlace*              =  "\x1b[38;2;253;245;230m"
      olive*                =  "\x1b[38;2;128;128;0m"
      olivedrab*            =  "\x1b[38;2;107;142;35m"
      orange*               =  "\x1b[38;2;255;165;0m"
      orangered*            =  "\x1b[38;2;255;69;0m"
      orchid*               =  "\x1b[38;2;218;112;214m"
      palegoldenrod*        =  "\x1b[38;2;238;232;170m"
      palegreen*            =  "\x1b[38;2;152;251;152m"
      paleturquoise*        =  "\x1b[38;2;175;238;238m"
      palevioletred*        =  "\x1b[38;2;216;112;147m"
      papayawhip*           =  "\x1b[38;2;255;239;213m"
      peachpuff*            =  "\x1b[38;2;255;218;185m"
      peru*                 =  "\x1b[38;2;205;133;63m"
      pink*                 =  "\x1b[38;2;255;192;203m"
      plum*                 =  "\x1b[38;2;221;160;221m"
      powderblue*           =  "\x1b[38;2;176;224;230m"
      purple*               =  "\x1b[38;2;128;0;128m"
      red*                  =  "\x1b[38;2;255;0;0m"
      rosybrown*            =  "\x1b[38;2;188;143;143m"
      royalblue*            =  "\x1b[38;2;65;105;225m"
      saddlebrown*          =  "\x1b[38;2;139;69;19m"
      salmon*               =  "\x1b[38;2;250;128;114m"
      sandybrown*           =  "\x1b[38;2;244;164;96m"
      seagreen*             =  "\x1b[38;2;46;139;87m"
      seashell*             =  "\x1b[38;2;255;245;238m"
      sienna*               =  "\x1b[38;2;160;82;45m"
      silver*               =  "\x1b[38;2;192;192;192m"
      skyblue*              =  "\x1b[38;2;135;206;235m"
      slateblue*            =  "\x1b[38;2;106;90;205m"
      slategray*            =  "\x1b[38;2;112;128;144m"
      snow*                 =  "\x1b[38;2;255;250;250m"
      springgreen*          =  "\x1b[38;2;0;255;127m"
      steelblue*            =  "\x1b[38;2;70;130;180m"
      tan*                  =  "\x1b[38;2;210;180;140m"
      teal*                 =  "\x1b[38;2;0;128;128m"
      thistle*              =  "\x1b[38;2;216;191;216m"
      tomato*               =  "\x1b[38;2;255;99;71m"
      turquoise*            =  "\x1b[38;2;64;224;208m"
      violet*               =  "\x1b[38;2;238;130;238m"
      wheat*                =  "\x1b[38;2;245;222;179m"
      white*                =  "\x1b[38;2;255;255;255m"    # same as brightwhite
      whitesmoke*           =  "\x1b[38;2;245;245;245m"
      yellow*               =  "\x1b[38;2;255;255;0m"
      yellowgreen*          =  "\x1b[38;2;154;205;50m"
      zcolor*               =  "\x1b[38;2;255;111;210m"
      zippi*                =  "\x1b[38;2;79;196;132m"     # maybe not displaying , showing default blueish green

# all colors except original terminal colors
const colorNames* = @[
      ("aliceblue", aliceblue),
      ("antiquewhite", antiquewhite),
      ("aqua", aqua),
      ("aquamarine", aquamarine),
      ("azure", azure),
      ("beige", beige),
      ("bigdip",bigdip),
      ("bisque", bisque),
      ("black", black),
      ("blanchedalmond", blanchedalmond),
      ("blue", blue),
      ("blueviolet", blueviolet),
      ("bluey",bluey),
      ("blueybg",blueybg),
      ("brown", brown),
      ("burlywood", burlywood),
      ("cadetblue", cadetblue),
      ("chartreuse", chartreuse),
      ("chocolate", chocolate),
      ("coral", coral),
      ("cornflowerblue", cornflowerblue),
      ("cornsilk", cornsilk),
      ("crimson", crimson),
      ("cyan", cyan),
      ("darkblue", darkblue),
      ("darkcyan", darkcyan),
      ("darkgoldenrod", darkgoldenrod),
      ("darkgray", darkgray),
      ("darkgreen", darkgreen),
      ("darkkhaki", darkkhaki),
      ("darkmagenta", darkmagenta),
      ("darkolivegreen", darkolivegreen),
      ("darkorange", darkorange),
      ("darkorchid", darkorchid),
      ("darkred", darkred),
      ("darksalmon", darksalmon),
      ("darkseagreen", darkseagreen),
      ("darkslateblue", darkslateblue),
      ("darkslategray", darkslategray),
      ("darkturquoise", darkturquoise),
      ("darkviolet", darkviolet),
      ("deeppink", deeppink),
      ("deepskyblue", deepskyblue),
      ("dimgray", dimgray),
      ("dodgerblue", dodgerblue),
      ("firebrick", firebrick),
      ("floralwhite", floralwhite),
      ("forestgreen", forestgreen),
      ("fuchsia", fuchsia),
      ("gainsboro", gainsboro),
      ("ghostwhite", ghostwhite),
      ("gold", gold),
      ("goldenrod", goldenrod),
      ("gray", gray),
      ("green", green),
      ("greenery",greenery),
      ("greenerybg",greenerybg),
      ("greenyellow", greenyellow),
      ("honeydew", honeydew),
      ("hotpink", hotpink),
      ("indianred", indianred),
      ("indigo", indigo),
      ("ivory", ivory),
      ("khaki", khaki),
      ("lavender", lavender),
      ("lavenderblush", lavenderblush),
      ("lawngreen", lawngreen),
      ("lemonchiffon", lemonchiffon),
      ("lightblue", lightblue),
      ("lightcoral", lightcoral),
      ("lightcyan", lightcyan),
      ("lightgoldenrodyellow", lightgoldenrodyellow),
      ("lightgrey", lightgrey),
      ("lightgreen", lightgreen),
      ("lightpink", lightpink),
      ("lightsalmon", lightsalmon),
      ("lightseagreen", lightseagreen),
      ("lightskyblue", lightskyblue),
      ("lightslategray", lightslategray),
      ("lightsteelblue", lightsteelblue),
      ("lightyellow", lightyellow),
      ("lime", lime),
      ("limegreen", limegreen),
      ("linen", linen),
      ("magenta", magenta),
      ("maroon", maroon),
      ("mediumaquamarine", mediumaquamarine),
      ("mediumblue", mediumblue),
      ("mediumorchid", mediumorchid),
      ("mediumpurple", mediumpurple),
      ("mediumseagreen", mediumseagreen),
      ("mediumslateblue", mediumslateblue),
      ("mediumspringgreen", mediumspringgreen),
      ("mediumturquoise", mediumturquoise),
      ("mediumvioletred", mediumvioletred),
      ("midnightblue", midnightblue),
      ("mintcream", mintcream),
      ("mistyrose", mistyrose),
      ("moccasin", moccasin),
      ("navajowhite", navajowhite),
      ("navy", navy),
      ("oldlace", oldlace),
      ("olive", olive),
      ("olivedrab", olivedrab),
      ("orange", orange),
      ("orangered", orangered),
      ("orchid", orchid),
      ("palegoldenrod", palegoldenrod),
      ("palegreen", palegreen),
      ("paleturquoise", paleturquoise),
      ("palevioletred", palevioletred),
      ("papayawhip", papayawhip),
      ("peachpuff", peachpuff),
      ("peru", peru),
      ("pink", pink),
      ("plum", plum),
      ("powderblue", powderblue),
      ("purple", purple),
      ("red", red),
      ("rosybrown", rosybrown),
      ("royalblue", royalblue),
      ("saddlebrown", saddlebrown),
      ("salmon", salmon),
      ("sandybrown", sandybrown),
      ("seagreen", seagreen),
      ("seashell", seashell),
      ("sienna", sienna),
      ("silver", silver),
      ("skyblue", skyblue),
      ("slateblue", slateblue),
      ("slategray", slategray),
      ("snow", snow),
      ("springgreen", springgreen),
      ("steelblue", steelblue),
      ("tan", tan),
      ("teal", teal),
      ("thistle", thistle),
      ("tomato", tomato),
      ("turquoise", turquoise),
      ("violet", violet),
      ("wheat", wheat),
      ("white", white),
      ("whitesmoke", whitesmoke),
      ("yellow", yellow),
      ("yellowgreen", yellowgreen),
      ("pastelbeige",pastelbeige),
      ("pastelbeigebg",pastelbeigebg),
      ("pastelblue",pastelblue),
      ("pastelbluebg",pastelbluebg),
      ("pastelgreen",pastelgreen),
      ("pastelgreenbg",pastelgreenbg),
      ("pastelorange",pastelorange),
      ("pastelorangebg",pastelorangebg),
      ("pastelpink",pastelpink),
      ("pastelpinkbg",pastelpinkbg),
      ("pastelwhite",pastelwhite),
      ("pastelwhitebg",pastelwhitebg),
      ("pastelyellow",pastelyellow),
      ("pastelyellowbg",pastelyellowbg),
      ("pastelyellowgreen",pastelyellowgreen),
      ("pastelyellowgreenbg",pastelyellowgreenbg),
      ("truetomato",truetomato),
      ("truetomatobg",truetomatobg),
      ("zcolor",zcolor),
      ("zippi",zippi)]

 
#hexColorNames used in eg svg creation      
const hexColorNames* = @[
        "#F0F8FF",
        "#FAEBD7",
        "#00FFFF",
        "#7FFFD4",
        "#F0FFFF",
        "#F5F5DC",
        "#FFE4C4",
        "#000000",
        "#FFEBCD",
        "#0000FF",
        "#8A2BE2",
        "#A52A2A",
        "#DEB887",
        "#5F9EA0",
        "#7FFF00",
        "#D2691E",
        "#FF7F50",
        "#6495ED",
        "#FFF8DC",
        "#DC143C",
        "#00FFFF",
        "#00008B",
        "#008B8B",
        "#B8860B",
        "#A9A9A9",
        "#006400",
        "#BDB76B",
        "#8B008B",
        "#556B2F",
        "#FF8C00",
        "#9932CC",
        "#8B0000",
        "#E9967A",
        "#8FBC8F",
        "#483D8B",
        "#2F4F4F",
        "#00CED1",
        "#9400D3",
        "#FF1493",
        "#00BFFF",
        "#696969",
        "#1E90FF",
        "#B22222",
        "#FFFAF0",
        "#228B22",
        "#FF00FF",
        "#DCDCDC",
        "#F8F8FF",
        "#FFD700",
        "#DAA520",
        "#808080",
        "#008000",
        "#ADFF2F",
        "#F0FFF0",
        "#FF69B4",
        "#CD5C5C",
        "#4B0082",
        "#FFFFF0",
        "#F0E68C",
        "#E6E6FA",
        "#FFF0F5",
        "#7CFC00",
        "#FFFACD",
        "#ADD8E6",
        "#F08080",
        "#E0FFFF",
        "#FAFAD2",
        "#D3D3D3",
        "#90EE90",
        "#FFB6C1",
        "#FFA07A",
        "#20B2AA",
        "#87CEFA",
        "#778899",
        "#B0C4DE",
        "#FFFFE0",
        "#00FF00",
        "#32CD32",
        "#FAF0E6",
        "#FF00FF",
        "#800000",
        "#66CDAA",
        "#0000CD",
        "#BA55D3",
        "#9370D8",
        "#3CB371",
        "#7B68EE",
        "#00FA9A",
        "#48D1CC",
        "#C71585",
        "#191970",
        "#F5FFFA",
        "#FFE4E1",
        "#FFE4B5",
        "#FFDEAD",
        "#000080",
        "#FDF5E6",
        "#808000",
        "#6B8E23",
        "#FFA500",
        "#FF4500",
        "#DA70D6",
        "#EEE8AA",
        "#98FB98",
        "#AFEEEE",
        "#D87093",
        "#FFEFD5",
        "#FFDAB9",
        "#CD853F",
        "#FFC0CB",
        "#DDA0DD",
        "#B0E0E6",
        "#800080",
        "#FF0000",
        "#BC8F8F",
        "#4169E1",
        "#8B4513",
        "#FA8072",
        "#F4A460",
        "#2E8B57",
        "#FFF5EE",
        "#A0522D",
        "#C0C0C0",
        "#87CEEB",
        "#6A5ACD",
        "#708090",
        "#FFFAFA",
        "#00FF7F",
        "#4682B4",
        "#D2B48C",
        "#008080",
        "#D8BFD8",
        "#FF6347",
        "#40E0D0",
        "#EE82EE",
        "#F5DEB3",
        "#FFFFFF",
        "#F5F5F5",
        "#FFFF00",
        "#9ACD32"]
 
      
# Color reference in hex and rgb  for colors mentioned in colors.nim
#       
# aliceblue            #F0F8FF       240   248   255
# antiquewhite         #FAEBD7       250   235   215                                                                                     
# aqua                 #00FFFF         0   255   255                                                                                     
# aquamarine           #7FFFD4       127   255   212                                                                                     
# azure                #F0FFFF       240   255   255                                                                                     
# beige                #F5F5DC       245   245   220                                                                                     
# bisque               #FFE4C4       255   228   196                                                                                     
# black                #000000         0     0     0                                                                                     
# blanchedalmond       #FFEBCD       255   235   205                                                                                     
# blue                 #0000FF         0     0   255                                                                                     
# blueviolet           #8A2BE2       138    43   226                                                                                     
# brown                #A52A2A       165    42    42                                                                                     
# burlywood            #DEB887       222   184   135                                                                                     
# cadetblue            #5F9EA0        95   158   160                                                                                     
# chartreuse           #7FFF00       127   255     0                                                                                     
# chocolate            #D2691E       210   105    30                                                                                     
# coral                #FF7F50       255   127    80                                                                                     
# cornflowerblue       #6495ED       100   149   237                                                                                     
# cornsilk             #FFF8DC       255   248   220                                                                                     
# crimson              #DC143C       220    20    60                                                                                     
# cyan                 #00FFFF         0   255   255                                                                                     
# darkblue             #00008B         0     0   139                                                                                     
# darkcyan             #008B8B         0   139   139                                                                                     
# darkgoldenrod        #B8860B       184   134    11                                                                                     
# darkgray             #A9A9A9       169   169   169                                                                                     
# darkgreen            #006400         0   100     0                                                                                     
# darkkhaki            #BDB76B       189   183   107                                                                                     
# darkmagenta          #8B008B       139     0   139                                                                                     
# darkolivegreen       #556B2F        85   107    47                                                                                     
# darkorange           #FF8C00       255   140     0                                                                                     
# darkorchid           #9932CC       153    50   204                                                                                     
# darkred              #8B0000       139     0     0                                                                                     
# darksalmon           #E9967A       233   150   122                                                                                     
# darkseagreen         #8FBC8F       143   188   143                                                                                     
# darkslateblue        #483D8B        72    61   139                                                                                     
# darkslategray        #2F4F4F        47    79    79                                                                                     
# darkturquoise        #00CED1         0   206   209                                                                                     
# darkviolet           #9400D3       148     0   211                                                                                     
# deeppink             #FF1493       255    20   147                                                                                     
# deepskyblue          #00BFFF         0   191   255                                                                                     
# dimgray              #696969       105   105   105                                                                                     
# dodgerblue           #1E90FF        30   144   255                                                                                     
# firebrick            #B22222       178    34    34                                                                                     
# floralwhite          #FFFAF0       255   250   240                                                                                     
# forestgreen          #228B22        34   139    34                                                                                     
# fuchsia              #FF00FF       255     0   255                                                                                     
# gainsboro            #DCDCDC       220   220   220                                                                                     
# ghostwhite           #F8F8FF       248   248   255                                                                                     
# gold                 #FFD700       255   215     0                                                                                     
# goldenrod            #DAA520       218   165    32                                                                                     
# gray                 #808080       128   128   128                                                                                     
# green                #008000         0   128     0                                                                                     
# greenyellow          #ADFF2F       173   255    47                                                                                     
# honeydew             #F0FFF0       240   255   240                                                                                     
# hotpink              #FF69B4       255   105   180                                                                                     
# indianred            #CD5C5C       205    92    92                                                                                     
# indigo               #4B0082        75     0   130                                                                                     
# ivory                #FFFFF0       255   255   240                                                                                     
# khaki                #F0E68C       240   230   140                                                                                     
# lavender             #E6E6FA       230   230   250                                                                                     
# lavenderblush        #FFF0F5       255   240   245                                                                                     
# lawngreen            #7CFC00       124   252     0                                                                                     
# lemonchiffon         #FFFACD       255   250   205                                                                                     
# lightblue            #ADD8E6       173   216   230                                                                                     
# lightcoral           #F08080       240   128   128                                                                                     
# lightcyan            #E0FFFF       224   255   255                                                                                     
# lightgoldenrodyellow #FAFAD2       250   250   210                                                                                     
# lightgrey            #D3D3D3       211   211   211                                                                                     
# lightgreen           #90EE90       144   238   144                                                                                     
# lightpink            #FFB6C1       255   182   193                                                                                     
# lightsalmon          #FFA07A       255   160   122                                                                                     
# lightseagreen        #20B2AA        32   178   170                                                                                     
# lightskyblue         #87CEFA       135   206   250                                                                                     
# lightslategray       #778899       119   136   153                                                                                     
# lightsteelblue       #B0C4DE       176   196   222                                                                                     
# lightyellow          #FFFFE0       255   255   224                                                                                     
# lime                 #00FF00         0   255     0                                                                                     
# limegreen            #32CD32        50   205    50                                                                                     
# linen                #FAF0E6       250   240   230                                                                                     
# magenta              #FF00FF       255     0   255                                                                                     
# maroon               #800000       128     0     0                                                                                     
# mediumaquamarine     #66CDAA       102   205   170                                                                                     
# mediumblue           #0000CD         0     0   205                                                                                     
# mediumorchid         #BA55D3       186    85   211                                                                                     
# mediumpurple         #9370D8       147   112   216                                                                                     
# mediumseagreen       #3CB371        60   179   113                                                                                     
# mediumslateblue      #7B68EE       123   104   238                                                                                     
# mediumspringgreen    #00FA9A         0   250   154                                                                                     
# mediumturquoise      #48D1CC        72   209   204                                                                                     
# mediumvioletred      #C71585       199    21   133                                                                                     
# midnightblue         #191970        25    25   112                                                                                     
# mintcream            #F5FFFA       245   255   250                                                                                     
# mistyrose            #FFE4E1       255   228   225                                                                                     
# moccasin             #FFE4B5       255   228   181                                                                                     
# navajowhite          #FFDEAD       255   222   173                                                                                     
# navy                 #000080         0     0   128                                                                                     
# oldlace              #FDF5E6       253   245   230                                                                                     
# olive                #808000       128   128     0                                                                                     
# olivedrab            #6B8E23       107   142    35                                                                                     
# orange               #FFA500       255   165     0                                                                                     
# orangered            #FF4500       255    69     0                                                                                     
# orchid               #DA70D6       218   112   214                                                                                     
# palegoldenrod        #EEE8AA       238   232   170                                                                                     
# palegreen            #98FB98       152   251   152                                                                                     
# paleturquoise        #AFEEEE       175   238   238                                                                                     
# palevioletred        #D87093       216   112   147                                                                                     
# papayawhip           #FFEFD5       255   239   213                                                                                     
# peachpuff            #FFDAB9       255   218   185                                                                                     
# peru                 #CD853F       205   133    63                                                                                     
# pink                 #FFC0CB       255   192   203                                                                                     
# plum                 #DDA0DD       221   160   221                                                                                     
# powderblue           #B0E0E6       176   224   230                                                                                     
# purple               #800080       128     0   128                                                                                     
# red                  #FF0000       255     0     0                                                                                     
# rosybrown            #BC8F8F       188   143   143                                                                                     
# royalblue            #4169E1        65   105   225                                                                                     
# saddlebrown          #8B4513       139    69    19                                                                                     
# salmon               #FA8072       250   128   114                                                                                     
# sandybrown           #F4A460       244   164    96                                                                                     
# seagreen             #2E8B57        46   139    87                                                                                     
# seashell             #FFF5EE       255   245   238                                                                                     
# sienna               #A0522D       160    82    45                                                                                     
# silver               #C0C0C0       192   192   192                                                                                     
# skyblue              #87CEEB       135   206   235                                                                                     
# slateblue            #6A5ACD       106    90   205                                                                                     
# slategray            #708090       112   128   144                                                                                     
# snow                 #FFFAFA       255   250   250                                                                                     
# springgreen          #00FF7F         0   255   127                                                                                     
# steelblue            #4682B4        70   130   180                                                                                     
# tan                  #D2B48C       210   180   140                                                                                     
# teal                 #008080         0   128   128
# thistle              #D8BFD8       216   191   216
# tomato               #FF6347       255    99    71
# turquoise            #40E0D0        64   224   208
# violet               #EE82EE       238   130   238
# wheat                #F5DEB3       245   222   179
# white                #FFFFFF       255   255   255
# whitesmoke           #F5F5F5       245   245   245
# yellow               #FFFF00       255   255     0
# yellowgreen          #9ACD32       154   205    50      
      
      
      
const
  # used by spellInteger,spellFloat
  tens* =  ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]
  small* = ["zero", "one", "two", "three", "four", "five", "six", "seven",
           "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
           "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
  huge* =  ["", "", "million", "billion", "trillion", "quadrillion",
           "quintillion", "sextillion", "septillion", "octillion", "nonillion","decillion"]
 
 
  pastelSet* = [pastelgreen,pastelbeige,pastelpink,pastelblue,pastelwhite,pastelorange,pastelyellow]

# slim numbers can be used with printSlimNumber

const snumber0* =
  @["┌─┐",
    "│ │",
    "└─┘"]


const snumber1* =
  @["  ╷",
    "  │",
    "  ╵"]

const snumber2* =
  @["╶─┐",
    "┌─┘",
    "└─╴"]

const snumber3* =
  @["╶─┐",
    "╶─┤",
    "╶─┘"]

const snumber4* =
  @["╷ ╷",
    "└─┤",
    "  ╵"]

const snumber5* =
  @["┌─╴",
    "└─┐",
    "╶─┘"]

const snumber6* =
  @["┌─╴",
    "├─┐",
    "└─┘"]

const snumber7* =
  @["╶─┐",
    "  │",
    "  ╵"]

const snumber8* =
  @["┌─┐",
    "├─┤",
    "└─┘"]

const snumber9* =
  @["┌─┐",
    "└─┤",
    "╶─┘"]


const scolon* =
  @["╷ ",
    "╷ ",
    "  "]


const scomma* =
   @["  ",
     "  ",
     "╷ "]

const sdot* =
   @["  ",
     "  ",
     ". "]


const sblank* =
   @["  ",
     "  ",
     "  "]

var slimNumberSet* = newSeq[string]()
for x in 0.. 9: slimNumberSet.add($(x))
var slimCharSet*   = @[",",".",":"," "]
# 


# arrows

const 
      leftarrow*       = "\u2190"
      uparrow*         = "\u2191"
      rightarrow*      = "\u2192"
      downarrow*       = "\u2193"
      leftrightarrow*  = "\u2194"
      updownaarrow*    = "\u2195"
      northwestarrow*  = "\u2196"
      northeastarrow*  = "\u2197"
      southwestarrow*  = "\u2198"
      southeastarrow*  = "\u2199"

      phone*           = "\u260E"
      fullflag*        = "\u2691"
      enterkey*        = "↵"
      sigma*           = "Σ"
      loopedsquare*    = "⌘"

# emojis
# mileage here may vary depending on whatever your system supports

const
    # emoji len 3
    check*              =  "\xE2\x9C\x93"
    xmark*              =  "\xE2\x9C\x98"
    heart*              =  "\xE2\x9D\xA4"
    sun*                =  "\xE2\x98\x80"
    star*               =  "\xE2\x98\x85"
    darkstar*           =  "\xE2\x98\x86"
    umbrella*           =  "\xE2\x98\x82"
    flag*               =  "\xE2\x9A\x91"
    snowflake*          =  "\xE2\x9D\x84"
    music*              =  "\xE2\x99\xAB"
    scissors*           =  "\xE2\x9C\x82"
    trademark*          =  "\xE2\x84\xA2"
    copyright*          =  "\xC2\xA9"
    roof*               =  "\xEF\xA3\xBF"
    skull*              =  "\xE2\x98\xA0"
    smile*              =  "\xE2\x98\xBA"
    # emoji len 4
    smiley*             =  "😃"
    innocent*           =  "😇"
    lol*                =  "😂"
    tongue*             =  "😛"
    blush*              =  "😊"
    sad*                =  "😟"
    cry*                =  "😢"
    rage*               =  "😡"
    cat*                =  "😺"
    kitty*              =  "🐱"
    monkey*             =  "🐵"
    cow*                =  "🐮"
    # other
    


const emojis* = @[check,xmark,heart,sun,star,darkstar,umbrella,flag,snowflake,music,scissors,
               trademark,copyright,roof,skull,smile,smiley,innocent,lol,tongue,blush,
               sad,cry,rage,cat,kitty,monkey,cow]
   

# more emojis len 4   
 
const ejm3* = @["😀","😁","😂","😃","😄","😅","😆","😇","😈","😉","😊","😋","😌","😍","😎","😏","😐","😑","😒","😓","😔","😕","😖","😗","😘","😙","😚","😛","😜","😝","😞","😟","😠","😡","😢","😣","😥","😦","😧","😨","😩","😪","😫","😭","😮","😯","😰","😱","😲","😳","😴","😵","😶","😷","😸","😹","😺","😻","😼","😽","😾","😿","🙀"]  
const ejm4* = toSeq(parsehexint("25B6")..parsehexint("26AB"))

const cards* = @[
 "🂡" ,"🂱" ,"🃁" ,"🃑",
 "🂢" ,"🂲" ,"🃂" ,"🃒",
 "🂣" ,"🂳" ,"🃃" ,"🃓",
 "🂤" ,"🂴" ,"🃄" ,"🃔",
 "🂥" ,"🂵" ,"🃅" ,"🃕",
 "🂦" ,"🂶" ,"🃆" ,"🃖",
 "🂧" ,"🂷" ,"🃇" ,"🃗",
 "🂨" ,"🂸" ,"🃈" ,"🃘",
 "🂩" ,"🂹" ,"🃉" ,"🃙",
 "🂪" ,"🂺" ,"🃊" ,"🃚",
 "🂫" ,"🂻" ,"🃋" ,"🃛",
 "🂬" ,"🂼" ,"🃌" ,"🃜",
 "🂭" ,"🂽" ,"🃍" ,"🃝",
 "🂮" ,"🂾" ,"🃎" ,"🃞",
 "🃏" ,"🃟"]
 #"🂠" ,"🂿"  # removed from cards set for a cleaner look

const kotakp* =  "🂠"
const kotakk* =  "🂿"
const rxCards* = toSeq(cards.low.. cards.high) # index into cards
const rxCol* = toSeq(colorNames.low.. colorNames.high) ## index into colorNames
const rxPastelCol* = toSeq(pastelset.low.. pastelset.high) ## index into colorNames 

# may or may not be available on all systems
const wideDot* = "\xE2\x9A\xAB" & " "


# amazon style date strings
const iso_8601_aws* = "yyyyMMdd'T'HHmmss'Z'"


