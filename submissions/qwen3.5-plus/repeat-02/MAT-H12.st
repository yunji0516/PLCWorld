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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    (* Rising edge detectors for bin exchange signals *)
    swap_edge : R_TRIG;
    take_bin_edge : R_TRIG;

    (* Press A state machine states *)
    a_idle : INT := 0;
    a_feeding : INT := 1;
    a_processing : INT := 2;
    a_done_state : INT := 3;
    a_ejecting : INT := 4;

    (* Press B state machine states *)
    b_idle : INT := 0;
    b_feeding : INT := 1;
    b_processing : INT := 2;
    b_done_state : INT := 3;
    b_ejecting : INT := 4;

    (* Press A state tracking *)
    a_state : INT := 0;

    (* Press B state tracking *)
    b_state : INT := 0;

    (* Batch sizes: batch 1/2 (type A) = 3 residuals, batch 3 (type B) = 2 residuals *)
    a_batch_size : INT := 3;
    b_batch_size : INT := 2;

    (* Bin exchange state machine: 0=idle, 1=swap_pulsed, 2=wait_return, 3=done *)
    bin_exchange_state : INT := 0;

    (* Completion tracking *)
    complete_count : INT := 0;
    complete_set : BOOL := FALSE;

    (* Temp variables *)
    capacity_available : BOOL;
    all_trays : BOOL;
    no_residuals : BOOL;
    residuals_in_bin : BOOL;
END_VAR

(* Main control logic - only active when start command is asserted *)
IF X0 THEN
    (* === Capacity check: occupied + pending + new_batch_size <= 6 === *)
    capacity_available := (DINT(D0) + DINT(D1) + DINT(a_batch_size)) <= DINT(D3);

    (* === Press A state machine === *)
    CASE a_state OF
        a_idle:
            (* Accept new batch when source available, bin docked, and capacity allows *)
            IF X16 AND X10 AND capacity_available THEN
                feed_a := TRUE;
                a_state := a_feeding;
            END_IF;

        a_feeding:
            (* Feed remains TRUE during feeding - press module handles transfer *)
            IF X19 OR X1A THEN
                (* Feed complete - pulse start_a rising edge to accept batch *)
                feed_a := FALSE;
                start_a := TRUE;
                a_state := a_processing;
            END_IF;

        a_processing:
            (* Start_a already pulsed - press is running *)
            IF X1A THEN
                a_state := a_done_state;
            END_IF;

        a_done_state:
            (* Press done - wait for exit to be clear before ejecting *)
            IF X1B THEN
                eject_a := TRUE;
                a_state := a_ejecting;
            END_IF;

        a_ejecting:
            (* Eject done - return to idle for next batch *)
            eject_a := FALSE;
            a_state := a_idle;
    END_CASE;

    (* Ensure all outputs are LOW in idle state *)
    IF a_state = a_idle THEN
        feed_a := FALSE;
        start_a := FALSE;
        eject_a := FALSE;
    END_IF;

    (* === Press B state machine === *)
    CASE b_state OF
        b_idle:
            (* Accept new batch when source available, bin docked, and capacity allows *)
            IF X1C AND X10 AND capacity_available THEN
                feed_b := TRUE;
                b_state := b_feeding;
            END_IF;

        b_feeding:
            (* Feed remains TRUE during feeding *)
            IF X1F OR X20 THEN
                feed_b := FALSE;
                start_b := TRUE;
                b_state := b_processing;
            END_IF;

        b_processing:
            IF X20 THEN
                b_state := b_done_state;
            END_IF;

        b_done_state:
            IF X21 THEN
                eject_b := TRUE;
                b_state := b_ejecting;
            END_IF;

        b_ejecting:
            eject_b := FALSE;
            b_state := b_idle;
    END_CASE;

    (* Ensure all outputs are LOW in idle state *)
    IF b_state = b_idle THEN
        feed_b := FALSE;
        start_b := FALSE;
        eject_b := FALSE;
    END_IF;

    (* === Bin exchange logic === *)
    (* Swap exchange: only when pending=0, residuals in docked bin, spare ready, retrieval spot vacant *)
    residuals_in_bin := DINT(D0) > 0;

    CASE bin_exchange_state OF
        0:
            (* Idle - check all swap conditions *)
            IF DINT(D1) = 0 AND residuals_in_bin AND X12 AND NOT X13 THEN
                swap := TRUE;
                bin_exchange_state := 1;
            END_IF;

        1:
            (* Swap pulsing - wait for swap_busy to go FALSE (swap complete) *)
            swap := FALSE;
            IF NOT X11 THEN
                bin_exchange_state := 2;
            END_IF;

        2:
            (* Waiting for return_ready - bin exchange complete, ready to take back *)
            IF X13 THEN
                take_bin := TRUE;
                bin_exchange_state := 3;
            END_IF;

        3:
            (* Pulse take_bin and reset exchange state *)
            take_bin := FALSE;
            bin_exchange_state := 0;
    END_CASE;

    (* === Completion condition === *)
    all_trays := DINT(D4) >= 3;
    no_residuals := DINT(D1) <= 0;

    IF all_trays AND no_residuals THEN
        complete_count := complete_count + 1;
        IF complete_count >= 50 THEN
            complete_set := TRUE;
        END_IF;
    ELSE
        complete_count := 0;
    END_IF;

    Y12 := complete_set;

ELSE
    (* Start not asserted - reset all outputs *)
    feed_a := FALSE;
    start_a := FALSE;
    eject_a := FALSE;
    feed_b := FALSE;
    start_b := FALSE;
    eject_b := FALSE;
    swap := FALSE;
    take_bin := FALSE;
    complete := FALSE;
    complete_set := FALSE;
    complete_count := 0;
    a_state := a_idle;
    b_state := b_idle;
    bin_exchange_state := 0;
END_IF;

END_PROGRAM