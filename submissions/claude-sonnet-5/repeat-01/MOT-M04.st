PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2  : BOOL;

    (* internal scaled physical values *)
    a_pos : REAL;
    a_spd : REAL;
    a_tgt : REAL;
    b_pos : REAL;
    b_spd : REAL;
    b_tgt : REAL;
    c_pos : REAL;
    c_spd : REAL;
    c_tgt : REAL;

    err_b : REAL;
    acc_b : REAL;

    wn2         : REAL := 1225.0;  (* 35^2, natural frequency squared *)
    two_zeta_wn : REAL := 70.0;    (* 2*zeta*wn, zeta=1, wn=35 *)
    acc_limit   : REAL := 4000.0;  (* mm/s^2, from permitted acceleration command range /100 *)

    cond_a_pos : BOOL;
    cond_a_spd : BOOL;
    cond_b_pos : BOOL;
    cond_b_spd : BOOL;
    cond_c_pos : BOOL;
    cond_c_spd : BOOL;
    all_ok     : BOOL;

    stable_timer : TON;
    y2_latch     : BOOL;
END_VAR

(* scale inputs from 0.01 units to physical units *)
a_pos := REAL(D11) / 100.0;
a_spd := REAL(D12) / 100.0;
a_tgt := REAL(D10) / 100.0;
b_pos := REAL(D13) / 100.0;
b_spd := REAL(D14) / 100.0;
b_tgt := REAL(D17) / 100.0;
c_pos := REAL(D15) / 100.0;
c_spd := REAL(D16) / 100.0;
c_tgt := REAL(D18) / 100.0;

IF X10 THEN
    (* enable hoist and pass through requested wire length target directly *)
    Y20 := TRUE;
    D20 := D10;

    (* PD acceleration control for trolley position, feedforward speed = 0 *)
    err_b := b_tgt - b_pos;
    acc_b := wn2 * err_b - two_zeta_wn * b_spd;

    IF acc_b > acc_limit THEN
        acc_b := acc_limit;
    ELSIF acc_b < -acc_limit THEN
        acc_b := -acc_limit;
    END_IF;

    D21 := DINT(acc_b * 100.0);
ELSE
    (* no request yet: keep outputs safe, hold current wire length as target *)
    Y20 := FALSE;
    D20 := D11;
    D21 := 0;
END_IF;

(* completion condition evaluation *)
cond_a_pos := ABS(a_pos - a_tgt) <= 1.0;
cond_a_spd := ABS(a_spd) <= 1.0;
cond_b_pos := ABS(b_pos - b_tgt) <= 1.0;
cond_b_spd := ABS(b_spd) <= 1.0;
cond_c_pos := ABS(c_pos - c_tgt) <= 0.2;
cond_c_spd := ABS(c_spd) <= 1.0;

all_ok := X10 AND cond_a_pos AND cond_a_spd AND cond_b_pos AND cond_b_spd AND cond_c_pos AND cond_c_spd;

stable_timer(IN := all_ok, PT := T#30ms);

IF stable_timer.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM