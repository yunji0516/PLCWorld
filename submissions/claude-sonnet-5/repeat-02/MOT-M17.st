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

    (* internal *)
    state       : INT := 0;
    started     : BOOL := FALSE;
    pos_tol     : DINT := 20;    (* 0.2 mm/deg * 100 *)
    vel_tol     : DINT := 100;   (* 1 mm/s or deg/s * 100 *)

    a_target_raw : DINT;
    b_target_raw : DINT;
    c_target_raw : DINT;
    d_target_raw : DINT;

    arrivedA : BOOL;
    arrivedB : BOOL;
    arrivedC : BOOL;
    arrivedD : BOOL;
END_VAR

(* Latch start request - enable is never activated before X0 *)
IF X0 THEN
    started := TRUE;
END_IF;

(* default rates - full speed, valid whether enabled or not *)
D21 := 1000;
D25 := 1000;
D29 := 1000;
D33 := 1000;

IF NOT started THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    D20 := 0;
    D24 := 0;
    D28 := 0;
    D32 := 0;
    Y2  := FALSE;
ELSE
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := TRUE;

    CASE state OF

        0: (* retract feeder A to 0, hold B,C,D at home *)
            a_target_raw := 0;
            b_target_raw := 0;
            c_target_raw := 0;
            d_target_raw := 0;
            D20 := a_target_raw;
            D24 := b_target_raw;
            D28 := c_target_raw;
            D32 := d_target_raw;
            IF ABS(D10 - a_target_raw) <= pos_tol AND ABS(D11) <= vel_tol THEN
                state := 1;
            END_IF;

        1: (* raise D for outbound clearance, A held at 0, B,C held at 0 *)
            a_target_raw := 0;
            b_target_raw := 0;
            c_target_raw := 0;
            d_target_raw := 10000;
            D20 := a_target_raw;
            D24 := b_target_raw;
            D28 := c_target_raw;
            D32 := d_target_raw;
            IF ABS(D16 - d_target_raw) <= pos_tol AND ABS(D17) <= vel_tol THEN
                state := 2;
            END_IF;

        2: (* outbound: rotate B to 90 and move C to target while D stays high, A held 0 *)
            a_target_raw := 0;
            b_target_raw := 9000;
            c_target_raw := D101;
            d_target_raw := 10000;
            D20 := a_target_raw;
            D24 := b_target_raw;
            D28 := c_target_raw;
            D32 := d_target_raw;
            IF ABS(D12 - b_target_raw) <= pos_tol AND ABS(D13) <= vel_tol AND
               ABS(D14 - c_target_raw) <= pos_tol AND ABS(D15) <= vel_tol THEN
                state := 3;
            END_IF;

        3: (* descend D to establish first destination stop B=90,C=target,D=0, A still held 0 *)
            a_target_raw := 0;
            b_target_raw := 9000;
            c_target_raw := D101;
            d_target_raw := 0;
            D20 := a_target_raw;
            D24 := b_target_raw;
            D28 := c_target_raw;
            D32 := d_target_raw;
            IF ABS(D16 - d_target_raw) <= pos_tol AND ABS(D17) <= vel_tol THEN
                state := 4;
            END_IF;

        4: (* destination stop reached: begin return - raise D again for return clearance *)
            a_target_raw := 0;
            b_target_raw := 9000;
            c_target_raw := D101;
            d_target_raw := 10000;
            D20 := a_target_raw;
            D24 := b_target_raw;
            D28 := c_target_raw;
            D32 := d_target_raw;
            IF ABS(D16 - d_target_raw) <= pos_tol AND ABS(D17) <= vel_tol THEN
                state := 5;
            END_IF;

        5: (* rotate B back to 0 at high D, C still at target, A still 0 *)
            a_target_raw := 0;
            b_target_raw := 0;
            c_target_raw := D101;
            d_target_raw := 10000;
            D20 := a_target_raw;
            D24 := b_target_raw;
            D28 := c_target_raw;
            D32 := d_target_raw;
            IF ABS(D12 - b_target_raw) <= pos_tol AND ABS(D13) <= vel_tol THEN
                state := 6;
            END_IF;

        6: (* B already 0 at high D: allow feeder re-entry and C retraction to overlap *)
            a_target_raw := 28000;
            b_target_raw := 0;
            c_target_raw := 0;
            d_target_raw := 10000;
            D20 := a_target_raw;
            D24 := b_target_raw;
            D28 := c_target_raw;
            D32 := d_target_raw;
            IF ABS(D10 - a_target_raw) <= pos_tol AND ABS(D11) <= vel_tol AND
               ABS(D14 - c_target_raw) <= pos_tol AND ABS(D15) <= vel_tol THEN
                state := 7;
            END_IF;

        7: (* final hold: A=280, B=0, C=0, D=100 *)
            a_target_raw := 28000;
            b_target_raw := 0;
            c_target_raw := 0;
            d_target_raw := 10000;
            D20 := a_target_raw;
            D24 := b_target_raw;
            D28 := c_target_raw;
            D32 := d_target_raw;

    END_CASE;

    arrivedA := ABS(D10 - 28000) <= pos_tol AND ABS(D11) <= vel_tol;
    arrivedB := ABS(D12 - 0)     <= pos_tol AND ABS(D13) <= vel_tol;
    arrivedC := ABS(D14 - 0)     <= pos_tol AND ABS(D15) <= vel_tol;
    arrivedD := ABS(D16 - 10000) <= pos_tol AND ABS(D17) <= vel_tol;

    IF state = 7 AND arrivedA AND arrivedB AND arrivedC AND arrivedD THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;

END_IF;

END_PROGRAM