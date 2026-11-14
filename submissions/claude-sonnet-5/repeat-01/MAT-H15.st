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
    D14 : INT;
    D15 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* internal *)
    step : INT := 0;
    accepted_a : BOOL := FALSE;
    accepted_b : BOOL := FALSE;
    target_side : INT := 0;
    kind_needed : INT := 0;
    prev_count : INT := 0;
    ship_side : INT := 0;
    ready_flag : BOOL := FALSE;
    clear_flag : BOOL := FALSE;
    home_flag : BOOL := FALSE;
    low_flag : BOOL := FALSE;
    complete_flag : BOOL := FALSE;
END_VAR

(* default reset of all one-shot outputs every scan; D-registers and complete flag retain value *)
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
Y1A := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

CASE step OF

0: (* wait for start *)
    IF X0 THEN
        step := 1;
    END_IF;

1: (* accept order A *)
    IF X1B THEN
        Y10 := TRUE;
        accepted_a := TRUE;
        step := 2;
    END_IF;

2: (* accept order B *)
    IF X1C THEN
        Y11 := TRUE;
        accepted_b := TRUE;
        step := 10;
    END_IF;

(* ---- supply pallet to station A ---- *)
10:
    IF X27 THEN
        D201 := 1;
        Y1C := TRUE;
        step := 11;
    END_IF;

11:
    IF X2A THEN
        Y1D := TRUE;
        step := 12;
    END_IF;

12:
    IF X2B THEN
        D201 := 1;
        Y1E := TRUE;
        step := 13;
    END_IF;

13:
    IF X2C THEN
        Y1F := TRUE;
        step := 14;
    END_IF;

14:
    IF X18 AND X28 THEN
        step := 20;
    END_IF;

(* ---- supply pallet to station B ---- *)
20:
    IF X27 THEN
        D201 := 2;
        Y1C := TRUE;
        step := 21;
    END_IF;

21:
    IF X2A THEN
        Y1D := TRUE;
        step := 22;
    END_IF;

22:
    IF X2B THEN
        D201 := 2;
        Y1E := TRUE;
        step := 23;
    END_IF;

23:
    IF X2C THEN
        Y1F := TRUE;
        step := 24;
    END_IF;

24:
    IF X18 AND X29 THEN
        step := 30;
    END_IF;

(* ---- stacking loop ---- *)
30:
    IF D11 < 3 THEN
        target_side := 1;
        kind_needed := D7;
        prev_count := D11;
        step := 31;
    ELSIF D12 < 4 THEN
        target_side := 2;
        kind_needed := D8;
        prev_count := D12;
        step := 31;
    ELSE
        step := 90;
    END_IF;

31: (* pick required kind *)
    IF kind_needed = 1 THEN
        ready_flag := X10;
    ELSE
        ready_flag := X11;
    END_IF;
    IF ready_flag AND NOT X12 THEN
        D200 := kind_needed;
        Y12 := TRUE;
        step := 32;
    END_IF;

32: (* wait head holding lead *)
    IF X13 AND NOT X12 THEN
        step := 33;
    END_IF;

33: (* place onto target station *)
    D201 := target_side;
    IF target_side = 1 THEN
        D202 := D9;
        clear_flag := X25;
    ELSE
        D202 := D10;
        clear_flag := X26;
    END_IF;
    IF clear_flag AND NOT X12 THEN
        Y13 := TRUE;
        step := 34;
    END_IF;

34: (* wait for placement confirmed by count increment *)
    IF target_side = 1 THEN
        IF D11 > prev_count THEN
            step := 30;
        END_IF;
    ELSE
        IF D12 > prev_count THEN
            step := 30;
        END_IF;
    END_IF;

(* ---- ship completed bundles ---- *)
90:
    ship_side := 1;
    step := 100;

100: (* dock fork at 850mm home support and insert *)
    IF NOT X12 THEN
        IF ship_side = 1 THEN
            home_flag := X21;
        ELSE
            home_flag := X22;
        END_IF;
        IF home_flag THEN
            D201 := ship_side;
            Y16 := TRUE;
            step := 101;
        END_IF;
    END_IF;

101: (* fork inserted -> lift *)
    IF X15 THEN
        Y17 := TRUE;
        step := 102;
    END_IF;

102: (* fork supporting -> lower station support to 780mm *)
    IF X16 THEN
        IF ship_side = 1 THEN
            D203 := 780;
            Y14 := TRUE;
        ELSE
            D204 := 780;
            Y15 := TRUE;
        END_IF;
        step := 103;
    END_IF;

103: (* support lowered -> transfer bundle to exit *)
    IF ship_side = 1 THEN
        low_flag := X23;
    ELSE
        low_flag := X24;
    END_IF;
    IF low_flag THEN
        Y18 := TRUE;
        step := 104;
    END_IF;

104: (* at exit -> release *)
    IF X17 THEN
        Y19 := TRUE;
        step := 105;
    END_IF;

105: (* fork returned home -> restore station support to 850mm *)
    IF X18 THEN
        IF ship_side = 1 THEN
            D203 := 850;
            Y14 := TRUE;
        ELSE
            D204 := 850;
            Y15 := TRUE;
        END_IF;
        step := 106;
    END_IF;

106: (* wait support back at home before next station or reception *)
    IF ship_side = 1 THEN
        home_flag := X21;
    ELSE
        home_flag := X22;
    END_IF;
    IF home_flag THEN
        IF ship_side = 1 THEN
            ship_side := 2;
            step := 100;
        ELSE
            step := 150;
        END_IF;
    END_IF;

(* ---- shared reception and acknowledgement ---- *)
150:
    IF X19 THEN
        Y1A := TRUE;
        step := 151;
    END_IF;

151:
    complete_flag := TRUE;
    step := 160;

160:
    ; (* maintain completion state; nothing further to command *)

ELSE
    ; (* undefined step, hold *)

END_CASE;

Y1B := complete_flag;

END_PROGRAM