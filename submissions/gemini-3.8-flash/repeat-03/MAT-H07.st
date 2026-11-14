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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;

    step : INT := 0;
    prev_step : INT := -1;
    step_timer : DINT := 0;
    started : BOOL := FALSE;
    a_accepted : BOOL := FALSE;
    b_accepted : BOOL := FALSE;
    b_trimmed : BOOL := FALSE;
    rolls_completed : INT := 0;

    tape_step : INT := 0;
    tape_timer : DINT := 0;
    tape_done_for_roll : BOOL := FALSE;

    eject_step : INT := 0;
    eject_timer : DINT := 0;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    RETURN;
END_IF;

(* Edge outputs default to FALSE each scan *)
Y10 := FALSE;
Y11 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y27 := FALSE;
Y28 := FALSE;

IF step <> prev_step THEN
    step_timer := 0;
    prev_step := step;
ELSE
    step_timer := step_timer + 1;
END_IF;

(* Tape Preparation State Machine: runs concurrently when needed *)
CASE tape_step OF
    0: (* Idle / wait for request *)
        Y25 := FALSE;
        Y26 := FALSE;
        IF NOT tape_done_for_roll AND rolls_completed < 3 THEN
            IF NOT X32 AND (X2F OR X2B) THEN
                tape_step := 10;
                tape_timer := 0;
            END_IF;
        END_IF;

    10: (* tape_prepare *)
        Y25 := TRUE;
        tape_timer := tape_timer + 1;
        IF X32 OR tape_timer > 5 THEN
            tape_step := 20;
            tape_timer := 0;
        END_IF;

    20: (* wait tape prepared *)
        Y25 := FALSE;
        IF NOT X32 THEN
            tape_step := 30;
            tape_timer := 0;
        END_IF;

    30: (* tape_hold *)
        Y26 := TRUE;
        tape_timer := tape_timer + 1;
        IF X30 AND tape_timer >= 20 THEN
            tape_step := 40;
            tape_timer := 0;
        END_IF;

    40: (* tape_cut pulse *)
        Y26 := TRUE;
        Y27 := TRUE;
        tape_step := 50;
        tape_timer := 0;

    50: (* wait tape severed *)
        Y26 := TRUE;
        IF X31 THEN
            tape_step := 60;
        END_IF;

    60: (* Ready to apply *)
        Y26 := TRUE;
        IF tape_done_for_roll THEN
            tape_step := 0;
        END_IF;
END_CASE;

(* Eject / External Reception State Machine *)
CASE eject_step OF
    0:
        Y29 := FALSE;
        (* idle *)

    10: (* Wait receiver ready & exit clear *)
        IF X35 AND X34 THEN
            Y29 := TRUE;
            eject_step := 20;
        END_IF;

    20: (* Wait exit received *)
        Y29 := TRUE;
        IF X22 THEN
            Y21 := TRUE; (* ack_exit pulse *)
            eject_step := 30;
        END_IF;

    30: (* Wait release cleared *)
        Y29 := FALSE;
        IF NOT X21 THEN
            eject_step := 0;
        END_IF;
END_CASE;

