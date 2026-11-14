PROGRAM Main
VAR
    X0 : BOOL; X10 : BOOL; X11 : BOOL; X12 : BOOL; X13 : BOOL;
    X14 : BOOL; X15 : BOOL; X16 : BOOL; X17 : BOOL; X18 : BOOL;
    X19 : BOOL; X1A : BOOL; X1B : BOOL; X1C : BOOL; X1D : BOOL;
    X1E : BOOL; X1F : BOOL; X20 : BOOL; X21 : BOOL; X22 : BOOL;
    X23 : BOOL; X24 : BOOL; X25 : BOOL; X26 : BOOL; X27 : BOOL;
    X28 : BOOL; X29 : BOOL; X2A : BOOL; X2B : BOOL; X2C : BOOL;
    X2D : BOOL; X2E : BOOL; X2F : BOOL; X30 : BOOL; X31 : BOOL;
    X32 : BOOL; X33 : BOOL; X34 : BOOL; X35 : BOOL;
    D0 : INT; D1 : INT; D2 : INT; D3 : INT; D4 : INT;
    D5 : INT; D6 : INT; D7 : INT; D8 : INT; D9 : INT;
    Y10 : BOOL; Y11 : BOOL; Y12 : BOOL; Y13 : BOOL; Y14 : BOOL;
    Y15 : BOOL; Y16 : BOOL; Y17 : BOOL; Y18 : BOOL; Y19 : BOOL;
    Y1A : BOOL; Y1B : BOOL; Y1C : BOOL; Y1D : BOOL; Y1E : BOOL;
    Y1F : BOOL; Y20 : BOOL; Y21 : BOOL; Y22 : BOOL; Y23 : BOOL;
    Y24 : BOOL; Y25 : BOOL; Y26 : BOOL; Y27 : BOOL; Y28 : BOOL;
    Y29 : BOOL;
    
    step : INT := 0;
    roll_cnt : INT := 0;
    tmr1 : TON; tmr2 : TON; tmr3 : TON; tmr4 : TON; tmr5 : TON;
    target_val : INT := 800;
END_VAR

Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
Y1F := FALSE; Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE; Y28 := FALSE;
Y29 := FALSE;

tmr1(IN := FALSE); tmr2(IN := FALSE); tmr3(IN := FALSE);
tmr4(IN := FALSE); tmr5(IN := FALSE);

CASE step OF
    0: 
        IF X0 THEN step := 1; END_IF;

    1: // ACCEPT_A
        Y10 := TRUE;
        IF X12 AND X14 THEN step := 2; END_IF;

    2: // ACCEPT_B
        Y11 := TRUE;
        IF X13 THEN step := 3; END_IF;

    3: // JOG_B
        Y14 := TRUE;
        IF X13 THEN step := 4; END_IF;

    4: // HOLD_B
        Y13 := TRUE;
        IF X15 THEN step := 5; END_IF;

    5: // TRIM_B
        Y15 := TRUE;
        IF X16 THEN step := 6; END_IF;

    6: // ACK_TRIM
        Y16 := TRUE;
        IF X17 THEN step := 7; END_IF;

    7: // CORE_FEED
        Y23 := TRUE;
        IF X2C THEN step := 8; END_IF;

    8: // CORE_STOP
        Y24 := TRUE;
        tmr1(IN := TRUE, PT := T#250ms);
        IF tmr1.Q THEN step := 9; END_IF;

    9: // WAIT_CORE_SEATED
        IF X2D AND X2E THEN step := 10; END_IF;

    10: // ACCEPT_ROLL
        Y17 := TRUE;
        IF X18 AND X19 THEN step := 11; END_IF;

    11: // EXTEND_MANDREL
        Y1F := TRUE;
        tmr2(IN := TRUE, PT := T#600ms);
        IF X1E OR tmr2.Q THEN step := 12; END_IF;

    12: // ENGAGE_NIPS
        Y18 := TRUE; Y19 := TRUE;
        tmr3(IN := TRUE, PT := T#200ms);
        IF tmr3.Q AND X1B AND X1C THEN step := 13; END_IF;

    13: // WINDING
        Y12 := FALSE; Y13 := FALSE;
        Y1A := TRUE;
        IF D5 >= target_val - 2 THEN step := 14; END_IF;

    14: // PREPARE_CUT
        Y1A := FALSE;
        Y12 := TRUE; Y13 := TRUE;
        tmr4(IN := TRUE, PT := T#200ms);
        IF tmr4.Q AND X14 AND X15 THEN step := 15; END_IF;

    15: // CUT_WEBS
        Y1C := TRUE; Y1D := TRUE;
        IF X27 AND X28 THEN step := 16; END_IF;

    16: // WIND_TAIL
        Y1A := TRUE;
        IF X26 OR D7 <= 0 THEN step := 17; END_IF;

    17: // TAPE_PREPARE
        Y1A := FALSE;
        Y25 := TRUE;
        IF X2F AND X2A THEN step := 18; END_IF;

    18: // TAPE_HOLD
        Y26 := TRUE;
        tmr5(IN := TRUE, PT := T#200ms);
        IF tmr5.Q AND X30 THEN step := 19; END_IF;

    19: // TAPE_CUT
        Y27 := TRUE;
        IF X31 THEN step := 20; END_IF;

    20: // TAPE_APPLY
        Y28 := TRUE;
        IF X33 THEN step := 21; END_IF;

    21: // SUPPORT_ROLL
        Y1B := TRUE;
        IF X1F THEN step := 22; END_IF;

    22: // RETRACT_MANDREL
        Y1E := TRUE;
        IF X1D THEN step := 23; END_IF;

    23: // EJECT_ROLL
        Y20 := TRUE;
        IF X22 THEN step := 24; END_IF;

    24: // ACK_EXIT
        Y21 := TRUE;
        tmr1(IN := TRUE, PT := T#100ms);
        IF tmr1.Q THEN step := 25; END_IF;

    25: // RETURN_CRADLE
        IF X34 AND X35 THEN Y29 := TRUE; END_IF;
        IF X20 THEN step := 26; END_IF;

    26: // CHECK_NEXT
        roll_cnt := roll_cnt + 1;
        IF roll_cnt = 1 THEN target_val := 1000;
        ELSIF roll_cnt = 2 THEN target_val := 700;
        END_IF;
        IF roll_cnt < 3 THEN
            step := 7;
        ELSE
            step := 27;
        END_IF;

    27: // FINISH
        Y22 := TRUE;
END_CASE;

END_PROGRAM