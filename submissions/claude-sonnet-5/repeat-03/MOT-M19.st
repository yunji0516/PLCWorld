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
    D102 : DINT;
    D103 : DINT;
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

    state : INT := 0;      (* 0=idle,1=prep C/D,2=run A first->second,3=done/retract *)
    run_phase : INT := 1;  (* 1=target first, 2=target second *)

    pos_tol : DINT := 20;   (* 0.2 mm * 100 *)
    spd_tol : DINT := 100;  (* 1 mm/s * 100 *)

    hold_a : DINT := 6000;   (* 60 mm *)
    hold_b : DINT := 0;      (* 0 mm, retracted *)
    c_work : DINT := 0;      (* work position *)
    b_first : DINT := 7000;  (* 70 mm engagement *)
    b_eng_low : DINT := 6000;
    b_eng_high : DINT := 7500;

    a_retract : DINT := 6000;  (* 60 mm return *)
    b_retract : DINT := 0;
    c_standby : DINT := 8000;  (* 80 mm standby *)
    d_retract : DINT := 0;

    target_a : DINT;
    target_b : DINT;
    target_c : DINT;
    target_d : DINT;

    a_arr : BOOL;
    b_arr : BOOL;
    c_arr : BOOL;
    d_arr : BOOL;
    c_ok : BOOL;
    d_ok : BOOL;
    b_eng : BOOL;
    valid : BOOL;
END_VAR

CASE state OF

0: (* IDLE - wait for start; keep outputs off/safe *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
    D20 := 0; D21 := 0;
    D24 := 0; D25 := 0;
    D28 := 0; D29 := 0;
    D32 := 0; D33 := 0;
    IF X0 THEN
        state := 1;
    END_IF;

1: (* PREP: bring C to work position, D to lane; hold A,B at initial values *)
    target_a := hold_a;
    target_b := hold_b;
    target_c := c_work;
    target_d := D103;

    c_arr := (ABS(D14 - target_c) <= pos_tol) AND (ABS(D15) <= spd_tol);
    d_arr := (ABS(D16 - target_d) <= pos_tol) AND (ABS(D17) <= spd_tol);

    Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
    D20 := target_a; D21 := 1000;
    D24 := target_b; D25 := 1000;
    D28 := target_c; D29 := 1000;
    D32 := target_d; D33 := 1000;

    IF c_arr AND d_arr THEN
        run_phase := 1;
        state := 2;
    END_IF;

2: (* RUN: sequence A first->second while holding B/C/D; monitor validity *)
    IF run_phase = 1 THEN
        target_a := D101;
    ELSE
        target_a := D102;
    END_IF;
    target_b := b_first;
    target_c := c_work;
    target_d := D103;

    a_arr := (ABS(D10 - target_a) <= pos_tol) AND (ABS(D11) <= spd_tol);
    b_arr := (ABS(D12 - target_b) <= pos_tol) AND (ABS(D13) <= spd_tol);
    c_ok := ABS(D14 - target_c) <= pos_tol;
    d_ok := ABS(D16 - target_d) <= pos_tol;
    b_eng := (D12 >= b_eng_low) AND (D12 <= b_eng_high);

    Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
    D20 := target_a; D21 := 1000;
    D24 := target_b; D25 := 1000;
    D28 := target_c; D29 := 1000;
    D32 := target_d; D33 := 1000;

    IF run_phase = 1 THEN
        valid := c_ok AND d_ok;
    ELSE
        valid := c_ok AND d_ok AND b_eng;
    END_IF;

    IF NOT valid THEN
        run_phase := 1; (* loss of engagement/work position/lane alignment: restart at first *)
    ELSE
        IF run_phase = 1 THEN
            IF a_arr AND b_arr THEN
                run_phase := 2;
            END_IF;
        ELSE
            IF a_arr THEN
                Y2 := TRUE;
                state := 3;
            END_IF;
        END_IF;
    END_IF;

3: (* DONE: retract guide, return base/section/head; keep completion asserted *)
    Y2 := TRUE;
    Y20 := TRUE; Y21 := TRUE; Y22 := TRUE; Y23 := TRUE;
    D20 := a_retract; D21 := 1000;
    D24 := b_retract; D25 := 1000;
    D28 := c_standby; D29 := 1000;
    D32 := d_retract; D33 := 1000;

ELSE
    state := 0;
END_CASE;

END_PROGRAM