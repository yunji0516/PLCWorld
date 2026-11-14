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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
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
    D200 : INT;
    D201 : INT;
    D202 : INT;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* internal state / memory *)
    st           : INT := 0;
    started      : BOOL := FALSE;
    prod_count   : INT := 0;
    cur_width    : INT := 160;
    required_tool: INT := 2;
    used_tool1   : BOOL := FALSE;
    used_tool2   : BOOL := FALSE;
    complete_cond: BOOL := FALSE;

    pad_timer     : TON;
    adjB_timer    : TON;
    maintain_timer: TON;
END_VAR

(* ---- timers, called every scan ---- *)
pad_timer(IN := (st = 21), PT := T#250ms);
adjB_timer(IN := (st = 33), PT := T#6s);

complete_cond := (prod_count >= 4) AND used_tool1 AND used_tool2 AND
                  (NOT X11) AND (NOT X12) AND (NOT X29) AND (NOT X2A) AND (NOT X1B);

maintain_timer(IN := complete_cond, PT := T#500ms);

CASE st OF

0: (* wait for start / loop entry for next product *)
    Y10:=FALSE; Y11:=FALSE; Y12:=FALSE; Y13:=FALSE; Y14:=FALSE;
    Y15:=FALSE; Y16:=FALSE; Y17:=FALSE; Y18:=FALSE; Y19:=FALSE;
    Y20:=FALSE; Y21:=FALSE; Y22:=FALSE; Y23:=FALSE; Y24:=FALSE;
    Y1A:=FALSE; Y1B:=FALSE; Y1D:=FALSE; Y1E:=FALSE; Y1F:=FALSE;
    IF NOT started THEN
        IF X0 THEN started := TRUE; END_IF;
    END_IF;
    IF started AND X10 THEN
        IF (prod_count MOD 2) = 0 THEN
            cur_width := 160; required_tool := 2; used_tool2 := TRUE;
        ELSE
            cur_width := 120; required_tool := 1; used_tool1 := TRUE;
        END_IF;
        st := 1;
    END_IF;

1: (* check head tool *)
    IF D8 = required_tool THEN
        st := 12;
    ELSIF (NOT X11) AND (NOT X12) AND (NOT X29) THEN
        IF D8 <> 0 THEN
            D200 := D8; st := 2;
        ELSE
            D200 := required_tool; st := 6;
        END_IF;
    END_IF;

2: Y1F := TRUE; st := 3;
3: Y1F := FALSE; IF X2A THEN st := 4; END_IF;
4: IF (NOT X12) AND X2A THEN Y20 := TRUE; st := 5; END_IF;
5: Y20 := FALSE; IF (NOT X2B) AND (D8 = 0) THEN D200 := required_tool; st := 6; END_IF;

6: Y1F := TRUE; st := 7;
7: Y1F := FALSE; IF X2A THEN st := 8; END_IF;
8: IF X2A THEN Y21 := TRUE; st := 9; END_IF;
9: Y21 := FALSE; IF X2B AND (D8 = required_tool) THEN st := 10; END_IF;

10: IF D8 <> 0 THEN Y22 := TRUE; st := 11; END_IF;
11: Y22 := FALSE; IF X13 THEN st := 12; END_IF;

12: (* adjust A jig width *)
    D201 := cur_width; Y23 := TRUE; st := 13;
13: IF X28 THEN Y23 := FALSE; st := 14; END_IF;

14: IF X28 AND X10 THEN Y10 := TRUE; st := 15; END_IF;
15: Y10 := FALSE; IF X14 THEN st := 16; END_IF;

16: Y11 := TRUE; st := 17;
17: IF X15 THEN Y11 := FALSE; st := 18; END_IF;

18: Y12 := TRUE; st := 19;
19: Y12 := FALSE; IF X17 THEN st := 20; END_IF;

20: Y13 := TRUE; st := 21;
21: Y13 := FALSE; IF pad_timer.Q THEN st := 22; END_IF;
22: IF X18 THEN st := 23; END_IF;

23: Y14 := TRUE; st := 24;
24: IF X13 THEN Y14 := FALSE; st := 25; END_IF;

25: Y15 := TRUE; st := 26;
26: Y15 := FALSE; IF X1A THEN st := 27; END_IF;

27: Y16 := TRUE; st := 28;
28: Y16 := FALSE; IF X12 THEN st := 29; END_IF;

29: Y17 := TRUE; st := 30;
30: Y17 := FALSE; IF NOT X18 THEN st := 31; END_IF;

31: IF X19 THEN st := 32; END_IF;

32: D202 := cur_width; Y24 := TRUE; st := 33;
33: IF adjB_timer.Q THEN Y24 := FALSE; st := 34; END_IF;

34: Y18 := TRUE; st := 35;
35: Y18 := FALSE; IF X1C THEN st := 36; END_IF;

36: IF X27 THEN st := 37; END_IF;

37: Y1D := TRUE; st := 38;
38: IF X23 THEN st := 39; END_IF;

39: IF X1A AND (NOT X17) THEN
        Y15 := TRUE; st := 40;
    ELSE
        st := 41;
    END_IF;
40: Y15 := FALSE; IF NOT X1A THEN st := 41; END_IF;

41: IF X22 AND X26 AND X23 AND X1C AND (D8 <> 0) AND (NOT X29) THEN
        Y19 := TRUE; st := 42;
    END_IF;
42: IF X1D THEN Y19 := FALSE; st := 43; END_IF;

43: Y1D := FALSE; st := 44;
44: IF X24 THEN st := 45; END_IF;

45: Y1E := TRUE; st := 46;
46: IF X25 THEN Y1E := FALSE; st := 47; END_IF;

47: Y1A := TRUE; st := 48;
48: IF X20 THEN st := 49; END_IF;

49: Y1B := TRUE; st := 50;
50: Y1B := FALSE; Y1A := FALSE; prod_count := prod_count + 1; st := 51;

51: IF prod_count >= 4 THEN
        st := 52;
    ELSE
        st := 0;
    END_IF;

52: Y10:=FALSE; Y11:=FALSE; Y12:=FALSE; Y13:=FALSE; Y14:=FALSE;
    Y15:=FALSE; Y16:=FALSE; Y17:=FALSE; Y18:=FALSE; Y19:=FALSE;
    Y20:=FALSE; Y21:=FALSE; Y22:=FALSE; Y23:=FALSE; Y24:=FALSE;
    Y1A:=FALSE; Y1B:=FALSE; Y1D:=FALSE; Y1E:=FALSE; Y1F:=FALSE;
    IF maintain_timer.Q THEN
        Y1C := TRUE;
        st := 53;
    END_IF;

53: Y1C := TRUE;

END_CASE;

END_PROGRAM