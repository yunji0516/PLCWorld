PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    (* internal *)
    edge1 : R_TRIG;
    started : BOOL := FALSE;
    phase : INT := 0;
    target : INT := 0;

    buf_low_margin : INT := 100;   (* keep buffer well above 80 *)
    buf_high_margin : INT := 850;  (* keep buffer well below 900 *)
    tol : INT := 3;
END_VAR

edge1(CLK := X10);

IF edge1.Q AND NOT started THEN
    target := D10;
    started := TRUE;
    phase := 10;
END_IF;

CASE phase OF

0: (* idle - no actuator operation before Start accepted *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;

10: (* extraction: forward carriage with closed grip, receiver open; regulate buffer via unwind *)
    (* unwind regulation - never let buffer approach the 900 upper limit *)
    IF D20 < buf_high_margin THEN
        Y26 := TRUE;
    ELSE
        Y26 := FALSE;
    END_IF;

    (* forward regulation - never extract when buffer is close to the 80 lower limit *)
    IF (D20 > buf_low_margin) AND (D21 < target) THEN
        Y20 := TRUE;
    ELSE
        Y20 := FALSE;
    END_IF;

    Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;

    IF D21 >= target THEN
        Y20 := FALSE;
        Y26 := FALSE;
        phase := 20;
    END_IF;

20: (* wait for carriage to come to rest before touching the receiver *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    IF X21 THEN
        phase := 30;
    END_IF;

30: (* close receiver at rest, within tolerance of the requested length *)
    Y24 := TRUE; Y25 := FALSE;
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y26 := FALSE;
    IF X24 THEN
        Y24 := FALSE; (* holds closed by position maintenance *)
        phase := 40;
    END_IF;

40: (* open feed grip now that receiver holds the web *)
    Y23 := TRUE; Y22 := FALSE;
    Y20 := FALSE; Y21 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    IF X23 THEN
        Y23 := FALSE; (* holds open by position maintenance *)
        phase := 50;
    END_IF;

50: (* reverse carriage home with grip fully open *)
    Y21 := TRUE;
    Y20 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    IF X20 AND X21 THEN
        Y21 := FALSE;
        phase := 60;
    END_IF;

60: (* verify completion conditions with all actuator outputs off *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    IF (D21 >= target - tol) AND (D21 <= target + tol)
        AND X24 AND X23 AND X20 AND X21 THEN
        Y2 := TRUE;
        phase := 70;
    END_IF;

70: (* maintain claim and terminal state for remainder of run *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
    Y2 := TRUE;

ELSE
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
END_CASE;

END_PROGRAM