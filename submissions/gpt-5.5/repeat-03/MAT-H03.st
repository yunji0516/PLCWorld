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
    started : BOOL;
    complete_latched : BOOL;
    load_req_active : BOOL;
    inspect_req_active : BOOL;
    detach_req_active : BOOL;
    pending_inspect_jig : INT;
    pending_inspect_product : INT;
    pending_inspect_generation : INT;
    detaching_jig : INT;
    loaded_count : INT;
    received_count : INT;
    received_ids : ARRAY[1..6] OF INT;
    i : INT;
    seen_reception : BOOL;
    inspected_at_inspect : BOOL;
    inspected_at_output : BOOL;
    prod101 : INT;
    prod102 : INT;
    inspected101 : BOOL;
    inspected102 : BOOL;
    final_ok : BOOL;
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
Y19 := FALSE;

IF X0 THEN
    started := TRUE;
END_IF;

IF complete_latched THEN
    Y19 := TRUE;
ELSE
    IF started THEN
        IF load_req_active THEN
            IF ((NOT X12) AND (D5 <> 0)) OR (D0 = 0) THEN
                load_req_active := FALSE;
            END_IF;
        END_IF;

        IF inspect_req_active THEN
            IF (NOT X14) AND (D9 = pending_inspect_product) AND (D10 = pending_inspect_generation) AND (pending_inspect_product <> 0) THEN
                IF pending_inspect_jig = 101 THEN
                    prod101 := pending_inspect_product;
                    inspected101 := TRUE;
                ELSIF pending_inspect_jig = 102 THEN
                    prod102 := pending_inspect_product;
                    inspected102 := TRUE;
                END_IF;
                inspect_req_active := FALSE;
                pending_inspect_jig := 0;
                pending_inspect_product := 0;
                pending_inspect_generation := 0;
            END_IF;
        END_IF;

        IF detach_req_active THEN
            IF (NOT X13) AND (D7 = 0) THEN
                IF detaching_jig = 101 THEN
                    prod101 := 0;
                    inspected101 := FALSE;
                ELSIF detaching_jig = 102 THEN
                    prod102 := 0;
                    inspected102 := FALSE;
                END_IF;
                detach_req_active := FALSE;
                detaching_jig := 0;
            END_IF;
        END_IF;

        seen_reception := FALSE;
        IF X16 AND (D12 <> 0) THEN
            FOR i := 1 TO 6 DO
                IF received_ids[i] = D12 THEN
                    seen_reception := TRUE;
                END_IF;
            END_FOR;
            IF (NOT seen_reception) AND (received_count < 6) THEN
                received_count := received_count + 1;
                received_ids[received_count] := D12;
                Y18 := TRUE;
            END_IF;
        END_IF;

        inspected_at_inspect := FALSE;
        IF (D1 = 101) AND (D6 <> 0) AND inspected101 AND (prod101 = D6) THEN
            inspected_at_inspect := TRUE;
        ELSIF (D1 = 102) AND (D6 <> 0) AND inspected102 AND (prod102 = D6) THEN
            inspected_at_inspect := TRUE;
        END_IF;

        inspected_at_output := FALSE;
        IF (D2 = 101) AND (D7 <> 0) AND inspected101 AND (prod101 = D7) THEN
            inspected_at_output := TRUE;
        ELSIF (D2 = 102) AND (D7 <> 0) AND inspected102 AND (prod102 = D7) THEN
            inspected_at_output := TRUE;
        END_IF;

        IF (NOT load_req_active) AND (loaded_count < 6) AND X10 AND (NOT X12) AND (D0 <> 0) AND (D5 = 0) AND X17 AND X1F AND (NOT X1B) THEN
            Y10 := TRUE;
            load_req_active := TRUE;
            loaded_count := loaded_count + 1;
            IF D0 = 101 THEN
                prod101 := D11;
                inspected101 := FALSE;
            ELSIF D0 = 102 THEN
                prod102 := D11;
                inspected102 := FALSE;
            END_IF;
        END_IF;

        IF (NOT inspect_req_active) AND (NOT X14) AND (D1 <> 0) AND (D6 <> 0) AND (NOT inspected_at_inspect) THEN
            Y11 := TRUE;
            D202 := D8;
            pending_inspect_jig := D1;
            pending_inspect_product := D6;
            pending_inspect_generation := D8;
            inspect_req_active := TRUE;
        END_IF;

        IF (NOT detach_req_active) AND (NOT X13) AND X15 AND (D2 <> 0) AND (D7 <> 0) AND inspected_at_output THEN
            Y12 := TRUE;
            detach_req_active := TRUE;
            detaching_jig := D2;
        END_IF;

        IF (NOT X11) AND (NOT X1B) AND (NOT X1C) THEN
            IF (D1 <> 0) AND (D6 <> 0) AND inspected_at_inspect AND (D2 = 0) THEN
                D200 := D1;
                D201 := 2;
                Y13 := TRUE;
            ELSIF (D0 <> 0) AND (D5 <> 0) AND (D1 = 0) AND X17 AND X1F THEN
                D200 := D0;
                D201 := 1;
                Y13 := TRUE;
                IF D0 = 101 THEN
                    prod101 := D5;
                    inspected101 := FALSE;
                ELSIF D0 = 102 THEN
                    prod102 := D5;
                    inspected102 := FALSE;
                END_IF;
            ELSIF (D2 <> 0) AND (D7 = 0) AND (NOT X13) AND (D3 = 0) AND X19 THEN
                D200 := D2;
                D201 := 3;
                Y13 := TRUE;
            ELSIF (D3 <> 0) AND (D4 = 0) AND X1A AND X1E THEN
                D200 := D3;
                D201 := 4;
                Y13 := TRUE;
            ELSIF (D4 <> 0) AND (D0 = 0) AND X18 THEN
                D200 := D4;
                D201 := 0;
                Y13 := TRUE;
            END_IF;
        END_IF;

        IF (NOT X11) AND (NOT Y13) THEN
            IF D3 <> 0 THEN
                IF X1E AND (NOT X1A) AND (NOT X1C) THEN
                    Y17 := TRUE;
                END_IF;
            ELSE
                IF (NOT X19) AND (NOT X1C) THEN
                    Y16 := TRUE;
                END_IF;
            END_IF;

            IF D0 <> 0 THEN
                IF X1F AND (NOT X17) AND (NOT X1B) THEN
                    Y14 := TRUE;
                END_IF;
            ELSE
                IF (D4 <> 0) THEN
                    IF (NOT X18) AND (NOT X1B) THEN
                        Y15 := TRUE;
                    END_IF;
                ELSE
                    IF (NOT X17) AND (NOT X1B) THEN
                        Y14 := TRUE;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

        final_ok := FALSE;
        IF (received_count >= 6) AND
           (D1 = 0) AND (D2 = 0) AND (D3 = 0) AND
           (((D0 = 101) AND (D4 = 102)) OR ((D0 = 102) AND (D4 = 101))) AND
           X17 AND X1F AND
           (NOT X11) AND (NOT X12) AND (NOT X13) AND (NOT X14) AND
           (NOT X1B) AND (NOT X1C) AND
           (NOT Y10) AND (NOT Y11) AND (NOT Y12) AND (NOT Y13) AND
           (NOT Y14) AND (NOT Y15) AND (NOT Y16) AND (NOT Y17) AND
           (NOT Y18) THEN
            final_ok := TRUE;
        END_IF;

        IF final_ok THEN
            complete_latched := TRUE;
            Y19 := TRUE;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM