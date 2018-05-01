{.deadCodeElim: on , optimization: speed.}
import cxglobal,cxconsts,cxprint,cxtruecolor
import strutils,terminal,sets

# cxfont.nim
#
# experimental font, slim numbers and 
# 
# old block font related procs (not in use ) 
# 
# 
# 
# Last : 2018-02-27 
# 

# type used in slim number printing
type
    T7 = object  
      zx : seq[string]
      
# experimental your results may depend on terminal in use
# 
# suggested : konsole for best effect
# 
# experimental font building  


template cxZero*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 7,coltop,xpos = xpos)
         printLn2(efb2 * 7,col,xpos = xpos)
         loopy(0..2,printLn2(efb2 * 2 & spaces(3) & efb2 * 2 ,col,xpos = xpos))
         printLn2(efb2 * 7,col,xpos = xpos)
         curup(6)         
          
template cx1*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
         let xpos = npos+5
         printLn2(spaces(4) & efb3 * 2 ,coltop,xpos=xpos)
         printLn2(spaces(3) & efb1 & efb2 * 2 ,col,xpos=xpos)
         printLn2(spaces(1) & efb1 & spaces(2) & efb2 * 2 ,col,xpos=xpos)
         printLn2(spaces(4) & efb2 * 2 ,col,xpos=xpos)
         printLn2(spaces(4) & efs2 * 2,col,xpos=xpos)
         printLn2(spaces(4) & efb2 * 2 ,col,xpos=xpos)
         curup(6) 
           
           
template cx2*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4 & spaces(4),coltop,xpos = xpos)
         printLn2(spaces(1) & efs2 & efb1 * 4 & efs2 & spaces(2),col,xpos = xpos)
         printLn2(spaces(6) & efs2 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(2) & efs2 * 3  & efb1 & spaces(3),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1  & spaces(4)  & spaces(2),col,xpos = xpos)
         printLn2(spaces(1) & efb1 * 1 & efb2 * 4  & efb1 * 1 & spaces(2),col,xpos = xpos)
         curup(6) 
 
        
           
            
template cx3*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 

         let xpos = npos+5
         printLn2(spaces(1) & efb3 * 6,coltop,xpos=xpos)
         printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
         printLn2(spaces(5) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(3) & efs2 * 3 & spaces(1),col,xpos=xpos)
         printLn2(spaces(5) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
         curup(6)      


template cx4*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos+5
         printLn2(spaces(5) & efb3 * 1,coltop,xpos=xpos)
         printLn2(spaces(5) & efb2 * 1,col,xpos=xpos)
         printLn2(spaces(3) & efb1 * 1 & spaces(1) & efs2 & spaces(3),col,xpos=xpos)
         printLn2(spaces(1) & efs2 * 1 & spaces(3) & efb2,col,xpos=xpos)
         printLn2(spaces(0) & efs2 * 1 & spaces(1) & efs2 & spaces(1) & efs2 * 4,col,xpos=xpos)
         printLn2(spaces(4) & efb2 * 2,col,xpos=xpos)
         curup(6)               
         
              
template cx5*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 5 & spaces(4),coltop,xpos = xpos)
         printLn2(spaces(1) & efs2 & efb1 * 5 & spaces(2),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1 & spaces(7),col,xpos = xpos)
         printLn2(spaces(1) & efb1 & spaces(0) & efs2 * 2 & spaces(1) & efs2 & spaces(3),col,xpos = xpos)
         printLn2(spaces(6) & efb1 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(1) & efb1 * 1 & efb2 * 3  & efb1 & spaces(3),col,xpos = xpos)
         curup(6)               
                            
              
              
template cx6*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4 & spaces(4),coltop,xpos = xpos)
         printLn2(spaces(1) & efs2 & efb1 * 4 & spaces(3),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1 & spaces(7),col,xpos = xpos)
         printLn2(spaces(1) & efb2 & spaces(1) & efs2 * 1 & spaces(1) & efs2 & spaces(3),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1 & spaces(4) & efb1 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(2) & efb1 & efb2 * 2  & efb1 & spaces(3),col,xpos = xpos)
         curup(6)               
              
     
              
template cx7*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 7,coltop,xpos = xpos)
         printLn2(efb2 * 7,col,xpos = xpos)
         printLn2(spaces(5) & efs2 * 1  & efb1 ,col,xpos = xpos)
         loopy(0..2,printLn2(spaces(4) & efb2 * 2 ,col,xpos = xpos))
         curup(6)  
 

template cx8*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4 & spaces(4),coltop,xpos = xpos)
         printLn2(spaces(1) & efs2 & efb1 & efb1 * 2  & efb1 & efs2 & spaces(2),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1  & spaces(4) & efs2 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(2) & efb1 &  efs2 * 2  & efb1 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1  & spaces(4) & efs2 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(2) & efb1 & efb2 * 2  & efb1 & spaces(3),col,xpos = xpos)
         curup(6) 
 
 
 
 
template cx9*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(1) & efb3 * 6,coltop,xpos = xpos)
         printLn2(efs2 & efb1 * 3 & efb2 * 3,col,xpos = xpos)
         printLn2(spaces(0) & efs2 * 1  & spaces(4) & efb2 * 2,col,xpos = xpos)
         printLn2(spaces(1) & efb1 &  efs2 * 3 & efb1 * 2,col,xpos = xpos)
         loopy(0..1,printLn2(spaces(5) & efb2 * 2 ,col,xpos = xpos))
         curup(6)  
 
 
 
proc cx10*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =
         cx1(npos,col,coltop)
         cxzero(npos + 9,col,coltop)
 
 
 
template cxa*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
         let xpos = npos + 5
         printLn2(spaces(4) & efb3 * 2 & spaces(3), coltop,xpos=xpos)
         printLn2(spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(2) & efb2 * 2 & spaces(2) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(2) & efs2 * 6 ,col,xpos=xpos)
         printLn2(spaces(1) & efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(1) & efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         curup(6)
        
            
template cxb*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 5, coltop,xpos=xpos)
         printLn2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         printLn2(efb2 * 3 & efs2 &  spaces(0) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         printLn2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         curup(6)

template cxc*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 

         let xpos = npos+5
         printLn2(spaces(1) & efb3 * 6,coltop,xpos=xpos)
         printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
         printLn2(efb2 * 2,col,xpos=xpos)
         printLn2(efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2,col,xpos=xpos)
         printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
         curup(6)
              
              
template cxd*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 5, coltop,xpos=xpos)
         println2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         println2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         println2(efb2 * 2 & spaces(4) & efs2,col,xpos=xpos)
         println2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         println2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         curup(6)

         
  
template cxe*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 7, coltop,xpos=xpos)
         printLn2(efb2 * 7, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 5, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 7, col,xpos=xpos)
         curup(6)  
 
