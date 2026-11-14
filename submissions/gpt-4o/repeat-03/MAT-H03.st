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
    state : INT := 0;
    product_count : INT := 0;
    complete_timer : TON;
    complete_edge : R_TRIG;
END_VAR

(* Implement the control logic here. *)

complete_edge(CLK := X20);

CASE state OF
    0: (* Initial State *)
        IF X0 THEN
            state := 1;
        END_IF

    1: (* Wait for Source Ready *)
        IF X10 AND NOT X12 THEN
            Y10 := TRUE;
            D200 := 101; (* Input Jig ID *)
            D201 := 1; (* Move to Inspection Position *)
            IF NOT X11 THEN
                Y13 := TRUE; (* Start Move *)
                state := 2;
            END_IF
        END_IF

    2: (* Handle Inspection *)
        Y10 := FALSE; (* Turn off admit *)
        IF NOT X11 AND X14 THEN
            Y11 := TRUE; (* Start Inspection *)
            D202 := D8; (* Current Inspect Generation *)
            state := 3;
        END_IF

    3: (* Wait for Inspection Completion *)
        IF NOT X14 THEN
            Y11 := FALSE;
            IF D9 = 1 THEN (* If Product is Good *)
                IF X15 THEN
                    Y12 := TRUE; (* Start Detach Product *)
                    state := 4;
                END_IF
            ELSE
                state := 5; (* Move to next step if product is bad *)
            END_IF
        END_IF

    4: (* Handle Product Reception *)
        IF X16 AND NOT X13 THEN
            Y12 := FALSE;
            Y18 := TRUE; (* Acknowledge Exit *)
            state := 5;
        END_IF

    5: (* Move Empty Jig to Output or Input Jig to Lower Center *)
        IF NOT X11 THEN
            IF D200 = 101 THEN
                D201 := 4; (* Move to Lower Center *)
            ELSE
                D201 := 0; (* Move to Left Lift *)
            END_IF
            Y13 := TRUE; (* Start Move *)
            IF D200 = 102 AND NOT X13 THEN
                product_count := product_count + 1;
                IF product_count = 6 THEN
                    state := 6; (* All Products received *)
                END_IF
            END_IF
        END_IF

    6: (* Completion Check *)
        IF complete_edge.Q THEN
            Y19 := TRUE; (* Indicate Task Complete *)
            complete_timer(IN := TRUE, PT := T#500ms);
            IF complete_timer.Q THEN
                Y19 := FALSE;
            END_IF
        END_IF
END_CASE

IF NOT X11 THEN
    Y13 := FALSE; (* Ensure move command is not persistent *)
END_IF

END_PROGRAM