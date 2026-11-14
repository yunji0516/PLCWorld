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
    D11 : INT;
    D12 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    accepted_ids : ARRAY[1..6] OF INT;
    inspected_ids : ARRAY[1..6] OF INT;
    detached_ids : ARRAY[1..6] OF INT;
    received_ids : ARRAY[1..6] OF INT;
    accepted_count : INT;
    inspected_count : INT;
    detached_count : INT;
    received_count : INT;
    i : INT;
    found : BOOL;
    foundAccepted : BOOL;
    foundInspectedD6 : BOOL;
    foundInspectedD7 : BOOL;
    foundDetached : BOOL;
    move_pending : BOOL;
    move_seen_busy : BOOL;
    load_pending : BOOL;
    load_seen_busy : BOOL;
    unload_pending : BOOL;
    unload_seen_busy : BOOL;
    inspect_req_active : BOOL;
    inspect_req_jig : INT;
    inspect_req_prod : INT;
    inspect_req_gen : INT;
    complete_latched : BOOL;
    ready_complete : BOOL;
    can_move : BOOL;
    issued_move : BOOL;
    just_acked : BOOL;
END_VAR

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := complete_latched;
issued_move := FALSE;
just_acked := FALSE;

IF move_pending THEN
    IF X11 THEN
        move_seen_busy := TRUE;
    END_IF;
    IF move_seen_busy AND NOT X11 THEN
        move_pending := FALSE;
        move_seen_busy := FALSE;
    END_IF;
END_IF;

IF load_pending THEN
    IF X12 THEN
        load_seen_busy := TRUE;
    END_IF;
    IF (load_seen_busy AND NOT X12) OR ((D5 <> 0) AND NOT X12) THEN
        load_pending := FALSE;
        load_seen_busy := FALSE;
    END_IF;
END_IF;

IF unload_pending THEN
    IF X13 THEN
        unload_seen_busy := TRUE;
    END_IF;
    IF ((unload_seen_busy AND NOT X13) AND (D7 = 0)) OR ((D7 = 0) AND NOT X13) THEN
        unload_pending := FALSE;
        unload_seen_busy := FALSE;
    END_IF;
END_IF;

IF inspect_req_active THEN
    IF (D1 <> inspect_req_jig) OR (D6 <> inspect_req_prod) OR (D6 = 0) THEN
        inspect_req_active := FALSE;
    ELSE
        IF (D10 = inspect_req_gen) AND (D9 = inspect_req_prod) THEN
            found := FALSE;
            FOR i := 1 TO 6 DO
                IF inspected_ids[i] = inspect_req_prod THEN
                    found := TRUE;
                END_IF;
            END_FOR;
            IF NOT found THEN
                IF inspected_count < 6 THEN
                    inspected_count := inspected_count + 1;
                    inspected_ids[inspected_count] := inspect_req_prod;
                END_IF;
            END_IF;
            inspect_req_active := FALSE;
        END_IF;
    END_IF;
END_IF;

foundInspectedD6 := FALSE;
foundInspectedD7 := FALSE;
foundDetached := FALSE;
foundAccepted := FALSE;

FOR i := 1 TO 6 DO
    IF (D6 <> 0) AND (inspected_ids[i] = D6) THEN
        foundInspectedD6 := TRUE;
    END_IF;
    IF (D7 <> 0) AND (inspected_ids[i] = D7) THEN
        foundInspectedD7 := TRUE;
    END_IF;
    IF (D12 <> 0) AND (detached_ids[i] = D12) THEN
        foundDetached := TRUE;
    END_IF;
    IF (D11 <> 0) AND (accepted_ids[i] = D11) THEN
        foundAccepted := TRUE;
    END_IF;
END_FOR;

IF X16 AND (D12 <> 0) AND foundDetached THEN
    found := FALSE;
    FOR i := 1 TO 6 DO
        IF received_ids[i] = D12 THEN
            found := TRUE;
        END_IF;
    END_FOR;
    IF NOT found THEN
        IF received_count < 6 THEN
            received_count := received_count + 1;
            received_ids[received_count] := D12;
            Y18 := TRUE;
            just_acked := TRUE;
        END_IF;
    END_IF;
END_IF;

