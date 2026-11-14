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

    (* internal *)
    step        : INT := 0;
    part_num    : INT := 0;
    cur_cell    : INT := 0;   (* 1 = A, 2 = B *)
    cur_src_pose: INT := 0;
    cur_cell_pose: INT := 0;
    target_pose : INT := 0;
    seq_counter : INT := 0;
    accept      : BOOL := FALSE;
    completion_declared : BOOL := FALSE;
    start_trig  : R_TRIG;
END_VAR

start_trig(CLK := X0);

CASE step OF

0: (* wait for start *)
    IF start_trig.Q THEN
        part_num := 1;
        step := 1;
    END_IF;

1: (* setup parameters for current part *)
    IF part_num <= 2 THEN
        cur_cell := 1; cur_src_pose := 1; cur_cell_pose := 3;
    ELSE
        cur_cell := 2; cur_src_pose := 2; cur_cell_pose := 4;
    END_IF;
    step := 2;

2: (* move to source *)
    IF NOT X10 THEN
        seq_counter := seq_counter + 1;
        D100 := cur_src_pose;
        D101 := seq_counter;
        step := 3;
    END_IF;

3: (* wait arrival at source *)
    IF (NOT X10) AND (D0 = cur_src_pose) THEN
        step := 4;
    END_IF;

4: (* grip close *)
    IF NOT X10 THEN
        Y10 := TRUE; Y11 := FALSE;
        step := 5;
    END_IF;

5: (* wait gripped *)
    IF X12 AND X13 THEN
        Y10 := FALSE;
        step := 6;
    END_IF;

6: (* open cell door *)
    IF cur_cell = 1 THEN
        IF NOT X21 THEN Y15 := TRUE; Y16 := FALSE; END_IF;
    ELSE
        IF NOT X2C THEN Y1A := TRUE; Y1B := FALSE; END_IF;
    END_IF;
    step := 7;

7: (* wait door open *)
    IF (cur_cell = 1 AND X21) OR (cur_cell = 2 AND X2C) THEN
        IF cur_cell = 1 THEN Y15 := FALSE; ELSE Y1A := FALSE; END_IF;
        step := 8;
    END_IF;

8: (* open clamp *)
    IF cur_cell = 1 THEN
        IF NOT X23 THEN Y18 := TRUE; Y17 := FALSE; END_IF;
    ELSE
        IF NOT X2E THEN Y1D := TRUE; Y1C := FALSE; END_IF;
    END_IF;
    step := 9;

9: (* wait clamp open *)
    IF (cur_cell = 1 AND X23) OR (cur_cell = 2 AND X2E) THEN
        IF cur_cell = 1 THEN Y18 := FALSE; ELSE Y1D := FALSE; END_IF;
        step := 10;
    END_IF;

10: (* wait cell empty and clear/safe for entry *)
    IF (cur_cell = 1 AND X1E AND X25 AND X26) OR
       (cur_cell = 2 AND X29 AND X30 AND X31) THEN
        step := 11;
    END_IF;

11: (* move robot into cell with part *)
    IF NOT X10 THEN
        seq_counter := seq_counter + 1;
        D100 := cur_cell_pose;
        D101 := seq_counter;
        step := 12;
    END_IF;

12: (* wait arrival at cell *)
    IF (NOT X10) AND (D0 = cur_cell_pose) THEN
        step := 13;
    END_IF;

13: (* release part into cell *)
    Y11 := TRUE; Y10 := FALSE;
    step := 14;

14: (* wait released *)
    IF X11 AND (NOT X13) THEN
        Y11 := FALSE;
        step := 15;
    END_IF;

15: (* retrieve robot home before closing door *)
    IF NOT X10 THEN
        seq_counter := seq_counter + 1;
        D100 := 0;
        D101 := seq_counter;
        step := 16;
    END_IF;

16: (* wait home *)
    IF (NOT X10) AND (D0 = 0) THEN
        step := 17;
    END_IF;

17: (* close door *)
    IF cur_cell = 1 THEN
        IF NOT X22 THEN Y16 := TRUE; Y15 := FALSE; END_IF;
    ELSE
        IF NOT X2D THEN Y1B := TRUE; Y1A := FALSE; END_IF;
    END_IF;
    step := 18;

18: (* wait door closed *)
    IF (cur_cell = 1 AND X22) OR (cur_cell = 2 AND X2D) THEN
        IF cur_cell = 1 THEN Y16 := FALSE; ELSE Y1B := FALSE; END_IF;
        step := 19;
    END_IF;

19: (* close clamp *)
    IF cur_cell = 1 THEN
        IF NOT X24 THEN Y17 := TRUE; Y18 := FALSE; END_IF;
    ELSE
        IF NOT X2F THEN Y1C := TRUE; Y1D := FALSE; END_IF;
    END_IF;
    step := 20;

20: (* wait clamp closed *)
    IF (cur_cell = 1 AND X24) OR (cur_cell = 2 AND X2F) THEN
        IF cur_cell = 1 THEN Y17 := FALSE; ELSE Y1C := FALSE; END_IF;
        step := 21;
    END_IF;

21: (* start machining cycle *)
    IF (cur_cell = 1 AND X1D AND X27 AND (NOT X20)) OR
       (cur_cell = 2 AND X28 AND X32 AND (NOT X2B)) THEN
        IF cur_cell = 1 THEN Y19 := TRUE; ELSE Y1E := TRUE; END_IF;
        step := 22;
    END_IF;

22: (* clear cycle pulse *)
    IF cur_cell = 1 THEN Y19 := FALSE; ELSE Y1E := FALSE; END_IF;
    step := 23;

23: (* wait cycle done *)
    IF (cur_cell = 1 AND X1F) OR (cur_cell = 2 AND X2A) THEN
        step := 24;
    END_IF;

24: (* open clamp before pick *)
    IF cur_cell = 1 THEN
        IF NOT X23 THEN Y18 := TRUE; Y17 := FALSE; END_IF;
    ELSE
        IF NOT X2E THEN Y1D := TRUE; Y1C := FALSE; END_IF;
    END_IF;
    step := 25;

25: (* wait clamp open *)
    IF (cur_cell = 1 AND X23) OR (cur_cell = 2 AND X2E) THEN
        IF cur_cell = 1 THEN Y18 := FALSE; ELSE Y1D := FALSE; END_IF;
        step := 26;
    END_IF;

26: (* open door *)
    IF cur_cell = 1 THEN
        IF NOT X21 THEN Y15 := TRUE; Y16 := FALSE; END_IF;
    ELSE
        IF NOT X2C THEN Y1A := TRUE; Y1B := FALSE; END_IF;
    END_IF;
    step := 27;

27: (* wait door open *)
    IF (cur_cell = 1 AND X21) OR (cur_cell = 2 AND X2C) THEN
        IF cur_cell = 1 THEN Y15 := FALSE; ELSE Y1A := FALSE; END_IF;
        step := 28;
    END_IF;

28: (* move to cell to retrieve machined part *)
    IF NOT X10 THEN
        seq_counter := seq_counter + 1;
        D100 := cur_cell_pose;
        D101 := seq_counter;
        step := 29;
    END_IF;

29: (* wait arrival *)
    IF (NOT X10) AND (D0 = cur_cell_pose) THEN
        step := 30;
    END_IF;

30: (* grip close to pick machined part *)
    Y10 := TRUE; Y11 := FALSE;
    step := 31;

31: (* wait gripped *)
    IF X12 AND X13 THEN
        Y10 := FALSE;
        step := 32;
    END_IF;

32: (* move to inspection *)
    IF NOT X10 THEN
        seq_counter := seq_counter + 1;
        D100 := 5;
        D101 := seq_counter;
        step := 33;
    END_IF;

33: (* wait arrival at inspection *)
    IF (NOT X10) AND (D0 = 5) THEN
        step := 34;
    END_IF;

34: (* wait inspection vacant *)
    IF NOT X14 THEN
        step := 35;
    END_IF;

35: (* release part at inspection *)
    Y11 := TRUE; Y10 := FALSE;
    step := 36;

36: (* wait released *)
    IF X11 AND (NOT X13) THEN
        Y11 := FALSE;
        step := 37;
    END_IF;

