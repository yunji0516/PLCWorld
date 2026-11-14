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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    step : INT := 0;
    pitch_idx : INT := 0;
    batch_idx : INT := 0;
    core_switch_phase : INT := 0;
    
    feed_t : TON;
    clamp_t : TON;
    cut_t : TON;
    edge_hold_t : TON;
    complete_t : TON;
END_VAR

Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y1A := FALSE; Y1B := FALSE;
Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE; D200 := 0;

feed_t(IN := (step = 30), PT := T#2000ms);
clamp_t(IN := (step = 40), PT := T#2000ms);
cut_t(IN := (step = 50), PT := T#600ms);
edge_hold_t(IN := (step = 110), PT := T#300ms);
complete_t(IN := (step = 200), PT := T#500ms);

CASE step OF
0: 
    IF X0 THEN step := 10; END_IF;

10: 
    IF pitch_idx >= 6 AND batch_idx >= 4 THEN
        step := 200;
    ELSIF pitch_idx < 6 AND X10 AND D3 < 600 AND NOT X18 THEN
        step := 20;
    ELSIF batch_idx < 4 AND X1B THEN
        step := 60;
    END_IF;

20: 
    Y10 := TRUE;
    step := 30;

30: 
    Y10 := FALSE;
    Y11 := TRUE;
    IF feed_t.Q THEN
        Y11 := FALSE;
        step := 40;
    END_IF;

40: 
    Y12 := TRUE;
    IF clamp_t.Q THEN
        step := 50;
    END_IF;

50: 
    Y13 := TRUE;
    D200 := 15;
    IF X14 OR X23 OR cut_t.Q THEN
        Y13 := FALSE;
        D200 := 0;
        step := 70;
    END_IF;

70: 
    Y14 := TRUE;
    step := 80;

80: 
    Y14 := FALSE;
    IF X16 THEN
        step := 90;
    END_IF;

90: 
    IF X16 THEN
        Y15 := TRUE;
        step := 91;
    END_IF;

91: 
    IF X17 THEN
        step := 92;
    END_IF;

92: 
    IF X19 AND X23 AND X16 AND NOT X18 THEN
        step := 93;
    END_IF;

93: 
    Y15 := FALSE;
    Y16 := TRUE;
    step := 94;

94: 
    Y16 := FALSE;
    IF X1A THEN
        step := 95;
    END_IF;

95: 
    Y1A := TRUE;
    step := 96;

96: 
    Y1A := FALSE;
    IF NOT X18 THEN
        pitch_idx := pitch_idx + 1;
        step := 10;
    END_IF;

60: 
    Y17 := TRUE;
    step := 61;

61: 
    Y17 := FALSE;
    Y18 := TRUE;
    IF X1D THEN
        Y18 := FALSE;
        step := 62;
    END_IF;

62: 
    Y19 := TRUE;
    step := 63;

63: 
    Y19 := FALSE;
    batch_idx := batch_idx + 1;
    IF batch_idx == 2 AND core_switch_phase == 0 THEN
        core_switch_phase := 1;
        step := 100;
    ELSIF batch_idx >= 4 THEN
        step := 10;
    ELSE
        step := 10;
    END_IF;

100: 
    Y18 := FALSE;
    step := 110;

110: 
    Y1C := TRUE;
    IF edge_hold_t.Q THEN
        step := 120;
    END_IF;

120: 
    IF X23 THEN
        step := 130;
    END_IF;

130: 
    Y1F := TRUE;
    step := 140;

140: 
    Y1F := FALSE;
    IF NOT X24 THEN
        step := 150;
    END_IF;

150: 
    IF X25 THEN
        Y20 := TRUE;
        step := 160;
    END_IF;

160: 
    Y20 := FALSE;
    IF X26 THEN
        step := 170;
    END_IF;

170: 
    Y21 := TRUE;
    IF X27 THEN
        Y21 := FALSE;
        step := 180;
    END_IF;

180: 
    Y22 := TRUE;
    IF X28 THEN
        Y22 := FALSE;
        step := 190;
    END_IF;

190: 
    Y1C := FALSE;
    IF X29 THEN
        core_switch_phase := 2;
        step := 61;
    END_IF;

200: 
    IF NOT X18 AND NOT X16 AND NOT Y16 AND NOT Y18 AND pitch_idx >= 6 AND batch_idx >= 4 AND core_switch_phase >= 2 AND X1F THEN
        IF complete_t.Q THEN
            Y1B := TRUE;
        ELSE
            Y1B := FALSE;
        END_IF;
    ELSE
        Y1B := FALSE;
    END_IF;
END_CASE;

IF D3 >= 600 THEN Y11 := FALSE; END_IF;
IF (step >= 90 AND step <= 96) AND NOT X16 THEN Y15 := FALSE; END_IF;

IF X21 AND step < 100 AND step > 63 AND step <> 110 AND step <> 120 AND step <> 130 AND step <> 140 AND step <> 150 AND step <> 160 AND step <> 170 AND step <> 180 AND step <> 190 THEN
    IF Y18 THEN Y18 := FALSE; END_IF;
    step := 100;
END_IF;

END_PROGRAM