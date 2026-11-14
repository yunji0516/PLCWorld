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
    start_trig : R_TRIG;
    state : INT := 0;
    scan_count : DINT := 0;
END_VAR

(* Implement the control logic here. *)

scan_count := scan_count + 1;

start_trig(CLK := X10);

CASE state OF

0: (* idle - wait for start request, no actuation *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    IF start_trig.Q AND (D10 = 1) THEN
        state := 1;
    END_IF;

1: (* advance both fingers toward datum faces *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF X20 AND X21 THEN
        state := 2;
    END_IF;

2: (* retract both fingers, keeping datum contact confirmed *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF X22 AND X20 AND X21 THEN
        state := 3;
    END_IF;

3: (* completion achieved - hold outputs off and claim latched *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    state := 0;

END_CASE;

END_PROGRAM