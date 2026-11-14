PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y24 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y25 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y2 : BOOL;

    (* internal *)
    state        : INT := 0;
    check1_done  : BOOL := FALSE;
    check2_done  : BOOL := FALSE;
    pos_tol      : DINT := 20;   (* 0.2 mm * 100 *)
    vel_tol      : DINT := 100;  (* 1 mm/s * 100 *)
    max_rate     : DINT := 1000;
END_VAR

CASE state OF

0: (* wait for start, hold all axes at origin *)
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    D20 := 0; D21 := max_rate; Y24 := TRUE;
    D24 := 0; D25 := max_rate; Y25 := TRUE;
    IF X0 THEN
        state := 1;
    END_IF;

1: (* extraction check: extend A and B to their end positions, C and D stay at 0 *)
    Y20 := TRUE;  Y21 := FALSE; (* A extend *)
    Y22 := TRUE;  Y23 := FALSE; (* B extend *)
    D20 := 0;     D21 := max_rate; Y24 := TRUE;  (* C stays at 0 *)
    D24 := 0;     D25 := max_rate; Y25 := TRUE;  (* D stays at 0 *)
    IF X2 AND X4 THEN
        check1_done := TRUE;
        state := 2;
    END_IF;

2: (* jig approach part 1: retract B to home, extend D to 100mm, keep A extended, C stays 0 *)
    Y20 := TRUE;  Y21 := FALSE; (* keep A extended *)
    Y22 := FALSE; Y23 := TRUE;  (* retract B *)
    D20 := 0;     D21 := max_rate; Y24 := TRUE;  (* C stays at 0 while x/q not yet safe combo settled *)
    D24 := 10000; D25 := max_rate; Y25 := TRUE;  (* D -> 100 mm *)
    IF X3 AND X5 THEN
        state := 3;
    END_IF;

3: (* jig approach part 2: descend C to 50mm, x=40 q=100 already safe combo *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := TRUE;
    D20 := 5000;  D21 := max_rate; Y24 := TRUE;  (* C -> 50 mm *)
    D24 := 10000; D25 := max_rate; Y25 := TRUE;  (* D holds at 100 mm *)
    IF (ABS(D10 - 5000) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        check2_done := TRUE;
        state := 4;
    END_IF;

4: (* return: retract C back to 0 first, keep x=40,q=100 safe combo unchanged *)
    Y20 := TRUE;  Y21 := FALSE;
    Y22 := FALSE; Y23 := TRUE;
    D20 := 0;     D21 := max_rate; Y24 := TRUE;  (* C -> 0 *)
    D24 := 10000; D25 := max_rate; Y25 := TRUE;  (* D still at 100 mm *)
    IF (ABS(D10 - 0) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        state := 5;
    END_IF;

5: (* return: now z<=10, safe to move A and D back to origin freely, B already home *)
    Y20 := FALSE; Y21 := TRUE;  (* retract A *)
    Y22 := FALSE; Y23 := TRUE;  (* keep B retract hold *)
    D20 := 0;     D21 := max_rate; Y24 := TRUE;  (* C holds at 0 *)
    D24 := 0;     D25 := max_rate; Y25 := TRUE;  (* D -> 0 *)
    IF X1 AND X3 AND
       (ABS(D12 - 0) <= pos_tol) AND (ABS(D13) <= vel_tol) AND
       (ABS(D10 - 0) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
        state := 6;
    END_IF;

6: (* all axes at origin, both checks completed: claim completion and hold *)
    Y20 := FALSE; Y21 := FALSE;
    Y22 := FALSE; Y23 := FALSE;
    D20 := 0; D21 := max_rate; Y24 := TRUE;
    D24 := 0; D25 := max_rate; Y25 := TRUE;
    IF check1_done AND check2_done THEN
        Y2 := TRUE;
    END_IF;

ELSE
    state := 0;

END_CASE;

END_PROGRAM