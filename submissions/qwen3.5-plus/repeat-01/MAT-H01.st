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
    
    step : INT := 0;
    seq : INT := 0;
    parts_done : INT := 0;
    part_idx : INT := 1;
    out_target : INT := 0;
    is_good : BOOL := FALSE;
    reject_used : ARRAY[0..3] OF BOOL := [FALSE, FALSE, FALSE, FALSE];
    cur_src : INT := 0;
    cur_cell : INT := 0;
    i : INT := 0;
END_VAR

Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;

CASE step OF
0:
    IF X0 THEN step := 10; END_IF;

10:
    IF part_idx = 1 OR part_idx = 3 THEN cur_src := 1; cur_cell := 3;
    ELSE cur_src := 2; cur_cell := 4; END_IF;
    D100 := cur_src;
    seq := seq + 1; D101 := seq;
    step := 11;

11:
    IF D0 = cur_src THEN step := 12; END_IF;

12:
    Y10 := TRUE;
    step := 13;

13:
    IF X12 THEN step := 14; END_IF;

14:
    D100 := cur_cell;
    seq := seq + 1; D101 := seq;
    step := 15;

15:
    IF D0 = cur_cell THEN step := 16; END_IF;

16:
    IF part_idx MOD 2 = 1 THEN Y15 := TRUE; ELSE Y1A := TRUE; END_IF;
    step := 17;

17:
    IF (part_idx MOD 2 = 1 AND X21) OR (part_idx MOD 2 = 0 AND X2C) THEN step := 18; END_IF;

18:
    IF part_idx MOD 2 = 1 THEN Y18 := TRUE; ELSE Y1D := TRUE; END_IF;
    step := 19;

19:
    IF (part_idx MOD 2 = 1 AND X23) OR (part_idx MOD 2 = 0 AND X2E) THEN step := 20; END_IF;

20:
    Y11 := TRUE;
    step := 21;

21:
    IF X11 THEN step := 22; END_IF;

22:
    D100 := 0;
    seq := seq + 1; D101 := seq;
    step := 23;

23:
    IF D0 = 0 THEN step := 24; END_IF;

24:
    IF part_idx MOD 2 = 1 THEN Y16 := TRUE; ELSE Y1B := TRUE; END_IF;
    step := 25;

25:
    IF (part_idx MOD 2 = 1 AND X22) OR (part_idx MOD 2 = 0 AND X2D) THEN step := 26; END_IF;

26:
    IF part_idx MOD 2 = 1 THEN Y17 := TRUE; ELSE Y1C := TRUE; END_IF;
    step := 27;

27:
    IF (part_idx MOD 2 = 1 AND X24) OR (part_idx MOD 2 = 0 AND X2F) THEN step := 28; END_IF;

28:
    IF part_idx MOD 2 = 1 THEN Y19 := TRUE; ELSE Y1E := TRUE; END_IF;
    step := 29;

29:
    IF (part_idx MOD 2 = 1 AND X20) OR (part_idx MOD 2 = 0 AND X2B) THEN step := 30; END_IF;

30:
    IF (part_idx MOD 2 = 1 AND X1F) OR (part_idx MOD 2 = 0 AND X2A) THEN step := 31; END_IF;

31:
    D100 := cur_cell;
    seq := seq + 1; D101 := seq;
    step := 32;

32:
    IF D0 = cur_cell THEN step := 33; END_IF;

33:
    IF part_idx MOD 2 = 1 THEN Y15 := TRUE; ELSE Y1A := TRUE; END_IF;
    step := 34;

34:
    IF (part_idx MOD 2 = 1 AND X21) OR (part_idx MOD 2 = 0 AND X2C) THEN step := 35; END_IF;

35:
    IF part_idx MOD 2 = 1 THEN Y18 := TRUE; ELSE Y1D := TRUE; END_IF;
    step := 36;

36:
    IF (part_idx MOD 2 = 1 AND X23) OR (part_idx MOD 2 = 0 AND X2E) THEN step := 37; END_IF;

37:
    Y10 := TRUE;
    step := 38;

38:
    IF X12 THEN step := 39; END_IF;

39:
    D100 := 0;
    seq := seq + 1; D101 := seq;
    step := 40;

40:
    IF D0 = 0 THEN step := 41; END_IF;

41:
    IF part_idx MOD 2 = 1 THEN Y16 := TRUE; ELSE Y1B := TRUE; END_IF;
    step := 42;

42:
    IF (part_idx MOD 2 = 1 AND X22) OR (part_idx MOD 2 = 0 AND X2D) THEN step := 43; END_IF;

43:
    D100 := 5;
    seq := seq + 1; D101 := seq;
    step := 44;

44:
    IF D0 = 5 THEN step := 45; END_IF;

45:
    Y11 := TRUE;
    step := 46;

46:
    IF X11 THEN step := 47; END_IF;

47:
    D100 := 0;
    seq := seq + 1; D101 := seq;
    step := 48;

48:
    IF D0 = 0 THEN step := 49; END_IF;

49:
    Y12 := TRUE;
    step := 50;

50:
    IF X16 THEN step := 51; END_IF;

51:
    is_good := (D4 >= 5800) AND (D4 <= 6200) AND (D5 >= 5800) AND (D5 <= 6200);
    IF is_good THEN
        out_target := 7;
    ELSE
        out_target := 0;
        FOR i := 0 TO 3 DO
            IF NOT reject_used[i] THEN
                out_target := 8 + i;
                reject_used[i] := TRUE;
                EXIT;
            END_IF;
        END_FOR;
    END_IF;
    step := 52;

52:
    Y10 := TRUE;
    step := 53;

53:
    IF X12 THEN step := 54; END_IF;

54:
    D100 := out_target;
    seq := seq + 1; D101 := seq;
    step := 55;

55:
    IF D0 = out_target THEN step := 56; END_IF;

56:
    Y11 := TRUE;
    step := 57;

57:
    IF X11 THEN 
        IF out_target = 7 THEN Y13 := TRUE; END_IF;
        step := 58; 
    END_IF;

58:
    D100 := 0;
    seq := seq + 1; D101 := seq;
    step := 59;

59:
    IF D0 = 0 THEN step := 60; END_IF;

60:
    part_idx := part_idx + 1;
    parts_done := parts_done + 1;
    IF parts_done < 4 THEN
        step := 10;
    ELSE
        step := 90;
    END_IF;

90:
    Y14 := TRUE;
END_CASE;
END_PROGRAM