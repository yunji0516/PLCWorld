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
    align_count : INT;
    retract_count : INT;
    done : BOOL;
END_VAR

(* Implement the control logic here. *)

start_edge(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y2 := done;

CASE state OF
    0:
        align_count := 0;
        retract_count := 0;
        IF start_edge.Q AND (D10 = 1) THEN
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := TRUE;

        IF align_count < 1000 THEN
            align_count := align_count + 1;
        END_IF;

        IF (align_count >= 45) AND X20 AND X21 THEN
            state := 2;
            retract_count := 0;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;

        IF retract_count < 1000 THEN
            retract_count := retract_count + 1;
        END_IF;

        IF (retract_count >= 45) AND X20 AND X21 AND X22 THEN
            done := TRUE;
            Y2 := TRUE;
            state := 3;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;

    ELSE
        state := 0;
        done := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
END_CASE;

END_PROGRAM