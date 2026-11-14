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

    step : INT := 0;
    sub_load : INT := 0;
    sub_ins : INT := 0;
    sub_insp : INT := 0;
    sub_ej : INT := 0;
    sub_rwk : INT := 0;
    sub_ret : INT := 0;

    prev_exit_received : BOOL := FALSE;
    prev_x1e : BOOL := FALSE;
    exit_ack_pending : BOOL := FALSE;

    turn_timer : TON;
    lock_timer : TON;
    unlock_timer : TON;
    clamp_timer : TON;
    complete_timer : TON;

    rework_active : BOOL := FALSE;
    rework_done_waiting_return : BOOL := FALSE;
    eject_in_progress : BOOL := FALSE;
    output_released : BOOL := FALSE;
    inspect_pulse : BOOL := FALSE;
    load_pulse : BOOL := FALSE;
    insert_pulse : BOOL := FALSE;
    prep_pulse : BOOL := FALSE;
    to_rework_pulse : BOOL := FALSE;
    rem_pulse : BOOL := FALSE;
    reseat_pulse : BOOL := FALSE;
    ret_pulse : BOOL := FALSE;
    rel_pulse : BOOL := FALSE;
    turn_pulse : BOOL := FALSE;
    ack_pulse : BOOL := FALSE;

    running : BOOL := FALSE;
    all_finished : BOOL := FALSE;
END_VAR

IF X0 THEN
    running := TRUE;
END_IF;

IF NOT running THEN
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
    RETURN;
END_IF;

IF X1E AND NOT prev_x1e THEN
    exit_ack_pending := TRUE;
END_IF;
prev_x1e := X1E;

ack_pulse := FALSE;
IF exit_ack_pending AND X1E THEN
    ack_pulse := TRUE;
    exit_ack_pending := FALSE;
END_IF;
Y19 := ack_pulse;

IF sub_rwk = 0 THEN
    Y1B := FALSE;
    IF rework_active THEN
        sub_rwk := 10;
    END_IF;
ELSIF sub_rwk = 10 THEN
    to_rework_pulse := TRUE;
    Y1B := TRUE;
    sub_rwk := 11;
ELSIF sub_rwk = 11 THEN
    Y1B := FALSE;
    IF X26 AND NOT X25 THEN
        sub_rwk := 20;
    END_IF;
ELSIF sub_rwk = 20 THEN
    Y1C := TRUE;
    clamp_timer(IN := TRUE, PT := T#350ms);
    IF clamp_timer.Q AND X27 THEN
        clamp_timer(IN := FALSE, PT := T#350ms);
        sub_rwk := 30;
    END_IF;
ELSIF sub_rwk = 30 THEN
    Y1D := TRUE;
    sub_rwk := 31;
ELSIF sub_rwk = 31 THEN
    Y1D := FALSE;
    IF X28 AND NOT X25 THEN
        sub_rwk := 40;
    END_IF;
ELSIF sub_rwk = 40 THEN
    Y1E := TRUE;
    sub_rwk := 41;
ELSIF sub_rwk = 41 THEN
    Y1E := FALSE;
    IF X29 AND NOT X25 THEN
        sub_rwk := 50;
    END_IF;
ELSIF sub_rwk = 50 THEN
    Y1C := FALSE;
    IF NOT X27 THEN
        sub_rwk := 60;
        rework_active := FALSE;
        rework_done_waiting_return := TRUE;
    END_IF;
ELSIF sub_rwk = 60 THEN
    IF NOT rework_done_waiting_return THEN
        sub_rwk := 0;
    END_IF;
END_IF;

IF sub_ret = 0 THEN
    Y1F := FALSE;
    IF rework_done_waiting_return AND (D0 = 0) AND X19 AND X2A AND NOT X14 AND NOT X25 THEN
        sub_ret := 10;
    END_IF;
ELSIF sub_ret = 10 THEN
    Y1F := TRUE;
    sub_ret := 11;
ELSIF sub_ret = 11 THEN
    Y1F := FALSE;
    IF NOT X25 AND NOT X14 AND (D0 > 0) THEN
        rework_done_waiting_return := FALSE;
        sub_ret := 0;
    END_IF;
END_IF;

load_pulse := FALSE;
prep_pulse := FALSE;
IF sub_load = 0 THEN
    IF (D0 = 0) AND X10 AND NOT X11 AND NOT rework_done_waiting_return AND X19 THEN
        sub_load := 10;
    END_IF;
ELSIF sub_load = 10 THEN
    load_pulse := TRUE;
    sub_load := 11;
ELSIF sub_load = 11 THEN
    IF NOT X14 AND (D0 > 0) THEN
        sub_load := 20;
    END_IF;
ELSIF sub_load = 20 THEN
    sub_load := 0;
END_IF;
Y10 := load_pulse;

insert_pulse := FALSE;
IF sub_ins = 0 THEN
    IF (D1 > 0) AND NOT X21 AND X19 THEN
        IF NOT X13 AND X12 THEN
            prep_pulse := TRUE;
        ELSIF X13 THEN
            sub_ins := 10;
        END_IF;
    END_IF;
ELSIF sub_ins = 10 THEN
    insert_pulse := TRUE;
    sub_ins := 11;
ELSIF sub_ins = 11 THEN
    IF NOT X15 AND X21 THEN
        sub_ins := 20;
    END_IF;
ELSIF sub_ins = 20 THEN
    sub_ins := 0;
END_IF;
Y11 := prep_pulse;
Y12 := insert_pulse;

inspect_pulse := FALSE;
IF sub_insp = 0 THEN
    IF (D2 > 0) AND X19 AND NOT (X22 AND (D6 = D2) AND (D7 = D5)) THEN
        D200 := D5;
        sub_insp := 10;
    END_IF;
ELSIF sub_insp = 10 THEN
    inspect_pulse := TRUE;
    sub_insp := 11;
ELSIF sub_insp = 11 THEN
    IF NOT X16 AND X22 AND (D6 = D2) AND (D7 = D5) THEN
        sub_insp := 20;
    END_IF;
ELSIF sub_insp = 20 THEN
    sub_insp := 0;
END_IF;
Y13 := inspect_pulse;

rel_pulse := FALSE;
IF sub_ej = 0 THEN
    Y14 := FALSE;
    Y15 := FALSE;
    IF (D3 > 0) AND X19 THEN
        IF X20 THEN
            IF X24 THEN
                IF X1B AND NOT X25 AND NOT X26 AND NOT rework_active AND NOT rework_done_waiting_return THEN
                    rework_active := TRUE;
                    sub_ej := 30;
                END_IF;
            ELSE
                IF X1B AND X1D AND NOT exit_ack_pending THEN
                    sub_ej := 10;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
ELSIF sub_ej = 10 THEN
    rel_pulse := TRUE;
    sub_ej := 11;
ELSIF sub_ej = 11 THEN
    IF NOT X17 THEN
        sub_ej := 12;
    END_IF;
ELSIF sub_ej = 12 THEN
    Y14 := TRUE;
    Y15 := FALSE;
    IF X1C THEN
        Y14 := FALSE;
        sub_ej := 13;
    END_IF;
ELSIF sub_ej = 13 THEN
    Y14 := FALSE;
    Y15 := TRUE;
    IF X1B THEN
        Y15 := FALSE;
        sub_ej := 20;
    END_IF;
ELSIF sub_ej = 20 THEN
    IF (D3 = 0) AND X1B THEN
        sub_ej := 0;
    END_IF;
ELSIF sub_ej = 30 THEN
    IF (D3 = 0) THEN
        sub_ej := 0;
    END_IF;
END_IF;
Y16 := rel_pulse;

CASE step OF
    0:
        Y17 := TRUE;
        lock_timer(IN := TRUE, PT := T#200ms);
        IF lock_timer.Q AND X19 THEN
            lock_timer(IN := FALSE, PT := T#200ms);
            step := 10;
        END_IF;

    10:
        IF (D10 >= 6) AND (D0 = 0) AND (D1 = 0) AND (D2 = 0) AND (D3 = 0)
           AND NOT rework_active AND NOT rework_done_waiting_return AND NOT X26
           AND X1B AND X19 AND NOT X18 AND NOT X14 AND NOT X15 AND NOT X16 AND NOT X17 AND NOT X25 THEN
            all_finished := TRUE;
            step := 50;
        ELSE
            IF rework_done_waiting_return AND (D0 = 0) THEN
                (* Wait for return_body to complete *)
            ELSIF (sub_load = 0) AND (sub_ins = 0) AND (sub_insp = 0) AND (sub_ej = 0)
               AND NOT X14 AND NOT X15 AND NOT X16 AND NOT X17
               AND X1B AND NOT rework_active THEN
                IF ((D0 = 0) OR (D0 > 0))
                   AND ((D1 = 0) OR X21)
                   AND ((D2 = 0) OR (X22 AND (D6 = D2) AND (D7 = D5)))
                   AND (D3 = 0) THEN
                    IF NOT (rework_done_waiting_return AND (D0 = 0)) THEN
                        step := 20;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

    20:
        Y17 := FALSE;
        unlock_timer(IN := TRUE, PT := T#200ms);
        IF unlock_timer.Q AND X1A THEN
            unlock_timer(IN := FALSE, PT := T#200ms);
            step := 21;
        END_IF;

    21:
        Y18 := TRUE;
        step := 22;

    22:
        Y18 := FALSE;
        IF X18 THEN
            step := 23;
        END_IF;

    23:
        IF NOT X18 THEN
            step := 24;
        END_IF;

    24:
        Y17 := TRUE;
        lock_timer(IN := TRUE, PT := T#200ms);
        IF lock_timer.Q AND X19 THEN
            lock_timer(IN := FALSE, PT := T#200ms);
            step := 10;
        END_IF;

    50:
        complete_timer(IN := TRUE, PT := T#600ms);
        Y1A := TRUE;
        Y17 := TRUE;
END_CASE;

END_PROGRAM