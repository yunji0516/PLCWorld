PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    (* Internal state machine *)
    state : INT := 0;

    (* Tolerances in raw (x100) scale *)
    pos_tol : DINT := 20;   (* 0.2 * 100 *)
    vel_tol : DINT := 100;  (* 1 * 100 *)

    a_arrived : BOOL;
    b_arrived : BOOL;
    c_arrived : BOOL;
END_VAR

(* -------- Arrival checks based on current sampled inputs -------- *)
a_arrived := FALSE;
b_arrived := FALSE;
c_arrived := FALSE;

CASE state OF

    0: (* WAIT_START : no enable before X0 *)
        Y20 := FALSE;
        D20 := 0;
        D21 := 0;

        Y21 := FALSE;
        D24 := 0;
        D25 := 0;

        Y22 := FALSE;
        D28 := 0;
        D29 := 0;

        Y2 := FALSE;

        IF X0 THEN
            state := 1;
        END_IF;

    1: (* MOVE_A_TO_FIRST : rotate disk to first index angle, tools retracted *)
        Y20 := TRUE;
        D20 := D101;
        D21 := 1000;

        Y21 := FALSE;
        D24 := 0;
        D25 := 0;

        Y22 := FALSE;
        D28 := 0;
        D29 := 0;

        Y2 := FALSE;

        IF (ABS(D10 - D101) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
            state := 2;
        END_IF;

    2: (* INSERT_B : disk held at first, B approaches depth1 *)
        Y20 := TRUE;
        D20 := D101;
        D21 := 1000;

        Y21 := TRUE;
        D24 := D103;
        D25 := 1000;

        Y22 := FALSE;
        D28 := 0;
        D29 := 0;

        Y2 := FALSE;

        IF (ABS(D12 - D103) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
            state := 3;
        END_IF;

    3: (* RETRACT_B : withdraw B back to 0, disk still held at first *)
        Y20 := TRUE;
        D20 := D101;
        D21 := 1000;

        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;

        Y22 := FALSE;
        D28 := 0;
        D29 := 0;

        Y2 := FALSE;

        IF (ABS(D12 - 0) <= pos_tol) AND (ABS(D13) <= vel_tol) THEN
            state := 4;
        END_IF;

    4: (* MOVE_A_TO_SECOND : B is fully retracted, safe to rotate disk *)
        Y20 := TRUE;
        D20 := D102;
        D21 := 1000;

        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;

        Y22 := FALSE;
        D28 := 0;
        D29 := 0;

        Y2 := FALSE;

        IF (ABS(D10 - D102) <= pos_tol) AND (ABS(D11) <= vel_tol) THEN
            state := 5;
        END_IF;

    5: (* INSERT_C : disk held at second, C approaches depth2 *)
        Y20 := TRUE;
        D20 := D102;
        D21 := 1000;

        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;

        Y22 := TRUE;
        D28 := D104;
        D29 := 1000;

        Y2 := FALSE;

        IF (ABS(D14 - D104) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
            state := 6;
        END_IF;

    6: (* RETRACT_C : withdraw C back to 0, disk still held at second *)
        Y20 := TRUE;
        D20 := D102;
        D21 := 1000;

        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;

        Y22 := TRUE;
        D28 := 0;
        D29 := 1000;

        Y2 := FALSE;

        IF (ABS(D14 - 0) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
            state := 7;
        END_IF;

    7: (* DONE : hold final state A=second, B=0, C=0 and assert completion *)
        Y20 := TRUE;
        D20 := D102;
        D21 := 1000;

        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;

        Y22 := TRUE;
        D28 := 0;
        D29 := 1000;

        Y2 := TRUE;

    ELSE
        (* Fallback safe state *)
        Y20 := FALSE;
        D20 := 0;
        D21 := 0;

        Y21 := FALSE;
        D24 := 0;
        D25 := 0;

        Y22 := FALSE;
        D28 := 0;
        D29 := 0;

        Y2 := FALSE;

        state := 0;

END_CASE;

END_PROGRAM