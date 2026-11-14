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
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* Edge detectors *)
    ed_start : R_TRIG;
    ed_body_ready : R_TRIG;
    ed_insert_supply : R_TRIG;
    ed_insert_staged : R_TRIG;
    ed_insert_complete : R_TRIG;
    ed_exit_received : R_TRIG;
    ed_reseated : R_TRIG;
    ed_locked : R_TRIG;
    ed_unlocked : R_TRIG;
    ed_return_ready : R_TRIG;
    ed_rework_clamped : R_TRIG;
    ed_insert_removed : R_TRIG;

    (* Timers *)
    t_lock : TON;
    t_unlock : TON;
    t_turn : TON;
    t_inspect : TON;
    t_rework_clamp : TON;
    t_complete : TON;

    (* State machine state *)
    state : INT := 0;

    (* Counters and tracking *)
    gen_cnt : INT := 0;
    good_count : INT := 0;
    ack_count : INT := 0;
    rework_count : INT := 0;
    bodies_processed : INT := 0;
    ng_flag : BOOL := FALSE;
    rework_needed_flag : BOOL := FALSE;

    (* Internal flags *)
    load_started : BOOL := FALSE;
    insert_started : BOOL := FALSE;
    inspect_started : BOOL := FALSE;
    eject_started : BOOL := FALSE;
    ejector_retracting : BOOL := FALSE;
    rework_sent : BOOL := FALSE;
    rework_clamp_engaged : BOOL := FALSE;
    remove_started : BOOL := FALSE;
    reseat_started : BOOL := FALSE;
    return_started : BOOL := FALSE;
    ack_started : BOOL := FALSE;
    turn_started : BOOL := FALSE;
    prev_locked : BOOL := FALSE;
    prev_unlocked : BOOL := FALSE;
    release_issued : BOOL := FALSE;
    inspect_result_captured : BOOL := FALSE;
    generation_updated : BOOL := FALSE;
    complete_asserted : BOOL := FALSE;
END_VAR

(* Update edge detectors *)
ed_start(CLK := X0);
ed_body_ready(CLK := X10);
ed_insert_supply(CLK := X12);
ed_insert_staged(CLK := X13);
ed_insert_complete(CLK := X21);
ed_exit_received(CLK := X1E);
ed_reseated(CLK := X29);
ed_locked(CLK := X19);
ed_unlocked(CLK := X1A);
ed_return_ready(CLK := X2A);
ed_rework_clamped(CLK := X27);
ed_insert_removed(CLK := X28);

