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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;

    state : INT := 0;
    roll_count : INT := 0;
    ton_complete : TON;
END_VAR

CASE state OF
0:
    IF X0 THEN
        state := 10;
    END_IF;

10:
    IF X10 THEN
        Y10 := TRUE;
        state := 11;
    END_IF;

11:
    IF X12 THEN
        Y10 := FALSE;
        state := 20;
    END_IF;

20:
    IF X11 THEN
        Y11 := TRUE;
        state := 21;
    END_IF;

21:
    IF X13 THEN
        Y11 := FALSE;
        state := 22;
    END_IF;

22:
    Y14 := TRUE;
    IF D2 >= D0 THEN
        Y14 := FALSE;
        state := 23;
    END_IF;

23:
    Y13 := TRUE;
    IF X15 THEN
        state := 24;
    END_IF;

24:
    Y15 := TRUE;
    IF X17 THEN
        state := 25;
    END_IF;

25:
    Y15 := FALSE;
    Y16 := TRUE;
    IF X16 THEN
        Y16 := FALSE;
        state := 30;
    END_IF;

30:
    Y24 := TRUE;
    IF X2E THEN
        state := 31;
    END_IF;

31:
    Y23 := TRUE;
    IF X2C AND X2D AND X20 THEN
        state := 32;
    END_IF;

32:
    Y17 := TRUE;
    IF X19 THEN
        Y17 := FALSE;
        state := 33;
    END_IF;

33:
    Y1F := TRUE;
    Y1E := FALSE;
    IF X1E THEN
        state := 35;
    END_IF;

35:
    Y25 := TRUE;
    IF X2F THEN
        Y25 := FALSE;
        Y26 := TRUE;
        state := 36;
    END_IF;

36:
    IF X30 THEN
        state := 37;
    END_IF;

37:
    Y27 := TRUE;
    IF X31 THEN
        Y27 := FALSE;
        state := 40;
    END_IF;

40:
    Y18 := TRUE;
    Y19 := TRUE;
    IF X1B AND X1C THEN
        state := 41;
    END_IF;

41:
    Y12 := FALSE;
    Y13 := FALSE;
    IF X24 THEN
        state := 42;
    END_IF;

42:
    Y1A := TRUE;
    IF D5 >= D4 THEN
        Y1A := FALSE;
        state := 43;
    END_IF;

43:
    Y12 := TRUE;
    Y13 := TRUE;
    IF X14 AND X15 THEN
        state := 44;
    END_IF;

44:
    Y1C := TRUE;
    Y1D := TRUE;
    IF X27 THEN
        state := 45;
    END_IF;

45:
    Y1C := FALSE;
    Y1D := FALSE;
    IF X28 THEN
        state := 46;
    END_IF;

46:
    Y1A := TRUE;
    IF X26 THEN
        Y1A := FALSE;
        state := 47;
    END_IF;

47:
    Y28 := TRUE;
    IF X33 THEN
        Y28 := FALSE;
        Y26 := FALSE;
        state := 50;
    END_IF;

50:
    Y1B := TRUE;
    Y18 := FALSE;
    Y19 := FALSE;
    IF X1F THEN
        state := 51;
    END_IF;

51:
    Y1E := TRUE;
    Y1F := FALSE;
    IF X1D THEN
        state := 52;
    END_IF;

52:
    IF X34 THEN
        Y20 := TRUE;
        state := 525;
    END_IF;

525:
    IF X22 THEN
        state := 53;
    END_IF;

53:
    Y20 := FALSE;
    Y21 := TRUE;
    Y1B := FALSE;
    IF NOT X22 THEN
        Y21 := FALSE;
        state := 54;
    END_IF;

54:
    IF X35 THEN
        Y29 := TRUE;
        state := 55;
    END_IF;

55:
    IF NOT X34 THEN
        state := 56;
    END_IF;

56:
    IF X34 THEN
        Y29 := FALSE;
        roll_count := roll_count + 1;
        IF roll_count = 3 THEN
            state := 60;
        ELSE
            state := 30;
        END_IF;
    END_IF;

60:
    Y22 := TRUE;

END_CASE;

ton_complete(IN := (state = 60), PT := T#100ms);

END_PROGRAM