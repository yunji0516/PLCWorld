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

    started : BOOL;
    completed : BOOL;

    step_rot : INT;
    turn_cmd : BOOL;
    turn_prev : BOOL;

    load_cmd : BOOL;
    load_prev : BOOL;
    load_done : BOOL;

    prep_cmd : BOOL;
    insert_cmd : BOOL;
    insert_prev : BOOL;
    insert_done : BOOL;

    inspect_cmd : BOOL;
    inspect_prev : BOOL;
    inspect_done : BOOL;

    eject_state : INT;
    eject_cmd : BOOL;
    eject_prev : BOOL;
    eject_done : BOOL;
    release_cmd : BOOL;
    release_prev : BOOL;

    rework_state : INT;
    to_rework_cmd : BOOL;
    to_rework_prev : BOOL;
    remove_cmd : BOOL;
    remove_prev : BOOL;
    reseat_cmd : BOOL;
    reseat_prev : BOOL;
    return_cmd : BOOL;
    return_prev : BOOL;
    rework_clamp_val : BOOL;

    rework_in_progress : BOOL;
    rework_ready_to_return : BOOL;

    ack_cmd : BOOL;
    ack_prev : BOOL;

    t_lock : TON;
    t_unlock : TON;
    t_clamp : TON;
    t_unclamp : TON;
    t_complete : TON;

    prev_p0_id : INT;
    prev_p2_id : INT;
    prev_p2_gen : INT;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := TRUE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    D200 := 0;
    step_rot := 0;
    RETURN;
END_IF;

// Ejection and Exit Acknowledgment
IF X1E AND NOT Y19 AND NOT ack_prev THEN
    ack_cmd := TRUE;
ELSE
    ack_cmd := FALSE;
END_IF;
ack_prev := ack_cmd;
Y19 := ack_cmd;

// Station 0: Loading or Returning Main Body
IF step_rot = 0 AND X19 AND NOT X18 THEN
    IF rework_ready_to_return AND D0 = 0 AND NOT X14 AND NOT X25 AND X2A THEN
        IF NOT return_cmd AND NOT return_prev THEN
            return_cmd := TRUE;
        ELSE
            return_cmd := FALSE;
        END_IF;
        return_prev := TRUE;
    ELSE
        return_cmd := FALSE;
        IF NOT rework_ready_to_return THEN
            return_prev := FALSE;
        END_IF;

        IF D0 = 0 AND NOT rework_in_progress AND NOT rework_ready_to_return THEN
            IF X10 AND NOT X11 AND NOT X14 THEN
                IF NOT load_done AND NOT load_cmd AND NOT load_prev THEN
                    load_cmd := TRUE;
                ELSE
                    load_cmd := FALSE;
                END_IF;
                load_prev := TRUE;
            ELSE
                load_cmd := FALSE;
                load_prev := FALSE;
            END_IF;
        ELSE
            load_cmd := FALSE;
            load_prev := FALSE;
        END_IF;
    END_IF;
ELSE
    load_cmd := FALSE;
    load_prev := FALSE;
    return_cmd := FALSE;
    return_prev := FALSE;
END_IF;
Y10 := load_cmd;
Y1F := return_cmd;

IF D0 <> 0 AND prev_p0_id = 0 THEN
    load_done := TRUE;
END_IF;
prev_p0_id := D0;

// Station 1: Prepare and Insert
IF step_rot = 0 AND X19 AND NOT X18 THEN
    IF D1 <> 0 AND NOT X21 AND NOT insert_done THEN
        IF NOT X13 AND X12 THEN
            prep_cmd := TRUE;
        ELSE
            prep_cmd := FALSE;
        END_IF;

        IF X13 AND NOT X15 THEN
            IF NOT insert_cmd AND NOT insert_prev THEN
                insert_cmd := TRUE;
            ELSE
                insert_cmd := FALSE;
            END_IF;
            insert_prev := TRUE;
        ELSE
            insert_cmd := FALSE;
            insert_prev := FALSE;
        END_IF;
    ELSE
        prep_cmd := FALSE;
        insert_cmd := FALSE;
        insert_prev := FALSE;
        IF D1 = 0 OR X21 THEN
            insert_done := TRUE;
        END_IF;
    END_IF;
