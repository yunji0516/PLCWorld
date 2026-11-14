PROGRAM Main
VAR
    D10 : DINT; D11 : DINT; D12 : DINT; D13 : DINT; D14 : DINT; D15 : DINT;
    D16 : DINT; D17 : DINT; D18 : DINT; D19 : DINT; D20 : DINT; D21 : DINT;
    D100 : DINT; X30 : BOOL; X32 : BOOL; D104 : DINT; D103 : DINT;
    D110 : DINT; X31 : BOOL; X33 : BOOL; D114 : DINT; D113 : DINT;
    X51 : BOOL; D90 : DINT; D91 : DINT; D92 : DINT; D93 : DINT; D94 : DINT;
    D95 : DINT; D96 : DINT; X52 : BOOL; X53 : BOOL; X54 : BOOL; X55 : BOOL;
    X56 : BOOL; X57 : BOOL; D150 : DINT; D151 : DINT;
    D200 : DINT; D201 : DINT; Y20 : BOOL; D204 : DINT; D205 : DINT; Y21 : BOOL;
    D208 : DINT; D209 : DINT; Y22 : BOOL; D212 : DINT; D213 : DINT; Y23 : BOOL;
    D216 : DINT; D217 : DINT; Y24 : BOOL; D220 : DINT; D221 : DINT; Y25 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT;
    D80 : DINT; D81 : DINT; D82 : DINT; Y2 : BOOL;

    st : INT := 0;
    req : INT := 3;
    seq : DINT := 0;
    done0 : BOOL := FALSE;
    done1 : BOOL := FALSE;
    all_flag : BOOL := FALSE;
    s_tmr : TON;
    h_tmr : TON;
    f_tmr : TON;
    rid : DINT;
    rdep : DINT;
    hx : DINT;
    hh : DINT;
    ta : DINT; tb : DINT; tc : DINT; td : DINT; te : DINT; tf : DINT;
    ea : BOOL; eb : BOOL; ec : BOOL; ed : BOOL; ee : BOOL; ef : BOOL;
    da : BOOL; db : BOOL; dc : BOOL; dd : BOOL; de : BOOL; df : BOOL;
    loc_val : INT;
    lift_ok : BOOL;
    lift_home_ok : BOOL;
END_VAR

da := (ABS(D10 - ta) <= 20) AND (ABS(D11) <= 100);
db := (ABS(D12 - tb) <= 20) AND (ABS(D13) <= 100);
dc := (ABS(D14 - tc) <= 20) AND (ABS(D15) <= 100);
dd := (ABS(D16 - td) <= 20) AND (ABS(D17) <= 100);
de := (ABS(D18 - te) <= 20) AND (ABS(D19) <= 100);
df := (ABS(D20 - tf) <= 20) AND (ABS(D21) <= 100);

IF req = 3 THEN
    IF NOT done0 AND D103 > 0 AND (NOT done1 OR D103 <= D113) THEN req := 0; END_IF;
    IF NOT done1 AND D113 > 0 AND req = 3 THEN req := 1; END_IF;
END_IF;

rid := IF req = 0 THEN D100 ELSE D110 END_IF;
rdep := D95;
hx := IF req = 0 THEN IF D104 = 1 THEN -90000 ELSE -35000 END_IF ELSE IF D114 = 1 THEN -90000 ELSE -35000 END_IF END_IF;
hh := IF req = 0 THEN IF D104 = 1 THEN D150 ELSE D151 END_IF ELSE IF D114 = 1 THEN D150 ELSE D151 END_IF END_IF;
loc_val := IF req = 0 THEN IF D104 = 1 THEN 1 ELSE 2 END_IF ELSE IF D114 = 1 THEN 1 ELSE 2 END_IF END_IF;

lift_ok := (req=0 AND D104=1 AND dc) OR (req=0 AND D104=2 AND dd) OR (req=1 AND D114=1 AND dc) OR (req=1 AND D114=2 AND dd);
lift_home_ok := lift_ok;

CASE st OF
0: 
    ta := 15000; tb := 0; 
    tc := IF req=0 AND D104=1 THEN D150 ELSIF req=0 AND D104=2 THEN D151 ELSIF req=1 AND D114=1 THEN D150 ELSIF req=1 AND D114=2 THEN D151 ELSE D150 END_IF;
    td := tc; te := 0; tf := 5000;
    ea := TRUE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    D80 := 0; D81 := 0;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF req <> 3 THEN st := 10; END_IF;
    IF done0 AND done1 AND NOT all_flag THEN st := 200; END_IF;

10: 
    ta := hx; ea := TRUE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF da THEN st := 20; END_IF;

