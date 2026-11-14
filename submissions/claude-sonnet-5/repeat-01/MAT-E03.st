PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    (* internal *)
    startTrig : R_TRIG;
    started   : BOOL := FALSE;
    sel1      : BOOL := FALSE;
    sel2      : BOOL := FALSE;
    sel3      : BOOL := FALSE;
    completed : BOOL := FALSE;
    cond1     : BOOL;
    cond2     : BOOL;
    cond3     : BOOL;
    scan_count : DINT := 0;
END_VAR

startTrig(CLK := X10);

(* Latch the selection mask on the single rising edge of Start *)
IF startTrig.Q AND NOT started THEN
    started := TRUE;
    sel1 := (AND_WORD(WORD(D10), WORD(1)) <> WORD(0));
    sel2 := (AND_WORD(WORD(D10), WORD(2)) <> WORD(0));
    sel3 := (AND_WORD(WORD(D10), WORD(4)) <> WORD(0));
END_IF;

(* Do not initiate any release before Start *)
IF started THEN
    Y20 := sel1;
    Y21 := sel2;
    Y22 := sel3;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

scan_count := scan_count + 1;

(* Evaluate completion: selected products released (not holding),
   unselected products still held (identity preserved) *)
cond1 := (sel1 AND NOT X20) OR (NOT sel1 AND X20);
cond2 := (sel2 AND NOT X21) OR (NOT sel2 AND X21);
cond3 := (sel3 AND NOT X22) OR (NOT sel3 AND X22);

IF started AND cond1 AND cond2 AND cond3 THEN
    completed := TRUE;
END_IF;

IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM