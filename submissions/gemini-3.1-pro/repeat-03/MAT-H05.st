PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    pulse_Y10 : BOOL;
    pulse_Y11 : BOOL;
    pulse_Y12 : BOOL;
    pulse_Y13 : BOOL;
    pulse_Y16 : BOOL;
    pulse_Y18 : BOOL;
    pulse_Y19 : BOOL;
    pulse_Y1B : BOOL;
    pulse_Y1D : BOOL;
    pulse_Y1E : BOOL;
    pulse_Y1F : BOOL;
    
    lvl_Y14 : BOOL;
    lvl_Y15 : BOOL;
    lvl_Y1C : BOOL;
    table_lock_level : BOOL := TRUE;
    
    pos0_state : INT := 0;
    pos1_state : INT := 0;
    pos2_state : INT := 0;
    pos3_state : INT := 0;
    table_state : INT := 0;
    rework_state : INT := 0;
    
    pocket_at_pos : ARRAY[0..3] OF INT := [0, 1, 2, 3];
    pocket_gen : ARRAY[0..3] OF INT := [0, 0, 0, 0];
    temp_pocket : INT;
    
    req_pos0 : BOOL;
    req_pos1 : BOOL;
    req_pos2 : BOOL;
    req_pos3 : BOOL;
    all_req : BOOL;
    has_work : BOOL;
    machine_empty : BOOL;
    is_complete_cond : BOOL;
    
    rework_clamp_timer : TON;
    timer_IN : BOOL;
END_VAR

(* Reset one-scan pulses *)
pulse_Y10 := FALSE;
pulse_Y11 := FALSE;
pulse_Y12 := FALSE;
pulse_Y13 := FALSE;
pulse_Y16 := FALSE;
pulse_Y18 := FALSE;
pulse_Y19 := FALSE;
pulse_Y1B := FALSE;
pulse_Y1D := FALSE;
pulse_Y1E := FALSE;
pulse_Y1F := FALSE;

(* Determine Readiness and Conditions *)
req_pos0 := (pos0_state = 0) AND ((D0 > 0) OR (NOT X10 AND NOT X2A));
req_pos1 := (pos1_state = 0) AND ((D1 = 0) OR (D4 > 0));
req_pos2 := (pos2_state = 0) AND ((D2 = 0) OR ((D2 > 0) AND (D6 = D2) AND (D7 = pocket_gen[pocket_at_pos[2]])));
req_pos3 := (pos3_state = 0) AND (D3 = 0);

all_req := req_pos0 AND req_pos1 AND req_pos2 AND req_pos3 AND X1B AND NOT X14 AND NOT X15 AND NOT X16 AND NOT X17;

has_work := (D0 > 0) OR (D1 > 0) OR (D2 > 0) OR (D3 > 0) OR X10 OR X2A OR X26;
machine_empty := (D0 = 0) AND (D1 = 0) AND (D2 = 0) AND (D3 = 0) AND NOT X26 AND NOT X1E;
is_complete_cond := (D10 >= 6) AND machine_empty AND X19 AND X1B AND NOT X18 AND (pos0_state = 0) AND (pos1_state = 0) AND (pos2_state = 0) AND (pos3_state = 0) AND (rework_state = 0);

(* Table Rotation State Machine *)
CASE table_state OF
    0:
        table_lock_level := TRUE;
        IF all_req AND X19 AND NOT X18 AND has_work THEN
            IF NOT (D10 >= 6 AND machine_empty) THEN
                table_state := 1;
            END_IF;
        END_IF;
    1:
        table_lock_level := FALSE;
        IF X1A THEN
            pulse_Y18 := TRUE;
            table_state := 2;
        END_IF;
    2:
        IF X18 THEN
            table_state := 3;
        END_IF;
    3:
        IF NOT X18 THEN
            table_state := 4;
        END_IF;
    4:
        table_lock_level := TRUE;
        IF X19 THEN
            temp_pocket := pocket_at_pos[3];
            pocket_at_pos[3] := pocket_at_pos[2];
            pocket_at_pos[2] := pocket_at_pos[1];
            pocket_at_pos[1] := pocket_at_pos[0];
            pocket_at_pos[0] := temp_pocket;
            table_state := 0;
        END_IF;
END_CASE;

(* Position 0: Load / Return Station *)
CASE pos0_state OF
    0:
        IF D0 = 0 AND X19 AND NOT X18 AND table_state = 0 THEN
            IF X2A THEN
                pocket_gen[pocket_at_pos[0]] := pocket_gen[pocket_at_pos[0]] + 1;
                pulse_Y1F := TRUE;
                pos0_state := 2;
            ELSIF X10 THEN
                pocket_gen[pocket_at_pos[0]] := pocket_gen[pocket_at_pos[0]] + 1;
                pulse_Y10 := TRUE;
                pos0_state := 1;
            END_IF;
        END_IF;
    1:
        IF D0 > 0 THEN
            pos0_state := 0;
        END_IF;
    2:
        IF D0 > 0 THEN
            pos0_state := 0;
        END_IF;
