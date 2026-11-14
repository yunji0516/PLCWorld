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

    init_done : BOOL;
    completed : BOOL;
    
    FH_State : INT;
    TH_State : INT;
    Wrap_State : INT;
    Index_State : INT;
    
    bundles_on_belt : INT;
    chuck_occupied : BOOL;
    wrap_done : BOOL;
    
    chuck_cmd_clamp : BOOL;
    chuck_cmd_unclamp : BOOL;
    
    pulse_prepare_tape : BOOL;
    prepare_tape_req : BOOL;
    belt_advancing : BOOL;
    
    Y10_cmd : BOOL;
    Y13_cmd : BOOL;
    Y14_cmd : BOOL;
    Y15_cmd : BOOL;
    Y16_cmd : BOOL;
    Y17_cmd : BOOL;
    Y19_cmd : BOOL;
    Y1A_cmd : BOOL;
    Y1E_cmd : BOOL;
    Y20_cmd : BOOL;
    Y21_cmd : BOOL;
    Y22_cmd : BOOL;
    Y24_cmd : BOOL;
END_VAR

IF NOT init_done THEN
    Y21_cmd := TRUE;
    init_done := TRUE;
END_IF;

belt_advancing := (bundles_on_belt > 0) AND NOT X10 AND X32;

IF X0 AND NOT completed THEN
    
    IF pulse_prepare_tape THEN
        prepare_tape_req := TRUE;
        pulse_prepare_tape := FALSE;
    END_IF;

    (* Forming Head State Machine *)
    CASE FH_State OF
        0:
            IF X2C THEN
                FH_State := 10;
            END_IF;
        10:
            IF X29 AND X2C THEN
                Y22_cmd := FALSE;
                FH_State := 1;
            END_IF;
        1:
            IF X2E THEN
                Y21_cmd := FALSE;
                FH_State := 2;
            END_IF;
        2:
            IF X2D THEN
                Y20_cmd := TRUE;
                FH_State := 3;
            END_IF;
        3:
            IF X2A THEN
                Y21_cmd := TRUE;
                FH_State := 4;
            END_IF;
        4:
            IF X2C THEN
                Y22_cmd := TRUE;
                FH_State := 5;
            END_IF;
        5:
            IF X2F AND X30 AND NOT belt_advancing THEN
                Y21_cmd := FALSE;
                FH_State := 6;
            END_IF;
        6:
            IF X2D THEN
                Y20_cmd := FALSE;
                FH_State := 7;
            END_IF;
        7:
            IF X2B THEN
                bundles_on_belt := bundles_on_belt + 1;
                Y21_cmd := TRUE;
                FH_State := 8;
            END_IF;
        8:
            IF X2C THEN
                FH_State := 10;
            END_IF;
    END_CASE;

    (* Transfer Head State Machine *)
    CASE TH_State OF
        0:
            IF wrap_done AND chuck_occupied THEN
                Y14_cmd := TRUE; Y13_cmd := FALSE; Y15_cmd := FALSE;
                TH_State := 10;
            ELSIF X10 AND NOT chuck_occupied THEN
                Y13_cmd := TRUE; Y14_cmd := FALSE; Y15_cmd := FALSE;
                TH_State := 1;
            END_IF;
        1:
            IF X33 AND NOT belt_advancing THEN
                Y24_cmd := TRUE;
                TH_State := 2;
            END_IF;
        2:
            IF X12 THEN
                Y10_cmd := TRUE;
                TH_State := 3;
            END_IF;
        3:
            IF X16 THEN
                IF bundles_on_belt > 0 THEN 
                    bundles_on_belt := bundles_on_belt - 1; 
                END_IF;
                D200 := D1;
                pulse_prepare_tape := TRUE;
                Y24_cmd := FALSE;
                Y14_cmd := TRUE;
                Y13_cmd := FALSE;
                TH_State := 4;
            END_IF;
        4:
            IF X13 AND X11 THEN
                chuck_cmd_clamp := TRUE;
                TH_State := 5;
            END_IF;
        5:
            IF X19 THEN
                Y10_cmd := FALSE;
                TH_State := 6;
            END_IF;
        6:
            IF X17 THEN
                chuck_occupied := TRUE;
                chuck_cmd_clamp := FALSE;
                Y13_cmd := TRUE;
                Y14_cmd := FALSE;
                TH_State := 7;
            END_IF;
        7:
            IF X18 THEN
                TH_State := 0;
            END_IF;
        10:
            IF X13 THEN
                Y10_cmd := TRUE;
                TH_State := 11;
            END_IF;
        11:
            IF X16 THEN
                chuck_cmd_unclamp := TRUE;
                TH_State := 12;
            END_IF;
        12:
            IF X1A THEN
                TH_State := 13;
            END_IF;
        13:
            IF X23 THEN
                Y15_cmd := TRUE;
                Y14_cmd := FALSE;
                TH_State := 14;
            END_IF;
        14:
            IF X14 THEN
                Y10_cmd := FALSE;
                TH_State := 15;
            END_IF;
        15:
            IF X17 THEN
                chuck_occupied := FALSE;
                chuck_cmd_unclamp := FALSE;
                Y13_cmd := TRUE;
                Y15_cmd := FALSE;
                TH_State := 0;
            END_IF;
    END_CASE;

    (* Chuck and Wrap State Machine *)
    IF NOT chuck_occupied AND NOT chuck_cmd_clamp THEN
        Wrap_State := 0;
        Y16_cmd := FALSE; Y17_cmd := FALSE; Y19_cmd := FALSE; Y1A_cmd := FALSE;
        wrap_done := FALSE;
    ELSE
        CASE Wrap_State OF
            0:
                IF chuck_occupied AND X19 AND X1B AND X18 THEN
                    Wrap_State := 1;
                END_IF;
            1:
                IF D2 >= D3 AND D3 > 0 THEN
                    Y16_cmd := FALSE;
                    Wrap_State := 2;
                ELSIF D4 <= 0 OR NOT X1C THEN
                    Y16_cmd := FALSE;
                    Wrap_State := 10;
                ELSE
                    Y16_cmd := TRUE;
                END_IF;
            10:
                Y16_cmd := FALSE;
                Wrap_State := 11;
            11:
                IF X19 AND X1B AND X18 THEN
                    Y17_cmd := TRUE;
                    IF X1D THEN
                        Wrap_State := 12;
                    END_IF;
                END_IF;
            12:
                Y17_cmd := FALSE;
                IF NOT X1D AND X1C THEN
                    Wrap_State := 1;
                END_IF;
            2:
                IF X20 AND (D5 = D0) THEN
                    Y19_cmd := TRUE;
                    Wrap_State := 3;
                END_IF;
            3:
                IF X21 THEN
                    Y19_cmd := FALSE;
                    Y1A_cmd := TRUE;
                    Wrap_State := 4;
                END_IF;
            4:
                IF X22 THEN
                    Y1A_cmd := FALSE;
                    wrap_done := TRUE;
                    Wrap_State := 5;
                END_IF;
            5:
                IF NOT chuck_occupied THEN
                    wrap_done := FALSE;
                    Wrap_State := 0;
                END_IF;
        END_CASE;
    END_IF;

    (* Single Item Forming Index State Machine *)
    CASE Index_State OF
        0:
            IF NOT X28 AND (D9 < D10) AND NOT ((D9 = D10) AND (D10 > 0)) THEN
                Y1E_cmd := TRUE;
                Index_State := 1;
            END_IF;
        1:
            IF X27 THEN
                Index_State := 2;
            END_IF;
        2:
            Y1E_cmd := FALSE;
            IF NOT X27 THEN
                Index_State := 0;
            END_IF;
    END_CASE;

