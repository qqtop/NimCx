# NimCx   ![Image](https://camo.githubusercontent.com/b0224997019dec4e51d692c722ea9bee2818c837/68747470733a2f2f696d672e736869656c64732e696f2f6769746875622f6c6963656e73652f6d6173686170652f6170697374617475732e737667)   ![Image](https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble.png)


![Image](http://qqtop.github.io/nimcxfont.png?raw=true)

![Image](http://qqtop.github.io/nimcxfont2.png?raw=true)

 NIMCX - Color and Utilities for the Linux Terminal
--------------------------------------------------------



| Code           | Demoslib         | Tests            |
|----------------|------------------|------------------|
| cx.nim         | cxDemo.nim       | cxTest.nim       |
| cxconsts.nim   |                  |                  |
| cxutils.nim    |                  |                  |


[Documentation for cx.nim](https://qqtop.github.io/cx.html)

[Documentation for cxutils.nim](https://qqtop.github.io/cxutils.html)

[Documentation for cxconsts.nim](https://qqtop.github.io/cxconsts.html)
                           

Requires     : Latest Nim dev version

Installation : 


```
    nimble install nimcx

```



Benchmark your procs :

```nim

    import nimcx

    proc doCalc() = 
        var b = createSeqint(10,0,100_000)        # random seq with 10 ints between 0 and 100000
        let rs = rndSample(b)                     # draw a random sample from b
        printLnBiCol("Random Sample : " & $rs)    # print the drawn sample
        seqHighLite(b,@[rs])                      # print the full seq with the sample highligthed
        echo()

    benchmark("proc doCalc ",50):                 # benchmark runs 50 times
       doCalc()
  
     
    benchmark("quicksomething ",2):               # benchmark runs 2 times
       printMadeWithNim()
       decho(10)
        
    showbench()      
    decho(10)
   
```

Example of showbench() output format

![Image](http://qqtop.github.io/nimcxbenchmark.png?raw=true)



Example usage of print procs 


![Image](http://qqtop.github.io/sierpcxdemp.png?raw=true)


Screenshots from cxTest

![Image](http://qqtop.github.io/nimcarpet.png?raw=true)




```nimrod         

import nimcx
# show the colors
showColors()
dofinish()

```


![Image](http://qqtop.github.io/nimcolors33.png?raw=true)

![Image](http://qqtop.github.io/nimcolors34.png?raw=true)

![Image](http://qqtop.github.io/nimcolors35.png?raw=true)

![Image](http://qqtop.github.io/nimcolors36.png?raw=true)

![Image](http://qqtop.github.io/nimcolors10.png?raw=true)

![Image](http://qqtop.github.io/nimcolors13.png?raw=true)

![Image](http://qqtop.github.io/nimbox.png?raw=true)

![Image](http://qqtop.github.io/snowmaninjapan.png?raw=true)

 
    Brought to you by :
  
  
   ![Image](http://qqtop.github.io/gnu2.png?raw=true)  ![Image](http://qqtop.github.io/gnu.png?raw=true)

   

