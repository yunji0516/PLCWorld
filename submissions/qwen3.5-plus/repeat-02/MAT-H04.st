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
    
    state : INT := 0;
    pkg_count : INT := 0;
    content_idx : INT := 0;
    tmr_sep_hold : TON;
    tmr_align : TON;
    tmr_pulse : TON;
    tmr_complete : TON;
END_VAR

tmr_pulse(IN := FALSE, PT := T#100ms);

CASE state OF
    0: (* IDLE *)
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
        Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
        Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
        D200 := 0;
        tmr_sep_hold(IN := FALSE);
        tmr_align(IN := FALSE);
        tmr_complete(IN := FALSE);
        
        IF X20 AND NOT X21 AND NOT (Y10 OR Y11 OR Y16) THEN
            state := 1;
            Y1B := TRUE;
        ELSIF (X23 OR NOT X20) AND NOT X21 AND NOT (Y10 OR Y11 OR Y16) THEN
            state := 4;
        END_IF;

    1: (* WAIT_HOLD *)
        IF X22 THEN
            state := 2;
            Y1C := TRUE;
            tmr_sep_hold(IN := TRUE, PT := T#250ms);
        END_IF;

    2: (* WAIT_SEP_FINISH *)
        IF X23 OR tmr_sep_hold.Q THEN
            state := 3;
            Y1B := FALSE;
            Y1C := FALSE;
            tmr_sep_hold(IN := FALSE);
        END_IF;

    3: (* WAIT_RETREAT *)
        IF NOT X21 THEN
            state := 4;
        END_IF;

    4: (* ACCEPT_POUCH *)
        Y10 := TRUE;
        tmr_pulse(IN := TRUE, PT := T#100ms);
        IF X11 OR tmr_pulse.Q THEN
            state := 5;
            Y10 := FALSE;
            tmr_pulse(IN := FALSE);
        END_IF;

    5: (* TRANSFER *)
        Y15 := TRUE;
        tmr_pulse(IN := TRUE, PT := T#100ms);
        IF X13 OR tmr_pulse.Q THEN
            state := 6;
            Y15 := FALSE;
            tmr_pulse(IN := FALSE);
        END_IF;

    6: (* OPEN_POUCH *)
        Y12 := TRUE; Y13 := TRUE; Y14 := TRUE;
        IF X1A AND X1B THEN
            state := 7;
        END_IF;

    7: (* SELECT_CONTENT *)
        content_idx := 0;
        IF (D4 AND 1) <> 0 THEN content_idx := 1;
        ELSIF (D4 AND 2) <> 0 THEN content_idx := 2;
        ELSIF (D4 AND 4) <> 0 THEN content_idx := 3;
        ELSIF (D4 AND 8) <> 0 THEN content_idx := 4;
        END_IF;
        
        IF content_idx > 0 THEN
            D200 := content_idx;
            state := 8;
        END_IF;

    8: (* ACCEPT_CONTENT *)
        Y11 := TRUE;
        tmr_pulse(IN := TRUE, PT := T#100ms);
        IF X15 OR tmr_pulse.Q THEN
            state := 9;
            Y11 := FALSE;
            tmr_pulse(IN := FALSE);
        END_IF;

    9: (* ALIGN_CONTENT *)
        Y1D := TRUE; Y1E := TRUE;
        tmr_align(IN := TRUE, PT := T#1000ms);
        IF tmr_align.Q THEN
            state := 10;
            Y1D := FALSE; Y1E := FALSE;
            tmr_align(IN := FALSE);
        END_IF;

    10: (* WAIT_ALIGNED *)
        IF X24 AND X25 THEN
            state := 11;
        END_IF;

    11: (* INSERT_CONTENT *)
        IF X13 AND X24 AND X25 AND (D0 = D2) AND (D5 >= D6 + 4) AND NOT X21 THEN
            Y16 := TRUE;
            state := 12;
        END_IF;

    12: (* WAIT_CONTAINED *)
        IF X19 THEN
            state := 13;
            Y16 := FALSE;
        END_IF;

    13: (* RETRACT *)
        Y17 := TRUE;
        IF X17 THEN
            state := 14;
            Y17 := FALSE;
        END_IF;

    14: (* WAIT_EXIT *)
        IF X1E THEN
            state := 15;
        END_IF;

    15: (* ACK_EXIT *)
        Y19 := TRUE;
        tmr_pulse(IN := TRUE, PT := T#100ms);
        IF tmr_pulse.Q THEN
            state := 16;
            Y19 := FALSE;
            tmr_pulse(IN := FALSE);
        END_IF;

    16: (* WAIT_SHUTTLE *)
        IF NOT X12 THEN
            state := 17;
        END_IF;

    17: (* INC_COUNT *)
        pkg_count := pkg_count + 1;
        IF pkg_count < 4 THEN
            state := 0;
        ELSE
            state := 18;
        END_IF;

    18: (* COMPLETE_PREP *)
        Y17 := TRUE;
        IF X17 AND NOT X12 THEN
            state := 19;
            Y17 := FALSE;
        END_IF;

    19: (* COMPLETE_ACTIVE *)
        Y1A := TRUE;
        tmr_complete(IN := TRUE, PT := T#500ms);
        IF tmr_complete.Q THEN
            state := 20;
        END_IF;

    20: (* DONE *)
        Y1A := TRUE;
        
ELSE
    state := 0;
END_CASE;

END_PROGRAM