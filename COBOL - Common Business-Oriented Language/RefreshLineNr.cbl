 00010 IDENTIFICATION DIVISION.       
 00020 PROGRAM-ID.    RENUMBER-PROG. 
 00030 AUTHOR.        TIMOTHY R P BROWN.  
 00040    
 00045******************************************************  
 00050* Program to refresh numbers to typed code           *       
 00060* Allows for comment all characters at position 7    *
 00065****************************************************** 
 00070                                       
 00080                  
 00090 ENVIRONMENT DIVISION.
 00100 INPUT-OUTPUT SECTION.     
 00110 FILE-CONTROL.                   
 00120        SELECT IN-FILE ASSIGN TO 'INPUT.COB'   
 00130        ORGANIZATION IS LINE SEQUENTIAL.     
 00140        SELECT OUT-FILE ASSIGN TO 'RENUM.COB'   
 00150        ORGANIZATION IS LINE SEQUENTIAL.   
 00160                
 00170 DATA DIVISION.     
 00180 FILE SECTION.    
 00190                         
 00200 FD IN-FILE.               
 00210 01 CODE-IN.
 00230        03 OLD-NUM  PIC 9(6).            
 00240        03 IN-CODE  PIC X(150).         
 00250                              
 00260 FD OUT-FILE.      
 00270 01 CODE-OUT        PIC X(91).    
 00280                        
 00290                         
 00300 WORKING-STORAGE SECTION.   
 00310                           
 00320 01 EOF-FLAG	PIC X VALUE 'N'.  
 00330        88 END-OF-FILE  VALUE 'Y'.    
 00340                            
 00350              
 00360 01 W-RENUMBER-CODE.      
 00370        03 W-NUM   PIC 9(6) VALUE ZEROS.    
 00380    03 W-CODE      PIC X(85) VALUE SPACES.  
 00390                            
 00400 01 LINE-NUMBER    PIC 9(6) VALUE ZEROS.    
 00403
 00407*****************************************************
 00410                                      
 00420 PROCEDURE DIVISION.                  
 00430 MAIN-PARA.                   
 00440        OPEN INPUT IN-FILE    
 00450             OUTPUT OUT-FILE     
 00460                               
 00470        PERFORM UNTIL END-OF-FILE      
 00480           ADD 10 TO LINE-NUMBER           
 00490           READ IN-FILE 
 00495              AT END MOVE 'Y' TO EOF-FLAG 
 00500              NOT AT END             
 00510                MOVE IN-CODE TO W-CODE        
 00520                MOVE LINE-NUMBER TO W-NUM    
 00530                WRITE CODE-OUT FROM W-RENUMBER-CODE  
 00550           END-READ  
 00570        END-PERFORM    
 00580                       
 00590        CLOSE IN-FILE OUT-FILE            
 00600        STOP RUN.    
