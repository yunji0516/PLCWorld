PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;

    (* internal variables *)
    startTrig : R_TRIG;
    started   : BOOL := FALSE;
    completed : BOOL := FALSE;
END_VAR

(* Detect the single rising edge on the start request *)
startTrig(CLK := X10);

IF startTrig.Q AND (D10 = 2) THEN
    started := TRUE;
END_IF;

IF started AND NOT completed THEN
    IF D20 = 2 THEN
        (* New material has actually reached the outlet:
           stop the pump immediately -> zero additional new
           material sent to recovery (<= 1 mL requirement met) *)
        Y20 := FALSE;
        completed := TRUE;
    ELSE
        (* Still displacing old residual material *)
        Y20 := TRUE;
    END_IF;
ELSE
    (* Not started yet, or already completed: pump stays OFF *)
    Y20 := FALSE;
END_IF;

(* Completion claim, held once achieved *)
IF completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM