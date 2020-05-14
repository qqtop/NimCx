{.deadCodeElim: on , optimization: speed.}

##     Library     : nimcx.nim
##     
##     Module      : cxconsts.nim
##
##     Status      : stable
##
##     License     : MIT opensource
##
##     Version     : 1.0.7
##
##     ProjectStart: 2015-06-20
##   
##     Latest      : 2020-05-14
##
##     Compiler    : latest stable or devel branch
##
##     OS          : Linux
##
##     Docs        : https://qqtop.github.io/cxconsts.html
##
##     Description : this file is part of nimcx and contains all public const declarations
## 
##                   it is automatically imported and exported by cx.nim
## 
##                   concerning unicode symbols , our testing system has gnu unicodefonts installed
##                   
##                   
## 

import terminal,colors,sequtils,strutils,htmlparser

{.hint: "\x1b[38;2;154;205;50m ╭──────────────────────── NIMCX ─────────────────────────────────────╮ " .}
    
{.hint: "\x1b[38;2;154;205;50m \u2691  NimCx     " & "\x1b[38;2;255;215;0m Officially made for Linux only." & 
                spaces(23) & "\x1b[38;2;154;205;50m \u2691 ".}
                
{.hint: "\x1b[38;2;154;205;50m \u2691  Compiling " &
        "\x1b[38;2;255;100;0m cxconsts.nim \xE2\x9A\xAB" &
        " " & "\xE2\x9A\xAB" & spaces(36) & "\x1b[38;2;154;205;50m \u2691 ".}
         
{.hint: "\x1b[38;2;154;205;50m ╰──────────────────────── CXCONSTS ──────────────────────────────────╯ " .}



 
const cxcodestart* = "cxcodestart"
const cxcodeend*   = "cxcodeend"
 
proc getFg*(fg:ForegroundColor):string =
    var gFG = ord(fg)
    result = "\e[" & $gFG & 'm'

proc getBg*(bg:BackgroundColor):string =
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
      # the empty block rune , display it like so:  echo showRune($RuneEmpty)
      # cannot get enough of them try this       :  loopy2(0,tw * 8,print(showRune($RuneEmpty),randcol()))
      RuneEmpty* = 0xFFFD

const
      # style constants for convenience
      cxNoStyle* = {}
      cxReverse* = {styleReverse}
      cxBright*  = {styleBright}
      cxDim*     = {styleDim}
      cxReverseBright* = {styleReverse,styleBright}   
      cxReverseDim* = {styleReverse,styleDim}      
      cxBlink* = {styleBlink}
      cxItalic* = {styleItalic}
      cxUnderscore* = {styleUnderscore}
      
const
      # block chars for font building with some easy to remember names
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
      cfb4* = "⭕"   # shadowed circle
      cfb5* = "⬤"    # black circle

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
      # standard terminal for line feeds , space
      CRLF* = "\x0D\x0A"  # Internet standard newline
      SP*   = "\x20"      # space
      CR*   = "\x0D"      # ctrl
      LF*   = "\x0A"      # standard newline


const

      # Terminal consts for bash movements ( still testing ,not working on some terminals )
      cup*      = "\x1b[A"      # ok
      cdown*    = "\x1b[B"      # ok
      cright*   = "\x1b[C"      # ok
      cleft*    = "\x1b[D"      # ok
      cend*     = "\x1b[F"      # no effect
      cpos1*    = "\x1b[H"      # ok moves  to screen position 0/0
      cins*     = "\x1b[2~"     # no effect
      cdel*     = "\x1b[3~"     # no effect
      cpgup*    = "\x1b[5~"     # no effect
      cpgdn*    = "\x1b[6~"     # no effect
      csave*    = "\x1b[s"      # ok saves last xpos (but not ypos)
      crestore* = "\x1b[u"      # ok restores saved xpos
      chide*    = "\x1b[?25l"   # ok hide 
      cshow*    = "\x1b[?25h"   # ok show
   
      
const
      euro*   = "€"
      dollar* = "$"
      yen*    = "¥"
      
const 
      # umlaut uppercase
      ae* = entityToRune("Auml")
      oe* = entityToRune("Ouml")
      ue* = entityToRune("Uuml")   
      
      # umlaut lowercase
      ael* = entityToRune("auml")
      oel* = entityToRune("ouml")
      uel* = entityToRune("uuml") 
      
      # example usage umlaut consts
      # echo(ue,"ber",oe,ae)
      # example usage htmlparser entityxx proc
      # echo entityToUtf8("#0931")    # sigma
      # echo entityToUtf8("#x03A3")
      # echo runeToEntity("∈".runeAt(0))
      # echo entityToRune("#8712")
      # echo "in ",sigma," ", ael , "ndert sich nichts"
      # echo ue,uel,ae,ael,oe,oel   
      # cxwriteln(lime,$ae,skyblue,$uel,yellow,$oel)
      
# selected box chars
# run : showseq(createSeqBoxChars())
# to see more
# 
const
      linechar* = "─"
      leftbottom* = "╰"
      lefttop* = "╭"
      righttop* = "╮"
      rightbottom* = "╯"
      vertlinechar* = "│"
      cross* = "┼"
      rcross* = "┤"
      lcross* = "├"
      topcross* ="┬"
      bottomcross* ="┴"      
          
      
const
      # Terminal ForegroundColor Normal

      termred*              = getFg(fgRed)
      termgreen*            = getFg(fgGreen)
      termblue*             = getFg(fgBlue)
      termcyan*             = getFg(fgCyan)
      termyellow*           = getFg(fgYellow)
      termwhite*            = getFg(fgWhite)
      termblack*            = getFg(fgBlack)
      termmagenta*          = getFg(fgMagenta)

      # Terminal ForegroundColor Bright

      brightred*            = fbright(fgRed)
      brightgreen*          = fbright(fgGreen)
      brightblue*           = fbright(fgBlue)
      brightcyan*           = fbright(fgCyan)
      brightyellow*         = fbright(fgYellow)
      brightwhite*          = fbright(fgWhite)
      brightmagenta*        = fbright(fgMagenta)
      brightblack*          = fbright(fgBlack)

      # Terminal BackgroundColor Normal

      bred*                 = getBg(bgRed)
      bgreen*               = getBg(bgGreen)
      bblue*                = getBg(bgBlue)
      bcyan*                = getBg(bgCyan)
      byellow*              = getBg(bgYellow)
      bwhite*               = getBg(bgWhite)
      bblack*               = getBg(bgBlack)
      bmagenta*             = getBg(bgMagenta)

      # Terminal BackgroundColor Bright

      bbrightred*           = bbright(bgRed)
      bbrightgreen*         = bbright(bgGreen)
      bbrightblue*          = bbright(bgBlue)
      bbrightcyan*          = bbright(bgCyan)
      bbrightyellow*        = bbright(bgYellow)
      bbrightwhite*         = bbright(bgWhite)
      bbrightmagenta*       = bbright(bgMagenta)
      bbrightblack*         = bbright(bgBlack)
      
      termClear*            = "\e[0m"
      termBold*             = "\e[1m"
      termItalic*           = "\e[3m"
      termUnderline*        = "\e[4m"
      termBlink*            = "\e[5m"
      termNegative*         = "\e[7m"
      termStrikethrough*    = "\e[9m"

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
      sandybrownbg*         = "\x1b[48;2;244;164;96m"
      pastelgreenbg*        = "\x1b[48;2;179;226;205m"
      pastelorangebg*       = "\x1b[48;2;253;205;172m"
      pastelbluebg*         = "\x1b[48;2;203;213;232m"
      pastelpinkbg*         = "\x1b[48;2;244;202;228m"
      pastelyellowgreenbg*  = "\x1b[48;2;230;245;201m"
      pastelyellowbg*       = "\x1b[48;2;255;242;174m"
      pastelbeigebg*        = "\x1b[48;2;241;226;204m"
      pastelwhitebg*        = "\x1b[48;2;204;204;204m"
      
      
      # TODO :  more colors
      
      # other colors of interest
      # https://www.colorbox.io/
      # http://www.javascripter.net/faq/hextorgb.htm
      # https://www.w3schools.com/colors/colors_trends.asp
      # http://www.javascripter.net/faq/hextorgb.htm
      truetomato*           =  "\x1b[38;2;255;100;0m"
      bigdip*               =  "\x1b[38;2;156;37;66m"
      greenery*             =  "\x1b[38;2;136;176;75m"     
      bluey*                =  "\x1b[38;2;0;189;183m"     
      trueblue*             =  "\x1b[38;2;0;115;207m"
      yaleblue*             =  "\x1b[38;2;15;77;146m"
      satblue*              =  "\x1b[38;2;0;148;255m"
      brightsatblue*        =  "\x1b[38;2;0;176;241m"    
      zyclam*               =  "\x1b[38;2;255;111;210m"
      zippi*                =  "\x1b[38;2;0;151;120m"

      
      # other colors of interest with background bit set
      
      truetomatobg*         =  "\x1b[48;2;255;100;0m"
      bigdipbg*             =  "\x1b[48;2;156;37;66m"
      greenerybg*           =  "\x1b[48;2;136;176;75m"
      blueybg*              =  "\x1b[48;2;0;189;183m"
      truebluebg*           =  "\x1b[48;2;0;115;207m"
      yalebluebg*           =  "\x1b[48;2;15;77;146m"
      satbluebg*            =  "\x1b[48;2;0;148;255m"
      brightsatbluebg*      =  "\x1b[48;2;0;176;241m"
      zyclambg*             =  "\x1b[48;2;255;111;210m"
      zippibg*              =  "\x1b[48;2;0;151;120m"     

      
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


 # colors lifted from colors.nim and massaged into rgb background escape seqs

      alicebluebg*            =  "\x1b[48;2;240;248;255m"
      antiquewhitebg*         =  "\x1b[48;2;250;235;215m"
      aquabg*                 =  "\x1b[48;2;0;255;255m"
      aquamarinebg*           =  "\x1b[48;2;127;255;212m"
      azurebg*                =  "\x1b[48;2;240;255;255m"
      beigebg*                =  "\x1b[48;2;245;245;220m"
      bisquebg*               =  "\x1b[48;2;255;228;196m"
      blackbg*                =  "\x1b[48;2;0;0;0m"
      blanchedalmondbg*       =  "\x1b[48;2;255;235;205m"
      bluebg*                 =  "\x1b[48;2;0;0;255m"
      bluevioletbg*           =  "\x1b[48;2;138;43;226m"
      brownbg*                =  "\x1b[48;2;165;42;42m"
      burlywoodbg*            =  "\x1b[48;2;222;184;135m"
      cadetbluebg*            =  "\x1b[48;2;95;158;160m"
      chartreusebg*           =  "\x1b[48;2;127;255;0m"
      chocolatebg*            =  "\x1b[48;2;210;105;30m"
      coralbg*                =  "\x1b[48;2;255;127;80m"
      cornflowerbluebg*       =  "\x1b[48;2;100;149;237m"
      cornsilkbg*             =  "\x1b[48;2;255;248;220m"
      crimsonbg*              =  "\x1b[48;2;220;20;60m"
      cyanbg*                 =  "\x1b[48;2;0;255;255m"
      darkbluebg*             =  "\x1b[48;2;0;0;139m"
      darkcyanbg*             =  "\x1b[48;2;0;139;139m"
      darkgoldenrodbg*        =  "\x1b[48;2;184;134;11m"
      darkgraybg*             =  "\x1b[48;2;169;169;169m"
      darkgreenbg*            =  "\x1b[48;2;0;100;0m"
      darkkhakibg*            =  "\x1b[48;2;189;183;107m"
      darkmagentabg*          =  "\x1b[48;2;139;0;139m"
      darkolivegreenbg*       =  "\x1b[48;2;85;107;47m"
      darkorangebg*           =  "\x1b[48;2;255;140;0m"
      darkorchidbg*           =  "\x1b[48;2;153;50;204m"
      darkredbg*              =  "\x1b[48;2;139;0;0m"
      darksalmonbg*           =  "\x1b[48;2;233;150;122m"
      darkseagreenbg*         =  "\x1b[48;2;143;188;143m"
      darkslatebluebg*        =  "\x1b[48;2;72;61;139m"
      darkslategraybg*        =  "\x1b[48;2;47;79;79m"
      darkturquoisebg*        =  "\x1b[48;2;0;206;209m"
      darkvioletbg*           =  "\x1b[48;2;148;0;211m"
      deeppinkbg*             =  "\x1b[48;2;255;20;147m"
      deepskybluebg*          =  "\x1b[48;2;0;191;255m"
      dimgraybg*              =  "\x1b[48;2;105;105;105m"
      dodgerbluebg*           =  "\x1b[48;2;30;144;255m"
      firebrickbg*            =  "\x1b[48;2;178;34;34m"
      floralwhitebg*          =  "\x1b[48;2;255;250;240m"
      forestgreenbg*          =  "\x1b[48;2;34;139;34m"
      fuchsiabg*              =  "\x1b[48;2;255;0;255m"
      gainsborobg*            =  "\x1b[48;2;220;220;220m"
      ghostwhitebg*           =  "\x1b[48;2;248;248;255m"
      goldbg*                 =  "\x1b[48;2;255;215;0m"
      goldenrodbg*            =  "\x1b[48;2;218;165;32m"
      graybg*                 =  "\x1b[48;2;128;128;128m"
      greenbg*                =  "\x1b[48;2;0;128;0m"
      greenyellowbg*          =  "\x1b[48;2;173;255;47m"
      honeydewbg*             =  "\x1b[48;2;240;255;240m"
      hotpinkbg*              =  "\x1b[48;2;255;105;180m"
      indianredbg*            =  "\x1b[48;2;205;92;92m"
      indigobg*               =  "\x1b[48;2;75;0;130m"
      ivorybg*                =  "\x1b[48;2;255;255;240m"
      khakibg*                =  "\x1b[48;2;240;230;140m"
      lavenderbg*             =  "\x1b[48;2;230;230;250m"
      lavenderblushbg*        =  "\x1b[48;2;255;240;245m"
      lawngreenbg*            =  "\x1b[48;2;124;252;0m"
      lemonchiffonbg*         =  "\x1b[48;2;255;250;205m"
      lightbluebg*            =  "\x1b[48;2;173;216;230m"
      lightcoralbg*           =  "\x1b[48;2;240;128;128m"
      lightcyanbg*            =  "\x1b[48;2;224;255;255m"
      lightgoldenrodyellowbg* =  "\x1b[48;2;250;250;210m"
      lightgreybg*            =  "\x1b[48;2;211;211;211m"
      lightgreenbg*           =  "\x1b[48;2;144;238;144m"
      lightpinkbg*            =  "\x1b[48;2;255;182;193m"
      lightsalmonbg*          =  "\x1b[48;2;255;160;122m"
      lightseagreenbg*        =  "\x1b[48;2;32;178;170m"
      lightskybluebg*         =  "\x1b[48;2;135;206;250m"
      lightslategraybg*       =  "\x1b[48;2;119;136;153m"
      lightsteelbluebg*       =  "\x1b[48;2;176;196;222m"
      lightyellowbg*          =  "\x1b[48;2;255;255;224m"
      limebg*                 =  "\x1b[48;2;0;255;0m"
      limegreenbg*            =  "\x1b[48;2;50;205;50m"
      linenbg*                =  "\x1b[48;2;250;240;230m"
      magentabg*              =  "\x1b[48;2;255;0;255m"
      maroonbg*               =  "\x1b[48;2;128;0;0m"
      mediumaquamarinebg*     =  "\x1b[48;2;102;205;170m"
      mediumbluebg*           =  "\x1b[48;2;0;0;205m"
      mediumorchidbg*         =  "\x1b[48;2;186;85;211m"
      mediumpurplebg*         =  "\x1b[48;2;147;112;216m"
      mediumseagreenbg*       =  "\x1b[48;2;60;179;113m"
      mediumslatebluebg*      =  "\x1b[48;2;123;104;238m"
      mediumspringgreenbg*    =  "\x1b[48;2;0;250;154m"
      mediumturquoisebg*      =  "\x1b[48;2;72;209;204m"
      mediumvioletredbg*      =  "\x1b[48;2;199;21;133m"
      midnightbluebg*         =  "\x1b[48;2;25;25;112m"
      mintcreambg*            =  "\x1b[48;2;245;255;250m"
      mistyrosebg*            =  "\x1b[48;2;255;228;225m"
      moccasinbg*             =  "\x1b[48;2;255;228;181m"
      navajowhitebg*          =  "\x1b[48;2;255;222;173m"
      navybg*                 =  "\x1b[48;2;0;0;128m"
      oldlacebg*              =  "\x1b[48;2;253;245;230m"
      olivebg*                =  "\x1b[48;2;128;128;0m"
      olivedrabbg*            =  "\x1b[48;2;107;142;35m"
      orangebg*               =  "\x1b[48;2;255;165;0m"
      orangeredbg*            =  "\x1b[48;2;255;69;0m"
      orchidbg*               =  "\x1b[48;2;218;112;214m"
      palegoldenrodbg*        =  "\x1b[48;2;238;232;170m"
      palegreenbg*            =  "\x1b[48;2;152;251;152m"
      paleturquoisebg*        =  "\x1b[48;2;175;238;238m"
      palevioletredbg*        =  "\x1b[48;2;216;112;147m"
      papayawhipbg*           =  "\x1b[48;2;255;239;213m"
      peachpuffbg*            =  "\x1b[48;2;255;218;185m"
      perubg*                 =  "\x1b[48;2;205;133;63m"
      pinkbg*                 =  "\x1b[48;2;255;192;203m"
      plumbg*                 =  "\x1b[48;2;221;160;221m"
      powderbluebg*           =  "\x1b[48;2;176;224;230m"
      purplebg*               =  "\x1b[48;2;128;0;128m"
      redbg*                  =  "\x1b[48;2;255;0;0m"
      rosybrownbg*            =  "\x1b[48;2;188;143;143m"
      royalbluebg*            =  "\x1b[48;2;65;105;225m"
      saddlebrownbg*          =  "\x1b[48;2;139;69;19m"
      salmonbg*               =  "\x1b[48;2;250;128;114m"
      seagreenbg*             =  "\x1b[48;2;46;139;87m"
      seashellbg*             =  "\x1b[48;2;255;245;238m"
      siennabg*               =  "\x1b[48;2;160;82;45m"
      silverbg*               =  "\x1b[48;2;192;192;192m"
      skybluebg*              =  "\x1b[48;2;135;206;235m"
      slatebluebg*            =  "\x1b[48;2;106;90;205m"
      slategraybg*            =  "\x1b[48;2;112;128;144m"
      snowbg*                 =  "\x1b[48;2;255;250;250m"
      springgreenbg*          =  "\x1b[48;2;0;255;127m"
      steelbluebg*            =  "\x1b[48;2;70;130;180m"
      tanbg*                  =  "\x1b[48;2;210;180;140m"
      tealbg*                 =  "\x1b[48;2;0;128;128m"
      thistlebg*              =  "\x1b[48;2;216;191;216m"
      tomatobg*               =  "\x1b[48;2;255;99;71m"
      turquoisebg*            =  "\x1b[48;2;64;224;208m"
      violetbg*               =  "\x1b[48;2;238;130;238m"
      wheatbg*                =  "\x1b[48;2;245;222;179m"
      whitebg*                =  "\x1b[48;2;255;255;255m"    # same as brightwhite
      whitesmokebg*           =  "\x1b[48;2;245;245;245m"
      yellowbg*               =  "\x1b[48;2;255;255;0m"
      yellowgreenbg*          =  "\x1b[48;2;154;205;50m"
 

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
      ("brightsatblue", brightsatblue),
      ("brightsatbluebg", brightsatbluebg),
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
      ("sandybrownbg", sandybrownbg),
      ("satblue", satblue),
      ("satbluebg", satbluebg),
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
      ("trueblue",trueblue),
      ("violet", violet),
      ("wheat", wheat),
      ("white", white),
      ("whitesmoke", whitesmoke),
      ("yaleblue",yaleblue),
      ("yellow", yellow),
      ("yellowgreen", yellowgreen),
      ("yellowgreenbg", yellowgreenbg),
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
      ("truebluebg",truebluebg),
      ("truetomato",truetomato),
      ("truetomatobg",truetomatobg),
      ("yalebluebg",yalebluebg),
      ("zyclam",zyclam),
      ("zyclambg",zyclambg),
      ("zippi",zippi),
      ("zippibg",zippibg)]

      
# cxColorNames can after recent change in terminal nim be used for backgroundcolors      
# note still need a fall back if terminal does not support truecolors , currently a
# error message maybe displayed , colors commented out are currently not in the named colors set in Nim
const cxColorNames* = @[
      ("colaliceblue"   , colaliceblue),
      ("colantiquewhite", colantiquewhite),
      ("colaqua"        , colaqua),
      ("colaquamarine"  , colaquamarine),
      ("colazure"       , colazure),
      ("colbeige"       , colbeige),
      #("colbigdip"      , colbigdip),
      ("colbisque"      , colbisque),
      ("colblack"       , colblack),
      ("colblanchedalmond", colblanchedalmond),
      ("colblue"        , colblue),
      ("colblueviolet"  , colblueviolet),
      #("colbluey"       , colbluey),
      #("colblueybg"     , colblueybg),
      ("colbrown"       , colbrown),
      ("colburlywood"   , colburlywood),
      ("colcadetblue"   , colcadetblue),
      ("colchartreuse"  , colchartreuse),
      ("colchocolate"   , colchocolate),
      ("colcoral"       , colcoral),
      ("colcornflowerblue", colcornflowerblue),
      ("colcornsilk"    , colcornsilk),
      ("colcrimson"     , colcrimson),
      ("colcyan"        , colcyan),
      ("coldarkblue"    , coldarkblue),
      ("coldarkcyan"    , coldarkcyan),
      ("coldarkgoldenrod", coldarkgoldenrod),
      ("coldarkgray"    , coldarkgray),
      ("coldarkgreen"   , coldarkgreen),
      ("coldarkkhaki"   , coldarkkhaki),
      ("coldarkmagenta" , coldarkmagenta),
      ("coldarkolivegreen", coldarkolivegreen),
      ("coldarkorange"  , coldarkorange),
      ("coldarkorchid"  , coldarkorchid),
      ("coldarkred"     , coldarkred),
      ("coldarksalmon"  , coldarksalmon),
      ("coldarkseagreen", coldarkseagreen),
      ("coldarkslateblue", coldarkslateblue),
      ("coldarkslategray", coldarkslategray),
      ("coldarkturquoise", coldarkturquoise),
      ("coldarkviolet"  , coldarkviolet),
      ("coldeeppink"    , coldeeppink),
      ("coldeepskyblue", coldeepskyblue),
      ("coldimgray"    , coldimgray),
      ("coldodgerblue" , coldodgerblue),
      ("colfirebrick"  , colfirebrick),
      ("colfloralwhite", colfloralwhite),
      ("colforestgreen", colforestgreen),
      ("colfuchsia"    , colfuchsia),
      ("colgainsboro"  , colgainsboro),
      ("colghostwhite" , colghostwhite),
      ("colgold"       , colgold),
      ("colgoldenrod"  , colgoldenrod),
      ("colgray"       , colgray),
      ("colgreen"      , colgreen),
      #("colgreenery"   ,greenery),
      #("colgreenerybg" , colgreenerybg),
      ("colgreenyellow", colgreenyellow),
      ("colhoneydew"   , colhoneydew),
      ("colhotpink"    , colhotpink),
      ("colindianred"  , colindianred),
      ("colindigo"     , colindigo),
      ("colivory"      , colivory),
      ("colkhaki"      , colkhaki),
      ("collavender"   , collavender),
      ("collavenderblush", collavenderblush),
      ("collawngreen"  , collawngreen),
      ("collemonchiffon", collemonchiffon),
      ("collightblue"  , collightblue),
      ("collightcoral" , collightcoral),
      ("collightcyan"  , collightcyan),
      ("collightgoldenrodyellow", collightgoldenrodyellow),
      ("collightgrey"  , collightgrey),
      ("collightgreen" , collightgreen),
      ("collightpink"  , collightpink),
      ("collightsalmon", collightsalmon),
      ("collightseagreen", collightseagreen),
      ("collightskyblue", collightskyblue),
      ("collightslategray", collightslategray),
      ("collightsteelblue", collightsteelblue),
      ("collightyellow", collightyellow),
      ("collime"       , collime),
      ("collimegreen"  , collimegreen),
      ("collinen"      , collinen),
      ("colmagenta"    , colmagenta),
      ("colmaroon"     , colmaroon),
      ("colmediumaquamarine", colmediumaquamarine),
      ("colmediumblue" , colmediumblue),
      ("colmediumorchid", colmediumorchid),
      ("colmediumpurple", colmediumpurple),
      ("colmediumseagreen", colmediumseagreen),
      ("colmediumslateblue", colmediumslateblue),
      ("colmediumspringgreen", colmediumspringgreen),
      ("colmediumturquoise", colmediumturquoise),
      ("colmediumvioletred", colmediumvioletred),
      ("colmidnightblue", colmidnightblue),
      ("colmintcream"  , colmintcream),
      ("colmistyrose"  , colmistyrose),
      ("colmoccasin"   , colmoccasin),
      ("colnavajowhite", colnavajowhite),
      ("colnavy"       , colnavy),
      ("cololdlace"    , cololdlace),
      ("cololive"      , cololive),
      ("cololivedrab"  , cololivedrab),
      ("colorange"     , colorange),
      ("colorangered"  , colorangered),
      ("colorchid"     , colorchid),
      ("colpalegoldenrod", colpalegoldenrod),
      ("colpalegreen"  , colpalegreen),
      ("colpaleturquoise", colpaleturquoise),
      ("colpalevioletred", colpalevioletred),
      ("colpapayawhip" , colpapayawhip),
      ("colpeachpuff"  , colpeachpuff),
      ("colperu"       , colperu),
      ("colpink"       , colpink),
      ("colplum"       , colplum),
      ("colpowderblue" , colpowderblue),
      ("colpurple"     , colpurple),
      ("colred"        , colred),
      ("colrosybrown"  , colrosybrown),
      ("colroyalblue"  , colroyalblue),
      ("colsaddlebrown", colsaddlebrown),
      ("colsalmon"     , colsalmon),
      ("colsandybrown" , colsandybrown),
      ("colseagreen"   , colseagreen),
      ("colseashell"   , colseashell),
      ("colsienna"     , colsienna),
      ("colsilver"     , colsilver),
      ("colskyblue"    , colskyblue),
      ("colslateblue"  , colslateblue),
      ("colslategray"  , colslategray),
      ("colsnow"       , colsnow),
      ("colspringgreen", colspringgreen),
      ("colsteelblue"  , colsteelblue),
      ("coltan"        , coltan),
      ("colteal"       , colteal),
      ("colthistle"    , colthistle),
      ("coltomato"     , coltomato),
      ("colturquoise"  , colturquoise),
      ("colviolet"     , colviolet),
      ("colwheat"      , colwheat),
      ("colwhite"      , colwhite),
      ("colwhitesmoke" , colwhitesmoke),
      #("colyaleblue"   , colYaleblue),
      ("colyellow"     , colyellow),
      ("colyellowgreen", colyellowgreen),
#       ("colpastelbeige",pastelbeige),
#       ("colpastelbeigebg",pastelbeigebg),
#       ("colpastelblue" ,pastelblue),
#       ("colpastelbluebg",pastelbluebg),
#       ("colpastelgreen",pastelgreen),
#       ("colpastelgreenbg",pastelgreenbg),
#       ("colpastelorange",pastelorange),
#       ("colpastelorangebg",pastelorangebg),
#       ("colpastelpink" ,pastelpink),
#       ("colpastelpinkbg",pastelpinkbg),
#       ("colpastelwhite",pastelwhite),
#       ("colpastelwhitebg",pastelwhitebg),
#       ("colpastelyellow",pastelyellow),
#       ("colpastelyellowbg",pastelyellowbg),
#       ("colpastelyellowgreen",pastelyellowgreen),
#       ("colpastelyellowgreenbg",pastelyellowgreenbg),
#       ("coltrueblue" ,trueblue),
#       ("coltruetomato" ,truetomato),
#       ("coltruetomatobg",truetomatobg),
#       ("colzcolor"     ,zcolor),
#       ("colzippi"      ,zippi)] 
        ]

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
      
      # other arrow set # needs to be improved as fonts may not be installed/visible in all distros
      lrarrow*  = "\u2B0C"   # leftrightarrow
      #rlarrow*  = "⮂"
      udarrow*  = "\u2B0D"   # updownaarrow
      #daarrow*  = "⮃"
      larrow*   = "\u2B05"   # leftarrow
      darrow*   = "\u2B07"   # downarrow
      uarrow*   = "\u2B06"   # uparrow
      swarrow*  = "\u2B0B"   # southwestarrow
      searrow*  = "\u2B0A"   # southeastarrow
      nwarrow*  = "\u2B09"   # northwestarrow
      nearrow*  = "\u2B08"   # northeastarrow
     
      
      # vars
      phone*           = "\u260E"
      fullflag*        = "\u2691"
      enterkey*        = "↵"
      sigma*           = "Σ"
      loopedsquare*    = "⌘"
      hand*            = "👋"
      backspacebutton* = ""
      tabbutton*       = ""
      enterbutton*     = ""
      rslash*          = "\u005C"   # backslash 
      
      
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
    errorsymbol2*       =  "𝐄"
    blove*              =  "😎"

