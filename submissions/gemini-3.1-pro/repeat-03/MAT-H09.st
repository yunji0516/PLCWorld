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
    
    started : BOOL := FALSE;
    a_state : INT := 0;
    b_state : INT := 0;
    capper_state : INT := 0;
    
    a_needs_pump : BOOL := FALSE;
    b_needs_pump : BOOL := FALSE;
    a_pump_enable : BOOL := FALSE;
    b_pump_enable : BOOL := FALSE;
    
    refill_cmd : BOOL := FALSE;
    
    a_needs_cap : BOOL := FALSE;
    b_needs_cap : BOOL := FALSE;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    RETURN;
END_IF;

(* Tank Refill Logic *)
IF D1 > 0 AND X2F AND NOT X30 AND NOT X32 THEN
    IF D0 <= 1400 THEN
        refill_cmd := TRUE;
    ELSIF D0 >= 1550 THEN
        refill_cmd := FALSE;
    END_IF;
ELSE
    refill_cmd := FALSE;
END_IF;
Y10 := refill_cmd;

(* Batch Swap Logic *)
IF D1 = 0 AND NOT Y10 AND NOT X30 AND X31 AND NOT X32 THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF;

(* Pump Allocation Logic - Prevents Common Tank Depletion *)
a_needs_pump := (a_state = 5);
b_needs_pump := (b_state = 5);

IF D0 > 100 THEN
    a_pump_enable := TRUE;
    b_pump_enable := TRUE;
ELSE
    IF a_needs_pump THEN
        a_pump_enable := TRUE;
        b_pump_enable := FALSE;
    ELSE
        a_pump_enable := FALSE;
        b_pump_enable := TRUE;
    END_IF;
END_IF;

(* Line A Filling Sequence *)
CASE a_state OF
0:
    IF X11 AND NOT X10 THEN
        Y14 := TRUE;
        a_state := 1;
    END_IF;
1:
    IF X10 THEN
        Y14 := FALSE;
        a_state := 2;
    END_IF;
2:
    Y15 := TRUE;
    IF X14 THEN
        a_state := 3;
    END_IF;
3:
    Y16 := TRUE;
    IF X13 THEN
        a_state := 4;
    END_IF;
4:
    Y17 := TRUE;
    IF X16 THEN
        a_state := 5;
    END_IF;
5:
    IF (D4 + D6) >= D5 THEN
        Y18 := FALSE;
        a_state := 6;
    ELSE
        Y18 := a_pump_enable;
    END_IF;
6:
    Y18 := FALSE;
    IF X18 THEN
        Y17 := FALSE;
        a_state := 7;
    END_IF;
7:
    IF X17 THEN
        Y16 := FALSE;
        a_state := 8;
    END_IF;
8:
    IF X12 THEN
        Y15 := FALSE;
        a_state := 9;
    END_IF;
9:
    IF X15 THEN
        a_state := 10;
    END_IF;
10:
    IF NOT X1A AND NOT X19 THEN
        Y19 := TRUE;
        a_state := 11;
    END_IF;
11:
    IF X19 OR NOT X10 THEN
        Y19 := FALSE;
        a_state := 12;
    END_IF;
12:
    IF NOT X10 AND NOT X19 THEN
        a_state := 0;
    END_IF;
END_CASE;

(* Line B Filling Sequence *)
CASE b_state OF
0:
    IF X1F AND NOT X1E THEN
        Y1B := TRUE;
        b_state := 1;
    END_IF;
1:
    IF X1E THEN
        Y1B := FALSE;
        b_state := 2;
    END_IF;
2:
    Y1C := TRUE;
    IF X22 THEN
        b_state := 3;
    END_IF;
3:
    Y1D := TRUE;
    IF X21 THEN
        b_state := 4;
    END_IF;
4:
    Y1E := TRUE;
    IF X24 THEN
        b_state := 5;
    END_IF;
5:
    IF (D9 + D11) >= D10 THEN
        Y1F := FALSE;
        b_state := 6;
    ELSE
        Y1F := b_pump_enable;
    END_IF;
6:
    Y1F := FALSE;
    IF X26 THEN
        Y1E := FALSE;
        b_state := 7;
    END_IF;
7:
    IF X25 THEN
        Y1D := FALSE;
        b_state := 8;
    END_IF;
8:
    IF X20 THEN
        Y1C := FALSE;
        b_state := 9;
    END_IF;
9:
    IF X23 THEN
        b_state := 10;
    END_IF;
10:
    IF NOT X28 AND NOT X27 THEN
        Y20 := TRUE;
        b_state := 11;
    END_IF;
11:
    IF X27 OR NOT X1E THEN
        Y20 := FALSE;
        b_state := 12;
    END_IF;
12:
    IF NOT X1E AND NOT X27 THEN
        b_state := 0;
    END_IF;
END_CASE;

(* Common Capping Logic *)
IF X1A AND NOT X1B THEN
    a_needs_cap := TRUE;
ELSE
    a_needs_cap := FALSE;
END_IF;

IF X28 AND NOT X29 THEN
    b_needs_cap := TRUE;
ELSE
    b_needs_cap := FALSE;
END_IF;

CASE capper_state OF
0:
    Y12 := FALSE;
    Y13 := FALSE;
    IF a_needs_cap AND NOT X2C THEN
        Y12 := TRUE;
        capper_state := 1;
    ELSIF b_needs_cap AND NOT X2C THEN
        Y13 := TRUE;
        capper_state := 2;
    END_IF;
1:
    IF X2C THEN
        Y12 := FALSE;
        capper_state := 3;
    END_IF;
2:
    IF X2C THEN
        Y13 := FALSE;
        capper_state := 3;
    END_IF;
3:
    IF NOT X2C THEN
        capper_state := 0;
    END_IF;
END_CASE;

(* Exit Accumulation Transfer Logic *)
IF X1B AND X1C THEN
    Y1A := TRUE;
ELSE
    Y1A := FALSE;
END_IF;

IF X29 AND X2A THEN
    Y21 := TRUE;
ELSE
    Y21 := FALSE;
END_IF;

(* Completion Declaration *)
IF X32 AND NOT Y18 AND NOT Y1F AND NOT Y10 AND NOT Y17 AND NOT Y1E AND X12 AND X20 AND NOT X2C AND NOT X30 THEN
    Y22 := TRUE;
END_IF;

END_PROGRAM