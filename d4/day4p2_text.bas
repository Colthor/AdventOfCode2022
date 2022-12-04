      REM these globals hold the pairs on the current line
      REM A1%-A2%,B1%-B2%
      LET A1%=0
      LET A2%=0
      LET B1%=0
      LET B2%=0

      LET count%=0

      file=OPENIN("day4.txt")
      WHILE NOT EOF#file
        line$=GET$#file
        PROC_parseline(line$)
        PRINT A1%, A2%, B1%, B2%
        IF (A1% <= B2% AND A2% >= B1%) THEN
          count%=count%+1
        ENDIF
      ENDWHILE
      PRINT "Count: ", count%
      END

      REM read the line into the globals at the top.
      DEF PROC_parseline(in$)
      start%=0
      end%=0
      end%=INSTR(in$, "-", 0)
      A1%=VAL(MID$(in$, 0, end%))
      start%=end%
      end%=INSTR(in$, ",", start%)
      A2%=VAL(MID$(in$, start%+1, end%))
      start%=end%
      end%=INSTR(in$, "-", start%)
      B1%=VAL(MID$(in$, start%+1, end%))
      B2%=VAL(MID$(in$, end%+1, LEN(in$)))
      ENDPROC
