PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;

    (* internal variables *)
    r_trig1   : R_TRIG;
    started   : BOOL := FALSE;

    phase     : INT := 0;   (* 0=idle,1=loading,2=departing,3=done *)
    loadStep  : INT := 0;   (* 0=wait home->command,1=wait end+loaded,2=wait home return *)
    matIndex  : INT := 1;

    w1 : INT;
    w2 : INT;
    w3 : INT;
    w4 : INT;

    side1 : INT; (* 1=left, 2=right for material index 1..4 *)
    side2 : INT;
    side3 : INT;
    side4 : INT;

    diffA : INT;
    diffB : INT;
    diffC : INT;

    curSide : INT;

    claimed : BOOL := FALSE;
END_VAR

r_trig1(CLK := X10);

(* Accept the single rising-edge start request *)
IF r_trig1.Q AND NOT started THEN
    started := TRUE;

    w1 := D20;
    w2 := D21;
    w3 := D22;
    w4 := D23;

    diffA := ABS((w1 + w2) - (w3 + w4)); (* pair (1,2)|(3,4) *)
    diffB := ABS((w1 + w3) - (w2 + w4)); (* pair (1,3)|(2,4) *)
    diffC := ABS((w1 + w4) - (w2 + w3)); (* pair (1,4)|(2,3) *)

    IF (diffA <= diffB) AND (diffA <= diffC) THEN
        side1 := 1; side2 := 1; side3 := 2; side4 := 2;
    ELSIF (diffB <= diffA) AND (diffB <= diffC) THEN
        side1 := 1; side2 := 2; side3 := 1; side4 := 2;
    ELSE
        side1 := 1; side2 := 2; side3 := 2; side4 := 1;
    END_IF;

    matIndex := 1;
    loadStep := 0;
    phase := 1;
END_IF;

(* Main sequencing *)
CASE phase OF

1: (* loading four materials in source order, side chosen by precomputed balanced assignment *)
    CASE matIndex OF
        1: curSide := side1;
        2: curSide := side2;
        3: curSide := side3;
        4: curSide := side4;
    ELSE
        curSide := 1;
    END_CASE;

    CASE loadStep OF
        0: (* must be at home before issuing a new placement command *)
            IF X20 THEN
                IF curSide = 1 THEN
                    Y20 := TRUE;
                    Y21 := FALSE;
                ELSE
                    Y21 := TRUE;
                    Y20 := FALSE;
                END_IF;
                loadStep := 1;
            END_IF;

        1: (* wait for outward end + loaded confirmation *)
            IF X21 AND X22 THEN
                Y20 := FALSE;
                Y21 := FALSE;
                loadStep := 2;
            END_IF;

        2: (* wait for automatic OFF-return to home before next material *)
            IF X20 THEN
                matIndex := matIndex + 1;
                loadStep := 0;
            END_IF;
    ELSE
        loadStep := 0;
    END_CASE;

    IF matIndex > 4 THEN
        Y20 := FALSE;
        Y21 := FALSE;
        phase := 2;
    END_IF;

2: (* depart, guarded by balance and full-load check *)
    IF (D26 >= 4) AND (ABS(D24 - D25) <= 1) THEN
        IF NOT X23 THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;
            phase := 3;
        END_IF;
    ELSE
        (* should not occur given guaranteed balanced partition; hold outputs safe *)
        Y22 := FALSE;
    END_IF;

3: (* terminal state: claim completion and maintain *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;

    IF (NOT claimed) AND X23 AND X20 AND (D26 >= 4) AND (ABS(D24 - D25) <= 1) THEN
        claimed := TRUE;
    END_IF;

    IF claimed THEN
        Y2 := TRUE;
    END_IF;

ELSE
    (* idle: no actuator operation before Start accepted *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_CASE;

END_PROGRAM