PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL;
    X10_prev : BOOL;
    start_edge : BOOL;
    start_accepted : BOOL;
    curr_state : INT;
END_VAR

(* Reset all outputs *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;
Y2 := FALSE;

(* Detect rising edge on X10 for start request *)
IF X10 AND NOT X10_prev THEN
    start_edge := TRUE;
END_IF;
X10_prev := X10;

IF NOT start_accepted AND start_edge THEN
    start_accepted := TRUE;
END_IF;

IF start_accepted THEN
    CASE curr_state OF
        0: (* idle - wait for start *)
            (* All outputs already reset above *)
            curr_state := 1;

        1: (* Lower to acquisition height at source *)
            Y24 := TRUE;  (* down *)
            IF X22 THEN  (* low position confirmed *)
                curr_state := 2;
            END_IF;

        2: (* Close alignment fingers for X and Z alignment *)
            Y25 := TRUE;  (* align X finger *)
            Y26 := TRUE;  (* align Z finger *)
            curr_state := 3;

        3: (* Wait for datum alignment at source *)
            Y25 := TRUE;  (* maintain align X *)
            Y26 := TRUE;  (* maintain align Z *)
            IF X31 AND X32 THEN  (* both X and Z datum aligned *)
                curr_state := 4;
            END_IF;

        4: (* Grip the workpiece *)
            Y20 := TRUE;  (* grip ON *)
            IF X24 THEN  (* holding confirmed *)
                curr_state := 5;
            END_IF;

        5: (* Retract alignment fingers before travel *)
            Y25 := FALSE;  (* retract X finger - OFF means retract *)
            Y26 := FALSE;  (* retract Z finger - OFF means retract *)
            curr_state := 6;

        6: (* Wait for fingers to become clear *)
            IF X29 THEN  (* both fingers clear *)
                curr_state := 7;
            END_IF;

        7: (* Lift to upper position for safe horizontal travel *)
            Y23 := TRUE;  (* up *)
            IF X23 THEN  (* high position - lift >= 360mm *)
                curr_state := 8;
            END_IF;

        8: (* Advance to receiver *)
            Y21 := TRUE;  (* advance *)
            IF X21 THEN  (* at target confirmed *)
                curr_state := 9;
            END_IF;

        9: (* Lower at receiver for workpiece release *)
            Y21 := FALSE;  (* stop advance *)
            Y24 := TRUE;  (* down *)
            IF X22 THEN  (* low position confirmed *)
                curr_state := 10;
            END_IF;

        10: (* Release workpiece onto receiver support *)
            Y20 := FALSE;  (* grip OFF - release *)
            IF X25 THEN  (* released confirmed *)
                curr_state := 11;
            END_IF;

        11: (* Lift head after release *)
            Y24 := FALSE;  (* stop down *)
            Y23 := TRUE;  (* up *)
            IF X23 THEN  (* high position *)
                curr_state := 12;
            END_IF;

        12: (* Return to source *)
            Y23 := FALSE;  (* stop up *)
            Y22 := TRUE;  (* return *)
            IF X20 THEN  (* at source confirmed *)
                curr_state := 13;
            END_IF;

        13: (* Final lift to upper position *)
            Y22 := FALSE;  (* stop return *)
            Y23 := TRUE;  (* up *)
            IF X23 THEN  (* high position *)
                curr_state := 14;
            END_IF;

        14: (* Complete - maintain completion claim *)
            Y2 := TRUE;  (* completion claim - must remain true *)
            (* All actuator outputs are OFF as required *)
    END_CASE;
END_IF;

END_PROGRAM