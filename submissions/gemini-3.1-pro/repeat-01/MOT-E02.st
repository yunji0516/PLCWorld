PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    timer : TON;
    comp_cond : BOOL;
END_VAR

IF X10 AND (state = 0) THEN
    state := 1;
END_IF

CASE state OF
    1:
        Y21 := TRUE;
        (* Wait for new reference setting and home complete from the drive *)
        IF X11 AND X13 THEN
            state := 2;
            Y21 := FALSE;
        END_IF
    2:
        (* Deactivate Home as part of completion requirements *)
        Y21 := FALSE;
END_CASE

(* Actual completion condition: new reference valid, home deactivated, and actual stop *)
comp_cond := (state = 2) AND X11 AND (NOT Y21) AND (D12 = 0);

timer(IN := comp_cond, PT := T#30ms);

IF timer.Q THEN
    Y2 := TRUE;
END_IF

END_PROGRAM