END_CASE;

(* Position 1: Insert Station *)
CASE pos1_state OF
    0:
        IF D1 > 0 AND D4 = 0 AND X19 AND NOT X18 AND table_state = 0 THEN
            IF X12 THEN
                pulse_Y11 := TRUE;
                pos1_state := 1;
            END_IF;
        END_IF;
    1:
        IF X13 AND NOT X15 THEN
            pulse_Y12 := TRUE;
            pos1_state := 2;
        END_IF;
    2:
        IF D4 > 0 AND X21 THEN
            pos1_state := 0;
        END_IF;
END_CASE;

(* Position 2: Inspect Station *)
CASE pos2_state OF
    0:
        IF D2 > 0 AND X19 AND NOT X18 AND table_state = 0 THEN
            IF (D6 <> D2 OR D7 <> pocket_gen[pocket_at_pos[2]]) AND NOT X16 THEN
                D200 := pocket_gen[pocket_at_pos[2]];
                pulse_Y13 := TRUE;
                pos2_state := 1;
            END_IF;
        END_IF;
    1:
        IF D6 = D2 AND D7 = pocket_gen[pocket_at_pos[2]] THEN
            pos2_state := 0;
        END_IF;
END_CASE;

(* Position 3: Extraction / to Rework Station *)
CASE pos3_state OF
    0:
        IF D3 > 0 AND X19 AND NOT X18 AND table_state = 0 THEN
            IF X20 THEN
                IF X24 THEN
                    IF NOT X26 AND NOT X25 AND X1B THEN
                        pulse_Y1B := TRUE;
                        pos3_state := 10;
                    END_IF;
                ELSE
                    pos3_state := 1;
                END_IF;
            END_IF;
        END_IF;
    1:
        IF X1D AND NOT X1E THEN
            lvl_Y14 := TRUE;
            lvl_Y15 := FALSE;
            pos3_state := 2;
        END_IF;
    2:
        IF X1C THEN
            lvl_Y14 := FALSE;
            lvl_Y15 := TRUE;
            pos3_state := 3;
        END_IF;
    3:
        IF X1B THEN
            lvl_Y15 := FALSE;
            pulse_Y16 := TRUE;
            pos3_state := 4;
        END_IF;
    4:
        IF X1E THEN
            pulse_Y19 := TRUE;
            pos3_state := 5;
        END_IF;
    5:
        IF NOT X1E THEN
            pos3_state := 0;
        END_IF;
    10:
        IF D3 = 0 THEN
            pos3_state := 0;
        END_IF;
END_CASE;

(* Rework Station Timer *)
timer_IN := (rework_state = 1) AND X27;
rework_clamp_timer(IN := timer_IN, PT := T#300ms);

(* Rework / Repair Jig State Machine *)
CASE rework_state OF
    0:
        IF X26 THEN
            rework_state := 1;
        END_IF;
    1:
        lvl_Y1C := TRUE;
        IF X27 AND rework_clamp_timer.Q AND NOT X25 THEN
            pulse_Y1D := TRUE;
            rework_state := 2;
        END_IF;
    2:
        lvl_Y1C := TRUE;
        IF X28 AND NOT X25 THEN
            pulse_Y1E := TRUE;
            rework_state := 3;
        END_IF;
    3:
        lvl_Y1C := TRUE;
        IF X29 AND NOT X25 THEN
            lvl_Y1C := FALSE;
            rework_state := 4;
        END_IF;
    4:
        lvl_Y1C := FALSE;
        IF X2A THEN
            rework_state := 5;
        END_IF;
    5:
        IF NOT X26 THEN
            rework_state := 0;
        END_IF;
END_CASE;

(* Completion Check *)
IF is_complete_cond THEN
    Y1A := TRUE;
END_IF;

(* Output Assignment *)
Y10 := pulse_Y10;
Y11 := pulse_Y11;
Y12 := pulse_Y12;
Y13 := pulse_Y13;
Y14 := lvl_Y14;
Y15 := lvl_Y15;
Y16 := pulse_Y16;
Y17 := table_lock_level;
Y18 := pulse_Y18;
Y19 := pulse_Y19;
Y1B := pulse_Y1B;
Y1C := lvl_Y1C;
Y1D := pulse_Y1D;
Y1E := pulse_Y1E;
Y1F := pulse_Y1F;

END_PROGRAM