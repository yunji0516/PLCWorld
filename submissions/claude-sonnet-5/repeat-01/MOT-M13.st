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

    (* internal state *)
    state : DINT := 0;
    hold_timer : TON;
    y2_latched : BOOL := FALSE;

    a_arr_120 : BOOL;
    a_arr_100 : BOOL;
    a_arr_0   : BOOL;
    b_arr_tgt : BOOL;
    b_arr_0   : BOOL;
    c_arr_tgt : BOOL;
    c_arr_0   : BOOL;
    d_arr_rcv : BOOL;
    d_arr_0   : BOOL;
    docked_now : BOOL;

    a_tgt : DINT;
    b_tgt : DINT;
    c_tgt : DINT;
    d_tgt : DINT;
    full_rate : DINT := 1000;
END_VAR

(* Arrival checks: position within 0.2 (raw 20) and speed within 1 (raw 100) *)
a_arr_120 := ABS(D10 - 12000) <= 20 AND ABS(D11) <= 100;
a_arr_100 := ABS(D10 - 10000) <= 20 AND ABS(D11) <= 100;
a_arr_0   := ABS(D10 - 0) <= 20 AND ABS(D11) <= 100;
b_arr_tgt := ABS(D12 - D101) <= 20 AND ABS(D13) <= 100;
b_arr_0   := ABS(D12 - 0) <= 20 AND ABS(D13) <= 100;
c_arr_tgt := ABS(D14 - D102) <= 20 AND ABS(D15) <= 100;
c_arr_0   := ABS(D14 - 0) <= 20 AND ABS(D15) <= 100;
d_arr_rcv := ABS(D16 - D103) <= 20 AND ABS(D17) <= 100;
d_arr_0   := ABS(D16 - 0) <= 20 AND ABS(D17) <= 100;

docked_now := a_arr_100 AND b_arr_tgt AND c_arr_tgt AND d_arr_rcv;

hold_timer(IN := (state = 4), PT := T#100ms);

CASE state OF
    0: (* wait start - prepare targets, enables off *)
        a_tgt := 12000; b_tgt := D101; c_tgt := 0; d_tgt := D103;
        IF X0 THEN
            state := 1;
        END_IF;

    1: (* align A,B; D preps in parallel; keep C at 0 *)
        a_tgt := 12000; b_tgt := D101; c_tgt := 0; d_tgt := D103;
        IF a_arr_120 AND b_arr_tgt THEN
            state := 2;
        END_IF;

    2: (* insert: move C through fixed opening to target; D must be ready too before docking *)
        a_tgt := 12000; b_tgt := D101; c_tgt := D102; d_tgt := D103;
        IF c_arr_tgt AND d_arr_rcv THEN
            state := 3;
        END_IF;

    3: (* dock: lower A to 100 while B,C,D held *)
        a_tgt := 10000; b_tgt := D101; c_tgt := D102; d_tgt := D103;
        IF docked_now THEN
            state := 4;
            y2_latched := TRUE;
        END_IF;

    4: (* hold docked state for required maintenance duration *)
        a_tgt := 10000; b_tgt := D101; c_tgt := D102; d_tgt := D103;
        IF hold_timer.Q THEN
            state := 5;
        END_IF;

    5: (* raise A off the support, B,C,D held so D=receive maintained while C>target-40,A<115 *)
        a_tgt := 12000; b_tgt := D101; c_tgt := D102; d_tgt := D103;
        IF a_arr_120 THEN
            state := 6;
        END_IF;

    6: (* retract C back through opening; A already >=115 so D constraint no longer forced but kept unchanged *)
        a_tgt := 12000; b_tgt := D101; c_tgt := 0; d_tgt := D103;
        IF c_arr_0 THEN
            state := 7;
        END_IF;

    7: (* return remaining axes to zero, C already retracted so constraint inactive *)
        a_tgt := 0; b_tgt := 0; c_tgt := 0; d_tgt := 0;
        IF a_arr_0 AND b_arr_0 AND c_arr_0 AND d_arr_0 THEN
            state := 8;
        END_IF;

    8: (* done - hold all axes at zero *)
        a_tgt := 0; b_tgt := 0; c_tgt := 0; d_tgt := 0;

END_CASE;

D20 := a_tgt;
D21 := full_rate;
Y20 := (state >= 1);

D24 := b_tgt;
D25 := full_rate;
Y21 := (state >= 1);

D28 := c_tgt;
D29 := full_rate;
Y22 := (state >= 1);

D32 := d_tgt;
D33 := full_rate;
Y23 := (state >= 1);

Y2 := y2_latched;

END_PROGRAM