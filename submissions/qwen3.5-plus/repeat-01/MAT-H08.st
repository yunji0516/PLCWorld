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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    st : INT := 0;
    pitch_count : INT := 0;
    recovery_count : INT := 0;
    start_seen : BOOL := FALSE;
    exchange_done : BOOL := FALSE;
    prev_waste_full : BOOL := FALSE;
    prev_pitch_avail : BOOL := FALSE;
    prev_recovery_avail : BOOL := FALSE;
    prev_exit_recv : BOOL := FALSE;
    prev_recovery_done : BOOL := FALSE;
    prev_cut_done : BOOL := FALSE;
    prev_held : BOOL := FALSE;
    prev_clamped : BOOL := FALSE;
    prev_bed_low : BOOL := FALSE;
    prev_empty_core : BOOL := FALSE;
    prev_core_docked : BOOL := FALSE;
    prev_left_thread : BOOL := FALSE;
    prev_right_thread : BOOL := FALSE;
    prev_recovery_conn : BOOL := FALSE;
    prev_edges_cut : BOOL := FALSE;
    prev_feed_busy : BOOL := FALSE;
    complete_timer : TON;
    edge_hold_timer : TON;
    cut_pulse_timer : TON;
    pickup_pulse_timer : TON;
    accept_pitch_pulse_timer : TON;
    unload_reel_pulse_timer : TON;
    load_core_pulse_timer : TON;
    feed_done_flag : BOOL := FALSE;
    recovery_done_flag : BOOL := FALSE;
END_VAR

BEGIN

    accept_pitch_pulse_timer(IN := FALSE, PT := T#50ms);
    cut_pulse_timer(IN := FALSE, PT := T#50ms);
    pickup_pulse_timer(IN := FALSE, PT := T#50ms);
    unload_reel_pulse_timer(IN := FALSE, PT := T#50ms);
    load_core_pulse_timer(IN := FALSE, PT := T#50ms);

    Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
    Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE;
    Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;
    D200 := 0;

    CASE st OF
        0:
            IF X0 AND NOT start_seen THEN
                start_seen := TRUE;
                st := 1;
            END_IF;

        1:
            IF X10 AND NOT prev_pitch_avail THEN
                st := 2;
            END_IF;
            prev_pitch_avail := X10;

        2:
            Y10 := TRUE;
            st := 3;

        3:
            Y11 := TRUE;
            IF (D3 >= 300) OR (X11 = FALSE AND prev_feed_busy = TRUE) THEN
                Y11 := FALSE;
                st := 4;
            END_IF;
            prev_feed_busy := X11;

        4:
            Y12 := TRUE;
            IF X15 AND NOT prev_clamped THEN
                st := 5;
            END_IF;
            prev_clamped := X15;

        5:
            D200 := 15;
            st := 6;

        6:
            Y13 := TRUE;
            st := 7;

        7:
            IF X14 AND NOT prev_cut_done THEN
                Y13 := FALSE;
                D200 := 0;
                st := 8;
            END_IF;
            prev_cut_done := X14;

        8:
            Y14 := TRUE;
            st := 9;

        9:
            IF X16 AND NOT prev_held THEN
                Y14 := FALSE;
                st := 10;
            END_IF;
            prev_held := X16;

        10:
            Y15 := TRUE;
            IF X17 AND NOT prev_bed_low THEN
                st := 11;
            END_IF;
            prev_bed_low := X17;

        11:
            Y16 := TRUE;
            IF X1A OR X19 THEN
                st := 12;
            END_IF;

        12:
            Y1A := TRUE;
            pitch_count := pitch_count + 1;
            st := 13;

        13:
            IF pitch_count >= 6 THEN
                st := 20;
            ELSE
                st := 1;
            END_IF;

        20:
            IF X1B AND NOT prev_recovery_avail THEN
                st := 21;
            END_IF;
            prev_recovery_avail := X1B;

        21:
            Y17 := TRUE;
            st := 22;

        22:
            Y18 := TRUE;
            IF X21 AND NOT prev_waste_full AND NOT exchange_done THEN
                Y18 := FALSE;
                st := 30;
            ELSIF X1D AND NOT prev_recovery_done THEN
                Y18 := FALSE;
                st := 23;
            END_IF;
            prev_waste_full := X21;
            prev_recovery_done := X1D;

        23:
            Y19 := TRUE;
            recovery_count := recovery_count + 1;
            IF recovery_count >= 4 THEN
                st := 40;
            ELSE
                st := 20;
            END_IF;

        30:
            Y1C := TRUE;
            edge_hold_timer(IN := TRUE, PT := T#300ms);
            IF edge_hold_timer.Q THEN
                st := 31;
            END_IF;

        31:
            Y1D := TRUE;
            Y1E := TRUE;
            IF X23 AND NOT prev_edges_cut THEN
                Y1D := FALSE;
                Y1E := FALSE;
                st := 32;
            END_IF;
            prev_edges_cut := X23;

        32:
            Y1F := TRUE;
            st := 33;

        33:
            IF X24 = FALSE THEN
                Y1F := FALSE;
                st := 34;
            END_IF;

        34:
            IF X25 AND NOT prev_empty_core THEN
                st := 35;
            END_IF;
            prev_empty_core := X25;

        35:
            Y20 := TRUE;
            st := 36;

        36:
            IF X26 AND NOT prev_core_docked THEN
                Y20 := FALSE;
                st := 37;
            END_IF;
            prev_core_docked := X26;

        37:
            Y21 := TRUE;
            IF X27 AND NOT prev_left_thread THEN
                Y21 := FALSE;
                st := 38;
            END_IF;
            prev_left_thread := X27;

        38:
            Y22 := TRUE;
            IF X28 AND NOT prev_right_thread THEN
                Y22 := FALSE;
                st := 39;
            END_IF;
            prev_right_thread := X28;

        39:
            Y1C := FALSE;
            exchange_done := TRUE;
            IF X29 AND NOT prev_recovery_conn THEN
                st := 21;
            END_IF;
            prev_recovery_conn := X29;

        40:
            IF pitch_count >= 6 AND recovery_count >= 4 AND X18 = FALSE AND X16 = FALSE AND X13 = FALSE AND X11 = FALSE AND X24 = FALSE THEN
                complete_timer(IN := TRUE, PT := T#500ms);
                IF complete_timer.Q THEN
                    Y1B := TRUE;
                END_IF;
            END_IF;
    END_CASE;

    prev_pitch_avail := X10;
    prev_recovery_avail := X1B;
    prev_exit_recv := X1A;
    prev_recovery_done := X1D;
    prev_cut_done := X14;
    prev_held := X16;
    prev_clamped := X15;
    prev_bed_low := X17;
    prev_empty_core := X25;
    prev_core_docked := X26;
    prev_left_thread := X27;
    prev_right_thread := X28;
    prev_recovery_conn := X29;
    prev_edges_cut := X23;
    prev_waste_full := X21;
    prev_feed_busy := X11;

END_PROGRAM