template cxf*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 7, coltop,xpos=xpos)
         printLn2(efb2 * 7, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 5, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         curup(6)  
 

template cxg*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 

        let xpos = npos+5
        printLn2(spaces(1) & efb3 * 6,coltop,xpos=xpos)
        printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
        printLn2(efb2 * 2,col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(2) & efs2 * 3,col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(3) & efb2 * 2,col,xpos=xpos)
        printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
        curup(6)
             
template cxh*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
        let xpos = npos + 5
        printLn2(efb3 * 2 & spaces(4) & efb3 * 2, coltop,xpos=xpos)
        printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & efs2 * 4 & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
        curup(6)   
 
template cxi*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    

        loopy2(0,2):
           let xpos = xloopy+npos+7
           printLn2(efb3 ,coltop,xpos=xpos)
           loopy(0..4,printLn2(efb2,col,xpos=xpos))
           curup(6)
           
             
template cxj*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    

        loopy2(0,2):
           let xpos = xloopy+npos+5
           printLn2(spaces(2) & efb3 * 2 ,coltop,xpos=xpos)
           loopy(0..2,printLn2(spaces(2) & efb2 * 2,col,xpos=xpos))
           printLn2(efs2 & spaces(1) & efb2 * 2,col,xpos = xpos)
           printLn2(spaces(1) & efb2 & efb2,col,xpos=xpos)
           curup(6) 
           
           
           
template cxk*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
         let xpos = npos+5
         printLn2(efb3 * 2 & spaces(4) & efb3 * 2,coltop,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb1 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(2) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(2) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         curup(6)          
         
template cxl*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 2, coltop,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 7, col,xpos=xpos)
         curup(6)
              
template cxm*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
        let xpos = npos + 5
        printLn2(efb3 * 2 & spaces(5) & efb3 * 2, coltop,xpos=xpos)
        printLn2(efb2 * 2 & efs2 & spaces(3) & efs2 & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(1) & efs2 & spaces(1) & efs2 & spaces(1) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(2) & efs2 & spaces(2) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(5) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(5) & efb2 * 2, col,xpos=xpos)
        curup(6) 
        
template cxn*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
         let xpos = npos + 5
         printLn2(efb3 * 2 & spaces(4) & efb3 * 2, coltop,xpos=xpos)
         printLn2(efb2 * 2 & efs2 & spaces(3) & efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(1) & efs2 & spaces(2) & efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(2) & efs2 & spaces(1) & efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(3) & efs2 & efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
         curup(6)  
 
template cxo*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4, coltop,xpos=xpos)
         printLn2(spaces(2) & efb2 * 4, col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(2) & efb2 * 3 & efb2,col,xpos=xpos)
         curup(6) 
          
template cxp*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 5, coltop,xpos=xpos)
         printLn2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         printLn2(efb2 * 3 & efs2 &  spaces(0) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 2,col,xpos=xpos)
         curup(6)
   
       
 
template cxq*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4, coltop,xpos=xpos)
         printLn2(spaces(2) & efb2 * 3 & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(3) & efs2 & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(2) & efb2 * 3 & efb2 & "\\",col,xpos=xpos)
         curup(6) 

template cxr*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 5, coltop,xpos=xpos)
         printLn2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(3) & efb3 & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & efs2 * 2 &  spaces(0) & efs2 * 1,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(1) & efs2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(3) & efb2 * 2,col,xpos=xpos)
         curup(6)
 
template cxs*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(3) & efb3 * 5, coltop,xpos=xpos)
         printLn2(spaces(1) & efb1 & spaces(1) & efb1 * 5,col,xpos=xpos)
         printLn2(efb1 * 1 & spaces(1) & efs2 * 1 ,col,xpos=xpos)
         printLn2(spaces(4) & efb1 & efs2 * 1 ,col,xpos=xpos)
         printLn2(spaces(5) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 5 &  efs2  * 1 & efb1  * 1 ,col,xpos=xpos)
         curup(6)  
  
 
template cxt*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 8, coltop,xpos=xpos)
         printLn2(efb2 * 8,col,xpos=xpos)
         loopy(0..3,printLn2(spaces(3) & efb2 * 2 ,col,xpos=xpos))
         curup(6)   
         
            
         
template cxu*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 2 & spaces(4) & efb3 * 2,coltop,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(1) & efb2 * 6 ,col,xpos=xpos)
         curup(6)         
         

         
template cxv*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 2 & spaces(4) & efb3 * 2,coltop,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efs2 * 2,col,xpos=xpos)
         printLn2(spaces(1) & efb2 * 2 & spaces(2) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(3) & efb2 * 2 ,col,xpos=xpos)
         curup(6)          
         
         
template cxw*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
         let xpos = npos + 5
         printLn2(efb3 * 2 & spaces(5) & efb3 * 2, coltop,xpos=xpos)
         printLn2(efb2 * 2 & spaces(5) & efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(5) & efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(2) & efs2 & spaces(2) & efb2 * 2, col,xpos=xpos)
         printLn2(spaces(1) & efb1 * 2 & spaces(0) & efs2 &  spaces(1) & efs2 & spaces(0) & efb1 * 2, col,xpos=xpos)
         printLn2(spaces(2) & efb2 * 2 &  spaces(1) & efb2 * 2, col,xpos=xpos)
         curup(6)          
 
              
template cxx*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
         let xpos = npos+5
         printLn2(spaces(1) & efb3 * 2 & spaces(3) & efb3 * 2 & spaces(1) ,coltop,xpos=xpos)
         printLn2(spaces(1) & efb2 * 2 & spaces(3) & efb2 * 2 & spaces(1) ,col,xpos=xpos)
         printLn2(spaces(2) & efs2 * 2 & spaces(1) & efs2 * 2 & spaces(2) ,col,xpos=xpos)
         printLn2(spaces(4) & efl1 * 2 & spaces(4),col,xpos=xpos)
         printLn2(spaces(2) & efs2 * 2 & spaces(1) & efs2 * 2 & spaces(2) ,col,xpos=xpos)
         printLn2(spaces(1) & efb2 * 2 & spaces(3) & efb2 * 2 & spaces(1) ,col,xpos=xpos)
         curup(6)

                   
template cxy*(npos:int=0,col: string=rndCol(),coltop:string = rndCol()) = 
         let xpos = npos + 5
         printLn2(spaces(1) & efb3 * 2 & spaces(3) & efb3 * 2, coltop,xpos=xpos)
         printLn2(spaces(1) & efb2 * 2 & spaces(3) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(2) & efs2 * 2 & spaces(1) & efs2 * 2,col,xpos=xpos)
         printLn2(spaces(4) & efl1 * 2,col,xpos=xpos)
         printLn2(spaces(4) & efl1 * 2,col,xpos=xpos)
         printLn2(spaces(3) & efl1 * 4,col,xpos=xpos)
         curup(6)
             
 
