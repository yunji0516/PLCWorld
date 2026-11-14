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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    Prod_State : INT := 0;
    Rec_State : INT := 0;
    Swap_State : INT := 0;
    products_processed : INT := 0;
    rolls_unloaded : INT := 0;
    recoveries_acked : INT := 0;
    is_complete : BOOL := FALSE;
END_VAR

IF NOT X0 THEN
    RETURN;
END_IF;

(* Product Pitch Processing Sequence *)
CASE Prod_State OF
    0:
        IF X10 AND (products_processed < 6) THEN
            Y10 := TRUE;
            Prod_State := 1;
        END_IF;
    1:
        Y10 := FALSE;
        Prod_State := 2;
    2:
        IF D3 <= 300 THEN
            Y11 := TRUE;
            Prod_State := 3;
        END_IF;
    3:
        IF X12 THEN
            Y11 := FALSE;
            Prod_State := 4;
        END_IF;
    4:
        Y12 := TRUE;
        IF X15 THEN
            Prod_State := 5;
        END_IF;
    5:
        D200 := 15;
        Y13 := TRUE;
        Prod_State := 6;
    6:
        IF X14 THEN
            Y13 := FALSE;
            Y12 := FALSE;
            Prod_State := 7;
        END_IF;
    7:
        IF X20 THEN
            Y14 := TRUE;
            Prod_State := 8;
        END_IF;
    8:
        IF X16 THEN
            Y14 := FALSE;
            Y15 := TRUE;
            Prod_State := 9;
        END_IF;
    9:
        IF X17 THEN
            Prod_State := 10;
        END_IF;
    10:
        IF X19 THEN
            Y16 := TRUE;
            Prod_State := 11;
        END_IF;
    11:
        IF X1A THEN
            Y1A := TRUE;
            Prod_State := 12;
        END_IF;
    12:
        IF NOT X1A THEN
            Y1A := FALSE;
            Y16 := FALSE;
            Y15 := FALSE;
            products_processed := products_processed + 1;
            Prod_State := 13;
        END_IF;
    13:
        IF NOT X18 THEN
            Prod_State := 0;
        END_IF;
END_CASE;

(* Web Recovery Sequence *)
CASE Rec_State OF
    0:
        IF X1B THEN
            Y17 := TRUE;
            Rec_State := 1;
        END_IF;
    1:
        Y17 := FALSE;
        Rec_State := 2;
    2:
        IF X1D THEN
            Y18 := FALSE;
            Y19 := TRUE;
            Rec_State := 3;
        ELSE
            IF Swap_State = 0 AND rolls_unloaded < 2 THEN
                Y18 := TRUE;
            ELSE
                Y18 := FALSE;
            END_IF;
        END_IF;
    3:
        IF NOT X1D THEN
            Y19 := FALSE;
            recoveries_acked := recoveries_acked + 1;
            Rec_State := 0;
        END_IF;
END_CASE;

(* Waste Reel Swap Sequence *)
CASE Swap_State OF
    0:
        IF X21 AND rolls_unloaded < 2 THEN
            Swap_State := 10;
        END_IF;
    10:
        Y1C := TRUE;
        IF X22 THEN
            Swap_State := 11;
        END_IF;
    11:
        Y1D := TRUE; 
        Y1E := TRUE;
        Swap_State := 12;
    12:
        IF X23 THEN
            Y1D := FALSE; 
            Y1E := FALSE;
            Swap_State := 13;
        END_IF;
    13:
        Y1F := TRUE;
        rolls_unloaded := rolls_unloaded + 1;
        Swap_State := 14;
    14:
        Y1F := FALSE;
        IF rolls_unloaded >= 2 THEN
            Swap_State := 20;
        ELSE
            IF X25 THEN 
                Swap_State := 15; 
            END_IF;
        END_IF;
    15:
        Y20 := TRUE;
        Swap_State := 16;
    16:
        IF X26 THEN
            Y20 := FALSE;
            Swap_State := 17;
        END_IF;
    17:
        Y21 := TRUE; 
        Y22 := TRUE;
        IF X27 AND X28 THEN 
            Swap_State := 18; 
        END_IF;
    18:
        Y21 := FALSE; 
        Y22 := FALSE;
        Y1C := FALSE;
        IF X29 THEN 
            Swap_State := 0; 
        END_IF;
    20:
        Y1C := FALSE;
END_CASE;

(* Overall Task Completion Validation *)
is_complete := (products_processed = 6) AND (rolls_unloaded = 2) AND (recoveries_acked = 4) AND (Prod_State = 0) AND (Swap_State = 20);

IF is_complete THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM