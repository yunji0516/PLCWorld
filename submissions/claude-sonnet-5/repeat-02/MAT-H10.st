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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;

    (* --- internal --- *)
    started      : BOOL;
    start_trig   : R_TRIG;

    main_step    : INT := 0;
    req_a        : INT := 0;
    req_b        : INT := 0;
    total_sent   : INT := 0;

    send_req     : BOOL;
    send_trig    : R_TRIG;

    swap_req     : BOOL;
    swap_trig    : R_TRIG;
    swap_started_seen : BOOL;

    take_empty_req  : BOOL;
    take_empty_trig : R_TRIG;
    mag1_recovered  : BOOL;

    a_step       : INT := 0;
    a_req        : BOOL;
    a_trig       : R_TRIG;
    a_release_req  : BOOL;
    a_release_trig : R_TRIG;
    a_assembled_count : INT := 0;

    b_step       : INT := 0;
    b_req        : BOOL;
    b_trig       : R_TRIG;
    b_release_req  : BOOL;
    b_release_trig : R_TRIG;
    b_assembled_count : INT := 0;

    deadline_timer  : TON;
    complete_timer  : TON;
    complete_latched : BOOL;
    completion_condition : BOOL;
    deadline_ms : DINT;
END_VAR

(* ---------------- edge detectors (use previous-scan requests) ---------------- *)
start_trig(CLK := X0);
IF start_trig.Q THEN
    started := TRUE;
END_IF;

send_trig(CLK := send_req);
swap_trig(CLK := swap_req);
take_empty_trig(CLK := take_empty_req);
a_trig(CLK := a_req);
a_release_trig(CLK := a_release_req);
b_trig(CLK := b_req);
b_release_trig(CLK := b_release_req);

Y13 := send_trig.Q;
Y14 := swap_trig.Q;
Y15 := take_empty_trig.Q;
Y16 := a_trig.Q;
Y18 := a_release_trig.Q;
Y17 := b_trig.Q;
Y19 := b_release_trig.Q;

deadline_timer(IN := TRUE, PT := T#300s);
deadline_ms := TIME_TO_INT(deadline_timer.ET);

(* ---------------- main extraction / swap state machine ---------------- *)
IF started THEN
    CASE main_step OF

    0:
        Y10 := TRUE;
        Y11 := TRUE;
        main_step := 10;

    10:
        Y10 := TRUE;
        Y11 := TRUE;
        IF X14 AND X12 THEN
            main_step := 20;
        END_IF;

    20:
        IF total_sent >= 7 THEN
            main_step := 90;
        ELSIF D1 <= 0 THEN
            main_step := 40;
        ELSE
            IF X16 AND X11 AND X12 THEN
                Y10 := FALSE;
                main_step := 30;
            END_IF;
        END_IF;

    30:
        IF X15 AND X17 THEN
            Y12 := TRUE;
            main_step := 35;
        END_IF;

    35:
        IF X18 THEN
            Y12 := FALSE;
            Y10 := TRUE;
            Y11 := FALSE;
            IF X1E AND (req_a < 3) THEN
                D200 := 1;
                req_a := req_a + 1;
                D201 := req_a;
            ELSIF X24 AND (req_b < 4) THEN
                D200 := 2;
                req_b := req_b + 1;
                D201 := req_b;
            ELSIF req_a < 3 THEN
                D200 := 1;
                req_a := req_a + 1;
                D201 := req_a;
            ELSE
                D200 := 2;
                req_b := req_b + 1;
                D201 := req_b;
            END_IF;
            send_req := TRUE;
            total_sent := total_sent + 1;
            main_step := 36;
        END_IF;

    36:
        IF send_trig.Q THEN
            send_req := FALSE;
            main_step := 37;
        END_IF;

    37:
        IF X14 AND X13 AND X16 THEN
            IF total_sent >= 7 THEN
                main_step := 90;
            ELSE
                Y11 := TRUE;
                main_step := 38;
            END_IF;
        END_IF;

    38:
        IF X12 THEN
            main_step := 20;
        END_IF;

    40:
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;
        IF X14 AND X13 AND X18 THEN
            main_step := 41;
        END_IF;

    41:
        Y10 := TRUE;
        Y11 := FALSE;
        IF X1A AND X1B THEN
            swap_req := TRUE;
            main_step := 42;
        END_IF;

    42:
        Y10 := TRUE;
        Y11 := FALSE;
        IF swap_trig.Q THEN
            swap_req := FALSE;
            swap_started_seen := FALSE;
            main_step := 43;
        END_IF;

    43:
        Y10 := TRUE;
        Y11 := FALSE;
        IF X19 THEN
            swap_started_seen := TRUE;
        END_IF;
        IF swap_started_seen AND (NOT X19) THEN
            main_step := 44;
        END_IF;

    44:
        Y10 := TRUE;
        Y11 := FALSE;
        IF X1B THEN
            take_empty_req := TRUE;
            main_step := 45;
        END_IF;

    45:
        Y10 := TRUE;
        Y11 := FALSE;
        IF take_empty_trig.Q THEN
            take_empty_req := FALSE;
            main_step := 46;
        END_IF;

    46:
        Y10 := TRUE;
        Y11 := FALSE;
        IF X1C THEN
            mag1_recovered := TRUE;
            main_step := 47;
        END_IF;

    47:
        Y10 := TRUE;
        IF X10 AND (D0 = 202) THEN
            Y11 := TRUE;
            main_step := 48;
        ELSE
            Y11 := FALSE;
        END_IF;

    48:
        IF X12 THEN
            main_step := 20;
        ELSE
            Y11 := TRUE;
        END_IF;

    90:
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;
        main_step := 91;

    91:
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;

    ELSE
        main_step := 0;
    END_CASE;
END_IF;

(* ---------------- assembly A ---------------- *)
CASE a_step OF
0:
    IF X1F AND X20 AND (NOT X21) THEN
        a_req := TRUE;
        a_step := 1;
    END_IF;
1:
    IF a_trig.Q THEN
        a_req := FALSE;
        a_step := 2;
    END_IF;
2:
    IF X22 THEN
        a_step := 3;
    END_IF;
3:
    IF X23 THEN
        a_release_req := TRUE;
        a_step := 4;
    END_IF;
4:
    IF a_release_trig.Q THEN
        a_release_req := FALSE;
        a_assembled_count := a_assembled_count + 1;
        a_step := 0;
    END_IF;
ELSE
    a_step := 0;
END_CASE;

(* ---------------- assembly B ---------------- *)
CASE b_step OF
0:
    IF X25 AND X26 AND (NOT X27) THEN
        b_req := TRUE;
        b_step := 1;
    END_IF;
1:
    IF b_trig.Q THEN
        b_req := FALSE;
        b_step := 2;
    END_IF;
2:
    IF X28 THEN
        b_step := 3;
    END_IF;
3:
    IF X29 THEN
        b_release_req := TRUE;
        b_step := 4;
    END_IF;
4:
    IF b_release_trig.Q THEN
        b_release_req := FALSE;
        b_assembled_count := b_assembled_count + 1;
        b_step := 0;
    END_IF;
ELSE
    b_step := 0;
END_CASE;

(* ---------------- completion ---------------- *)
completion_condition :=
    (D3 = 3) AND (D4 = 4) AND
    (a_assembled_count = 3) AND (b_assembled_count = 4) AND
    mag1_recovered AND
    (X10 AND (D0 = 202)) AND
    (D1 = 1) AND
    X16 AND
    X14 AND
    X13;

complete_timer(IN := completion_condition, PT := T#500ms);

IF complete_timer.Q AND (deadline_ms <= 300000) THEN
    complete_latched := TRUE;
END_IF;

Y1A := complete_latched;

END_PROGRAM