template cxz*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 8, coltop,xpos=xpos)
         printLn2(efb2 * 8,col,xpos=xpos)
         printLn2(spaces(6) & efb2 * 2 ,col,xpos=xpos)
         printLn2(spaces(3) & efb2 * 2 ,col,xpos=xpos)
         printLn2(spaces(0) & efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 8,col,xpos=xpos)    
         curup(6)
 
 
 
template cxpoint*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
         let xpos = npos+5
         printLn2(efb3 * 0 ,coltop,xpos=xpos)
         printLn2(efb2 * 0 ,col,xpos=xpos)
         printLn2(efb2 * 0 ,col,xpos=xpos)
         printLn2(efb2 * 0 ,col,xpos=xpos)
         printLn2(efb3 * 2 ,coltop,xpos=xpos)
         printLn2(efb2 * 2 ,col,xpos=xpos)
         curup(6)   
 
 
 
template cxhyphen*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
         let xpos = npos+5
         printLn2(efb3 * 0 ,coltop,xpos=xpos)
         printLn2(efb2 * 0 ,col,xpos=xpos)
         printLn2(efb3 * 5 ,coltop,xpos=xpos)
         printLn2(efb2 * 5 ,col,xpos=xpos)
         printLn2(efb2 * 0 ,coltop,xpos=xpos)
         printLn2(efb2 * 0 ,col,xpos=xpos)
         curup(6)    
       
template cxgrid*(npos:int = 0,col:string=rndCol(),coltop:string = lime) =    
         # for testing purpose
         let xpos = npos + 5
         let xwd  = 9
         loopy2(0,xwd): 
             print(efb3  ,coltop,xpos=xpos + xloopy)
         echo()
         loopy2(0,5):
               loopy2(0,xwd) :
                  cxprint(efb2 ,colgreen,xpos=xpos + xloopy)
               echo()  
         curup(6)
 
proc printFont*(s:string,col:string = rndCol() ,coltop:string = rndCol(), xpos:int = -10) = 
     ## printFont
     ## 
     ## display experimental cxfont
     ## 
     ## search cxTest for example proc printFontTest
     ## 
     ## 

     var npos = xpos
     var ccol = col
     for x in s.toLowerAscii:
        
        npos += 10
        case x 
            of 'a' : 
                     npos = npos - 1
                     cxa(npos,ccol,coltop)
                     npos = npos + 1
            of 'b' : 
                     cxb(npos,ccol,coltop)
                     npos = npos - 1
            of 'c' : cxc(npos,ccol,coltop)
            of 'd' : 
                     cxd(npos,ccol,coltop)
                     npos = npos - 1
            of 'e' : cxe(npos,ccol,coltop)
            of 'f' :
                     cxf(npos,ccol,coltop)
                     npos = npos - 1
            of 'g' : cxg(npos,ccol,coltop)
            of 'h' : cxh(npos,ccol,coltop)
            of 'i' : 
                     npos = npos - 2
                     cxi(npos,ccol,coltop)
                     npos = npos - 4
            of 'j' : 
                     cxj(npos,ccol,coltop)
                     npos = npos - 2
            of 'k' : cxk(npos,ccol,coltop)
            of 'l' : 
                     cxl(npos,ccol,coltop)
                     npos = npos - 1
            of 'm' : 
                     cxm(npos,ccol,coltop)
                     npos = npos + 1
                     
            of 'n' : cxn(npos,ccol,coltop)
            of 'o' : cxo(npos,ccol,coltop)
            of 'p' : 
                     cxp(npos,ccol,coltop)
                     npos = npos - 1
                     
            of 'q' : cxq(npos,ccol,coltop)
            of 'r' : cxr(npos,ccol,coltop)
            of 's' : cxs(npos,ccol,coltop)
            of 't' : cxt(npos,ccol,coltop)
            of 'u' : cxu(npos,ccol,coltop)
            of 'v' : cxv(npos,ccol,coltop)
            of 'w' : 
                     cxw(npos,ccol,coltop)
                     npos = npos + 1
            of 'x' : 
                     npos = npos - 1
                     cxx(npos,ccol,coltop)
            of 'y' : 
                     npos = npos - 2
                     cxy(npos,ccol,coltop)
                     
            of 'z' : cxz(npos,ccol,coltop)
            of '.' : 
                     cxpoint(npos,ccol,coltop)
                     npos = npos - 5
            of '-' : 
                     cxhyphen(npos,ccol,coltop)
                     npos = npos - 3
                     
            of ' ' : npos = npos - 5
            of '1' : 
                     cx1(npos,ccol,coltop)
                     npos = npos - 2
            of '2' : cx2(npos,ccol,coltop)
            of '3' : cx3(npos,ccol,coltop)
            of '4' : cx4(npos,ccol,coltop)
            of '5' : cx5(npos,ccol,coltop)
            of '6' : cx6(npos,ccol,coltop)
            of '7' : 
                     cx7(npos,ccol,coltop)
                     npos = npos - 1
            of '8' : cx8(npos,ccol,coltop)
            of '9' : cx9(npos,ccol,coltop)
            of '0' : cxzero(npos,ccol,coltop)
                      
            else: discard 

            
#proc printFontFancy*(s:string,col:string = rndcol(),coltop:string = rndcol(), xpos:int = -10) = 
     
proc printFontFancy*(s:string, coltop1 = rndcol(),xpos:int = -10) = 
     ## printFontFancy
     ## 
     ## display experimental cxfont with every element in rand color
     ## changing of coltop color possible
     ## 
     ## 
     ## 
     var npos = xpos
     var coltop = rndTrueCol()
     for x in s.toLowerAscii:
        npos += 10
        case x 
            of 'a' : 
                     npos = npos - 1
                     cxa(npos,coltop=coltop)
                     npos = npos + 1
            of 'b' : 
                     cxb(npos,coltop=coltop)
                     npos = npos - 1
            of 'c' : cxc(npos,coltop=coltop)
            of 'd' : 
                     cxd(npos,coltop=coltop)
                     npos = npos - 1
            of 'e' : cxe(npos,coltop=coltop)
            of 'f' :
                     cxf(npos,coltop=coltop)
                     npos = npos - 1
            of 'g' : cxg(npos,coltop=coltop)
            of 'h' : cxh(npos,coltop=coltop)
            of 'i' : 
                     npos = npos - 2
                     cxi(npos,coltop=coltop)
                     npos = npos - 4
            of 'j' : 
                     cxj(npos,coltop=coltop)
                     npos = npos - 2
            of 'k' : cxk(npos,coltop=coltop)
            of 'l' : 
                     cxl(npos,coltop=coltop)
                     npos = npos - 1
            of 'm' : 
                     cxm(npos,coltop=coltop)
                     npos = npos + 1
                     
            of 'n' : cxn(npos,coltop=coltop)
            of 'o' : cxo(npos,coltop=coltop)
            of 'p' : 
                     cxp(npos,coltop=coltop)
                     npos = npos - 1
                     
            of 'q' : cxq(npos,coltop=coltop)
            of 'r' : cxr(npos,coltop=coltop)
            of 's' : cxs(npos,coltop=coltop)
            of 't' : cxt(npos,coltop=coltop)
            of 'u' : cxu(npos,coltop=coltop)
            of 'v' : cxv(npos,coltop=coltop)
            of 'w' : 
                     cxw(npos,coltop=coltop)
                     npos = npos + 1
            of 'x' : 
                     npos = npos - 1
                     cxx(npos,coltop=coltop)
            of 'y' : 
                     npos = npos - 2
                     cxy(npos,coltop=coltop)
                     
            of 'z' : cxz(npos,coltop=coltop)
            of '.' : 
                     cxpoint(npos,coltop=coltop)
                     npos = npos - 5
            of '-' : 
                     cxhyphen(npos,coltop=coltop)
                     npos = npos - 3
                     
            of ' ' : npos = npos - 5
            of '1' : 
                     cx1(npos,coltop=coltop)
                     npos = npos - 2
            of '2' : cx2(npos,coltop=coltop)
            of '3' : cx3(npos,coltop=coltop)
            of '4' : cx4(npos,coltop=coltop)
            of '5' : cx5(npos,coltop=coltop)
            of '6' : cx6(npos,coltop=coltop)
            of '7' : 
                     cx7(npos,coltop=coltop)
                     npos = npos - 1
            of '8' : cx8(npos,coltop=coltop)
            of '9' : cx9(npos,coltop=coltop)
            of '0' : cxzero(npos,coltop=coltop)
                      
            else: discard             
 
