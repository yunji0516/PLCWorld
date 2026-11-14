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

    (* Internal state *)
    Step        : INT := 0;
    ProdCount   : INT := 0;   (* completed products 0..4 *)
    CurWidth    : INT := 0;
    ToolNeeded  : INT := 0;
    Widths      : ARRAY[1..4] OF INT := [160,120,160,120];
    startTrig   : R_TRIG;
    compTimer   : TON;
    mask_ok     : BOOL := FALSE;
    ClampCmd    : BOOL := FALSE;    (* persistent: b_clamp level *)
    KeeperOpenCmd : BOOL := FALSE;  (* persistent: b_keeper_open level *)
    AckCmd      : BOOL := FALSE;    (* persistent: ack_exit level *)
END_VAR

(* ---- default (pulse-style) outputs OFF each scan ---- *)
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
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y1A := FALSE;
Y1F := FALSE;

startTrig(CLK := X0);

CASE Step OF

0: (* IDLE *)
    IF startTrig.Q THEN
        ProdCount := 0;
        Step := 10;
    END_IF;

10: (* set A width for current product *)
    CurWidth := Widths[ProdCount + 1];
    D201 := CurWidth;
    Y23 := TRUE;
    Step := 12;

12: (* wait ready to admit *)
    IF X10 AND X28 AND X13 AND NOT X11 THEN
        Step := 13;
    END_IF;

13: (* admit pulse *)
    Y10 := TRUE;
    Step := 14;

14: (* confirm admit *)
    IF X14 AND X13 THEN
        Step := 15;
    END_IF;

15: (* work_a request *)
    IF X2C THEN
        Y11 := TRUE;
    END_IF;
    IF X15 THEN
        Step := 16;
    END_IF;

16: (* to_cradle pulse *)
    Y12 := TRUE;
    Step := 17;

17: (* confirm cradle present, head still holding corner *)
    IF X17 THEN
        Step := 18;
    END_IF;

18: (* cradle_lock pulse *)
    Y13 := TRUE;
    Step := 19;

19: (* confirm pad secured *)
    IF X18 THEN
        Step := 20;
    END_IF;

20: (* head_release pulse *)
    Y14 := TRUE;
    Step := 21;

21: (* confirm head clear *)
    IF X13 THEN
        Step := 22;
    END_IF;

22: (* rotate pulse *)
    Y15 := TRUE;
    Step := 23;

23: (* confirm cradle flipped *)
    IF X1A THEN
        Step := 24;
    END_IF;

24: (* tool check for corner-gripping tool *)
    IF CurWidth = 160 THEN
        ToolNeeded := 1;
    ELSE
        ToolNeeded := 2;
    END_IF;
    IF D8 = ToolNeeded THEN
        Step := 35;
    ELSIF D8 = 0 THEN
        D200 := ToolNeeded;
        Step := 29;
    ELSE
        D200 := D8;
        Step := 25;
    END_IF;

25: (* dock to current tool slot *)
    Y1F := TRUE;
    Step := 26;

26: (* confirm at rack *)
    IF X2A THEN
        Step := 27;
    END_IF;

27: (* unlock (detach) current tool - only at rack, not holding a product *)
    IF X2A AND NOT X12 THEN
        Y20 := TRUE;
        Step := 28;
    END_IF;

28: (* confirm detached *)
    IF D8 = 0 THEN
        D200 := ToolNeeded;
        Step := 29;
    END_IF;

29: (* dock to new tool slot *)
    Y1F := TRUE;
    Step := 30;

30: (* confirm at new rack slot *)
    IF X2A THEN
        Step := 31;
    END_IF;

31: (* lock new tool *)
    Y21 := TRUE;
    Step := 32;

32: (* confirm latched *)
    IF (D8 = ToolNeeded) AND X2B THEN
        Step := 33;
    END_IF;

33: (* tool_return - requires attached tool *)
    IF D8 <> 0 THEN
        Y22 := TRUE;
        Step := 34;
    END_IF;

34: (* confirm head back at safe/origin *)
    IF X13 THEN
        Step := 35;
    END_IF;

35: (* head_grip pulse *)
    Y16 := TRUE;
    Step := 36;

36: (* confirm corner held *)
    IF X12 THEN
        Step := 37;
    END_IF;

37: (* cradle_unlock pulse - pad retract, only after corner holding established *)
    Y17 := TRUE;
    Step := 38;

38: (* confirm cradle clear *)
    IF X19 THEN
        Step := 39;
    END_IF;

39: (* set B width for current product *)
    D202 := CurWidth;
    Y24 := TRUE;
    Step := 41;

41: (* to_b pulse *)
    Y18 := TRUE;
    Step := 42;

42: (* confirm product at B, head cleared *)
    IF X1C AND X13 THEN
        Step := 43;
    END_IF;

43: (* engage corner clamp only after transfer head cleared product *)
    IF X27 THEN
        ClampCmd := TRUE;
    END_IF;
    IF ClampCmd AND X23 THEN
        Step := 45;
    END_IF;

45: (* retract old spring keeper support *)
    KeeperOpenCmd := TRUE;
    IF X25 THEN
        Step := 47;
    END_IF;

47: (* work_b request *)
    mask_ok := AND_WORD(WORD(D6), WORD(2)) <> WORD(0);
    IF X2D AND X22 AND X26 AND ClampCmd AND KeeperOpenCmd AND (NOT X29) AND mask_ok THEN
        Y19 := TRUE;
    END_IF;
    IF X1D THEN
        Step := 48;
    END_IF;

48: (* release pulse *)
    Y1A := TRUE;
    Step := 49;

49: (* confirm exit reception, then open clamp/keeper *)
    IF X20 THEN
        ClampCmd := FALSE;
        KeeperOpenCmd := FALSE;
        Step := 50;
    END_IF;

50: (* ack exit - hold until exit clear *)
    AckCmd := TRUE;
    IF X1F THEN
        AckCmd := FALSE;
        Step := 52;
    END_IF;

52: (* advance to next product or finish *)
    ProdCount := ProdCount + 1;
    IF ProdCount >= 4 THEN
        Step := 60;
    ELSE
        Step := 10;
    END_IF;

60: (* final tool park check *)
    IF D8 = 0 THEN
        Step := 66;
    ELSE
        D200 := D8;
        Step := 61;
    END_IF;

61: (* dock to current tool slot *)
    Y1F := TRUE;
    Step := 62;

62: (* confirm at rack *)
    IF X2A THEN
        Step := 63;
    END_IF;

63: (* detach last tool, only at rack, not holding product *)
    IF X2A AND NOT X12 THEN
        Y20 := TRUE;
        Step := 64;
    END_IF;

64: (* confirm detached *)
    IF D8 = 0 THEN
        D200 := 0;
        Step := 65;
    END_IF;

65: (* dock empty head away from rack (home) *)
    Y1F := TRUE;
    Step := 66;

66: (* confirm head clear/home *)
    IF X13 THEN
        Step := 99;
    END_IF;

99: (* completion: maintain, no further product/tool motion *)
    Y1C := TRUE;
    compTimer(IN := TRUE, PT := T#500ms);

END_CASE;

(* persistent level outputs *)
Y1D := ClampCmd;
Y1E := KeeperOpenCmd;
Y1B := AckCmd;

END_PROGRAM