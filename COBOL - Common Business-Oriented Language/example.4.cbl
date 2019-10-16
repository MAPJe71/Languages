000010*
000020* This is a test Program that demonstrates
000030* automatic OSVS to FSC migration using osvsf2cs.
000040*
000050 IDENTIFICATION DIVISION.
000060 PROGRAM-ID. SAMPROG.
000070
000080 ENVIRONMENT DIVISION.
000090 CONFIGURATION SECTION.
000100 SPECIAL-NAMES.
000110     C02 IS ADVANCE-1.
000120 INPUT-OUTPUT SECTION.
000130 FILE-CONTROL.
000140     SELECT WORK-FILE
000150     ACCESS MODE IS SEQUENTIAL
000160     ASSIGN TO WFILE-NAME.
000170
000180 DATA DIVISION.
000190 FILE SECTION.
000200 FD  WORK-FILE
000210     LABEL RECORDS ARE STANDARD
000220     RECORDING MODE IS V
000230     BLOCK CONTAINS 0 RECORDS.
000240 01  WORK-RECORD              PIC X(80).
000250
000260 WORKING-STORAGE SECTION.
000270* Non-standard nonnumeric literal continuation.
000280 01  MSG                      PIC X(80) VALUE 'SAMPPROG -
000290-     'FILE WRITTEN - JUST A TEST'.
000300* Sync clauses are moved down.
000310 01  SYNC-GROUP               SYNC.
000320     03 WFILE-NAME            PIC X(30) VALUE "file.out".
000330     03 NUM-FIELD             PIC 9(4) COMP.
000340* Reserved words like TRANSACTION are renamed.
000350 01  RES-WORDS.
000360     03 SORT-STATUS           PIC 9(2).
000370     03 TRANSACTION           PIC X(10) VALUE 'trn-id-1'.
000380     03 SUFFIX                PIC X.
000390 01  CDATE                    PIC X(8).
000400 01  CTIME                    PIC X(8).
000410     EJECT
000420*
000430****************************************************************
000440*
000450 PROCEDURE DIVISION.
000460 INIT-DATE.
000470     OPEN OUTPUT WORK-FILE.
000480* Exhibit statement is converted to DISPLAY
000490     EXHIBIT NAMED TRANSACTION.
000500     MOVE ALL "A" TO WORK-RECORD.
000510* Mnemonic advances are propagated
000520     WRITE WORK-RECORD AFTER ADVANCING ADVANCE-1.
000530     CLOSE WORK-FILE.
000540     DISPLAY MSG.
000550* CURRENT-DATE and TIME-OF-DAY special registers
000560* are computed from the system functions.
000570     MOVE CURRENT-DATE TO CDATE.
000580     MOVE TIME-OF-DAY TO CTIME.
000590     DISPLAY " Date: " CDATE
000600             " Time: " CTIME.
000610     GOBACK.