proc printNimCx*(npos:int = tw div 2 - 30) =
        ## printNimcx
        ## 
        ##  experiments in block font building , default is center in terminal
        ## 
        #echo()
        var xpos = npos
        cxn(xpos,dodgerblue,coltop=gold)
        cxi(xpos+10,truetomato,coltop=gold)
        cxm(xpos+17,gold,coltop=gold)
        let colc = randCol2("light")
        cxc(xpos+29, colc,coltop=red)
        cxx(xpos+38,coltop=red) 
        #echo()
              

proc printMadeWithNim*(npos:int = tw div 2 - 60) =
        ## printNimcx
        ## 
        ##  experiments in block font building , default is center in terminal
        ## 
        echo()
        var xpos = npos
        cxm(xpos     ,rndCol(),coltop=red)
        cxa(xpos + 10,rndCol(),coltop=red)
        cxd(xpos + 21,rndCol(),coltop=red)
        cxe(xpos + 30,rndCol(),coltop=red)
        
        cxw(xpos + 42,rndCol(),coltop=red)
        cxi(xpos + 52,rndCol(),coltop=red)
        cxt(xpos + 58,rndCol(),coltop=red)
        cxh(xpos + 68,rndCol(),coltop=red)
        
        cxn(xpos + 82,dodgerblue,coltop=gold)
        cxi(xpos + 90,truetomato,coltop=gold)
        cxm(xpos + 96,gold,coltop=gold)
        echo()

proc printNim*(npos:int = tw div 2 - 60) =  
        echo()
        var xpos = npos
        cxn(xpos,brightcyan,coltop=red)
        cxi(xpos + 9,brightcyan,coltop=lime)
        cxm(xpos + 16,brightcyan,coltop=red)
        echo()  
        
# end experimental font   


# printing of slimfonts related routine

proc printSlimNumber*(anumber:string,fgr:string = yellowgreen ,bgr:BackgroundColor = bgBlack,xpos:int = 1) =
    ## printSlimNumber
    ##
    ## # will shortly be deprecated use:  printSlim
    ##
    ## prints an string in big slim font
    ##
    ## available chars 123456780,.:
    ##
    ##
    ## usufull for big counter etc , a clock can also be build easily but
    ## running in a tight while loop just uses up cpu cycles needlessly.
    ##
    ##.. code-block:: nim
    ##    for x in 990.. 1005:
    ##         cleanScreen()
    ##         printSlimNumber($x)
    ##         sleep(750)
    ##    echo()
    ##
    ##    printSlimNumber($23456345,blue)
    ##    decho(2)
    ##    printSlimNumber("1234567:345,23.789",fgr=salmon,xpos=20)
    ##    sleep(1500)
    ##    import times
    ##    cleanScreen()
    ##    decho(2)
    ##    printSlimNumber($getClockStr(),fgr=salmon,xpos=20)
    ##    decho(5)
    ##
    ##    for x in rxCol:
    ##       printSlimNumber($x,colorNames[x][1])
    ##       curup(3)
    ##       sleep(500)
    ##    curdn(3)

    var asn = newSeq[string]()
    var printseq = newSeq[seq[string]]()
    for x in anumber: asn.add($x)
    for x in asn:
      case  x
        of "0": printseq.add(snumber0)
        of "1": printseq.add(snumber1)
        of "2": printseq.add(snumber2)
        of "3": printseq.add(snumber3)
        of "4": printseq.add(snumber4)
        of "5": printseq.add(snumber5)
        of "6": printseq.add(snumber6)
        of "7": printseq.add(snumber7)
        of "8": printseq.add(snumber8)
        of "9": printseq.add(snumber9)
        of ":": printseq.add(scolon)
        of ",": printseq.add(scomma)
        of ".": printseq.add(sdot)
        else: discard

    for x in 0.. 2:
        curSetx(xpos)
        for y in 0..<printseq.len:
            print(" " & printseq[y][x],fgr,bgr)
        writeLine(stdout,"")



proc slimN(x:int):T7 =
  # supporting slim number printing
  var nnx : T7
  case x
    of 0: nnx.zx = snumber0
    of 1: nnx.zx = snumber1
    of 2: nnx.zx = snumber2
    of 3: nnx.zx = snumber3
    of 4: nnx.zx = snumber4
    of 5: nnx.zx = snumber5
    of 6: nnx.zx = snumber6
    of 7: nnx.zx = snumber7
    of 8: nnx.zx = snumber8
    of 9: nnx.zx = snumber9
    else: discard
  result = nnx


proc slimC(x:string):T7 =
  # supporting slim chars printing
  var nnx:T7
  case x
    of ".": nnx.zx = sdot
    of ",": nnx.zx = scomma
    of ":": nnx.zx = scolon
    of " ": nnx.zx = sblank
    else : discard
  result = nnx


proc prsn(x:int,fgr:string = termwhite,xpos:int = 0) =
     # print routine for slim numbers
     for x in slimN(x).zx: printLn2(x,fgr = fgr,xpos = xpos)

proc prsc(x:string,fgr:string = termwhite,xpos:int = 0) =
     # print routine for slim chars
     for x in slimc(x).zx: printLn2($x,fgr = fgr,xpos = xpos)


