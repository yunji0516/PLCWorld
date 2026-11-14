PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    (* Add internal variables here. *)
    prev_X10 : BOOL;
    start_pulse : BOOL;
    started : BOOL;
    completed : BOOL;
    inventory_ok : BOOL := TRUE;
    unwind_cmd : BOOL;
END_VAR

(* Implement the control logic here. *)
start_pulse := X10 AND NOT prev_X10;
prev_X10 := X10;

IF (NOT started) AND (NOT completed) THEN
    Y20 := FALSE;
    Y2 := FALSE;
    unwind_cmd := FALSE;
    inventory_ok := TRUE;

    IF start_pulse AND (D10 = 1) THEN
        started := TRUE;
        inventory_ok := (D20 >= 200) AND (D20 <= 700);
    END_IF;
END_IF;

IF started AND (NOT completed) THEN
    IF (D20 < 200) OR (D20 > 700) THEN
        inventory_ok := FALSE;
    END_IF;

    IF X20 THEN
        unwind_cmd := FALSE;
        Y20 := FALSE;

        IF inventory_ok AND (D20 >= 200) AND (D20 <= 700) THEN
            completed := TRUE;
        END_IF;
    ELSE
        IF D20 <= 450 THEN
            unwind_cmd := TRUE;
        ELSIF D20 >= 550 THEN
            unwind_cmd := FALSE;
        END_IF;

        Y20 := unwind_cmd;
    END_IF;
END_IF;

IF completed THEN
    Y20 := FALSE;
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM