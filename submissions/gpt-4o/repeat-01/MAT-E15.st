PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    D20 : INT;
    (* Internal variables *)
    start_edge : R_TRIG;
    target_reached : BOOL := FALSE;
    completion_time : DINT := 0;
END_VAR

(* R_TRIG instance for detecting start request edge *)
start_edge(CLK := X10);

(* Control logic *)
IF start_edge.Q THEN
    (* Reset state at start request edge *)
    target_reached := FALSE;
    completion_time := 0;
END_IF

(* Maintain vacuums ON according to safety requirements *)
Y20 := TRUE;  // left_vac: actuator command.
Y21 := TRUE;  // right_vac: actuator command.

(* Control logic to open the container *)
IF NOT target_reached THEN
    IF D20 < D10 THEN
        Y22 := TRUE;   // open command
        Y23 := FALSE;  // make sure close is OFF
    ELSE
        Y22 := FALSE;  // stop opening
        target_reached := TRUE;
    END_IF
END_IF

(* Completion condition enforcement *)
IF target_reached THEN
    IF X20 AND X21 AND (D20 >= D10) THEN
        Y2 := TRUE;  // Completion claim
        completion_time := completion_time + 1;
    ELSE
        Y2 := FALSE;  // Fail to hold the vacuum or incorrect gap
    END_IF
ENDIF

(* Maintain output after completion *)
IF completion_time > 0 AND completion_time < 1600 THEN
    Y22 := FALSE;  // Ensure open is OFF
    Y23 := FALSE;  // Ensure close is OFF
ENDIF

END_PROGRAM