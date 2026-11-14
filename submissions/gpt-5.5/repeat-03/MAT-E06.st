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
    requestedId : INT;
END_VAR

(* Implement the control logic here. *)

startEdge(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF startEdge.Q THEN
            requestedId := D10;
            state := 10;
        END_IF;

    10:
        Y2 := FALSE;
        Y21 := FALSE;
        IF X21 AND X22 THEN
            Y20 := FALSE;
            Y21 := TRUE;
            state := 20;
        ELSE
            Y20 := TRUE;
        END_IF;

    20:
        Y2 := FALSE;
        Y20 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            Y2 := TRUE;
            state := 30;
        ELSE
            Y21 := TRUE;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;

    ELSE
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        state := 0;
END_CASE;

END_PROGRAM