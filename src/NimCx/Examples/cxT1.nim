import nimcx

# linux only

superHeader("Testing print procs from cx.nim")
printLn("tested in bash and qterminal 0.7.0")
decho(2)

let s = "Test color string"
let n = 1234567
let f = 123.4567
let k = @[1234,4567,654]

# background colors for print and printLn are standard terminal colors
# to use other colors use printStyled or printLnStyled with stylereverse

printLn(s,white,brightblack)
print(cleareol)
printLn(n,white,red,xpos = 20)
print(cleareol)
printLn(f,white,blue,xpos = 50)
print(cleareol)
printLn(k,steelblue,lightgreen,xpos = 15,styled={stylereverse},substr = $k)
print(cleareol)
printLn(f,substr = $(f),rosybrown,styled={stylereverse})
printLn(cleareol)

decho(2)

printLn(s,lime)
printLn(n,brightgreen)
printLn(f,greenyellow)
printLn(k,rosybrown)
decho(2)

printLnRainbow(s,{})
printLnRainbow(n,{})
printLnRainbow(f,{})
printLnrainbow(k,{styleUnderscore})
decho(2)

printLn(s,substr="t",clrainbow,styled={styleUnderScore,styleBlink})
decho(2)

# change color upon first separator , hence bicolor ...
# default seperator ":"
printLnBiCol(s,"c",brightgreen,brightwhite)
printLnBiCol(s,"c")  # default colors
printLnBiCol("Junk Food",spaces(1),red,brightblue) # separator is a space
decho(2)

# all in one color , fmtx is a simple formater , but you could use strfmt too if installed
printLn(fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),k),greenyellow)      
# all in one color with new background 
print(fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),k),brightyellow,brightred)
decho(2)

printLn(s,clrainbow,brightyellow)  
printLn(s,lime)
decho(2)

print(s,black,brightmagenta)
printLn(s &  " ---> this is white at position x = 25",xpos = 25)

printLnHl("Everyone and the cat likes fresh salmon.","the cat",yellowgreen)
decho(2)
print("123423456576782312345",substr="23",lightseagreen,styled={stylereverse,styleBlink})
echo()
printLn("The dog blinks . ",rosybrown,styled={styleUnderScore,styleBlink},substr=" dog ")

doFinish()
