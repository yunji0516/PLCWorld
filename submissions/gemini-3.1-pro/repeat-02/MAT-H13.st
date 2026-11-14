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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
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
    D200 : INT;
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
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    Index_State : INT := 0;
    Form_Align_State : INT := 0;
    Chuck_State : INT := 0;
    Grip_State : INT := 0;
    
    TON_rise : TON;
    swap_started : BOOL := FALSE;
    swap_req : BOOL := FALSE;
END_VAR

IF X0 THEN
    (* Form Indexing *)
    CASE Index_State OF
        0: 
            IF NOT X28 AND D9 < D10 AND NOT Y1F AND NOT X27 THEN 
                Index_State := 1; 
            END_IF;
        1: 
            IF X27 THEN 
                Index_State := 2; 
            END_IF;
        2: 
            IF NOT X27 AND X28 THEN 
                Index_State := 0; 
            END_IF;
    END_CASE;

    (* Form Align *)
    CASE Form_Align_State OF
        0: 
            IF D9 = D10 AND D10 > 0 THEN
                IF X29 THEN Form_Align_State := 1; END_IF;
            END_IF;
        1: 
            IF X2D THEN Form_Align_State := 2; END_IF;
        2: 
            IF X2A THEN Form_Align_State := 3; END_IF;
        3: 
            IF X2C THEN Form_Align_State := 4; END_IF;
        4: 
            IF X2F THEN Form_Align_State := 5; END_IF;
        5: 
            IF X30 THEN
                IF X2D THEN Form_Align_State := 6; END_IF;
            END_IF;
        6: 
            IF X2B THEN Form_Align_State := 7; END_IF;
        7: 
            IF X2C THEN Form_Align_State := 8; END_IF;
        8: 
            IF X2E THEN Form_Align_State := 0; END_IF;
    END_CASE;

    (* Chuck Operation *)
    CASE Chuck_State OF
        0:
            IF Grip_State = 6 THEN
                IF X19 THEN Chuck_State := 1; END_IF;
            END_IF;
        1:
            IF X17 AND Grip_State = 7 THEN Chuck_State := 2; END_IF;
        2:
            IF X1B AND X18 THEN
                IF D4 <= 0 THEN
                    Chuck_State := 3;
                ELSIF D2 >= D3 AND D3 > 0 THEN
                    Chuck_State := 4;
                END_IF;
            END_IF;
        3:
            IF X18 THEN
                IF NOT swap_started THEN
                    swap_req := TRUE;
                    IF X1D THEN swap_started := TRUE; swap_req := FALSE; END_IF;
                ELSE
                    swap_req := FALSE;
                    IF NOT X1D THEN
                        Chuck_State := 2;
                        swap_started := FALSE;
                    END_IF;
                END_IF;
            END_IF;
        4:
            IF X20 AND D5 = D0 THEN
                Chuck_State := 5;
            END_IF;
        5:
            IF X21 THEN
                Chuck_State := 6;
            END_IF;
        6:
            IF X22 THEN
                Chuck_State := 7;
            END_IF;
        7:
            IF Grip_State = 12 AND X16 THEN
                IF X1A THEN Chuck_State := 8; END_IF;
            END_IF;
        8:
            IF Grip_State = 0 THEN
                Chuck_State := 0;
            END_IF;
    END_CASE;

    (* Transfer Gripper *)
    CASE Grip_State OF
        0:
            IF Chuck_State = 7 THEN
                Grip_State := 10;
            ELSIF Chuck_State = 0 AND X10 AND X33 THEN
                Grip_State := 1;
            END_IF;
        1:
            IF X33 AND X10 THEN
                Grip_State := 2;
            END_IF;
        2:
            IF X12 THEN Grip_State := 3; END_IF;
        3:
            IF X16 THEN Grip_State := 4; END_IF;
        4:
            IF TON_rise.Q AND D1 > 0 THEN Grip_State := 5; END_IF;
        5:
            IF X13 AND X11 THEN Grip_State := 6; END_IF;
        6:
            IF X19 THEN Grip_State := 7; END_IF;
        7:
            IF X17 THEN Grip_State := 8; END_IF;
        8:
            Grip_State := 0;
            
        10:
            IF X13 THEN Grip_State := 11; END_IF;
        11:
            IF X16 THEN Grip_State := 12; END_IF;
        12:
            IF X1A AND X22 AND X23 THEN Grip_State := 13; END_IF;
        13:
            IF X14 THEN Grip_State := 14; END_IF;
        14:
            IF X17 THEN Grip_State := 15; END_IF;
        15:
            Grip_State := 0;
    END_CASE;
END_IF;

(* Timer Update *)
TON_rise(IN := (Grip_State = 4), PT := T#1000ms);

(* Outputs *)
Y1C := X25 AND X28 AND (Index_State = 0);
Y1D := X25;
Y1E := (Index_State = 1);

IF Form_Align_State = 0 THEN
    Y1F := (D9 = D10 AND D10 > 0);
ELSIF Form_Align_State = 1 OR Form_Align_State = 2 THEN
    Y1F := TRUE;
ELSE
    Y1F := FALSE;
END_IF;

Y21 := TRUE;
IF Form_Align_State = 1 OR Form_Align_State = 2 OR Form_Align_State = 6 THEN
    Y21 := FALSE;
ELSIF Form_Align_State = 5 AND X30 THEN
    Y21 := FALSE;
END_IF;

Y20 := (Form_Align_State = 2 OR Form_Align_State = 3 OR Form_Align_State = 4 OR Form_Align_State = 5);
Y22 := (Form_Align_State = 4 OR Form_Align_State = 5 OR Form_Align_State = 6 OR Form_Align_State = 7);
Y23 := X32 AND X2C AND NOT Y24 AND NOT X15;

Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
IF Grip_State = 1 OR Grip_State = 2 OR Grip_State = 3 OR Grip_State = 4 OR Grip_State = 8 OR Grip_State = 15 OR Grip_State = 0 THEN
    Y13 := TRUE;
ELSIF Grip_State = 5 OR Grip_State = 6 OR Grip_State = 7 OR Grip_State = 10 OR Grip_State = 11 OR Grip_State = 12 THEN
    Y14 := TRUE;
ELSIF Grip_State = 13 OR Grip_State = 14 THEN
    Y15 := TRUE;
END_IF;

Y24 := (Grip_State = 2 OR Grip_State = 3);

IF (Grip_State >= 3 AND Grip_State <= 6) OR (Grip_State >= 11 AND Grip_State <= 14) THEN
    Y10 := TRUE;
ELSE
    Y10 := FALSE;
END_IF;

IF (Chuck_State = 0 AND Grip_State = 6) OR (Chuck_State >= 1 AND Chuck_State <= 6) OR (Chuck_State = 7 AND Grip_State < 12) THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF;

Y12 := (Chuck_State >= 2 AND Chuck_State <= 7);
Y16 := (Chuck_State = 2) AND X1B AND X18 AND (D4 > 0) AND (D2 < D3 OR D3 = 0);
Y17 := swap_req AND (Chuck_State = 3) AND X18;

D200 := D0;
Y18 := (D200 > 0 AND D5 <> D0);

Y19 := (Chuck_State = 5);
Y1A := (Chuck_State = 6);

Y1B := X24 AND (Chuck_State = 0) AND (Grip_State = 0) AND (Form_Align_State = 0);

END_PROGRAM