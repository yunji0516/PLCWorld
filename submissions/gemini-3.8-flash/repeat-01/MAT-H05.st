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
    step : INT;
    sub_step : INT;
    rework_step : INT;
    eject_step : INT;

    load_done_station : BOOL;
    insert_done_station : BOOL;
    inspect_done_station : BOOL;
    eject_done_station : BOOL;

    clamp_timer : TON;
    complete_timer : TON;

    prev_exit_received : BOOL;
    ack_pulse : BOOL;
    rework_active : BOOL;
    eject_active : BOOL;
END_VAR

IF X0 AND NOT started THEN
    started := TRUE;
    step := 0;
END_IF;

IF NOT started THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := TRUE;
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

(* Exit receipt acknowledgement pulse *)
IF X1E AND NOT prev_exit_received THEN
    ack_pulse := TRUE;
END_IF;
prev_exit_received := X1E;

IF ack_pulse THEN
    Y19 := TRUE;
    ack_pulse := FALSE;
ELSE
    Y19 := FALSE;
END_IF;

(* Clamp timer for rework *)
clamp_timer(IN := Y1C, PT := T#350ms);

(* Rework State Machine *)
CASE rework_step OF
    0:
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        IF rework_active THEN
            rework_step := 10;
        END_IF;

    10: (* Trigger to_rework *)
        IF NOT X25 THEN
            Y1B := TRUE;
            rework_step := 11;
        END_IF;

    11:
        Y1B := FALSE;
        IF X26 AND NOT X25 THEN
            Y1C := TRUE;
            rework_step := 20;
        END_IF;

    20: (* Wait for clamp *)
        IF X27 AND clamp_timer.Q THEN
            IF NOT X25 THEN
                Y1D := TRUE;
                rework_step := 21;
            END_IF;
        END_IF;

    21:
        Y1D := FALSE;
        IF X28 AND NOT X25 THEN
            Y1E := TRUE;
            rework_step := 22;
        END_IF;

    22:
        Y1E := FALSE;
        IF X29 AND NOT X25 THEN
            Y1C := FALSE; (* Unclamp *)
            rework_step := 30;
        END_IF;

    30: (* Wait unclamped and return_ready *)
        IF NOT X27 AND X2A AND NOT X25 THEN
            (* Wait until pocket at position 0 is empty and table is locked *)
            IF D0 = 0 AND X19 AND NOT X14 AND NOT X18 THEN
                Y1F := TRUE;
                rework_step := 31;
            END_IF;
        END_IF;

    31:
        Y1F := FALSE;
        IF NOT X25 AND NOT X26 THEN
            rework_active := FALSE;
            rework_step := 0;
        END_IF;
END_CASE;

(* Eject / Release State Machine *)
CASE eject_step OF
    0:
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := FALSE;
        IF eject_active THEN
            eject_step := 10;
        END_IF;

    10:
        IF X1B AND X1D AND NOT X1E THEN
            Y16 := TRUE;
            eject_step := 11;
        END_IF;

    11:
        Y16 := FALSE;
        eject_step := 12;

    12:
        IF NOT X17 THEN
            Y15 := FALSE;
            Y14 := TRUE;
            eject_step := 13;
        END_IF;

    13:
        IF X1C THEN
            Y14 := FALSE;
            Y15 := TRUE;
            eject_step := 14;
        END_IF;

    14:
        IF X1B AND NOT X17 THEN
            eject_done_station := TRUE;
            eject_active := FALSE;
            eject_step := 0;
        END_IF;
END_CASE;

(* Main Table Coordination State Machine *)
CASE step OF
    0: (* Ensure locked and ready *)
        Y17 := TRUE;
        Y18 := FALSE;
        IF X19 AND NOT X18 THEN
            step := 10;
            sub_step := 0;
            load_done_station := FALSE;
            insert_done_station := FALSE;
            inspect_done_station := FALSE;
            eject_done_station := FALSE;
        END_IF;

    10: (* Station 0: Load body if needed *)
        IF D0 = 0 THEN
            IF X10 AND NOT X14 THEN
                Y10 := TRUE;
                step := 11;
            ELSIF X11 OR rework_active OR (rework_step > 0) THEN
                load_done_station := TRUE;
                step := 20;
            END_IF;
        ELSE
            load_done_station := TRUE;
            step := 20;
        END_IF;

    11:
        Y10 := FALSE;
        IF NOT X14 THEN
            load_done_station := TRUE;
            step := 20;
        END_IF;

    20: (* Station 1: Insert if needed *)
        IF D1 > 0 AND NOT X21 THEN
            IF NOT X13 THEN
                Y11 := TRUE;
            ELSE
                Y11 := FALSE;
                IF NOT X15 THEN
                    Y12 := TRUE;
                    step := 21;
                END_IF;
            END_IF;
        ELSE
            Y11 := FALSE;
            insert_done_station := TRUE;
            step := 30;
        END_IF;

    21:
        Y12 := FALSE;
        IF X21 AND NOT X15 THEN
            insert_done_station := TRUE;
            step := 30;
        END_IF;

    30: (* Station 2: Inspect if needed *)
        IF D2 > 0 AND (NOT X22 OR (D6 <> D2) OR (D7 <> D5)) THEN
            IF NOT X16 THEN
                D200 := D5;
                Y13 := TRUE;
                step := 31;
            END_IF;
        ELSE
            inspect_done_station := TRUE;
            step := 40;
        END_IF;

    31:
        Y13 := FALSE;
        IF X22 AND (D6 = D2) AND (D7 = D5) AND NOT X16 THEN
            inspect_done_station := TRUE;
            step := 40;
        END_IF;

    40: (* Station 3: Handle eject or rework *)
        IF D3 > 0 AND X20 THEN
            IF X24 THEN
                (* NG product: send to rework *)
                IF NOT rework_active AND (rework_step = 0) AND X1B THEN
                    rework_active := TRUE;
                    step := 41;
                END_IF;
            ELSE
                (* Good product: eject *)
                IF NOT eject_active AND (eject_step = 0) THEN
                    eject_active := TRUE;
                    step := 42;
                END_IF;
            END_IF;
        ELSE
            eject_done_station := TRUE;
            step := 50;
        END_IF;

    41: (* Waiting for rework to pick up from pocket 3 *)
        IF rework_step >= 20 THEN
            eject_done_station := TRUE;
            step := 50;
        END_IF;

    42: (* Waiting for eject completion *)
        IF eject_done_station THEN
            step := 50;
        END_IF;

    50: (* Check if all completed or need table turn *)
        IF X1F OR (D10 >= 6) THEN
            IF (rework_step = 0) AND NOT rework_active AND (eject_step = 0) AND NOT eject_active AND X1B AND NOT X26 THEN
                step := 100;
            END_IF;
        ELSIF load_done_station AND insert_done_station AND inspect_done_station AND eject_done_station THEN
            IF (rework_step = 0) AND NOT rework_active AND (eject_step = 0) AND NOT eject_active AND X1B AND NOT X25 AND NOT X14 AND NOT X15 AND NOT X16 AND NOT X17 THEN
                (* Unlock table *)
                Y17 := FALSE;
                step := 60;
            END_IF;
        END_IF;

    60: (* Wait unlocked, then turn *)
        IF X1A AND NOT X19 THEN
            Y18 := TRUE;
            step := 61;
        END_IF;

    61:
        Y18 := FALSE;
        IF X18 THEN
            step := 62;
        END_IF;

    62: (* Table rotating, wait until stopped *)
        IF NOT X18 THEN
            Y17 := TRUE; (* Lock pin *)
            step := 63;
        END_IF;

    63: (* Wait locked *)
        IF X19 THEN
            step := 0;
        END_IF;

    100: (* Completion *)
        Y17 := TRUE;
        Y18 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        IF X19 AND NOT X18 AND X1B AND NOT X25 AND NOT X14 AND NOT X15 AND NOT X16 AND NOT X17 THEN
            Y1A := TRUE;
        END_IF;
END_CASE;

complete_timer(IN := Y1A, PT := T#500ms);

END_PROGRAM