const emojis* = @[check,xmark,heart,sun,star,darkstar,umbrella,flag,snowflake,music,scissors,
               trademark,copyright,roof,skull,smile,smiley,innocent,lol,tongue,blush,
               sad,cry,rage,cat,kitty,monkey,cow,errorsymbol2,blove]
   

# more emojis len 4   
 
const ejm3* = @["😀","😁","😂","😃","😄","😅","😆","😇","😈","😉","😊","😋","😌","😍","😎","😏","😐","😑","😒","😓","😔","😕","😖","😗","😘","😙","😚","😛","😜","😝","😞","😟","😠","😡","😢","😣","😥","😦","😧","😨","😩","😪","😫","😭","😮","😯","😰","😱","😲","😳","😴","😵","😶","😷","😸","😹","😺","😻","😼","😽","😾","😿","🙀"]  
const ejm4* = toSeq(parseHexInt("25B6")..parseHexInt("26AB"))

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
const txCol* = toSeq(cxColorNames.low..cxColorNames.high)  ## index into cxcolorNames
# may or may not be available on all systems
const wideDot* = "\xE2\x9A\xAB" & " "

# amazon style date strings
const iso_8601_aws* = "yyyyMMdd'T'HHmmss'Z'"

let nimcxl* = """   
   _  _  _  _  _   ___  _  _ 
   |\ |  |  |\/|  |      \/  
   | \|  |  |  |  |___  _/\_ 
      
 """    

# Font constants have been moved to cxfontconsts.nim in order to shrink
# binaries which do not use them