proc printSlim* (ss:string = "", frg:string = termwhite,xpos:int = 0,align:string = "left") =
    ## printSlim
    ##
    ## prints available slim numbers and slim chars
    ##
    ## right alignment : the string will be written left of xpos position
    ## left  alignment : the string will be written right of xpos position
    ##
    ## make sure enough space is available left or right of xpos
    ##
    ##.. code-block:: nim
    ##      printSlim($"82233.32",salmon,xpos = 25,align = "right")
    ##      decho(3)
    ##      printSlim($"33.87",salmon,xpos = 25,align = "right")
    ##      ruler(25,lime)
    ##      decho(3)
    ##      printSlim($"82233.32",peru,xpos = 25)
    ##      decho(3)
    ##      printSlim($"33.87",peru,xpos = 25)
    ##

    var npos = xpos
    #if we want to right align we need to know the overall length, which needs a scan
    var sswidth = 0
    if align.toLowerAscii() == "right":
      for x in ss:
         if $x in slimCharSet:
           sswidth = sswidth + 1
         else:
           sswidth = sswidth + 3

    for x in ss:
      if $x in slimcharset:
        prsc($x ,frg, xpos = npos - sswidth)
        npos = npos + 1
        curup(3)
      else:
        var mn:int = parseInt($x)
        prsn(mn ,frg, xpos = npos - sswidth)
        npos = npos + 3
        curup(3)
        
# routines for dotmatrix font
# see dotmatrixraw in cxconsts
        
let cxfonts = toSet(["dotmatrix","bracketmatrix","sideways"])

proc printCxFontLetter*(n:int,xpos:int,cxfont:seq[seq[string]],color:string) =
  for y in 0 ..< cxfont[n].len:
        printLn2(cxfont[n][y].replace("@","").replace("$",""),color,xpos = xpos,styled={styleBright}) 
  curup(9)


proc printCxFontText*(textseq:seq[int],xpos:int = 2,cxfont:seq[seq[string]],color:string = randcol()) = 
  var nxpos = xpos
  for achar in textseq:
      printCxFontLetter(achar,nxpos,cxfont,color)
      nxpos = nxpos + 19
  decho(5)

  
proc createCxFont*(name:string):seq[seq[string]] =
   if name in cxfonts:
     case name 
     
       of "dotmatrix":
                var c = dotmatrixraw.replace("_",".").replace("(","|").replace(")","|")
                var cs = c.splitlines()
                #echo "cs len : ",cs.len
                var cdotmatrixfont = newSeq[seq[string]]()
                var caseq = newseq[string]()
                for x in 0 .. cs.len - 1:
                  if cs[x].contains("@@") == true:
                      cdotmatrixfont.add(caseq)
                      caseq = @[]
                  else:    
                      caseq.add(cs[x])
                result = cdotmatrixfont  
                
       of "bracketmatrix":    # the original font in dotmatrixraw
                #echo dotmatrixraw   # prints ok
                var bs = dotmatrixraw.splitlines()
                #for x in 0 .. bs.len - 1: printLn(bs[x],rndcol())   # ok
                #echo "bs len : ",bs.len
                var dotmatrixfont = newSeq[seq[string]]()
                var aseq = newseq[string]()
                for x in 0 .. bs.len - 1:
                    if bs[x].contains("@@") == true:
                       dotmatrixfont.add(aseq)
                       aseq = @[]
                    else:    
                       aseq.add(bs[x])
                result = dotmatrixfont    
                
       of "sideways":    # the original font in sidewaysraw
                #echo dotmatrixraw   # prints ok
                var ss = sidewaysraw.splitlines()
                #for x in 0 .. ss.len - 1: printLn(ss[x],rndcol())   # ok
                #echo "ss len : ",ss.len
                var sidewaysfont = newSeq[seq[string]]()
                var sseq = newseq[string]()
                for x in 0 .. ss.len - 1:
                    if ss[x].contains("##") == true:
                       sidewaysfont.add(sseq)
                       sseq = @[]
                    else:    
                       sseq.add(ss[x].replace("#",""))
                result = sidewaysfont    
                        
                
                
                
                
                
proc showCxFont*(name:string) =
     if name in cxfonts:
       case name 
          of "dotmatrix":
             decho(5)
             var cdotmatrixfont = createCxFont(name)
             #echo "dotmatrixfont len : ", cdotmatrixfont.len   
             var xpos = 2
             for x in 0 ..< cdotmatrixfont.len:
                for y in 0 ..< cdotmatrixfont[x].len:
                   printLnBiCol2(cdotmatrixfont[x][y].replace("@","").replace("$","") & cxlpad(":" & $x,3),colLeft=clRainbow,colRight = lightgrey,xpos = xpos)                                         
                curup(9)
                xpos = xpos + 27
                if xpos > 110: 
                    xpos = 2
                    decho(12)
             decho(5)
             
          of "bracketmatrix":
             var dotmatrixfont = createCxFont(name)
             #echo "bracketmatrix len : ", dotmatrixfont.len   
             #echo dotmatrixfont[5]
             var xpos = 2
             for x in 0 ..< dotmatrixfont.len:
                for y in 0 ..< dotmatrixfont[x].len:
                   printLnBiCol2(dotmatrixfont[x][y].replace("@","").replace("$","") & cxlpad(":" & $x,3),colLeft=clRainbow,colRight = lightgrey,xpos = xpos)                                                                                 
                curup(9)
                xpos = xpos + 27
                if xpos > 110: 
                  xpos = 2
                  decho(12)
             decho(5)
             
          of "sideways":   
             var sidewaysfont = createCxFont(name)
             #echo "bracketmatrix len : ", dotmatrixfont.len   
             #echo dotmatrixfont[5]
             var xpos = 2
             for x in 0 ..< sidewaysfont.len:
                for y in 0 ..< sidewaysfont[x].len:
                   printLnBiCol2(sidewaysfont[x][y] & cxlpad(":" & $x,3),colLeft=clRainbow,colRight = lightgrey,xpos = xpos)                                                                                 
                curup(5)
                xpos = xpos + 27
                if xpos > 110: 
                  xpos = 2
                  decho(9)
             decho(5)
       
# example usage for dotmatrix fonts
# currently 2 are available dotmatrix and bracketmatrix        
        
