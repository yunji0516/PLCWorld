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
    D20 : INT;
    (* Add internal variables here. *)
    start_edge : R_TRIG;
    state : INT;
END_VAR

(* Implement the control logic here. *)

start_edge(CLK := X10);

IF Y2 THEN
    Y20 := FALSE;
    Y21 := FALSE;
ELSE
    CASE state OF
        0:
            Y20 := FALSE;
            Y21 := FALSE;
            IF start_edge.Q AND (D10 = 1) THEN
                state := 10;
            END_IF;

        10:
            Y20 := TRUE;
            Y21 := FALSE;
            IF X22 OR (D20 >= 650) THEN
                state := 20;
            END_IF;

        20:
            Y20 := FALSE;
            Y21 := TRUE;
            IF X20 THEN
                state := 30;
            END_IF;

        30:
            Y20 := FALSE;
            Y21 := FALSE;
            IF X22 OR (D20 >= 650) THEN
                Y2 := TRUE;
            ELSE
                state := 10;
            END_IF;

    ELSE
        state := 0;
        Y20 := FALSE;
        Y21 := FALSE;
    END_CASE;
END_IF;

END_PROGRAM