37: (* retrieve robot clear of inspection *)
    IF NOT X10 THEN
        seq_counter := seq_counter + 1;
        D100 := 0;
        D101 := seq_counter;
        step := 38;
    END_IF;

38: (* wait home *)
    IF (NOT X10) AND (D0 = 0) THEN
        step := 39;
    END_IF;

39: (* start inspection when idle, present, and clear *)
    IF (NOT X15) AND X14 AND X1C THEN
        Y12 := TRUE;
        step := 40;
    END_IF;

40: (* clear measure pulse *)
    Y12 := FALSE;
    step := 41;

41: (* wait measurement result and decide *)
    IF X16 AND (NOT X15) THEN
        IF (D4 >= 5800) AND (D4 <= 6200) AND (D5 >= 5800) AND (D5 <= 6200) THEN
            accept := TRUE;
            target_pose := 7;
        ELSE
            accept := FALSE;
            IF NOT X34 THEN
                target_pose := 8;
            ELSIF NOT X35 THEN
                target_pose := 9;
            ELSIF NOT X36 THEN
                target_pose := 10;
            ELSE
                target_pose := 11;
            END_IF;
        END_IF;
        step := 42;
    END_IF;

42: (* move to inspection to pick part back *)
    IF NOT X10 THEN
        seq_counter := seq_counter + 1;
        D100 := 5;
        D101 := seq_counter;
        step := 43;
    END_IF;

43: (* wait arrival *)
    IF (NOT X10) AND (D0 = 5) THEN
        step := 44;
    END_IF;

44: (* grip close, only if not measuring *)
    IF NOT X15 THEN
        Y10 := TRUE; Y11 := FALSE;
        step := 45;
    END_IF;

45: (* wait gripped *)
    IF X12 AND X13 THEN
        Y10 := FALSE;
        step := 46;
    END_IF;

46: (* wait receiver vacancy at target *)
    IF (target_pose = 7 AND X19) OR
       (target_pose = 8 AND (NOT X34)) OR
       (target_pose = 9 AND (NOT X35)) OR
       (target_pose = 10 AND (NOT X36)) OR
       (target_pose = 11 AND (NOT X37)) THEN
        step := 47;
    END_IF;

47: (* move to target pose *)
    IF NOT X10 THEN
        seq_counter := seq_counter + 1;
        D100 := target_pose;
        D101 := seq_counter;
        step := 48;
    END_IF;

48: (* wait arrival *)
    IF (NOT X10) AND (D0 = target_pose) THEN
        step := 49;
    END_IF;

49: (* release part at target *)
    Y11 := TRUE; Y10 := FALSE;
    step := 50;

50: (* wait released *)
    IF X11 AND (NOT X13) THEN
        Y11 := FALSE;
        step := 51;
    END_IF;

51: (* retrieve robot home *)
    IF NOT X10 THEN
        seq_counter := seq_counter + 1;
        D100 := 0;
        D101 := seq_counter;
        step := 52;
    END_IF;

52: (* wait home *)
    IF (NOT X10) AND (D0 = 0) THEN
        step := 53;
    END_IF;

53: (* trigger outfeed if normal, else skip *)
    IF target_pose = 7 THEN
        IF X1A THEN
            Y13 := TRUE;
            step := 54;
        END_IF;
    ELSE
        step := 56;
    END_IF;

54: (* clear outfeed pulse *)
    Y13 := FALSE;
    step := 55;

55: (* wait outfeed cleared *)
    IF X19 THEN
        step := 56;
    END_IF;

56: (* advance to next part or finish *)
    part_num := part_num + 1;
    IF part_num <= 4 THEN
        step := 1;
    ELSE
        step := 900;
    END_IF;

900: (* completion check and hold *)
    IF NOT completion_declared THEN
        IF X1B AND (D0 = 0) AND (NOT X13) AND (NOT X10) AND
           (NOT X20) AND (NOT X2B) AND (NOT X15) AND
           X21 AND X2C AND X23 AND X2E THEN
            Y14 := TRUE;
            completion_declared := TRUE;
        END_IF;
    ELSE
        Y14 := TRUE;
    END_IF;

ELSE
    step := 0;

END_CASE;

END_PROGRAM