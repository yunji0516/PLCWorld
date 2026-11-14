PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;
    state : INT;
    started : BOOL;
    depth : DINT;
    a_arrived : BOOL;
    b_arrived : BOOL;
    c_arrived : BOOL;
    d_arrived : BOOL;
    d_retracted : BOOL;
    b_retracted : BOOL;
    c_retracted : BOOL;
    a_retracted : BOOL;
    rate : DINT := 1000;
    start_edge : R_TRIG;
END_VAR

FUNCTION Arrived : BOOL
VAR_INPUT
    pos : DINT;
    vel : DINT;
    target : DINT;
    pos_tol : DINT;
    vel_tol : DINT;
END_VAR
    Arrived := (ABS(pos - target) <= pos_tol) AND (ABS(vel) <= vel_tol);
END_FUNCTION

IF NOT started AND X0 THEN
    started := TRUE;
    depth := D101;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := TRUE;
    state := 1;
END_IF;

IF started THEN
    CASE state OF
    0: ;
    1: (* Phase 1: Move A to 100 *)
        IF a_arrived THEN
            state := 2;
        ELSE
            D20 := 10000;
            D21 := rate;
            IF Arrived(D10, D11, 10000, 20, 100) THEN
                a_arrived := TRUE;
            END_IF;
        END_IF;
    2: (* Phase 2: Move B and C to 60 each *)
        IF b_arrived AND c_arrived THEN
            state := 3;
        ELSE
            D24 := 6000;
            D25 := rate;
            D28 := 6000;
            D29 := rate;
            IF NOT b_arrived AND Arrived(D12, D13, 6000, 20, 100) THEN
                b_arrived := TRUE;
            END_IF;
            IF NOT c_arrived AND Arrived(D14, D15, 6000, 20, 100) THEN
                c_arrived := TRUE;
            END_IF;
        END_IF;
    3: (* Phase 3: Move D to depth - maintain locked posture A=100, B=60, C=60 *)
        IF d_arrived THEN
            state := 4;
        ELSE
            D32 := depth;
            D33 := rate;
            IF Arrived(D16, D17, depth, 20, 100) THEN
                d_arrived := TRUE;
            END_IF;
        END_IF;
    4: (* Phase 4: Retract D to 0 - still maintain locked posture *)
        IF d_retracted THEN
            state := 5;
        ELSE
            D32 := 0;
            D33 := rate;
            IF Arrived(D16, D17, 0, 20, 100) THEN
                d_retracted := TRUE;
            END_IF;
        END_IF;
    5: (* Phase 5: Retract B and C to 0 *)
        IF b_retracted AND c_retracted THEN
            state := 6;
        ELSE
            D24 := 0;
            D25 := rate;
            D28 := 0;
            D29 := rate;
            IF NOT b_retracted AND Arrived(D12, D13, 0, 20, 100) THEN
                b_retracted := TRUE;
            END_IF;
            IF NOT c_retracted AND Arrived(D14, D15, 0, 20, 100) THEN
                c_retracted := TRUE;
            END_IF;
        END_IF;
    6: (* Phase 6: Retract A to 0, then signal completion *)
        IF a_retracted THEN
            Y2 := TRUE;
        ELSE
            D20 := 0;
            D21 := rate;
            IF Arrived(D10, D11, 0, 20, 100) THEN
                a_retracted := TRUE;
            END_IF;
        END_IF;
    END_CASE;
END_IF;

(* Keep rate outputs active while running *)
D21 := rate;
D25 := rate;
D29 := rate;
D33 := rate;

(* Edge detection for start signal *)
start_edge(CLK := X0);

END_PROGRAM