ready_complete := FALSE;
IF (received_count >= 6) AND
   (((D0 = 101) AND (D4 = 102)) OR ((D0 = 102) AND (D4 = 101))) AND
   (D1 = 0) AND (D2 = 0) AND (D3 = 0) AND
   (D5 = 0) AND (D6 = 0) AND (D7 = 0) AND
   X17 AND
   NOT X11 AND NOT X12 AND NOT X13 AND NOT X14 AND
   NOT X1B AND NOT X1C AND
   NOT move_pending AND NOT load_pending AND NOT unload_pending AND
   NOT inspect_req_active AND NOT just_acked THEN
    ready_complete := TRUE;
END_IF;

IF ready_complete THEN
    complete_latched := TRUE;
    Y19 := TRUE;
END_IF;

IF complete_latched THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y19 := TRUE;
ELSE
    IF X0 THEN
        IF X10 AND (accepted_count < 6) AND (D11 <> 0) AND NOT foundAccepted AND
           (D0 <> 0) AND (D5 = 0) AND X17 AND X1F AND
           NOT X11 AND NOT X1B AND NOT X12 AND NOT load_pending THEN
            Y10 := TRUE;
            load_pending := TRUE;
            load_seen_busy := FALSE;
            accepted_count := accepted_count + 1;
            accepted_ids[accepted_count] := D11;
        END_IF;

        IF (D1 <> 0) AND (D6 <> 0) AND NOT foundInspectedD6 AND
           NOT inspect_req_active AND NOT X14 THEN
            Y11 := TRUE;
            D202 := D8;
            inspect_req_active := TRUE;
            inspect_req_jig := D1;
            inspect_req_prod := D6;
            inspect_req_gen := D8;
        END_IF;

        IF X15 AND (D2 <> 0) AND (D7 <> 0) AND foundInspectedD7 AND
           NOT X13 AND NOT unload_pending THEN
            Y12 := TRUE;
            unload_pending := TRUE;
            unload_seen_busy := FALSE;
            found := FALSE;
            FOR i := 1 TO 6 DO
                IF detached_ids[i] = D7 THEN
                    found := TRUE;
                END_IF;
            END_FOR;
            IF NOT found THEN
                IF detached_count < 6 THEN
                    detached_count := detached_count + 1;
                    detached_ids[detached_count] := D7;
                END_IF;
            END_IF;
        END_IF;

        can_move := NOT move_pending AND NOT X11 AND NOT X1B AND NOT X1C;

        IF can_move THEN
            IF (D1 <> 0) AND (D6 <> 0) AND foundInspectedD6 AND
               (D2 = 0) AND NOT X14 THEN
                D200 := D1;
                D201 := 2;
                Y13 := TRUE;
                move_pending := TRUE;
                move_seen_busy := FALSE;
                issued_move := TRUE;
            ELSIF (D2 <> 0) AND (D7 = 0) AND (D3 = 0) AND
                  X19 AND NOT X13 AND NOT unload_pending THEN
                D200 := D2;
                D201 := 3;
                Y13 := TRUE;
                move_pending := TRUE;
                move_seen_busy := FALSE;
                issued_move := TRUE;
            ELSIF (D3 <> 0) AND (D4 = 0) AND X1A AND X1E THEN
                D200 := D3;
                D201 := 4;
                Y13 := TRUE;
                move_pending := TRUE;
                move_seen_busy := FALSE;
                issued_move := TRUE;
            ELSIF (D4 <> 0) AND (D0 = 0) AND X18 THEN
                D200 := D4;
                D201 := 0;
                Y13 := TRUE;
                move_pending := TRUE;
                move_seen_busy := FALSE;
                issued_move := TRUE;
            ELSIF (D0 <> 0) AND (D5 <> 0) AND (D1 = 0) AND
                  X17 AND X1F AND NOT X12 AND NOT load_pending THEN
                D200 := D0;
                D201 := 1;
                Y13 := TRUE;
                move_pending := TRUE;
                move_seen_busy := FALSE;
                issued_move := TRUE;
            END_IF;
        END_IF;

        IF NOT X11 AND NOT move_pending AND NOT issued_move THEN
            IF D0 <> 0 THEN
                IF X1F AND NOT X17 AND NOT X1B THEN
                    Y14 := TRUE;
                END_IF;
            ELSE
                IF NOT X18 AND NOT X1B THEN
                    Y15 := TRUE;
                END_IF;
            END_IF;

            IF D3 <> 0 THEN
                IF X1E AND NOT X1A AND NOT X1C THEN
                    Y17 := TRUE;
                END_IF;
            ELSE
                IF NOT X19 AND NOT X1C THEN
                    Y16 := TRUE;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM