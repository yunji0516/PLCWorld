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
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D100 : INT;
    D101 : INT;
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

    (* Internal state *)
    step        : INT := 0;
    started     : BOOL := FALSE;
    part_num    : INT := 1;
    cur_source  : INT;
    cur_cell    : INT;
    is_cell_a   : BOOL;
    dest_pose   : INT;
    accept      : BOOL;

    depth_low   : INT := 5800;
    depth_high  : INT := 6200;
END_VAR

CASE step OF

0: (* wait for start *)
    IF X0 THEN
        started := TRUE;
        step := 1;
    END_IF;

1: (* setup per-part parameters *)
    IF part_num <= 2 THEN
        cur_source := 1;
        cur_cell   := 3;
        is_cell_a  := TRUE;
    ELSE
        cur_source := 2;
        cur_cell   := 4;
        is_cell_a  := FALSE;
    END_IF;
    step := 2;

2: (* issue move to source *)
    IF NOT X10 THEN
        D100 := cur_source;
        D101 := D101 + 1;
        step := 3;
    END_IF;

3: (* wait arrive source *)
    IF (NOT X10) AND (D0 = cur_source) THEN
        step := 4;
    END_IF;

4: (* grip close at source *)
    Y10 := TRUE; Y11 := FALSE;
    step := 5;

5: (* wait grip closed *)
    IF X12 AND X13 THEN
        Y10 := FALSE;
        step := 6;
    END_IF;

6: (* issue move to cell, door must be open *)
    IF ((is_cell_a AND X21) OR ((NOT is_cell_a) AND X2C)) AND (NOT X10) THEN
        D100 := cur_cell;
        D101 := D101 + 1;
        step := 7;
    END_IF;

7: (* wait arrive cell *)
    IF (NOT X10) AND (D0 = cur_cell) THEN
        step := 8;
    END_IF;

8: (* release part into cell *)
    Y11 := TRUE; Y10 := FALSE;
    step := 9;

9: (* wait released *)
    IF X11 AND (NOT X13) THEN
        Y11 := FALSE;
        step := 10;
    END_IF;

10: (* retreat to home before door close *)
    IF NOT X10 THEN
        D100 := 0;
        D101 := D101 + 1;
        step := 11;
    END_IF;

11: (* wait arrive home *)
    IF (NOT X10) AND (D0 = 0) THEN
        step := 12;
    END_IF;

12: (* issue clamp close *)
    IF is_cell_a THEN
        Y17 := TRUE; Y18 := FALSE;
    ELSE
        Y1C := TRUE; Y1D := FALSE;
    END_IF;
    step := 13;

13: (* wait clamp closed *)
    IF is_cell_a THEN
        IF X24 THEN Y17 := FALSE; step := 14; END_IF;
    ELSE
        IF X2F THEN Y1C := FALSE; step := 14; END_IF;
    END_IF;

14: (* issue door close *)
    IF is_cell_a THEN
        Y16 := TRUE; Y15 := FALSE;
    ELSE
        Y1B := TRUE; Y1A := FALSE;
    END_IF;
    step := 15;

15: (* wait door closed *)
    IF is_cell_a THEN
        IF X22 THEN Y16 := FALSE; step := 16; END_IF;
    ELSE
        IF X2D THEN Y1B := FALSE; step := 16; END_IF;
    END_IF;

16: (* issue cycle start, only if part present, idle, door and clamp closed *)
    IF is_cell_a THEN
        IF X27 AND (NOT X20) AND X22 AND X24 THEN
            Y19 := TRUE;
            step := 17;
        END_IF;
    ELSE
        IF X32 AND (NOT X2B) AND X2D AND X2F THEN
            Y1E := TRUE;
            step := 17;
        END_IF;
    END_IF;

17: (* clear cycle pulse *)
    IF is_cell_a THEN
        Y19 := FALSE;
    ELSE
        Y1E := FALSE;
    END_IF;
    step := 18;

18: (* wait machining done *)
    IF is_cell_a THEN
        IF X1F THEN step := 19; END_IF;
    ELSE
        IF X2A THEN step := 19; END_IF;
    END_IF;

19: (* issue clamp open before pick *)
    IF is_cell_a THEN
        Y18 := TRUE; Y17 := FALSE;
    ELSE
        Y1D := TRUE; Y1C := FALSE;
    END_IF;
    step := 20;

20: (* wait clamp open *)
    IF is_cell_a THEN
        IF X23 THEN Y18 := FALSE; step := 21; END_IF;
    ELSE
        IF X2E THEN Y1D := FALSE; step := 21; END_IF;
    END_IF;

21: (* issue door open *)
    IF is_cell_a THEN
        Y15 := TRUE; Y16 := FALSE;
    ELSE
        Y1A := TRUE; Y1B := FALSE;
    END_IF;
    step := 22;

22: (* wait door open *)
    IF is_cell_a THEN
        IF X21 THEN Y15 := FALSE; step := 23; END_IF;
    ELSE
        IF X2C THEN Y1A := FALSE; step := 23; END_IF;
    END_IF;

23: (* issue move into cell to pick finished part *)
    IF ((is_cell_a AND X21) OR ((NOT is_cell_a) AND X2C)) AND (NOT X10) THEN
        D100 := cur_cell;
        D101 := D101 + 1;
        step := 24;
    END_IF;

24: (* wait arrive cell *)
    IF (NOT X10) AND (D0 = cur_cell) THEN
        step := 25;
    END_IF;

25: (* grip close - pick finished part *)
    Y10 := TRUE; Y11 := FALSE;
    step := 26;

26: (* wait grip closed *)
    IF X12 AND X13 THEN
        Y10 := FALSE;
        step := 27;
    END_IF;

27: (* issue move to inspection, receiver must be vacant and idle *)
    IF (NOT X14) AND (NOT X15) AND (NOT X10) THEN
        D100 := 5;
        D101 := D101 + 1;
        step := 28;
    END_IF;

28: (* wait arrive inspection *)
    IF (NOT X10) AND (D0 = 5) THEN
        step := 29;
    END_IF;

29: (* place part at inspection *)
    Y11 := TRUE; Y10 := FALSE;
    step := 30;

30: (* wait released *)
    IF X11 AND (NOT X13) THEN
        Y11 := FALSE;
        step := 31;
    END_IF;

31: (* retreat to home before starting inspection *)
    IF NOT X10 THEN
        D100 := 0;
        D101 := D101 + 1;
        step := 32;
    END_IF;

32: (* wait arrive home *)
    IF (NOT X10) AND (D0 = 0) THEN
        step := 33;
    END_IF;

33: (* issue measure, part present, station idle, robot clear *)
    IF X14 AND (NOT X15) THEN
        Y12 := TRUE;
        step := 34;
    END_IF;

34: (* clear measure pulse *)
    Y12 := FALSE;
    step := 35;

35: (* wait measurement result *)
    IF X16 THEN
        step := 36;
    END_IF;

36: (* evaluate result and pick destination *)
    IF (D4 >= depth_low) AND (D4 <= depth_high) AND (D5 >= depth_low) AND (D5 <= depth_high) THEN
        accept := TRUE;
        dest_pose := 7;
    ELSE
        accept := FALSE;
        IF NOT X34 THEN
            dest_pose := 8;
        ELSIF NOT X35 THEN
            dest_pose := 9;
        ELSIF NOT X36 THEN
            dest_pose := 10;
        ELSE
            dest_pose := 11;
        END_IF;
    END_IF;
    step := 37;

37: (* issue move to inspection to pick measured part *)
    IF NOT X10 THEN
        D100 := 5;
        D101 := D101 + 1;
        step := 38;
    END_IF;

38: (* wait arrive inspection *)
    IF (NOT X10) AND (D0 = 5) THEN
        step := 39;
    END_IF;

39: (* grip close - pick measured part *)
    Y10 := TRUE; Y11 := FALSE;
    step := 40;

40: (* wait grip closed *)
    IF X12 AND X13 THEN
        Y10 := FALSE;
        step := 41;
    END_IF;

41: (* issue move to destination, receiver vacancy check for outfeed *)
    IF ((dest_pose <> 7) OR X19) AND (NOT X10) THEN
        D100 := dest_pose;
        D101 := D101 + 1;
        step := 42;
    END_IF;

42: (* wait arrive destination *)
    IF (NOT X10) AND (D0 = dest_pose) THEN
        step := 43;
    END_IF;

43: (* release part at destination *)
    IF (dest_pose <> 7) OR X19 THEN
        Y11 := TRUE; Y10 := FALSE;
        step := 44;
    END_IF;

44: (* wait released *)
    IF X11 AND (NOT X13) THEN
        Y11 := FALSE;
        step := 45;
    END_IF;

45: (* issue outfeed pulse only for accepted parts *)
    IF dest_pose = 7 THEN
        Y13 := TRUE;
    END_IF;
    step := 46;

46: (* clear outfeed pulse *)
    Y13 := FALSE;
    step := 47;

47: (* retreat to home *)
    IF NOT X10 THEN
        D100 := 0;
        D101 := D101 + 1;
        step := 48;
    END_IF;

48: (* wait arrive home *)
    IF (NOT X10) AND (D0 = 0) THEN
        step := 49;
    END_IF;

49: (* advance to next part or finish *)
    part_num := part_num + 1;
    IF part_num > 4 THEN
        step := 50;
    ELSE
        step := 1;
    END_IF;

50: (* all parts delivered, robot home and idle: declare completion *)
    Y14 := TRUE;

ELSE
    step := step;

END_CASE;

END_PROGRAM