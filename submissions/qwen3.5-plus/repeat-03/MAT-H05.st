PROGRAM Main
VAR
    X0 : BOOL; X10 : BOOL; X11 : BOOL; X12 : BOOL; X13 : BOOL;
    X14 : BOOL; X15 : BOOL; X16 : BOOL; X17 : BOOL; X18 : BOOL;
    X19 : BOOL; X20 : BOOL; X21 : BOOL; X22 : BOOL; X23 : BOOL;
    X24 : BOOL; X25 : BOOL; X26 : BOOL; X27 : BOOL; X28 : BOOL;
    X29 : BOOL; Y10 : BOOL; Y11 : BOOL; Y12 : BOOL; Y13 : BOOL;
    Y14 : BOOL; Y15 : BOOL; Y16 : BOOL; Y17 : BOOL; Y18 : BOOL;
    Y19 : BOOL; D0 : INT; D1 : INT; D2 : INT; D3 : INT; D4 : INT;
    D5 : INT; D6 : INT; D7 : INT; D8 : INT; D9 : INT; D10 : INT;
    D200 : INT; X1A : BOOL; X1B : BOOL; X1C : BOOL; X1D : BOOL;
    X1E : BOOL; X1F : BOOL; X2A : BOOL; Y1A : BOOL; Y1B : BOOL;
    Y1C : BOOL; Y1D : BOOL; Y1E : BOOL; Y1F : BOOL;
    state : INT := 0;
    load_count : INT := 0;
    good_count : INT := 0;
    rework_count : INT := 0;
    generation : INT := 1;
    is_ng : BOOL := FALSE;
    skip_insert : BOOL := FALSE;
    returning_to_0 : BOOL := FALSE;
    load_busy_f : BOOL := FALSE;
    insert_busy_f : BOOL := FALSE;
    inspect_busy_f : BOOL := FALSE;
    eject_busy_f : BOOL := FALSE;
    rework_busy_f : BOOL := FALSE;
    return_busy_f : BOOL := FALSE;
    edge_start : R_TRIG;
    edge_exit_recv : R_TRIG;
    complete_tmr : TON;
END_VAR

Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE;
Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := TRUE;
Y18 := FALSE; Y19 := FALSE;
Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;
D200 := generation;
Y1A := FALSE;

edge_start(CLK := X0);
edge_exit_recv(CLK := X1E);