(* Update timers *)
t_lock(IN := Y17, PT := T#150ms);
t_unlock(IN := NOT Y17, PT := T#150ms);
t_turn(IN := Y18, PT := T#3500ms);
t_inspect(IN := Y13, PT := T#5000ms);
t_rework_clamp(IN := Y1C, PT := T#300ms);
t_complete(IN := complete_asserted, PT := T#500ms);

(* Default all outputs to FALSE *)
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

(* Update generation output *)
D200 := gen_cnt;

(* State machine *)
CASE state OF
    0: (* IDLE - wait for start *)
        IF ed_start.Q THEN
            state := 10;
        END_IF;

    10: (* WAIT_LOCKED_INITIAL - ensure table locked at position 0 *)
        Y17 := TRUE;
        IF X19 THEN
            state := 20;
        END_IF;

    20: (* WAIT_BODY - wait for body_ready at position 0 *)
        Y17 := TRUE;
        IF X10 AND NOT X11 THEN
            state := 30;
        ELSIF X11 AND bodies_processed >= 6 THEN
            IF good_count >= 6 AND ack_count >= 6 AND rework_count >= 2 THEN
                state := 900;
            ELSE
                state := 20;
            END_IF;
        END_IF;

    30: (* LOAD_BODY - load main body into pocket at position 0 *)
        Y17 := TRUE;
        Y10 := TRUE;
        load_started := TRUE;
        IF NOT X14 AND load_started THEN
            load_started := FALSE;
            state := 40;
        END_IF;

    40: (* CONFIRM_LOAD_DONE - verify load completed *)
        Y17 := TRUE;
        IF NOT X14 THEN
            bodies_processed := bodies_processed + 1;
            state := 50;
        END_IF;

    50: (* UNLOCK_FOR_TURN_TO_1 *)
        Y17 := FALSE;
        IF X1A THEN
            state := 60;
        END_IF;

    60: (* TURN_TO_POSITION_1 *)
        Y18 := TRUE;
        turn_started := TRUE;
        IF NOT X18 AND turn_started THEN
            Y18 := FALSE;
            turn_started := FALSE;
            state := 70;
        END_IF;

    70: (* LOCK_AT_POSITION_1 *)
        Y17 := TRUE;
        IF X19 THEN
            state := 80;
        END_IF;

    80: (* PREPARE_INSERT - reserve insert supply *)
        Y17 := TRUE;
        Y11 := TRUE;
        IF X13 THEN
            Y11 := FALSE;
            state := 90;
        END_IF;

    90: (* INSERT - insert insert into main body *)
        Y17 := TRUE;
        Y12 := TRUE;
        insert_started := TRUE;
        IF X21 AND insert_started THEN
            insert_started := FALSE;
            state := 100;
        END_IF;

    100: (* CONFIRM_INSERT_DONE *)
        Y17 := TRUE;
        IF X21 THEN
            state := 110;
        END_IF;

    110: (* UNLOCK_FOR_TURN_TO_2 *)
        Y17 := FALSE;
        IF X1A THEN
            state := 120;
        END_IF;

    120: (* TURN_TO_POSITION_2 *)
        Y18 := TRUE;
        turn_started := TRUE;
        IF NOT X18 AND turn_started THEN
            Y18 := FALSE;
            turn_started := FALSE;
            state := 130;
        END_IF;

    130: (* LOCK_AT_POSITION_2 *)
        Y17 := TRUE;
        IF X19 THEN
            state := 140;
        END_IF;

    140: (* INSPECT - request inspection *)
        Y17 := TRUE;
        Y13 := TRUE;
        gen_cnt := gen_cnt + 1;
        D200 := gen_cnt;
        inspect_started := TRUE;
        IF X22 AND inspect_started THEN
            inspect_started := FALSE;
            state := 150;
        END_IF;

    150: (* WAIT_INSPECT_COMPLETE *)
        Y17 := TRUE;
        IF NOT X16 THEN
            state := 160;
        END_IF;

    160: (* CAPTURE_RESULT *)
        Y17 := TRUE;
        ng_flag := X24;
        inspect_result_captured := TRUE;
        state := 170;

    170: (* DECIDE - check if rework needed or proceed to ejection *)
        Y17 := TRUE;
        IF ng_flag THEN
            rework_needed_flag := TRUE;
            state := 200;
        ELSE
            rework_needed_flag := FALSE;
            state := 300;
        END_IF;

    200: (* SEND_TO_REWORK - send NG product to repair jig *)
        Y17 := TRUE;
        Y1B := TRUE;
        rework_sent := TRUE;
        state := 210;

    210: (* WAIT_REWORK_AVAILABLE *)
        Y17 := TRUE;
        IF X26 THEN
            state := 220;
        END_IF;

    220: (* REWORK_CLAMP - engage repair clamp *)
        Y17 := TRUE;
        Y1C := TRUE;
        rework_clamp_engaged := TRUE;
        IF X27 THEN
            state := 230;
        END_IF;

    230: (* REMOVE_INSERT - lift insert *)
        Y17 := TRUE;
        Y1C := TRUE;
        Y1D := TRUE;
        remove_started := TRUE;
        IF X28 AND remove_started THEN
            remove_started := FALSE;
            state := 240;
        END_IF;

    240: (* RESEAT_INSERT - reseat insert to bottom *)
        Y17 := TRUE;
        Y1C := TRUE;
        Y1E := TRUE;
        reseat_started := TRUE;
        IF X29 AND reseat_started THEN
            reseat_started := FALSE;
            state := 250;
        END_IF;

    250: (* RELEASE_REWORK_CLAMP *)
        Y17 := TRUE;
        Y1C := FALSE;
        rework_clamp_engaged := FALSE;
        IF NOT X27 THEN
            state := 260;
        END_IF;

    260: (* WAIT_REWORK_DONE *)
        Y17 := TRUE;
        IF NOT X25 AND NOT X26 THEN
            rework_count := rework_count + 1;
            state := 270;
        END_IF;

    270: (* RETURN_BODY - return repaired assembly to position 0 *)
        Y17 := TRUE;
        IF X19 AND NOT X14 THEN
            Y1F := TRUE;
            return_started := TRUE;
            state := 280;
        END_IF;

    280: (* WAIT_RETURN_COMPLETE *)
        Y17 := TRUE;
        Y1F := FALSE;
        IF NOT X2A OR NOT X1F OR X10 THEN
            return_started := FALSE;
            generation_updated := TRUE;
            ng_flag := FALSE;
            inspect_result_captured := FALSE;
            state := 50;
        END_IF;

    300: (* UNLOCK_FOR_TURN_TO_3 *)
        Y17 := FALSE;
        IF X1A THEN
            state := 310;
        END_IF;

    310: (* TURN_TO_POSITION_3 *)
        Y18 := TRUE;
        turn_started := TRUE;
        IF NOT X18 AND turn_started THEN
            Y18 := FALSE;
            turn_started := FALSE;
            state := 320;
        END_IF;

    320: (* LOCK_AT_POSITION_3 *)
        Y17 := TRUE;
        IF X19 THEN
            state := 330;
        END_IF;

    330: (* CHECK_EJECTOR_READY *)
        Y17 := TRUE;
        IF X1B AND X1D THEN
            state := 340;
        END_IF;

    340: (* EJECT_EXTEND - push inspected product to receiver *)
        Y17 := TRUE;
        Y14 := TRUE;
        eject_started := TRUE;
        state := 350;

    350: (* WAIT_EJECT_COMPLETE *)
        Y17 := TRUE;
        Y14 := TRUE;
        IF X1C OR X17 THEN
            state := 360;
        END_IF;

    360: (* EJECT_RETRACT *)
        Y17 := TRUE;
        Y14 := FALSE;
        Y15 := TRUE;
        ejector_retracting := TRUE;
        IF X1B AND ejector_retracting THEN
            Y15 := FALSE;
            ejector_retracting := FALSE;
            state := 370;
        END_IF;

    370: (* WAIT_EJECTOR_HOME *)
        Y17 := TRUE;
        IF X1B AND NOT X17 THEN
            state := 380;
        END_IF;

    380: (* INCREMENT_GOOD_COUNT *)
        Y17 := TRUE;
        good_count := good_count + 1;
        state := 390;

    390: (* RELEASE_OUTPUT - send product to exit transport *)
        Y17 := TRUE;
        IF X1B AND X1D AND X20 THEN
            Y16 := TRUE;
            release_issued := TRUE;
            state := 400;
        END_IF;

    400: (* WAIT_RELEASE_DONE *)
        Y17 := TRUE;
        Y16 := FALSE;
        IF NOT X20 OR NOT X1E THEN
            release_issued := FALSE;
            state := 410;
        END_IF;

    410: (* UNLOCK_FOR_TURN_TO_0 *)
        Y17 := FALSE;
        IF X1A THEN
            state := 420;
        END_IF;

    420: (* TURN_TO_POSITION_0 *)
        Y18 := TRUE;
        turn_started := TRUE;
        IF NOT X18 AND turn_started THEN
            Y18 := FALSE;
            turn_started := FALSE;
            state := 430;
        END_IF;

    430: (* LOCK_AT_POSITION_0 *)
        Y17 := TRUE;
        IF X19 THEN
            state := 440;
        END_IF;

    440: (* ACK_OUTPUT *)
        Y17 := TRUE;
        IF X1E THEN
            Y19 := TRUE;
            ack_started := TRUE;
            state := 450;
        END_IF;

    450: (* WAIT_ACK_DONE *)
        Y17 := TRUE;
        Y19 := FALSE;
        IF NOT X1E AND ack_started THEN
            ack_started := FALSE;
            ack_count := ack_count + 1;
            state := 460;
        END_IF;

    460: (* CHECK_IF_ALL_DONE *)
        Y17 := TRUE;
        IF good_count >= 6 AND ack_count >= 6 AND rework_count >= 2 AND NOT X18 AND X19 THEN
            IF NOT X14 AND NOT X15 AND NOT X16 AND NOT X17 AND NOT X25 THEN
                state := 900;
            END_IF;
        ELSIF NOT X11 AND bodies_processed < 10 THEN
            state := 20;
        ELSIF X11 THEN
            IF good_count >= 6 AND ack_count >= 6 AND rework_count >= 2 THEN
                state := 900;
            ELSE
                state := 460;
            END_IF;
        ELSE
            state := 460;
        END_IF;

    900: (* ASSERT_COMPLETE - all done, hold for 0.5s *)
        Y17 := TRUE;
        complete_asserted := TRUE;
        Y1A := TRUE;
        IF t_complete.Q THEN
            state := 910;
        END_IF;

    910: (* COMPLETE_HELD - maintain complete *)
        Y17 := TRUE;
        Y1A := TRUE;
        complete_asserted := TRUE;

END_CASE;

(* Safety: ensure rotation only when unlocked *)
IF state = 60 OR state = 120 OR state = 310 OR state = 420 THEN
    IF NOT X1A THEN
        Y18 := FALSE;
        turn_started := FALSE;
    END_IF;
END_IF;

(* Safety: ensure lock engaged for operations *)
IF state >= 10 AND state < 50 OR state >= 70 AND state < 110 OR state >= 130 AND state < 170 OR state >= 200 AND state < 270 OR state >= 320 AND state < 380 OR state >= 430 AND state < 460 OR state >= 900 THEN
    Y17 := TRUE;
END_IF;

(* Safety: rework clamp engaged during remove/reseat *)
IF state >= 220 AND state <= 250 THEN
    Y1C := TRUE;
END_IF;

(* Safety: prohibit rotation while ejector not home *)
IF (state = 310 OR state = 420) AND NOT X1B THEN
    Y18 := FALSE;
    turn_started := FALSE;
END_IF;

(* Prohibit rotation while return head not retreated *)
IF (state = 60 OR state = 120 OR state = 310 OR state = 420) AND return_started THEN
    Y18 := FALSE;
    turn_started := FALSE;
END_IF;

END_PROGRAM