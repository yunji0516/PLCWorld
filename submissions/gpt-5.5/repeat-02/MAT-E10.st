PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    (* Add internal variables here. *)
    start_edge : R_TRIG;
    started : BOOL;
    unwind_latch : BOOL;
END_VAR

(* Implement the control logic here. *)

start_edge(CLK := X10);

IF start_edge.Q THEN
    started := TRUE;
    unwind_latch := FALSE;
    Y2 := FALSE;
END_IF;

IF NOT started THEN
    Y20 := FALSE;
    Y2 := FALSE;
ELSE
    IF Y2 THEN
        Y20 := FALSE;
    ELSE
        IF X20 THEN
            Y20 := FALSE;
            unwind_latch := FALSE;
            Y2 := TRUE;
        ELSE
            IF D20 <= 300 THEN
                unwind_latch := TRUE;
            END_IF;

            IF D20 >= 650 THEN
                unwind_latch := FALSE;
            END_IF;

            Y20 := unwind_latch;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM