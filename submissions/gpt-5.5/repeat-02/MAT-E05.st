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
    start_edge : R_TRIG;
    state : INT;
END_VAR

(* Implement the control logic here. *)
start_edge(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;

        IF start_edge.Q AND (D10 = 1) THEN
            IF X20 AND X21 THEN
                state := 20;
            ELSE
                state := 10;
            END_IF;
        END_IF;

    10:
        Y2 := FALSE;

        IF X20 AND X21 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 20;
        ELSE
            Y20 := TRUE;
            Y21 := TRUE;
        END_IF;

    20:
        Y20 := FALSE;
        Y21 := FALSE;

        IF X20 AND X21 AND X22 THEN
            Y2 := TRUE;
            state := 30;
        ELSE
            Y2 := FALSE;
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