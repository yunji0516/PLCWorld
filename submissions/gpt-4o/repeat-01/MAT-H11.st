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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
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
    D13 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* Internal variables *)
    state : INT := 0;
    timer : TON;
    product_counter : INT := 0;
    b_ready : BOOL;
    tool_ready : BOOL;
    complete_started : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
timer(IN := complete_started, PT := T#500ms);

b_ready := X22 AND X1D AND X27 AND X26 AND X2D;
tool_ready := (X2A AND X2B) OR (X8 = 0);

IF X0 THEN
    CASE state OF
        0: (* Initialize and wait for start signal *)
            IF NOT X11 AND (product_counter < 4) THEN
                Y10 := X10 AND X28;
                Y23 := X10 AND X28 AND (D10 MOD 2 = 0) AND (D201 <> 160);
                Y24 := X10 AND X28 AND (D10 MOD 2 = 1) AND (D202 <> 120);
                Y11 := X10 AND X28 AND Y10;
                state := 1;
            END_IF
        1: (* Admit product into A-side operation *)
            IF Y10 THEN
                Y10 := FALSE; (* Reset admit signal *)
                IF NOT X16 THEN
                    Y11 := TRUE;
                END_IF
            END_IF
            IF X15 THEN
                Y11 := FALSE; (* Reset A-side operation *)
                Y12 := TRUE; (* Move completed A product to cradle *)
                state := 2;
            END_IF
        2: (* Transfer A product to inversion cradle *)
            IF X17 THEN
                Y13 := TRUE; (* Lock cradle *)
                state := 3;
            END_IF
        3: (* Secure B-side pad vacuum *)
            IF X1A AND X18 THEN
                Y14 := TRUE; (* Release head *)
                timer(IN := TRUE, PT := T#250ms);
                state := 4;
            END_IF
        4: (* Rotate cradle 180 degrees *)
            IF NOT X12 AND timer.Q THEN
                Y15 := TRUE; (* Rotate signal *)
                state := 5;
            END_IF
        5: (* Grip product after inversion *)
            IF X19 THEN
                Y15 := FALSE;
                Y16 := TRUE; (* Grip product with head *)
                state := 6;
            END_IF
        6: (* Unlock cradle and transfer to B-side *)
            IF X1A THEN
                Y17 := TRUE; (* Unlock cradle *)
                Y18 := TRUE; (* Transfer B product *)
                state := 7;
            END_IF
        7: (* Work on B-side product *)
            IF b_ready THEN
                Y19 := TRUE; (* Request B-side work *)
                state := 8;
            END_IF
        8: (* B-side work and release *)
            IF X1E THEN
                IF NOT X11 THEN
                    IF X1F THEN
                        Y1A := TRUE; (* Release product to exit *)
                        IF X20 THEN
                            Y1B := TRUE; (* Confirm exit receipt *)
                            product_counter := product_counter + 1;
                            Y1A := FALSE;
                            Y1B := FALSE;
                            Y19 := FALSE;
                            Y18 := FALSE;
                            IF product_counter >= 4 THEN
                                complete_started := TRUE;
                                state := 9;
                            ELSE
                                state := 0; (* Go back to start for next product *)
                            END_IF
                        END_IF
                    END_IF
                END_IF
            END_IF
        9: (* All products processed, maintain completion flag *)
            Y1C := TRUE;
            IF timer.Q THEN
                Y1C := FALSE; (* End complete signal after 0.5 seconds *)
                complete_started := FALSE;
                state := 0;
            END_IF
    END_CASE
END_IF

END_PROGRAM