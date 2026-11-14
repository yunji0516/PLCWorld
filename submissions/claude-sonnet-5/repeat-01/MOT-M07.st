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

    (* internal state *)
    step        : INT := 0;
    started     : BOOL := FALSE;

    a_tgt       : DINT := 0;
    b_tgt       : DINT := 0;
    c_tgt       : DINT := 0;

    pos_tol     : DINT := 20;   (* 0.2 mm * 100 *)
    vel_tol     : DINT := 100;  (* 1 mm/s * 100 *)
    safe_b      : DINT := 10000; (* 100 mm * 100, raised transit height *)

    arrived_a   : BOOL;
    arrived_b   : BOOL;
    arrived_c   : BOOL;

    port1_done  : BOOL := FALSE;
    port2_done  : BOOL := FALSE;
    y2_latch    : BOOL := FALSE;
END_VAR

(* latch the start request *)
started := started OR X0;

(* arrival evaluation based on currently commanded targets *)
arrived_a := (ABS(D10 - a_tgt) <= pos_tol) AND (ABS(D11) <= vel_tol);
arrived_b := (ABS(D12 - b_tgt) <= pos_tol) AND (ABS(D13) <= vel_tol);
arrived_c := (ABS(D14 - c_tgt) <= pos_tol) AND (ABS(D15) <= vel_tol);

IF NOT started THEN
    (* safety: never enable before X0 request *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D21 := 0;
    D25 := 0;
    D29 := 0;

    a_tgt := 0;
    b_tgt := 0;
    c_tgt := 0;

    D20 := a_tgt;
    D24 := b_tgt;
    D28 := c_tgt;

    Y2 := FALSE;
ELSE
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    D21 := 1000;
    D25 := 1000;
    D29 := 1000;

    CASE step OF
        0: (* raise B first, keep A,C at 0 (outside deck footprint) *)
            a_tgt := 0;
            c_tgt := 0;
            b_tgt := safe_b;
            step := 1;

        1: (* wait for raised transit height *)
            IF arrived_b THEN
                step := 2;
            END_IF;

        2: (* move laterally / forward to first port location while raised *)
            a_tgt := D101;
            c_tgt := 0;
            step := 3;

        3: (* wait for A,C arrival aligned with first opening *)
            IF arrived_a AND arrived_c THEN
                step := 4;
            END_IF;

        4: (* descend into first opening *)
            b_tgt := 0;
            step := 5;

        5: (* wait for stop arrival at first port *)
            IF arrived_a AND arrived_b AND arrived_c THEN
                port1_done := TRUE;
                step := 6;
            END_IF;

        6: (* raise back out of first opening to transit height *)
            b_tgt := safe_b;
            step := 7;

        7:
            IF arrived_b THEN
                step := 8;
            END_IF;

        8: (* move to second port location while raised *)
            a_tgt := D102;
            c_tgt := D104;
            step := 9;

        9: (* wait for A,C arrival aligned with second opening *)
            IF arrived_a AND arrived_c THEN
                step := 10;
            END_IF;

        10: (* descend into second opening *)
            b_tgt := D103;
            step := 11;

        11: (* wait for stop arrival at second port *)
            IF arrived_a AND arrived_b AND arrived_c THEN
                port2_done := TRUE;
                step := 12;
            END_IF;

        12: (* raise back out of second opening to transit height *)
            b_tgt := safe_b;
            step := 13;

        13:
            IF arrived_b THEN
                step := 14;
            END_IF;

        14: (* return laterally to home while raised (outside deck footprint at A=0) *)
            a_tgt := 0;
            c_tgt := 0;
            step := 15;

        15:
            IF arrived_a AND arrived_c THEN
                step := 16;
            END_IF;

        16: (* descend to final home height *)
            b_tgt := 0;
            step := 17;

        17: (* wait for final home arrival, both ports must have been completed *)
            IF arrived_a AND arrived_b AND arrived_c AND port1_done AND port2_done THEN
                y2_latch := TRUE;
                step := 18;
            END_IF;

        18: (* hold at home, maintain completion *)
            a_tgt := 0;
            b_tgt := 0;
            c_tgt := 0;

        ELSE
            ;
    END_CASE;

    D20 := a_tgt;
    D24 := b_tgt;
    D28 := c_tgt;

    Y2 := y2_latch;
END_IF;

END_PROGRAM