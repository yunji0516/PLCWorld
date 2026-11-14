PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    state : INT;
    forwardDone : BOOL;
END_VAR

(* Implement the control logic here. *)
startEdge(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;

CASE state OF
    0:
        Y2 := FALSE;
        forwardDone := FALSE;
        IF startEdge.Q THEN
            state := 10;
        END_IF;

    10:
        Y2 := FALSE;
        IF X21 AND X22 THEN
            forwardDone := TRUE;
            state := 20;
        ELSE
            Y20 := TRUE;
        END_IF;

    20:
        Y2 := FALSE;
        IF X20 AND forwardDone THEN
            state := 30;
        ELSE
            Y21 := TRUE;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;

ELSE
    state := 0;
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    forwardDone := FALSE;
END_CASE;

END_PROGRAM