proc dotMatrixFontTest*() =
    ## dotMatrixFontTest
    ## 
    ## The current way to use fonts bracketmatrix and dotmatrix
    ## 
    ## is to run 
    ##
    ##.. code-block:: nim 
    ##  import nimcx 
    ##  showCxFont("dotmatrix")   # or "bracketmatrix"
    ## 
    ## note the numbers next to the required characters
    ## 
    ## and then 
    ## 
    ##.. code-block:: nim
    ##    let myfont = createCxFont("dotmatrix")
    ##    # lets print <NIM>123
    ##    printCxFontText(@[12,30,25,29,14,1,2,3],xpos = 2,myfont) 
    ## 
    ##    
    ## Alternatively compile cxmatrixfontE1.nim which calls this function
    ##             
    showCxFont("bracketmatrix")  
    decho(10)
    showCxFont("dotmatrix") 
    decho(10)
    showCxFont("sideways") 
    decho(10)
    
    let myfont = createCxFont("dotmatrix")
    printCxFontText(@[51,62,67,60,48,67,65,56,71],xpos = 1,myfont)  # dotmatrix
    decho(5)
    printCxFontText(@[12,30,25,29,14,0,1,2,3,4],xpos = 2,myfont)    # <NIM>01234
    decho(12)
    
    let myotherfont = createCxFont("bracketmatrix")
    printCxFontText(@[49,65,48,50,58,52,67],xpos = 1, myotherfont) # bracket
    decho(4)
    printCxFontText(@[60,48,67,65,56,71],xpos = 60,myotherfont)    # matrix
    decho(5)
    printCxFontText(@[12,30,25,29,14,5,6,7,8,9],xpos = 2,myotherfont)  # <NIM>56789
    decho(10)
    
    
    let mysidewaysfont = createCxFont("sideways")
    printCxFontText(@[41],xpos = 3,mysidewaysfont)  # N
    decho(3)
    printCxFontText(@[36],xpos = 3,mysidewaysfont)  # I
    decho(3)
    printCxFontText(@[40],xpos = 3,mysidewaysfont)  # M
    decho(3)
    printCxFontText(@[16],xpos = 3,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[14],xpos = 3,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[15],xpos = 3,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[22],xpos = 3,mysidewaysfont)  # 2
    decho(3)
    curup(25)
    printCxFontText(@[30,25,29,19,40],xpos = 50,myfont)
    decho(5)
    printCxFontText(@[60,48,67,65,56,71],xpos = 40,myotherfont)
    curup(18)
    let dl = tw - 12
    printCxFontText(@[41],xpos = dl,mysidewaysfont)  # N
    decho(3)
    printCxFontText(@[36],xpos = dl,mysidewaysfont)  # I
    decho(3)
    printCxFontText(@[40],xpos = dl,mysidewaysfont)  # M
    decho(3)
    printCxFontText(@[16],xpos = dl,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[14],xpos = dl,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[15],xpos = dl,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[22],xpos = dl,mysidewaysfont)  # 2
    decho(3)
    
    decho(5)