ELSE
    prep_cmd := FALSE;
    insert_cmd := FALSE;
    insert_prev := FALSE;
END_IF;
Y11 := prep_cmd;
Y12 := insert_cmd;

// Station 2: Inspection
IF step_rot = 0 AND X19 AND NOT X18 THEN
    IF D2 <> 0 THEN
        D200 := D5;
        IF (D6 = D2) AND (D7 = D5) AND X22 THEN
            inspect_done := TRUE;
            inspect_cmd := FALSE;
            inspect_prev := FALSE;
        ELSIF NOT inspect_done AND NOT X16 THEN
            IF NOT inspect_cmd AND NOT inspect_prev THEN
                inspect_cmd := TRUE;
            ELSE
                inspect_cmd := FALSE;
            END_IF;
            inspect_prev := TRUE;
        ELSE
            inspect_cmd := FALSE;
        END_IF;
    ELSE
        inspect_cmd := FALSE;
        inspect_prev := FALSE;
        inspect_done := TRUE;
    END_IF;
ELSE
    inspect_cmd := FALSE;
    inspect_prev := FALSE;
END_IF;
Y13 := inspect_cmd;

// Station 3: Eject / Disposition (Pass to belt OR Move to rework)
IF step_rot = 0 AND X19 AND NOT X18 THEN
    IF D3 <> 0 THEN
        IF X22 AND (D6 = D3) AND (D7 = D8) THEN
            IF X24 THEN
                // NG Part -> Move to Rework
                eject_done := TRUE;
                IF NOT rework_in_progress AND NOT rework_ready_to_return AND NOT X26 AND NOT X25 AND X1B THEN
                    IF NOT to_rework_cmd AND NOT to_rework_prev THEN
                        to_rework_cmd := TRUE;
                        rework_in_progress := TRUE;
                    ELSE
                        to_rework_cmd := FALSE;
                    END_IF;
                    to_rework_prev := TRUE;
                ELSE
                    to_rework_cmd := FALSE;
                END_IF;
            ELSE
                // Good Part -> Eject to belt
                to_rework_cmd := FALSE;
                to_rework_prev := FALSE;
                CASE eject_state OF
                    0:
                        IF X1D AND NOT X1E AND X1B AND NOT X17 THEN
                            IF NOT release_cmd AND NOT release_prev THEN
                                release_cmd := TRUE;
                            ELSE
                                release_cmd := FALSE;
                            END_IF;
                            release_prev := TRUE;
                            eject_state := 1;
                        ELSE
                            release_cmd := FALSE;
                            release_prev := FALSE;
                        END_IF;
                    1:
                        release_cmd := FALSE;
                        IF X20 THEN
                            Y14 := TRUE;
                            Y15 := FALSE;
                            IF X1C THEN
                                eject_state := 2;
                            END_IF;
                        END_IF;
                    2:
                        Y14 := FALSE;
                        Y15 := TRUE;
                        IF X1B AND NOT X17 THEN
                            Y15 := FALSE;
                            eject_done := TRUE;
                            eject_state := 3;
                        END_IF;
                    3:
                        Y14 := FALSE;
                        Y15 := FALSE;
                END_CASE;
            END_IF;
        ELSE
            to_rework_cmd := FALSE;
            release_cmd := FALSE;
        END_IF;
    ELSE
        to_rework_cmd := FALSE;
        to_rework_prev := FALSE;
        release_cmd := FALSE;
        release_prev := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        eject_done := TRUE;
        eject_state := 0;
    END_IF;
ELSE
    to_rework_cmd := FALSE;
    to_rework_prev := FALSE;
    release_cmd := FALSE;
    release_prev := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
END_IF;
Y1B := to_rework_cmd;
Y16 := release_cmd;

