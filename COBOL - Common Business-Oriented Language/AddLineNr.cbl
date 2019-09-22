000010 IDENTIFICATION DIVISION.                       
000020 PROGRAM-ID. LINE-NO-PROG.                        
000030 AUTHOR.     TIM R P BROWN.    
000040****************************************************
000050* Program to add line numbers to typed code        *    
000060* Allows for comment asterisk, solidus, or hyphen ,*     
000070* moving it into position 7.                       *  
000080*                                                  *  
000090****************************************************  
000100                              
000110 ENVIRONMENT DIVISION.              
000120 INPUT-OUTPUT SECTION.              
000130 FILE-CONTROL.                 
000140     SELECT IN-FILE ASSIGN TO 'INPUT.TXT'     
000150        ORGANIZATION IS LINE SEQUENTIAL.  
000160     SELECT OUT-FILE ASSIGN TO 'OUTPUT.COB'      
000170        ORGANIZATION IS LINE SEQUENTIAL. 
000180 
000185*****************************************************
000187                    
000190 DATA DIVISION.                     
000200 FILE SECTION.                   
000210             
000220 FD IN-FILE.                      
000230 01 LINE-CODE-IN.            
000240     03 CHAR-1       PIC X.     
000250     03 CODE-LINE    PIC X(110).       
000260                                
000270 FD OUT-FILE.                 
000280 01 LINE-CODE-OUT    PIC X(120).             
000290                                                 
000300                                            
000310 WORKING-STORAGE SECTION.                  
000320                                   
000330 01 EOF-FLAG     PIC X VALUE 'N'.        
000340     88 END-OF-FILE        VALUE 'Y'.   
000350                                        
000360 01 NUMBER-CODE.                               
000370     03 L-NUM-CODE    PIC 9(6) VALUE ZEROS.    
000380     03 B-SPACE   PIC X VALUE SPACE.          
000390     03 L-CODE    PIC X(100) VALUE SPACES.    
000400                            
000410 01 NUMBER-COMMENT.                 
000420     03 L-NUM-COM     PIC 9(6) VALUE ZEROS.     
000430     03 L-COMMENT     PIC X(100) VALUE SPACES.  
000440                       
000450 01 LINE-NUMBER      PIC 9(6) VALUE ZEROS.     
000460                     
000470                            
000480*****************************************************
000490                              
000500 PROCEDURE DIVISION.
000510                                              
000510 MAIN-PARA.                        
000520     OPEN INPUT IN-FILE                
000530          OUTPUT OUT-FILE
000535        
000540     PERFORM UNTIL END-OF-FILE              
000550       ADD 10 TO LINE-NUMBER                
000560       READ IN-FILE AT END    
000570         MOVE 'Y' TO EOF-FLAG              
000580       NOT AT END                   
000590         IF     (CHAR-1 = '*')             
000600                  OR (CHAR-1 = '/')             
000610                  OR (CHAR-1 = '-') THEN        
000620            MOVE LINE-CODE-IN TO L-COMMENT   
000630            MOVE LINE-NUMBER TO L-NUM-COM   
000640            WRITE LINE-CODE-OUT FROM NUMBER-COMMENT  
000660         ELSE                                  
000670            MOVE LINE-CODE-IN TO L-CODE                
000680            MOVE LINE-NUMBER TO L-NUM-CODE         
000690            WRITE LINE-CODE-OUT FROM NUMBER-CODE        
000720         END-IF                                     
000730       END-READ                                
000740       INITIALIZE NUMBER-CODE NUMBER-COMMENT   
000750     END-PERFORM                           
000760                                        
000770     CLOSE IN-FILE OUT-FILE             
000780     STOP RUN.                           
