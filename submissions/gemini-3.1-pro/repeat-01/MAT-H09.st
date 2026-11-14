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
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
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

    state_A : INT := 0;
    state_B : INT := 0;
    fill_token : INT := 0;
    
    timer_A : TON;
    timer_B : TON;
    delay_A : BOOL := FALSE;
    delay_B : BOOL := FALSE;
    
    cap_a_req : BOOL := FALSE;
    cap_b_req : BOOL := FALSE;
    cap_a_trig : R_TRIG;
    cap_b_trig : R_TRIG;
    
    swap_cond : BOOL := FALSE;
    swap_trig : R_TRIG;
    complete_cond : BOOL := FALSE;
END_VAR

(* Tank Replenishment Logic *)
IF D3 = 6 THEN
    Y10 := FALSE;
ELSIF X2F AND D1 > 0 THEN
    IF D0 < 1400 THEN
        Y10 := TRUE;
    ELSIF D0 >= 1550 THEN
        Y10 := FALSE;
    END_IF;
ELSE
    Y10 := FALSE;
END_IF;

(* Swap Logic *)
swap_cond := (D3 < 6) AND (D1 = 0) AND (NOT Y10) AND (NOT X2F) AND X31 AND (NOT X30);
swap_trig(CLK := swap_cond);
Y11 := swap_trig.Q;

(* Shared Capping Resource Logic *)
cap_a_req := FALSE;
cap_b_req := FALSE;
IF NOT X2C THEN
    IF X1A AND NOT X1B THEN
        cap_a_req := TRUE;
    ELSIF X28 AND NOT X29 THEN
        cap_b_req := TRUE;
    END_IF;
END_IF;

cap_a_trig(CLK := cap_a_req);
Y12 := cap_a_trig.Q;

cap_b_trig(CLK := cap_b_req);
Y13 := cap_b_trig.Q;

(* Pump Start Delay Timers *)
delay_A := (state_A = 5);
timer_A(IN := delay_A, PT := T#150ms);

delay_B := (state_B = 5);
timer_B(IN := delay_B, PT := T#150ms);

(* Line A State Machine *)
CASE state_A OF
0:
    IF X0 AND X11 AND NOT X10 THEN
        Y14 := TRUE;
        state_A := 1;
    END_IF;
1:
    IF X10 THEN
        Y14 := FALSE;
        state_A := 2;
    END_IF;
2:
    Y15 := TRUE;
    IF X14 THEN
        state_A := 3;
    END_IF;
3:
    Y16 := TRUE;
    IF X13 THEN
        state_A := 4;
    END_IF;
4:
    IF (fill_token = 0 OR fill_token = 1) THEN
        IF D0 >= 1000 OR (NOT X31 AND D1 = 0 AND NOT X2F) THEN
            fill_token := 1;
            Y17 := TRUE;
            state_A := 5;
        END_IF;
    END_IF;
5:
    IF timer_A.Q THEN
        Y18 := TRUE;
        state_A := 6;
    END_IF;
6:
    IF (D4 + D6) >= D5 THEN
        Y18 := FALSE;
        state_A := 7;
    END_IF;
7:
    IF X18 THEN
        Y17 := FALSE;
        state_A := 8;
    END_IF;
8:
    IF X17 THEN
        fill_token := 0;
        Y16 := FALSE;
        state_A := 9;
    END_IF;
9:
    IF X12 THEN
        Y15 := FALSE;
        state_A := 10;
    END_IF;
10:
    IF X15 THEN
        state_A := 11;
    END_IF;
11:
    IF NOT X1A AND NOT X19 THEN
        Y19 := TRUE;
        state_A := 12;
    END_IF;
12:
    IF X1A THEN
        Y19 := FALSE;
        state_A := 13;
    END_IF;
13:
    IF X1B THEN
        state_A := 14;
    END_IF;
14:
    IF X1C THEN
        Y1A := TRUE;
        state_A := 15;
    END_IF;
15:
    IF NOT X1A THEN
        Y1A := FALSE;
        state_A := 0;
    END_IF;
END_CASE;

(* Line B State Machine *)
CASE state_B OF
0:
    IF X0 AND X1F AND NOT X1E THEN
        Y1B := TRUE;
        state_B := 1;
    END_IF;
1:
    IF X1E THEN
        Y1B := FALSE;
        state_B := 2;
    END_IF;
2:
    Y1C := TRUE;
    IF X22 THEN
        state_B := 3;
    END_IF;
3:
    Y1D := TRUE;
    IF X21 THEN
        state_B := 4;
    END_IF;
4:
    IF (fill_token = 0 OR fill_token = 2) THEN
        IF D0 >= 1000 OR (NOT X31 AND D1 = 0 AND NOT X2F) THEN
            fill_token := 2;
            Y1E := TRUE;
            state_B := 5;
        END_IF;
    END_IF;
5:
    IF timer_B.Q THEN
        Y1F := TRUE;
        state_B := 6;
    END_IF;
6:
    IF (D9 + D11) >= D10 THEN
        Y1F := FALSE;
        state_B := 7;
    END_IF;
7:
    IF X26 THEN
        Y1E := FALSE;
        state_B := 8;
    END_IF;
8:
    IF X25 THEN
        fill_token := 0;
        Y1D := FALSE;
        state_B := 9;
    END_IF;
9:
    IF X20 THEN
        Y1C := FALSE;
        state_B := 10;
    END_IF;
10:
    IF X23 THEN
        state_B := 11;
    END_IF;
11:
    IF NOT X28 AND NOT X27 THEN
        Y20 := TRUE;
        state_B := 12;
    END_IF;
12:
    IF X28 THEN
        Y20 := FALSE;
        state_B := 13;
    END_IF;
13:
    IF X29 THEN
        state_B := 14;
    END_IF;
14:
    IF X2A THEN
        Y21 := TRUE;
        state_B := 15;
    END_IF;
15:
    IF NOT X28 THEN
        Y21 := FALSE;
        state_B := 0;
    END_IF;
END_CASE;

(* Completion Status *)
complete_cond := (D3 = 6) AND
                 (NOT Y18) AND (NOT Y1F) AND
                 (NOT Y10) AND
                 (NOT Y17) AND (NOT Y1E) AND X17 AND X25 AND
                 X12 AND X20 AND
                 (NOT X2C) AND
                 (NOT Y11) AND (NOT X30);

Y22 := complete_cond;

END_PROGRAM