// Rework Station Sequence
t_clamp(IN := (rework_state = 1), PT := T#350ms);
t_unclamp(IN := (rework_state = 6), PT := T#350ms);

CASE rework_state OF
    0:
        rework_clamp_val := FALSE;
        remove_cmd := FALSE;
        reseat_cmd := FALSE;
        IF rework_in_progress AND X26 AND NOT X25 THEN
            rework_state := 1;
        END_IF;
    1:
        rework_clamp_val := TRUE;
        IF X27 AND t_clamp.Q THEN
            rework_state := 2;
        END_IF;
    2:
        IF NOT X25 AND NOT X28 THEN
            IF NOT remove_cmd AND NOT remove_prev THEN
                remove_cmd := TRUE;
            ELSE
                remove_cmd := FALSE;
            END_IF;
            remove_prev := TRUE;
        ELSE
            remove_cmd := FALSE;
            IF X28 AND NOT X25 THEN
                remove_prev := FALSE;
                rework_state := 3;
            END_IF;
        END_IF;
    3:
        remove_cmd := FALSE;
        IF NOT X25 AND NOT X29 THEN
            IF NOT reseat_cmd AND NOT reseat_prev THEN
                reseat_cmd := TRUE;
            ELSE
                reseat_cmd := FALSE;
            END_IF;
            reseat_prev := TRUE;
        ELSE
            reseat_cmd := FALSE;
            IF X29 AND NOT X25 THEN
                reseat_prev := FALSE;
                rework_state := 4;
            END_IF;
        END_IF;
    4:
        reseat_cmd := FALSE;
        rework_state := 5;
    5:
        rework_state := 6;
    6:
        rework_clamp_val := FALSE;
        IF NOT X27 AND t_unclamp.Q THEN
            rework_ready_to_return := TRUE;
            rework_in_progress := FALSE;
            rework_state := 7;
        END_IF;
    7:
        IF NOT rework_ready_to_return AND NOT X26 THEN
            rework_state := 0;
        END_IF;
END_CASE;

Y1C := rework_clamp_val;
Y1D := remove_cmd;
Y1E := reseat_cmd;

IF rework_ready_to_return AND (D0 <> 0) AND NOT X25 THEN
    rework_ready_to_return := FALSE;
END_IF;

// Rotary Table Indexing Sequence
t_unlock(IN := (step_rot = 1), PT := T#200ms);
t_lock(IN := (step_rot = 4), PT := T#200ms);

CASE step_rot OF
    0:
        Y17 := TRUE;
        turn_cmd := FALSE;
        turn_prev := FALSE;
        IF (D10 < 6) THEN
            IF (insert_done OR (D1 = 0)) AND
               (inspect_done OR (D2 = 0)) AND
               (eject_done OR (D3 = 0)) AND
               NOT X14 AND NOT X15 AND NOT X16 AND NOT X17 AND X1B AND
               NOT rework_ready_to_return AND
               (load_done OR (D0 <> 0) OR (X11 AND NOT rework_in_progress)) THEN
                step_rot := 1;
            END_IF;
        END_IF;
    1:
        Y17 := FALSE;
        IF X1A AND t_unlock.Q THEN
            step_rot := 2;
        END_IF;
    2:
        IF NOT turn_cmd AND NOT turn_prev THEN
            turn_cmd := TRUE;
        ELSE
            turn_cmd := FALSE;
        END_IF;
        turn_prev := TRUE;
        IF X18 THEN
            step_rot := 3;
            turn_cmd := FALSE;
        END_IF;
    3:
        turn_cmd := FALSE;
        turn_prev := FALSE;
        IF NOT X18 THEN
            step_rot := 4;
        END_IF;
    4:
        Y17 := TRUE;
        IF X19 AND t_lock.Q THEN
            load_done := FALSE;
            insert_done := FALSE;
            inspect_done := FALSE;
            eject_done := FALSE;
            eject_state := 0;
            step_rot := 0;
        END_IF;
END_CASE;
Y18 := turn_cmd;

// Completion Check
IF (D10 >= 6) AND NOT rework_in_progress AND NOT rework_ready_to_return AND
   NOT X14 AND NOT X15 AND NOT X16 AND NOT X17 AND NOT X18 AND NOT X25 AND
   X19 AND X1B AND NOT X26 AND NOT Y10 AND NOT Y11 AND NOT Y12 AND NOT Y13 AND
   NOT Y14 AND NOT Y15 AND NOT Y16 AND NOT Y18 AND NOT Y1B AND NOT Y1C AND
   NOT Y1D AND NOT Y1E AND NOT Y1F THEN
    completed := TRUE;
END_IF;

t_complete(IN := completed, PT := T#500ms);
Y1A := completed;

END_PROGRAM