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
    process_state : INT := 0;
    tool_exchange : BOOL := FALSE;
    product_count : INT := 0;
    complete_time : TIME := T#0s;
    all_done_trigger : BOOL := FALSE;
    head_released : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

(* State Machine for process control *)
CASE process_state OF

    0: (* Initial Setup *)
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
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y1A := FALSE;
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        IF X0 THEN
            process_state := 1;
        END_IF;

    1: (* Prepare Tool and Fixtures *)
        IF NOT tool_exchange THEN
            IF X10 AND X28 AND X2A AND NOT X29 THEN
                D200 := 0; (* Select Tool 1 for A-side initially *)
                Y23 := TRUE; (* Adjust A-width *)
                Y24 := TRUE; (* Adjust B-width *)
                tool_exchange := TRUE;
            END_IF;
        ELSE
            IF X2B THEN
                Y21 := TRUE; (* Lock Tool *)
                process_state := 2;
            END_IF;
        END_IF;
    
    2: (* Handle A-side Product *)
        IF X14 AND NOT X16 THEN
            Y10 := TRUE; (* Admit product to A-side *)
            Y11 := TRUE; (* Request A-side work *)
            IF X15 THEN
                Y12 := TRUE; (* Transfer to cradle *)
                process_state := 3;
            END_IF;
        END_IF;
    
    3: (* Handle Inversion and B-side Setup *)
        IF X17 AND NOT X18 THEN
            Y13 := TRUE; (* Lock cradle *)
        END_IF;
        IF X18 THEN
            Y14 := TRUE; (* Release head *)
        END_IF;
        IF X13 THEN
            Y15 := TRUE; (* Rotate cradle *)
            IF X1A THEN
                Y16 := TRUE; (* Grip head on B-side *)
                process_state := 4;
            END_IF;
        END_IF;
    
    4: (* Handle B-side Product *)
        IF X1C AND NOT X1E THEN
            Y19 := TRUE; (* Request B-side work *)
            IF X1D THEN
                Y18 := TRUE; (* Transfer to B Jig *)
                process_state := 5;
            END_IF;
        END_IF;

    5: (* Exit Procedure *)
        IF X20 AND NOT Y1B THEN
            Y1A := TRUE; (* Release Product *)
            Y1B := TRUE; (* Acknowledge Exit *)
            product_count := product_count + 1;
            IF product_count >= 4 THEN
                all_done_trigger := TRUE;
                process_state := 6;
            ELSE
                process_state := 1; (* Reset for next Product *)
            END_IF;
        END_IF;

    6: (* Completion and Hold State *)
        Y1C := TRUE; (* Set Complete *)
        IF complete_time = T#0s THEN
            complete_time := T#0.5s; (* Set the completion hold time *)
        ELSE
            complete_time := complete_time - T#0.01s;
            IF complete_time <= T#0s THEN
                complete_time := T#0s; (* Hold complete for 0.5s *)
            END_IF;
        END_IF;

END_CASE

END_PROGRAM