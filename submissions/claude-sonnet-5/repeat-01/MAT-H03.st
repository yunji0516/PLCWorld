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
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    (* internal *)
    seq        : INT := 0;
    act_started: BOOL := FALSE;
    prod_count : INT := 0;
    target_count : INT := 6;

    exit_edge  : R_TRIG;
    complete_tmr : TON;
    complete_latched : BOOL := FALSE;
    complete_cond : BOOL := FALSE;
END_VAR

(* default outputs to false each scan, latched outputs handled separately *)
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;

(* exit reception edge detection *)
exit_edge(CLK := X16);
IF exit_edge.Q THEN
    prod_count := prod_count + 1;
    Y18 := TRUE;
END_IF;

CASE seq OF

0: (* idle, wait for start *)
    IF X0 THEN
        seq := 10;
    END_IF;

10: (* ensure left lift up, ready for admit at upper-left *)
    IF prod_count >= target_count THEN
        seq := 999;
    ELSIF X1F THEN
        seq := 20;
    ELSIF (NOT X1B) AND (NOT X11) THEN
        seq := 11;
    END_IF;

11: (* left up pulse *)
    Y14 := TRUE;
    seq := 12;

12: (* wait left lift moving up and settled *)
    IF X1B THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X1B) THEN
        act_started := FALSE;
        seq := 20;
    END_IF;

20: (* wait for source ready, then admit product *)
    IF X10 THEN
        seq := 21;
    END_IF;

21: (* admit pulse *)
    Y10 := TRUE;
    seq := 22;

22: (* wait load busy cycle to finish *)
    IF X12 THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X12) THEN
        act_started := FALSE;
        seq := 30;
    END_IF;

30: (* move loaded jig from position 0 to inspection position 1 *)
    IF NOT X11 THEN
        D200 := D0;
        D201 := 1;
        Y13 := TRUE;
        seq := 31;
    END_IF;

31: (* wait transfer complete *)
    IF X11 THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X11) THEN
        act_started := FALSE;
        seq := 40;
    END_IF;

40: (* issue local inspection request *)
    IF NOT X14 THEN
        D202 := D8;
        Y11 := TRUE;
        seq := 41;
    END_IF;

41: (* wait inspection completion *)
    IF X14 THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X14) THEN
        act_started := FALSE;
        seq := 50;
    END_IF;

50: (* move jig with product to extraction position 2 *)
    IF NOT X11 THEN
        D200 := D1;
        D201 := 2;
        Y13 := TRUE;
        seq := 51;
    END_IF;

51: (* wait transfer complete *)
    IF X11 THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X11) THEN
        act_started := FALSE;
        seq := 60;
    END_IF;

60: (* wait exit clear then extract product *)
    IF X15 AND (NOT X14) AND (NOT X13) THEN
        Y12 := TRUE;
        seq := 61;
    END_IF;

61: (* wait for pickup+return of extraction (unload_busy release) *)
    IF X13 THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X13) THEN
        act_started := FALSE;
        seq := 70;
    END_IF;

70: (* wait external reception confirmed then proceed *)
    IF X16 THEN
        seq := 80;
    END_IF;

80: (* move empty jig from position 2 to right lift position 3 *)
    IF NOT X11 THEN
        D200 := D2;
        D201 := 3;
        Y13 := TRUE;
        seq := 81;
    END_IF;

81: (* wait transfer complete *)
    IF X11 THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X11) THEN
        act_started := FALSE;
        seq := 90;
    END_IF;

90: (* wait until jig fully seated and stopper closed on right lift *)
    IF X1E AND (NOT X1C) AND (NOT X11) THEN
        seq := 100;
    END_IF;

100: (* lower the right lift, jig fully seated/stopper closed *)
    IF X1E AND (NOT X11) AND (NOT X1C) THEN
        Y17 := TRUE;
        seq := 101;
    END_IF;

101: (* wait right lift lowering complete *)
    IF X1C THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X1C) THEN
        act_started := FALSE;
        seq := 110;
    END_IF;

110: (* move empty jig from right lift 3 to lower center 4 *)
    IF NOT X11 THEN
        D200 := D3;
        D201 := 4;
        Y13 := TRUE;
        seq := 111;
    END_IF;

111: (* wait transfer complete *)
    IF X11 THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X11) THEN
        act_started := FALSE;
        seq := 120;
    END_IF;

120: (* ensure left lift lowered to receive returning empty jig *)
    IF X18 THEN
        seq := 130;
    ELSIF (NOT X1B) AND (NOT X11) THEN
        Y15 := TRUE;
        seq := 121;
    END_IF;

121: (* left down pulse issued, move to wait *)
    seq := 122;

122: (* wait left lift lowering complete *)
    IF X1B THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X1B) THEN
        act_started := FALSE;
        seq := 130;
    END_IF;

130: (* move empty jig from lower center 4 back to left lift position 0 *)
    IF NOT X11 THEN
        D200 := D4;
        D201 := 0;
        Y13 := TRUE;
        seq := 131;
    END_IF;

131: (* wait transfer complete, jig now reusable at position 0 *)
    IF X11 THEN
        act_started := TRUE;
    END_IF;
    IF act_started AND (NOT X11) THEN
        act_started := FALSE;
        IF prod_count >= target_count THEN
            seq := 999;
        ELSE
            seq := 10;
        END_IF;
    END_IF;

999: (* all products handled, hold idle *)
    ;

ELSE
    seq := 0;

END_CASE;

(* completion evaluation: both jigs stationary/recovered, all tools stopped,
   all products received, external all_done confirmation asserted *)
complete_cond := (prod_count >= target_count)
                  AND X20
                  AND (NOT X11) AND (NOT X12) AND (NOT X13) AND (NOT X14)
                  AND (NOT X1B) AND (NOT X1C);

complete_tmr(IN := complete_cond AND (NOT complete_latched), PT := T#500ms);
IF complete_tmr.Q THEN
    complete_latched := TRUE;
END_IF;

Y19 := complete_latched;

END_PROGRAM