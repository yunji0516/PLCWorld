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

    (* internal state *)
    phase : INT := 0;
    idx : INT := 1;
    width_needed : INT;
    tool_needed : INT;
    completed_count : INT := 0;
    clamp_on : BOOL := FALSE;
    keeper_on : BOOL := FALSE;
    ack_on : BOOL := FALSE;
    complete_latch : BOOL := FALSE;
    complete_timer : TON;
    cond_complete : BOOL := FALSE;
END_VAR

(* reset one-shot pulse outputs every scan; level outputs are driven from
   persistent flags at the end of the program *)
Y10 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y1F := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y1A := FALSE;
Y11 := FALSE;
Y19 := FALSE;

CASE phase OF

0:
    IF X0 THEN
        idx := 1;
        phase := 10;
    END_IF;

10: (* determine width/tool need for current product, hold jig widths *)
    IF idx MOD 2 = 1 THEN
        width_needed := 160;
    ELSE
        width_needed := 120;
    END_IF;
    IF width_needed = 160 THEN
        tool_needed := 1;
    ELSE
        tool_needed := 2;
    END_IF;
    D201 := width_needed;
    D202 := width_needed;
    D200 := tool_needed;
    Y23 := TRUE;
    Y24 := TRUE;
    IF D8 = tool_needed THEN
        phase := 20;
    ELSIF (NOT X12) AND (NOT X11) THEN
        phase := 11;
    END_IF;

11: (* start tool exchange: detach current tool if any, else go attach *)
    IF D8 <> 0 THEN
        D200 := D8;
        Y1F := TRUE;
        phase := 12;
    ELSE
        D200 := tool_needed;
        Y1F := TRUE;
        phase := 16;
    END_IF;

12: (* wait at current tool rack slot, then unlock/detach *)
    IF (NOT X29) AND X2A THEN
        Y20 := TRUE;
        phase := 13;
    END_IF;

13: (* wait detach complete, dock to new slot *)
    IF (NOT X29) AND (NOT X2B) THEN
        D200 := tool_needed;
        Y1F := TRUE;
        phase := 16;
    END_IF;

16: (* wait arrival at target tool slot, then lock/attach *)
    IF (NOT X29) AND X2A THEN
        Y21 := TRUE;
        phase := 17;
    END_IF;

17: (* wait attach confirmed, return head to origin with tool *)
    IF (NOT X29) AND X2B THEN
        Y22 := TRUE;
        phase := 18;
    END_IF;

18: (* wait return-to-origin complete *)
    IF NOT X29 THEN
        phase := 20;
    END_IF;

20: (* admit leading product to A jig *)
    IF X10 AND X28 AND X13 THEN
        Y10 := TRUE;
        phase := 21;
    END_IF;

21: (* wait product seated at A and head returned *)
    IF X14 AND X13 THEN
        phase := 22;
    END_IF;

22: (* A-side face operation *)
    IF NOT X15 THEN
        Y11 := X2C AND X14;
    ELSE
        Y11 := FALSE;
        phase := 30;
    END_IF;

30: (* transfer completed A product to cradle *)
    IF X13 AND X19 AND (NOT X1A) THEN
        Y12 := TRUE;
        phase := 31;
    END_IF;

31:
    IF X17 THEN
        phase := 40;
    END_IF;

40: (* lock cradle pad / secure vacuum *)
    Y13 := TRUE;
    phase := 41;

41:
    IF X18 THEN
        phase := 50;
    END_IF;

50: (* release corner head after pad secured *)
    Y14 := TRUE;
    phase := 51;

51:
    IF X13 THEN
        phase := 60;
    END_IF;

60: (* invert cradle/product/pad *)
    Y15 := TRUE;
    phase := 61;

61:
    IF X1A AND (NOT X1B) THEN
        phase := 70;
    END_IF;

70: (* opposing corner fingers grip both Z ends *)
    Y16 := TRUE;
    phase := 71;

71:
    IF X12 THEN
        phase := 80;
    END_IF;

80: (* retract pad only after corner holding established *)
    Y17 := TRUE;
    phase := 81;

81:
    IF NOT X18 THEN
        phase := 90;
    END_IF;

90: (* after cradle clear, transfer to B jig *)
    IF X19 THEN
        Y18 := TRUE;
        phase := 91;
    END_IF;

91: (* wait product at B and head vacated *)
    IF X1C AND X13 THEN
        phase := 100;
    END_IF;

100: (* engage corner clamp only after transfer head cleared, width prepared *)
    IF X27 AND X2D THEN
        clamp_on := TRUE;
        phase := 101;
    END_IF;

101: (* retract keeper for unobstructed work face *)
    IF X23 THEN
        keeper_on := TRUE;
        phase := 102;
    END_IF;

102:
    IF X25 THEN
        phase := 110;
    END_IF;

110: (* B-side face operation, keep support & face access throughout *)
    IF NOT X1D THEN
        Y19 := X1C AND X22 AND X23 AND X26 AND (NOT X29);
    ELSE
        Y19 := FALSE;
        phase := 120;
    END_IF;

120: (* release: open corner clamp *)
    clamp_on := FALSE;
    phase := 121;

121: (* wait both support retractions before release *)
    IF X24 AND X25 THEN
        phase := 130;
    END_IF;

130: (* hand over to exit *)
    Y1A := TRUE;
    phase := 131;

131:
    IF X20 THEN
        ack_on := TRUE;
        phase := 132;
    END_IF;

132: (* acknowledge exit, count completion *)
    IF X1F THEN
        ack_on := FALSE;
        completed_count := completed_count + 1;
        phase := 140;
    END_IF;

140: (* next product or done *)
    IF idx < 4 THEN
        idx := idx + 1;
        phase := 10;
    ELSE
        phase := 200;
    END_IF;

200: (* completion supervision *)
    cond_complete := (completed_count = 4) AND X21 AND X13 AND (NOT X11)
                      AND (NOT X12) AND (NOT X29) AND (NOT X2A);
    complete_timer(IN := cond_complete, PT := T#500ms);
    IF complete_timer.Q THEN
        complete_latch := TRUE;
    END_IF;

ELSE
    ;
END_CASE;

Y1D := clamp_on;
Y1E := keeper_on;
Y1B := ack_on;
Y1C := complete_latch;

END_PROGRAM