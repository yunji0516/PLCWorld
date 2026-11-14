PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;

    start_edge : R_TRIG;
    w : ARRAY [0..3] OF INT;
    side_plan : ARRAY [0..3] OF BOOL;
    current_idx : INT;
    state : INT;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        (* Idle - Wait for Start Request *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF start_edge.Q THEN
            (* Read source masses *)
            w[0] := D20;
            w[1] := D21;
            w[2] := D22;
            w[3] := D23;
            
            (* Calculate balanced partition *)
            (* We need to split 4 items into 2 sets of 2 (Left/False, Right/True) *)
            (* Check all combinations for Right side *)
            
            (* Combination 1: Right has items 0,1. Left has 2,3. *)
            IF ABS(DINT(w[2]) + DINT(w[3]) - (DINT(w[0]) + DINT(w[1]))) <= 1 THEN
                side_plan[0] := TRUE; side_plan[1] := TRUE;
                side_plan[2] := FALSE; side_plan[3] := FALSE;
            (* Combination 2: Right has items 0,2. Left has 1,3. *)
            ELSIF ABS(DINT(w[1]) + DINT(w[3]) - (DINT(w[0]) + DINT(w[2]))) <= 1 THEN
                side_plan[0] := TRUE; side_plan[1] := FALSE;
                side_plan[2] := TRUE; side_plan[3] := FALSE;
            (* Combination 3: Right has items 0,3. Left has 1,2. *)
            ELSIF ABS(DINT(w[1]) + DINT(w[2]) - (DINT(w[0]) + DINT(w[3]))) <= 1 THEN
                side_plan[0] := TRUE; side_plan[1] := FALSE;
                side_plan[2] := FALSE; side_plan[3] := TRUE;
            (* Combination 4: Right has items 1,2. Left has 0,3. *)
            ELSIF ABS(DINT(w[0]) + DINT(w[3]) - (DINT(w[1]) + DINT(w[2]))) <= 1 THEN
                side_plan[0] := FALSE; side_plan[1] := TRUE;
                side_plan[2] := TRUE; side_plan[3] := FALSE;
            (* Combination 5: Right has items 1,3. Left has 0,2. *)
            ELSIF ABS(DINT(w[0]) + DINT(w[2]) - (DINT(w[1]) + DINT(w[3]))) <= 1 THEN
                side_plan[0] := FALSE; side_plan[1] := TRUE;
                side_plan[2] := FALSE; side_plan[3] := TRUE;
            (* Combination 6: Right has items 2,3. Left has 0,1. *)
            ELSIF ABS(DINT(w[0]) + DINT(w[1]) - (DINT(w[2]) + DINT(w[3]))) <= 1 THEN
                side_plan[0] := FALSE; side_plan[1] := FALSE;
                side_plan[2] := TRUE; side_plan[3] := TRUE;
            ELSE
                (* Fallback - should not be reached if balanced partition exists *)
                side_plan[0] := TRUE; side_plan[1] := TRUE;
                side_plan[2] := FALSE; side_plan[3] := FALSE;
            END_IF;
            
            current_idx := 0;
            state := 1;
        END_IF;

    1:
        (* Wait for Transfer Module Home before starting cycle *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            state := 2;
        END_IF;

    2:
        (* Set Placement Side Command *)
        (* Latching occurs when module starts from home *)
        IF side_plan[current_idx] THEN
            Y21 := TRUE;  (* Place Right *)
            Y20 := FALSE;
        ELSE
            Y20 := TRUE;  (* Place Left *)
            Y21 := FALSE;
        END_IF;
        state := 3;

    3:
        (* Wait for Transfer Module End (Placement Position) *)
        (* Keep command HIGH until End sensor triggers *)
        IF X21 THEN
            state := 4;
        END_IF;

    4:
        (* Clear Command to trigger Return, Wait for Home *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            (* Module returned home. Item loaded. *)
            current_idx := current_idx + 1;
            IF current_idx < 4 THEN
                state := 2; (* Load next item *)
            ELSE
                state := 5; (* All loaded *)
            END_IF;
        END_IF;

    5:
        (* Depart Receiver *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        state := 6;

    6:
        (* Wait for Receiver Fully Departed *)
        Y20 := FALSE;
        Y21 := FALSE;
        (* Y22 remains TRUE *)
        IF X23 THEN
            Y22 := FALSE;
            state := 7;
        END_IF;

    7:
        (* Completion *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM