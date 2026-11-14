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
    complete_latched : BOOL;
    rot_state : INT;
    turn_started : BOOL;
    eject_phase : INT;
    repair_stage : INT;
    repair_count : INT;
    any_work : BOOL;
    all_idle : BOOL;
    load_cond : BOOL;
    insert_cond : BOOL;
    inspect_cond : BOOL;
    release_cond : BOOL;
    ack_cond : BOOL;
    rework_cond : BOOL;
    return_cond : BOOL;
    remove_cond : BOOL;
    reseat_cond : BOOL;
    ready_to_turn : BOOL;
    complete_ready : BOOL;
    load_pulse_mem : BOOL;
    insert_pulse_mem : BOOL;
    inspect_pulse_mem : BOOL;
    release_pulse_mem : BOOL;
    ack_pulse_mem : BOOL;
    rework_pulse_mem : BOOL;
    remove_pulse_mem : BOOL;
    reseat_pulse_mem : BOOL;
    return_pulse_mem : BOOL;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

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
Y1A := complete_latched;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

D200 := D5;

all_idle := (NOT X14) AND (NOT X15) AND (NOT X16) AND (NOT X17) AND (NOT X18) AND (NOT X25);
any_work := (D0 <> 0) OR (D1 <> 0) OR (D2 <> 0) OR (D3 <> 0) OR X20 OR X1E OR X26 OR X2A OR (repair_stage <> 0);

complete_ready := started AND X1F AND (D10 >= 6) AND (repair_count >= 2) AND
                  X19 AND X1B AND all_idle AND (NOT X20) AND (NOT X1E) AND
                  (repair_stage = 0) AND (NOT X26) AND (NOT X2A) AND
                  (D0 = 0) AND (D1 = 0) AND (D2 = 0) AND (D3 = 0);

IF complete_ready THEN
    complete_latched := TRUE;
END_IF;

IF complete_latched THEN
    Y1A := TRUE;
    Y17 := TRUE;
    rot_state := 0;
    eject_phase := 0;
ELSE
    IF NOT started THEN
        Y17 := TRUE;
    ELSE
        IF (repair_stage = 0) AND X26 THEN
            repair_stage := 2;
        END_IF;

        IF (repair_stage = 1) AND X26 THEN
            repair_stage := 2;
        END_IF;

        IF (repair_stage = 2) AND X28 THEN
            repair_stage := 3;
        END_IF;

        IF (repair_stage = 3) AND X29 THEN
            repair_stage := 4;
        END_IF;

        IF (repair_stage = 5) AND (NOT X25) AND (NOT X26) AND (NOT X2A) THEN
            repair_stage := 0;
        END_IF;

        IF (rot_state = 0) AND X19 AND (NOT X18) THEN
            Y11 := X12 AND (NOT X13) AND (D1 <> 0) AND (NOT X21) AND (NOT X15);

            load_cond := X19 AND (NOT X14) AND (D0 = 0) AND X10 AND
                         (repair_stage = 0) AND (NOT X26) AND (NOT X2A) AND
                         (NOT (X20 AND X24));

            IF load_cond THEN
                IF load_pulse_mem THEN
                    Y10 := FALSE;
                    load_pulse_mem := FALSE;
                ELSE
                    Y10 := TRUE;
                    load_pulse_mem := TRUE;
                END_IF;
            ELSE
                Y10 := FALSE;
                load_pulse_mem := FALSE;
            END_IF;

            insert_cond := X19 AND (NOT X15) AND (D1 <> 0) AND (NOT X21) AND X13;
            IF insert_cond THEN
                IF insert_pulse_mem THEN
                    Y12 := FALSE;
                    insert_pulse_mem := FALSE;
                ELSE
                    Y12 := TRUE;
                    insert_pulse_mem := TRUE;
                END_IF;
            ELSE
                Y12 := FALSE;
                insert_pulse_mem := FALSE;
            END_IF;

            inspect_cond := X19 AND (NOT X16) AND (D2 <> 0) AND (NOT X22);
            IF inspect_cond THEN
                IF inspect_pulse_mem THEN
                    Y13 := FALSE;
                    inspect_pulse_mem := FALSE;
                ELSE
                    Y13 := TRUE;
                    inspect_pulse_mem := TRUE;
                END_IF;
            ELSE
                Y13 := FALSE;
                inspect_pulse_mem := FALSE;
            END_IF;

            IF (eject_phase = 0) AND (NOT X17) AND (NOT X20) AND
               (D3 <> 0) AND X23 AND X1B AND X1D AND (NOT X1E) THEN
                eject_phase := 1;
            END_IF;

            IF (eject_phase = 0) AND (NOT X1B) THEN
                eject_phase := 2;
            END_IF;

            IF eject_phase = 1 THEN
                IF X1D AND (NOT X1E) AND (NOT X20) THEN
                    Y14 := TRUE;
                ELSE
                    Y14 := FALSE;
                END_IF;

                IF X1C OR X20 OR (D3 = 0) THEN
                    eject_phase := 2;
                    Y14 := FALSE;
                END_IF;
            END_IF;

            IF eject_phase = 2 THEN
                Y14 := FALSE;
                IF NOT X1B THEN
                    Y15 := TRUE;
                ELSE
                    Y15 := FALSE;
                    eject_phase := 0;
                END_IF;
            END_IF;

            release_cond := X20 AND X1B AND (NOT X24) AND X1D AND (NOT X1E) AND
                            (NOT X17) AND (repair_stage = 0);
            IF release_cond THEN
                IF release_pulse_mem THEN
                    Y16 := FALSE;
                    release_pulse_mem := FALSE;
                ELSE
                    Y16 := TRUE;
                    release_pulse_mem := TRUE;
                END_IF;
            ELSE
                Y16 := FALSE;
                release_pulse_mem := FALSE;
            END_IF;

            ack_cond := X1E;
            IF ack_cond THEN
                IF ack_pulse_mem THEN
                    Y19 := FALSE;
                    ack_pulse_mem := FALSE;
                ELSE
                    Y19 := TRUE;
                    ack_pulse_mem := TRUE;
                END_IF;
            ELSE
                Y19 := FALSE;
                ack_pulse_mem := FALSE;
            END_IF;

            rework_cond := X20 AND X1B AND X24 AND (NOT X17) AND (NOT X25) AND
                           (NOT X26) AND (repair_stage = 0);
            IF rework_cond THEN
                IF rework_pulse_mem THEN
                    Y1B := FALSE;
                    rework_pulse_mem := FALSE;
                ELSE
                    Y1B := TRUE;
                    rework_pulse_mem := TRUE;
                    repair_stage := 1;
                    repair_count := repair_count + 1;
                END_IF;
            ELSE
                Y1B := FALSE;
                rework_pulse_mem := FALSE;
            END_IF;

            IF (repair_stage = 2) OR (repair_stage = 3) THEN
                Y1C := TRUE;
            ELSE
                Y1C := FALSE;
            END_IF;

            remove_cond := (repair_stage = 2) AND X26 AND X27 AND (NOT X28) AND (NOT X25);
            IF remove_cond THEN
                IF remove_pulse_mem THEN
                    Y1D := FALSE;
                    remove_pulse_mem := FALSE;
                ELSE
                    Y1D := TRUE;
                    remove_pulse_mem := TRUE;
                END_IF;
            ELSE
                Y1D := FALSE;
                remove_pulse_mem := FALSE;
            END_IF;

            reseat_cond := (repair_stage = 3) AND X26 AND X27 AND X28 AND (NOT X29) AND (NOT X25);
            IF reseat_cond THEN
                IF reseat_pulse_mem THEN
                    Y1E := FALSE;
                    reseat_pulse_mem := FALSE;
                ELSE
                    Y1E := TRUE;
                    reseat_pulse_mem := TRUE;
                END_IF;
            ELSE
                Y1E := FALSE;
                reseat_pulse_mem := FALSE;
            END_IF;

            return_cond := (repair_stage = 4) AND X2A AND (NOT X25) AND (NOT X27) AND
                           X19 AND (D0 = 0);
            IF return_cond THEN
                IF return_pulse_mem THEN
                    Y1F := FALSE;
                    return_pulse_mem := FALSE;
                ELSE
                    Y1F := TRUE;
                    return_pulse_mem := TRUE;
                    repair_stage := 5;
                END_IF;
            ELSE
                Y1F := FALSE;
                return_pulse_mem := FALSE;
            END_IF;
        ELSE
            load_pulse_mem := FALSE;
            insert_pulse_mem := FALSE;
            inspect_pulse_mem := FALSE;
            release_pulse_mem := FALSE;
            ack_pulse_mem := FALSE;
            rework_pulse_mem := FALSE;
            remove_pulse_mem := FALSE;
            reseat_pulse_mem := FALSE;
            return_pulse_mem := FALSE;
        END_IF;

        all_idle := (NOT X14) AND (NOT X15) AND (NOT X16) AND (NOT X17) AND (NOT X18) AND (NOT X25);
        any_work := (D0 <> 0) OR (D1 <> 0) OR (D2 <> 0) OR (D3 <> 0) OR X20 OR X1E OR X26 OR X2A OR (repair_stage <> 0);

        ready_to_turn := (rot_state = 0) AND X19 AND all_idle AND X1B AND (eject_phase = 0) AND
                         (D1 = 0 OR X21) AND (D2 = 0 OR X22) AND (D3 = 0) AND
                         (NOT X20) AND (NOT X1E) AND (repair_stage = 0) AND
                         (NOT X26) AND (NOT X2A) AND
                         (NOT (X10 AND (D0 = 0))) AND
                         any_work;

        IF ready_to_turn THEN
            rot_state := 1;
            turn_started := FALSE;
        END_IF;

        CASE rot_state OF
            0:
                Y17 := TRUE;
                Y18 := FALSE;
            1:
                Y17 := FALSE;
                IF X1A AND (NOT X18) THEN
                    Y18 := TRUE;
                    rot_state := 2;
                    turn_started := FALSE;
                ELSE
                    Y18 := FALSE;
                END_IF;
            2:
                Y17 := FALSE;
                Y18 := FALSE;
                IF X18 THEN
                    turn_started := TRUE;
                END_IF;
                IF turn_started AND (NOT X18) THEN
                    rot_state := 3;
                END_IF;
                IF (NOT turn_started) AND (NOT X18) THEN
                    rot_state := 1;
                END_IF;
            3:
                Y17 := TRUE;
                Y18 := FALSE;
                IF X19 THEN
                    rot_state := 0;
                END_IF;
        ELSE
            Y17 := TRUE;
            Y18 := FALSE;
            rot_state := 0;
        END_CASE;
    END_IF;
END_IF;

END_PROGRAM