CASE state OF
    0: // IDLE - wait for start
        Y17 := TRUE;
        IF edge_start.Q THEN
            state := 10;
        END_IF;

    10: // LOAD body at position 0
        Y17 := TRUE;
        Y10 := TRUE;
        Y11 := TRUE;
        IF X14 THEN
            load_busy_f := TRUE;
        END_IF;
        IF load_busy_f AND NOT X14 THEN
            Y10 := FALSE;
            Y11 := FALSE;
            load_busy_f := FALSE;
            load_count := load_count + 1;
            skip_insert := FALSE;
            state := 20;
        END_IF;

    20: // UNLOCK before rotation
        Y17 := FALSE;
        IF X1A THEN
            state := 30;
        END_IF;

    30: // TURN rotation
        Y17 := FALSE;
        Y18 := TRUE;
        IF X18 THEN
            Y18 := FALSE;
            state := 35;
        END_IF;

    35: // Wait for rotation to stop
        Y17 := FALSE;
        IF NOT X18 THEN
            state := 40;
        END_IF;

    40: // LOCK after rotation
        Y17 := TRUE;
        IF X19 THEN
            IF returning_to_0 THEN
                returning_to_0 := FALSE;
                skip_insert := FALSE;
                state := 10;
            ELSIF skip_insert THEN
                state := 60;
            ELSE
                state := 50;
            END_IF;
        END_IF;

    50: // INSERT at position 1
        Y17 := TRUE;
        Y12 := TRUE;
        IF X15 THEN
            insert_busy_f := TRUE;
        END_IF;
        IF insert_busy_f AND NOT X15 THEN
            Y12 := FALSE;
            insert_busy_f := FALSE;
            state := 60;
        END_IF;

    60: // UNLOCK before rotation 1->2
        Y17 := FALSE;
        IF X1A THEN
            state := 70;
        END_IF;

    70: // TURN to position 2
        Y17 := FALSE;
        Y18 := TRUE;
        IF X18 THEN
            Y18 := FALSE;
            state := 75;
        END_IF;

    75: // Wait for rotation to stop
        Y17 := FALSE;
        IF NOT X18 THEN
            state := 80;
        END_IF;

    80: // LOCK after rotation 1->2
        Y17 := TRUE;
        IF X19 THEN
            state := 90;
        END_IF;

    90: // INSPECT at position 2
        Y17 := TRUE;
        Y13 := TRUE;
        IF X16 THEN
            inspect_busy_f := TRUE;
        END_IF;
        IF inspect_busy_f AND NOT X16 THEN
            Y13 := FALSE;
            inspect_busy_f := FALSE;
            is_ng := X24;
            state := 100;
        END_IF;

    100: // UNLOCK before rotation 2->3
        Y17 := FALSE;
        IF X1A THEN
            state := 110;
        END_IF;

    110: // TURN to position 3
        Y17 := FALSE;
        Y18 := TRUE;
        IF X18 THEN
            Y18 := FALSE;
            state := 115;
        END_IF;

    115: // Wait for rotation to stop
        Y17 := FALSE;
        IF NOT X18 THEN
            state := 120;
        END_IF;

    120: // LOCK after rotation 2->3
        Y17 := TRUE;
        IF X19 THEN
            state := 130;
        END_IF;

    130: // DECIDE: NG or good
        Y17 := TRUE;
        IF is_ng THEN
            state := 200;
        ELSE
            state := 140;
        END_IF;

    140: // EJECT extend
        Y17 := TRUE;
        Y14 := TRUE;
        IF X17 THEN
            eject_busy_f := TRUE;
        END_IF;
        IF eject_busy_f AND NOT X17 THEN
            Y14 := FALSE;
            eject_busy_f := FALSE;
            state := 150;
        END_IF;

    150: // RETRACT ejector
        Y17 := TRUE;
        Y15 := TRUE;
        IF X1B THEN
            Y15 := FALSE;
            state := 160;
        END_IF;

    160: // RELEASE output (check conditions)
        Y17 := TRUE;
        IF X20 AND X1B AND X1D THEN
            Y16 := TRUE;
            state := 170;
        END_IF;

    170: // WAIT for exit received
        Y17 := TRUE;
        Y16 := FALSE;
        IF X1E OR edge_exit_recv.Q THEN
            state := 180;
        END_IF;

    180: // ACK exit
        Y17 := TRUE;
        Y19 := TRUE;
        IF NOT X1E THEN
            Y19 := FALSE;
            good_count := good_count + 1;
            state := 190;
        END_IF;

    190: // CHECK if more products to load
        Y17 := TRUE;
        IF load_count < 6 THEN
            returning_to_0 := TRUE;
            state := 20;
        ELSE
            state := 300;
        END_IF;

    200: // REWORK to_rework
        Y17 := TRUE;
        Y1B := TRUE;
        IF X25 THEN
            rework_busy_f := TRUE;
        END_IF;
        IF rework_busy_f AND NOT X25 THEN
            Y1B := FALSE;
            rework_busy_f := FALSE;
            state := 210;
        END_IF;

    210: // REWORK clamp
        Y17 := TRUE;
        Y1C := TRUE;
        IF X27 THEN
            state := 220;
        END_IF;

    220: // REWORK remove_insert
        Y17 := TRUE;
        Y1C := TRUE;
        Y1D := TRUE;
        IF X28 THEN
            Y1D := FALSE;
            state := 230;
        END_IF;

    230: // REWORK reseat_insert
        Y17 := TRUE;
        Y1C := TRUE;
        Y1E := TRUE;
        IF X29 THEN
            Y1E := FALSE;
            state := 240;
        END_IF;

    240: // REWORK release clamp
        Y17 := TRUE;
        Y1C := FALSE;
        IF NOT X27 THEN
            state := 250;
        END_IF;

    250: // REWORK return_body to position 0
        Y17 := TRUE;
        Y1F := TRUE;
        IF (X26 OR X2A) THEN
            return_busy_f := TRUE;
        END_IF;
        IF return_busy_f AND NOT X26 AND NOT X2A THEN
            Y1F := FALSE;
            return_busy_f := FALSE;
            generation := generation + 1;
            D200 := generation;
            rework_count := rework_count + 1;
            skip_insert := TRUE;
            state := 20;
        END_IF;

    300: // COMPLETION check
        Y17 := TRUE;
        Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE;
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE;
        Y18 := FALSE; Y19 := FALSE;
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;
        IF good_count >= 6 AND rework_count >= 2 AND
           X19 AND NOT X18 AND NOT X14 AND NOT X15 AND NOT X16 AND
           NOT X17 AND X1B AND NOT X25 THEN
            complete_tmr(IN := TRUE, PT := T#500ms);
            IF complete_tmr.Q THEN
                Y1A := TRUE;
            END_IF;
        ELSE
            Y1A := FALSE;
            complete_tmr(IN := FALSE, PT := T#500ms);
        END_IF;

END_CASE;

END_PROGRAM