END_IF;

(* Completion Condition *)
IF X24 AND (TH_State = 0) AND (Wrap_State = 0) AND (FH_State = 0 OR FH_State = 10) AND (Index_State = 0) AND (bundles_on_belt = 0) AND NOT chuck_occupied THEN
    completed := TRUE;
END_IF;

(* Output Mapping *)
IF completed THEN
    Y1B := TRUE;
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE; Y14 := FALSE; Y15 := FALSE;
    Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
    Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;
    Y20 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE;
    Y21 := TRUE;
ELSE
    Y1B := FALSE;
    Y10 := Y10_cmd;
    Y11 := (chuck_cmd_clamp OR chuck_occupied) AND NOT chuck_cmd_unclamp;
    Y12 := chuck_occupied AND NOT chuck_cmd_unclamp;
    Y13 := Y13_cmd;
    Y14 := Y14_cmd;
    Y15 := Y15_cmd;
    Y16 := Y16_cmd;
    Y17 := Y17_cmd;
    Y18 := prepare_tape_req;
    Y19 := Y19_cmd;
    Y1A := Y1A_cmd;
    Y1C := X25 AND X28 AND NOT X27 AND NOT completed;
    Y1D := X25;
    Y1E := Y1E_cmd;
    Y1F := (D9 = D10) AND (D10 > 0);
    Y20 := Y20_cmd;
    Y21 := Y21_cmd;
    Y22 := Y22_cmd;
    Y23 := belt_advancing;
    Y24 := Y24_cmd;
END_IF;

IF X20 THEN
    prepare_tape_req := FALSE;
END_IF;

END_PROGRAM