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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    
    a_state : INT := 0;
    a_started : INT := 0;
    a_ejected : INT := 0;
    a_starting : BOOL := FALSE;
    
    b_state : INT := 0;
    b_started : INT := 0;
    b_ejected : INT := 0;
    b_starting : BOOL := FALSE;
    
    prev_swap_cond : BOOL := FALSE;
    prev_take_bin : BOOL := FALSE;
    
    is_completed : BOOL := FALSE;
END_VAR

CASE a_state OF
  0:
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    IF X16 AND (a_started < 2) AND NOT X17 AND NOT X18 AND NOT X19 AND NOT X1A THEN
       a_state := 1;
    END_IF;
  1:
    Y13 := TRUE;
    IF X17 THEN
       Y13 := FALSE;
       a_state := 2;
    END_IF;
  2:
    IF X17 AND NOT X19 AND X10 AND NOT X11 AND ((D0 + D1 + D6) <= 6) AND NOT b_starting THEN
       a_starting := TRUE;
       a_state := 3;
    END_IF;
  3:
    Y14 := TRUE;
    a_started := a_started + 1;
    a_state := 4;
  4:
    Y14 := FALSE;
    IF X19 THEN
       a_starting := FALSE;
       a_state := 5;
    END_IF;
  5:
    IF X1A THEN
       a_state := 6;
    END_IF;
  6:
    IF X1B THEN
       a_state := 7;
    END_IF;
  7:
    Y15 := TRUE;
    a_state := 8;
  8:
    Y15 := FALSE;
    IF NOT X1A AND NOT X17 THEN
       a_ejected := a_ejected + 1;
       a_state := 0;
    END_IF;
END_CASE;

CASE b_state OF
  0:
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    IF X1C AND (b_started < 1) AND NOT X1D AND NOT X1E AND NOT X1F AND NOT X20 THEN
       b_state := 1;
    END_IF;
  1:
    Y16 := TRUE;
    IF X1D THEN
       Y16 := FALSE;
       b_state := 2;
    END_IF;
  2:
    IF X1D AND NOT X1F AND X10 AND NOT X11 AND ((D0 + D1 + D8) <= 6) AND NOT a_starting THEN
       b_starting := TRUE;
       b_state := 3;
    END_IF;
  3:
    Y17 := TRUE;
    b_started := b_started + 1;
    b_state := 4;
  4:
    Y17 := FALSE;
    IF X1F THEN
       b_starting := FALSE;
       b_state := 5;
    END_IF;
  5:
    IF X20 THEN
       b_state := 6;
    END_IF;
  6:
    IF X21 THEN
       b_state := 7;
    END_IF;
  7:
    Y18 := TRUE;
    b_state := 8;
  8:
    Y18 := FALSE;
    IF NOT X20 AND NOT X1D THEN
       b_ejected := b_ejected + 1;
       b_state := 0;
    END_IF;
END_CASE;

IF D1 = 0 AND D0 > 0 AND X12 AND NOT X13 AND NOT X11 AND NOT X14 THEN
    IF (a_state = 2 AND (D0 + D1 + D6 > 6)) OR
       (b_state = 2 AND (D0 + D1 + D8 > 6)) THEN
        IF NOT prev_swap_cond THEN
            Y10 := TRUE;
        ELSE
            Y10 := FALSE;
        END_IF;
        prev_swap_cond := TRUE;
    ELSE
        Y10 := FALSE;
        prev_swap_cond := FALSE;
    END_IF;
ELSE
    Y10 := FALSE;
    prev_swap_cond := FALSE;
END_IF;

IF X13 THEN
    IF NOT prev_take_bin THEN
        Y11 := TRUE;
    ELSE
        Y11 := FALSE;
    END_IF;
    prev_take_bin := TRUE;
ELSE
    Y11 := FALSE;
    prev_take_bin := FALSE;
END_IF;

IF a_ejected = 2 AND b_ejected = 1 AND X1B AND X21 AND 
   D1 = 0 AND 
   X10 AND NOT X11 AND 
   NOT X13 AND NOT X14 AND
   a_state = 0 AND b_state = 0 THEN
    is_completed := TRUE;
END_IF;

IF is_completed THEN
    Y12 := TRUE;
ELSE
    Y12 := FALSE;
END_IF;

END_PROGRAM