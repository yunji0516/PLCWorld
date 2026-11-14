PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;
    start_edge : R_TRIG;
    stage : INT := 0;
    target_materials : ARRAY [1..3] OF BOOL;
    return_materials : ARRAY [1..3] OF BOOL;
    all_done : BOOL := FALSE;
END_VAR

(* Detect start signal rising edge and set target/return arrays *)
start_edge(CLK := X10);

IF start_edge.Q THEN
    target_materials[1] := BOOL((D10 AND 1) <> 0);
    target_materials[2] := BOOL((D10 AND 2) <> 0);
    target_materials[3] := BOOL((D10 AND 4) <> 0);

    return_materials[1] := NOT target_materials[1];
    return_materials[2] := NOT target_materials[2];
    return_materials[3] := NOT target_materials[3];

    stage := 1;
END_IF

(* Process stages *)
CASE stage OF
    0: (* Idle, waiting for start request *)
        /* Nothing to do here */

    1: (* Lift to safe height *)
        IF NOT X22 THEN
            Y22 := TRUE;  (* Command lift up *)
        ELSE
            Y22 := FALSE;
            stage := 2;
        END_IF

    2: (* Move towards target *)
        IF X20 THEN
            IF NOT X21 THEN
                Y20 := TRUE;  (* Move forward *)
            ELSE
                Y20 := FALSE;
                stage := 3;
            END_IF
        END_IF

    3: (* Lower to deliver position *)
        IF NOT X23 THEN
            Y23 := TRUE;  (* Command lift down *)
        ELSE
            Y23 := FALSE;
            stage := 4;
        END_IF

    4: (* Release selected materials *)
        IF target_materials[1] AND X26 THEN Y24 := TRUE; ELSE Y24 := FALSE; END_IF
        IF target_materials[2] AND X27 THEN Y25 := TRUE; ELSE Y25 := FALSE; END_IF
        IF target_materials[3] AND X28 THEN Y26 := TRUE; ELSE Y26 := FALSE; END_IF

        IF (NOT target_materials[1] OR X24)
           AND (NOT target_materials[2] OR X24)
           AND (NOT target_materials[3] OR X24) THEN
            stage := 5;
        END_IF

    5: (* Lift to safe height *)
        IF NOT X22 THEN
            Y22 := TRUE;  (* Command lift up *)
        ELSE
            Y22 := FALSE;
            stage := 6;
        END_IF

    6: (* Move back to home/source position *)
        IF X21 THEN
            IF NOT X20 THEN
                Y21 := TRUE;  (* Move back *)
            ELSE
                Y21 := FALSE;
                stage := 7;
            END_IF
        END_IF

    7: (* Lower to return position *)
        IF NOT X23 THEN
            Y23 := TRUE;  (* Command lift down *)
        ELSE
            Y23 := FALSE;
            stage := 8;
        END_IF

    8: (* Release non-selected materials *)
        IF return_materials[1] AND X26 THEN Y24 := TRUE; ELSE Y24 := FALSE; END_IF
        IF return_materials[2] AND X27 THEN Y25 := TRUE; ELSE Y25 := FALSE; END_IF
        IF return_materials[3] AND X28 THEN Y26 := TRUE; ELSE Y26 := FALSE; END_IF

        IF (NOT return_materials[1] OR X24)
           AND (NOT return_materials[2] OR X24)
           AND (NOT return_materials[3] OR X24) THEN
            stage := 9;
        END_IF

    9: (* Lift to upper source position *)
        IF NOT X22 THEN
            Y22 := TRUE;  (* Command lift up *)
        ELSE
            Y22 := FALSE;
            all_done := TRUE;
            stage := 10;
        END_IF

    10: (* Completion and maintain outputs *)
        IF all_done THEN
            Y2 := TRUE;
        END_IF

END_CASE

END_PROGRAM