(* Main Sequencing State Machine *)
CASE step OF
    0: (* Accept A and B webs *)
        IF X10 AND NOT a_accepted THEN
            Y10 := TRUE;
            a_accepted := TRUE;
        END_IF;
        IF X11 AND NOT b_accepted THEN
            Y11 := TRUE;
            b_accepted := TRUE;
        END_IF;
        IF a_accepted AND b_accepted THEN
            step := 10;
        END_IF;

    10: (* Jog B to origin_b *)
        IF D2 < D0 THEN
            Y14 := TRUE;
        ELSE
            Y14 := FALSE;
            step := 20;
        END_IF;

    20: (* Hold B *)
        Y13 := TRUE;
        IF X15 AND step_timer >= 20 THEN
            step := 30;
        END_IF;

    30: (* Trim B *)
        Y13 := TRUE;
        Y15 := TRUE;
        step := 40;

    40: (* Wait trim done & trim received *)
        Y13 := TRUE;
        IF X17 THEN
            Y16 := TRUE; (* ack_trim pulse *)
            step := 50;
        END_IF;

    50: (* Release Hold B *)
        Y13 := FALSE;
        IF X25 THEN
            step := 100;
        END_IF;

    100: (* Core Feeding & Preparation *)
        Y24 := TRUE; (* core_stop *)
        IF X2E THEN
            Y23 := TRUE; (* core_feed *)
            IF X2D THEN
                Y23 := FALSE;
                step := 110;
            END_IF;
        END_IF;

    110: (* Accept Roll onto shaft *)
        Y24 := TRUE;
        IF X1D AND NOT X1A THEN
            Y17 := TRUE; (* accept_roll pulse *)
            step := 120;
        END_IF;

    120: (* Extend Mandrel *)
        Y24 := FALSE;
        Y1F := TRUE;
        IF X1E THEN
            Y1F := FALSE;
            step := 130;
        END_IF;

    130: (* Close Nips *)
        Y18 := TRUE;
        Y19 := TRUE;
        IF X1B AND X1C AND step_timer >= 20 THEN
            step := 140;
        END_IF;

    140: (* Wind to Target *)
        Y18 := TRUE;
        Y19 := TRUE;
        Y1A := TRUE;
        IF D5 >= (D4 - 2) THEN
            Y1A := FALSE;
            step := 150;
        END_IF;

    150: (* Apply Holds before cut *)
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF X14 AND X15 AND step_timer >= 20 THEN
            step := 160;
        END_IF;

    160: (* Cut Webs A and B *)
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y1C := TRUE;
        Y1D := TRUE;
        step := 170;

    170: (* Wait cut complete and cutters clear *)
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        IF X27 AND X28 THEN
            step := 180;
        END_IF;

    180: (* Wind remaining tail *)
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y1A := TRUE;
        IF X26 OR D7 <= 0 THEN
            Y1A := FALSE;
            step := 190;
        END_IF;

    190: (* Engage Roll Support *)
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y1B := TRUE;
        IF X1F THEN
            step := 200;
        END_IF;

    200: (* Apply Tape to secure tail *)
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y1B := TRUE;
        IF tape_step = 60 AND X2A THEN
            Y28 := TRUE; (* tape_apply pulse *)
            step := 210;
        END_IF;

    210: (* Wait tail taped *)
        Y18 := TRUE;
        Y19 := TRUE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y1B := TRUE;
        IF X33 THEN
            tape_done_for_roll := TRUE;
            step := 220;
        END_IF;

    220: (* Retract Mandrel *)
        Y18 := FALSE;
        Y19 := FALSE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y1B := TRUE;
        Y1E := TRUE;
        IF X1D THEN
            Y1E := FALSE;
            step := 230;
        END_IF;

    230: (* Eject Roll *)
        Y12 := TRUE;
        Y13 := TRUE;
        Y1B := TRUE;
        IF NOT X21 THEN
            Y20 := TRUE; (* eject pulse *)
            eject_step := 10;
            step := 240;
        END_IF;

    240: (* Wait Cradle return / eject complete *)
        Y12 := TRUE;
        Y13 := TRUE;
        IF NOT X21 AND X20 THEN
            Y1B := FALSE;
            rolls_completed := rolls_completed + 1;
            tape_done_for_roll := FALSE;
            IF rolls_completed >= 3 OR X23 THEN
                step := 300;
            ELSE
                step := 100;
            END_IF;
        END_IF;

    300: (* Wait for exit reception to finish and signal completion *)
        Y12 := TRUE;
        Y13 := TRUE;
        IF eject_step = 0 AND (X23 OR rolls_completed >= 3) THEN
            Y22 := TRUE;
            IF step_timer >= 10 THEN
                step := 310;
            END_IF;
        END_IF;

    310: (* Finished / Maintain *)
        Y12 := TRUE;
        Y13 := TRUE;
        Y22 := TRUE;
END_CASE;

END_PROGRAM