20: 
    tc := IF req=0 AND D104=1 THEN 73250 ELSE D14 END_IF;
    td := IF req=0 AND D104=2 THEN 73250 ELSE D16 END_IF;
    IF req=1 AND D114=1 THEN tc := 73250; td := D16; END_IF;
    IF req=1 AND D114=2 THEN td := 73250; tc := D14; END_IF;
    ea := FALSE; eb := FALSE; ec := TRUE; ed := TRUE; ee := FALSE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF lift_ok THEN st := 30; END_IF;

30: 
    tb := 18000; ea := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE; eb := TRUE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF db THEN st := 40; END_IF;

40: 
    D80 := 1; D81 := loc_val; seq := seq + 1; D82 := seq;
    ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF D90 = rid THEN st := 50; END_IF;

50: 
    ta := 85000; ea := TRUE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF da THEN st := 60; END_IF;

60: 
    tb := 0; ea := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE; eb := TRUE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF db THEN st := 70; END_IF;

70: 
    tf := 5000; ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := TRUE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF df AND D20 <= 50000 THEN st := 80; END_IF;

80: 
    te := 9000; ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := TRUE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF de THEN st := 90; END_IF;

90: 
    te := 9000; ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := TRUE; ef := FALSE;
    s_tmr(IN := de AND (ABS(D19) <= 100), PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF s_tmr.Q THEN st := 100; END_IF;

100: 
    tf := rdep; ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := TRUE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF df THEN st := 110; END_IF;

110: 
    tf := rdep; ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := TRUE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := df AND (ABS(D21) <= 100), PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF h_tmr.Q THEN st := 120; END_IF;

120: 
    tf := 5000; ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := TRUE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF df THEN st := 130; END_IF;

130: 
    te := 0; ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := TRUE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF de THEN st := 140; END_IF;

140: 
    ta := hx; ea := TRUE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF da THEN st := 150; END_IF;

150: 
    tb := 18000; ea := FALSE; eb := TRUE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF db THEN st := 160; END_IF;

160: 
    D80 := 2; D81 := loc_val; seq := seq + 1; D82 := seq;
    ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF (req=0 AND X32) OR (req=1 AND X33) THEN st := 170; END_IF;

170: 
    tb := 0; ea := FALSE; eb := TRUE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF db THEN st := 180; END_IF;

180: 
    tc := IF req=0 AND D104=1 THEN hh ELSE D14 END_IF;
    td := IF req=0 AND D104=2 THEN hh ELSE D16 END_IF;
    IF req=1 AND D114=1 THEN tc := hh; td := D16; END_IF;
    IF req=1 AND D114=2 THEN td := hh; tc := D14; END_IF;
    ea := FALSE; eb := FALSE; ec := TRUE; ed := TRUE; ee := FALSE; ef := FALSE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF lift_home_ok THEN st := 190; END_IF;

190: 
    IF req = 0 THEN D300 := rid; D301 := 1; done0 := TRUE; END_IF;
    IF req = 1 THEN D302 := rid; D303 := 1; done1 := TRUE; END_IF;
    D80 := 0; D81 := 0; req := 3; st := 0;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);

200: 
    ta := 0; tb := 0; tc := D150; td := D151; te := 0; tf := 5000;
    ea := TRUE; eb := TRUE; ec := TRUE; ed := TRUE; ee := TRUE; ef := TRUE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
    IF da AND db AND dc AND dd AND de AND df THEN st := 210; END_IF;

210: 
    ta := 0; tb := 0; tc := D150; td := D151; te := 0; tf := 5000;
    ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    Y2 := TRUE;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := TRUE, PT := T#100ms);
    IF f_tmr.Q THEN all_flag := TRUE; Y2 := FALSE; st := 220; END_IF;

220: 
    Y2 := FALSE;
    ta := 0; tb := 0; tc := D150; td := D151; te := 0; tf := 5000;
    ea := FALSE; eb := FALSE; ec := FALSE; ed := FALSE; ee := FALSE; ef := FALSE;
    D80 := 0; D81 := 0;
    s_tmr(IN := FALSE, PT := T#30ms); h_tmr(IN := FALSE, PT := T#80ms); f_tmr(IN := FALSE, PT := T#100ms);
END_CASE;

IF D12 > 4000 THEN ea := FALSE; END_IF;

D200 := ta; D204 := tb; D208 := tc; D212 := td; D216 := te; D220 := tf;
D201 := 800; D205 := 800; D209 := 800; D213 := 800; D217 := 800; D221 := 800;
Y20 := ea; Y21 := eb; Y22 := ec; Y23 := ed; Y24 := ee; Y25 := ef;

END_PROGRAM