# end of dotmatrixfont related functions        

       
# 
# ###### old block font  currently commented out as not in use
# # some handmade font...
# let a1 = "  ██   "
# let a2 = " ██ █  "
# let a3 = "██   █ "
# let a4 = "██ █ █ "
# let a5 = "██   █ "
# 
# 
# let b1 = "███ █  "
# let b2 = "██   █ "
# let b3 = "███ █  "
# let b4 = "██   █ "
# let b5 = "███ █  "
# 
# 
# let c1 = " █████ "
# let c2 = "██     "
# let c3 = "██     "
# let c4 = "██     "
# let c5 = " █████ "
# 
# 
# let d1 = "███ █  "
# let d2 = "██   █ "
# let d3 = "██   █ "
# let d4 = "██   █ "
# let d5 = "███ █  "
# 
# 
# let e1 = "█████  "
# let e2 = "██     "
# let e3 = "████   "
# let e4 = "██     "
# let e5 = "█████  "
# 
# 
# let f1 = "█████  "
# let f2 = "██     "
# let f3 = "████   "
# let f4 = "██     "
# let f5 = "██     "
# 
# 
# let g1 = " ████  "
# let g2 = "██     "
# let g3 = "██  ██ "
# let g4 = "██   █ "
# let g5 = " ████  "
# 
# 
# let h1 = "██   █ "
# let h2 = "██   █ "
# let h3 = "██████ "
# let h4 = "██   █ "
# let h5 = "██   █ "
# 
# 
# let i1 = "  ██   "
# let i2 = "  ██   "
# let i3 = "  ██   "
# let i4 = "  ██   "
# let i5 = "  ██   "
# 
# 
# let j1 = "    ██ "
# let j2 = "    ██ "
# let j3 = "    ██ "
# let j4 = " █  ██ "
# let j5 = "  ██   "
# 
# 
# let k1 = "██   █ "
# let k2 = "██  █  "
# let k3 = "██ █   "
# let k4 = "██  █  "
# let k5 = "██   █ "
# 
# 
# let l1 = "██     "
# let l2 = "██     "
# let l3 = "██     "
# let l4 = "██     "
# let l5 = "██████ "
# 
# 
# let m1 = "███ ██ "
# let m2 = "██ █ █ "
# let m3 = "██ █ █ "
# let m4 = "██   █ "
# let m5 = "██   █ "
# 
# 
# let n1 = "██   █ "
# let n2 = "███  █ "
# let n3 = "██ █ █ "
# let n4 = "██  ██ "
# let n5 = "██   █ "
# 
# 
# let o1 = " ████  "
# let o2 = "██   █ "
# let o3 = "██   █ "
# let o4 = "██   █ "
# let o5 = " ████  "
# 
# 
# let p1 = "██ ██  "
# let p2 = "██   █ "
# let p3 = "██ ██  "
# let p4 = "██     "
# let p5 = "██     "
# 
# 
# let q1 = " ████  "
# let q2 = "██   █ "
# let q3 = "██   █ "
# let q4 = "██ █ █ "
# let q5 = " ██ █  "
# 
# 
# let r1 = "███ █  "
# let r2 = "██   █ "
# let r3 = "███ █  "
# let r4 = "██   █ "
# let r5 = "██   █ "
# 
# 
# let s1 = "  █ ██ "
# let s2 = " █     "
# let s3 = "   █   "
# let s4 = "     █ "
# let s5 = " ██ █  "
# 
# 
# let t1 = "██████ "
# let t2 = "  ██   "
# let t3 = "  ██   "
# let t4 = "  ██   "
# let t5 = "  ██   "
# 
# 
# let u1 = "██   █ "
# let u2 = "██   █ "
# let u3 = "██   █ "
# let u4 = "██   █ "
# let u5 = "██████ "
# 
# 
# let v1 = "██   █ "
# let v2 = "██   █ "
# let v3 = "██   █ "
# let v4 = " █  █  "
# let v5 = "  ██   "
# 
# 
# let w1 = "██   █ "
# let w2 = "██   █ "
# let w3 = "██ █ █ "
# let w4 = " █ █ █ "
# let w5 = "  █ █  "
# 
# 
# let x1 = "██   █ "
# let x2 = "  █ █  "
# let x3 = "   █   "
# let x4 = "  █ █  "
# let x5 = "██   █ "
# 
# 
# let y1 = "██   █ "
# let y2 = "  █ █  "
# let y3 = "   █   "
# let y4 = "   █   "
# let y5 = "   █   "
# 
# 
# 
# let z1 = "██████ "
# let z2 = "    █  "
# let z3 = "   █   "
# let z4 = " █     "
# let z5 = "██████ "
# 
# 
# let hy1= "       "
# let hy2= "       "
# let hy3= " █████ "
# let hy4= "       "
# let hy5= "       "
# 
# 
# let pl1= "       "
# let pl2= "   █   "
# let pl3= " █████ "
# let pl4= "   █   "
# let pl5= "       "
# 
# 
# let ul1 = "      "
# let ul2 = "      "
# let ul3 = "      "
# let ul4 = "      "
# let ul5 = "██████"
# 
# 
# let el1 = "      "
# let el2 = "██████"
# let el3 = "      "
# 
# let el4 = "██████"
# let el5 = "      "
# 
# 
# let clb1 = spaces(6)
# let clb2 = spaces(6)
# let clb3 = spaces(6)
# let clb4 = spaces(6)
# let clb5 = spaces(6)
# 
# 
# let abx* = @[a1,a2,a3,a4,a5]
# let bbx* = @[b1,b2,b3,b4,b5]
# let cbx* = @[c1,c2,c3,c4,c5]
# let dbx* = @[d1,d2,d3,d4,d5]
# let ebx* = @[e1,e2,e3,e4,e5]
# let fbx* = @[f1,f2,f3,f4,f5]
# let gbx* = @[g1,g2,g3,g4,g5]
# let hbx* = @[h1,h2,h3,h4,h5]
# let ibx* = @[i1,i2,i3,i4,i5]
# let jbx* = @[j1,j2,j3,j4,j5]
# let kbx* = @[k1,k2,k3,k4,k5]
# let lbx* = @[l1,l2,l3,l4,l5]
# let mbx* = @[m1,m2,m3,m4,m5]
# let nbx* = @[n1,n2,n3,n4,n5]
# let obx* = @[o1,o2,o3,o4,o5]
# let pbx* = @[p1,p2,p3,p4,p5]
# let qbx* = @[q1,q2,q3,q4,q5]
# let rbx* = @[r1,r2,r3,r4,r5]
# let sbx* = @[s1,s2,s3,s4,s5]
# let tbx* = @[t1,t2,t3,t4,t5]
# let ubx* = @[u1,u2,u3,u4,u5]
# let vbx* = @[v1,v2,v3,v4,v5]
# let wbx* = @[w1,w2,w3,w4,w5]
# let xbx* = @[x1,x2,x3,x4,x5]
# let ybx* = @[y1,y2,y3,y4,y5]
# let zbx* = @[z1,z2,z3,z4,z5]
# 
# let hybx* = @[hy1,hy2,hy3,hy4,hy5]
# let plbx* = @[pl1,pl2,pl3,pl4,pl5]
# let ulbx* = @[ul1,ul2,ul3,ul4,ul5]
# let elbx* = @[el1,el2,el3,el4,el5]
# 
# let clbx* = @[clb1,clb2,clb3,clb4,clb5]
# 
# let bigLetters* = @[abx,bbx,cbx,dbx,ebx,fbx,gbx,hbx,ibx,jbx,kbx,lbx,mbx,nbx,obx,pbx,qbx,rbx,sbx,tbx,ubx,vbx,wbx,xbx,ybx,zbx,hybx,plbx,ulbx,elbx,clbx]
# 
# # a big block number set which can be used with printBigNumber
# # for the newer experimental block font see printfont() in cx.nim
# 
# const number0 =
#  @["██████"
#   ,"██  ██"
#   ,"██  ██"
#   ,"██  ██"
#   ,"██████"]
# 
# const number1 =
#  @["    ██"
#   ,"    ██"
#   ,"    ██"
#   ,"    ██"
#   ,"    ██"]
# 
# const number2 =
#  @["██████"
#   ,"    ██"
#   ,"██████"
#   ,"██    "
#   ,"██████"]
# 
# const number3 =
#  @["██████"
#   ,"    ██"
#   ,"██████"
#   ,"    ██"
#   ,"██████"]
# 
# const number4 =
#  @["██  ██"
#   ,"██  ██"
#   ,"██████"
#   ,"    ██"
#   ,"    ██"]
# 
# const number5 =
#  @["██████"
#   ,"██    "
#   ,"██████"
#   ,"    ██"
#   ,"██████"]
# 
# const number6 =
#  @["██████"
#   ,"██    "
#   ,"██████"
#   ,"██  ██"
#   ,"██████"]
# 
# const number7 =
#  @["██████"
#   ,"    ██"
#   ,"    ██"
#   ,"    ██"
#   ,"    ██"]
# 
# const number8 =
#  @["██████"
#   ,"██  ██"
#   ,"██████"
#   ,"██  ██"
#   ,"██████"]
# 
# const number9 =
#  @["██████"
#   ,"██  ██"
#   ,"██████"
#   ,"    ██"
#   ,"██████"]
# 
# const colon =
#  @["      "
#   ,"  ██  "
#   ,"      "
#   ,"  ██  "
#   ,"      "]
# 
# const plussign =
#  @["      "
#   ,"  ██  "
#   ,"██████"
#   ,"  ██  "
#   ,"      "]
# 
# const equalsign =
#  @["      "
#   ,"██████"
#   ,"      "
#   ,"██████"
#   ,"      "]
#  
# const minussign =
#  @["      "
#   ,"      "
#   ,"██████"
#   ,"      "
#   ,"      "] 
#  
# const clrb =
#  @["      "
#   ,"      "
#   ,"      "
#   ,"      "
#   ,"      "]
#   
#   
# const bigdot =
#  @["      "
#   ,"      "
#   ,"      "
#   ,"      "
#   ,"  ██  "]
# 
# 
# const numberlen = 4
# 
# # big NIM in block letters
# # see printNimSxR for how to print this sets and similar one you make up
# 
# let NIMX1 = "██     █    ██    ███   ██"
# let NIMX2 = "██ █   █    ██    ██ █ █ █"
# let NIMX3 = "██  █  █    ██    ██  █  █"
# let NIMX4 = "██   █ █    ██    ██  █  █"
# let NIMX5 = "██     █    ██    ██     █"
# 
# let nimsx* = @[NIMX1,NIMX2,NIMX3,NIMX4,NIMX5]
# 
# 
# let NIMX6  = "███   ██  ██  ██     █  ██"
# let NIMX7  = "██ █ █ █  ██  ██ █   █  ██"
# let NIMX8  = "██  █  █  ██  ██  █  █  ██"
# let NIMX9  = "██  █  █  ██  ██   █ █  ██"
# let NIMX10 = "██     █  ██  ██     █  ██"
# 
# let nimsx2* = @[NIMX6,NIMX7,NIMX8,NIMX9,NIMX10]
# 
# 
# # large font printing, numbers are implemented
# 
# proc printBigNumber*(xnumber:string|int|int64,fgr:string = yellowgreen ,bgr:BackgroundColor = bgBlack,xpos:int = 1,fun:bool = false) =
#     ## printBigNumber
#     ##
#     ## prints a string in big block font
#     ##
#     ## available 1234567890:
#     ##
#     ##
#     ## if fun parameter = true then foregrouncolor will be ignored and every block
#     ##
#     ## element colored individually
#     ##
#     ##
#     ## xnumber can be given as int or string
#     ##
#     ## usufull for big counter etc , a clock can also be build easily but
#     ## running in a tight while loop just uses up cpu cycles needlessly.
#     ##
#     ## .. code-block:: nim
#     ##    for x in 990..1105:
#     ##         cleanScreen()
#     ##         printBigNumber(x)
#     ##         sleepy(3)
#     ##
#     ##    cleanScreen()
#     ##
#     ##    printBigNumber($23456345,steelblue)
#     ##
#     ## .. code-block:: nim
#     ##    import nimcx
#     ##    for x in countdown(9,0):
#     ##         cleanScreen()
#     ##         if x == 5:
#     ##             for y in countup(10,25):
#     ##                 cleanScreen()
#     ##                 printBigNumber($y,tomato)
#     ##                 sleepy(0.5)
#     ##         cleanScreen()
#     ##         printBigNumber($x)
#     ##         sleepy(0.5)
#     ##    doFinish()
# 
#     let anumber = $xnumber
#     var asn = newSeq[string]()
#     var printseq = newSeq[seq[string]]()
#     for x in anumber: asn.add($x)
#     for x in asn:
#       case  x
#         of "0": printseq.add(number0)
#         of "1": printseq.add(number1)
#         of "2": printseq.add(number2)
#         of "3": printseq.add(number3)
#         of "4": printseq.add(number4)
#         of "5": printseq.add(number5)
#         of "6": printseq.add(number6)
#         of "7": printseq.add(number7)
#         of "8": printseq.add(number8)
#         of "9": printseq.add(number9)
#         of ":": printseq.add(colon)
#         of " ": printseq.add(clrb)
#         of "+": printseq.add(plussign)
#         of "-": printseq.add(minussign)
#         of "=": printseq.add(equalsign)
#         of ".": printseq.add(bigdot)
#         else: discard
# 
#     for x in 0..numberlen:
#         curSetx(xpos)
#         for y in 0..<printseq.len:
#             if fun == false:
#                print(" " & printseq[y][x],fgr,bgr)
#             else:
#                 # we want to avoid black
#                 var funny = randcol()
#                 while funny == black: funny = randcol()
#                 print(" " & printseq[y][x],funny,bgr)
#         echo()
#     curup(5)
# 
# 
# 
# 
# proc printBigLetters*(aword:string,fgr:string = yellowgreen ,bgr:BackgroundColor = bgBlack,xpos:int = 1,k:int = 7,fun:bool = false) =
#   ## printBigLetters
#   ##
#   ## prints big block letters in desired color at desired position
#   ##
#   ## note position must be specified as global in format :   var xpos = 5
#   ##
#   ## if fun parameter = true then foregrouncolor will be ignored and every block
#   ##
#   ## element colored individually
#   ##
#   ## k parameter specifies character distance reasonable values are 7,8,9,10 . Default = 7
#   ##
#   ## also note that depending on terminal width only a limited number of chars can be displayed
#   ##
#   ##
#   ##
#   ## .. code-block:: nim
#   ##       printBigLetters("ABA###RR#3",xpos = 1)
#   ##       printBigLetters("#",xpos = 1)   # the '#' char is used to denote a blank space or to overwrite
#   ##       printBigLetters("Nim#DOES#IT#AGAIN",xpos = 1,fun=true)
# 
#   var xpos = xpos
#   template abc(s:typed,xpos:int) =
#       # abc
#       #
#       # template to support printBigLetters
#       #
# 
#       for x in 0..4:
#         if fun == false:
#            printLn(s[x],fgr = fgr,bgr = bgr ,xpos = xpos)
#         else:
#            # we want to avoid black
#            var funny = randcol()
#            while funny == black:
#                funny = randcol()
#            printLn(s[x],fgr = funny,bgr = bgr ,xpos = xpos)
#       curup(5)
#       xpos = xpos + k
# 
#   for aw in aword:
#       let aws = $aw
#       var ak = aws.toLowerAscii()
#       case ak
#       of "a" : abc(abx,xpos)
#       of "b" : abc(bbx,xpos)
#       of "c" : abc(cbx,xpos)
#       of "d" : abc(dbx,xpos)
#       of "e" : abc(ebx,xpos)
#       of "f" : abc(fbx,xpos)
#       of "g" : abc(gbx,xpos)
#       of "h" : abc(hbx,xpos)
#       of "i" : abc(ibx,xpos)
#       of "j" : abc(jbx,xpos)
#       of "k" : abc(kbx,xpos)
#       of "l" : abc(lbx,xpos)
#       of "m" : abc(mbx,xpos)
#       of "n" : abc(nbx,xpos)
#       of "o" : abc(obx,xpos)
#       of "p" : abc(pbx,xpos)
#       of "q" : abc(qbx,xpos)
#       of "r" : abc(rbx,xpos)
#       of "s" : abc(sbx,xpos)
#       of "t" : abc(tbx,xpos)
#       of "u" : abc(ubx,xpos)
#       of "v" : abc(vbx,xpos)
#       of "w" : abc(wbx,xpos)
#       of "x" : abc(xbx,xpos)
#       of "y" : abc(ybx,xpos)
#       of "z" : abc(zbx,xpos)
#       of "-" : abc(hybx,xpos)
#       of "+" : abc(plbx,xpos)
#       of "_" : abc(ulbx,xpos)
#       of "=" : abc(elbx,xpos)
#       of "#" : abc(clbx,xpos)
#       of "1","2","3","4","5","6","7","8","9","0",":":
#                printBigNumber($aw,fgr = fgr , bgr = bgr,xpos = xpos,fun = fun)
#                curup(5)
#                xpos = xpos + k
#       of " " : xpos = xpos + 2
#       else: discard
# 
# proc printNimSxR*(nimsx:seq[string],col:string = yellowgreen, xpos: int = 1) =
#     ## printNimSxR
#     ##
#     ## prints large Letters or a word which have been predefined
#     ##
#     ## see values of nimsx1 and nimsx2 above
#     ##
#     ##
#     ## .. code-block:: nim
#     ##    printNimSxR(nimsx,xpos = 10)
#     ##
#     ## allows x positioning
#     ##
#     ## in your calling code arrange that most right one is printed first
#     ##
# 
#     var sxpos = xpos
#     var maxl = 0
# 
#     for x in nimsx:
#       if maxl < x.len:
#           maxl = x.len
# 
#     var maxpos = cx.tw - maxl div 2
# 
#     if xpos > maxpos:
#           sxpos = maxpos
# 
#     for x in nimsx :
#           printLn(" ".repeat(xpos) & x,randcol())
# 
