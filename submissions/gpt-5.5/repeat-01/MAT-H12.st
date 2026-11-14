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
    (* Add internal variables here. *)
    accepted_a : INT := 0;
    accepted_b : INT := 0;
    a_to_eject : INT := 0;
    b_to_eject : INT := 0;
    good_received : INT := 0;
    a_exit_wait : BOOL := FALSE;
    b_exit_wait : BOOL := FALSE;
    a_exit_seen_occupied : BOOL := FALSE;
    b_exit_seen_occupied : BOOL := FALSE;
    a_feed_latch : BOOL := FALSE;
    b_feed_latch : BOOL := FALSE;
    a_load_needed : BOOL := FALSE;
    b_load_needed : BOOL := FALSE;
    a_can_start : BOOL := FALSE;
    b_can_start : BOOL := FALSE;
    cap_value : INT := 6;
    load_value : INT := 0;
    a_size : INT := 3;
    b_size : INT := 2;
    swapped : BOOL := FALSE;
    swapped_count : INT := 0;
    retrieval_occupied : BOOL := FALSE;
    return_take_requested : BOOL := FALSE;
    return_busy_seen : BOOL := FALSE;
    residual_total : INT := 0;
    complete_latched : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

Y10 := FALSE;
Y11 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;

IF D3 > 0 THEN
    cap_value := D3;
ELSE
    cap_value := 6;
END_IF;

a_size := 3;
IF (D6 > 0) AND (D6 <= 6) THEN
    a_size := D6;
END_IF;

b_size := 2;
IF (D8 > 0) AND (D8 <= 6) THEN
    b_size := D8;
END_IF;

IF a_exit_wait THEN
    IF NOT X1B THEN
        a_exit_seen_occupied := TRUE;
    END_IF;
    IF a_exit_seen_occupied AND X1B THEN
        good_received := good_received + 1;
        a_exit_wait := FALSE;
        a_exit_seen_occupied := FALSE;
    END_IF;
END_IF;

IF b_exit_wait THEN
    IF NOT X21 THEN
        b_exit_seen_occupied := TRUE;
    END_IF;
    IF b_exit_seen_occupied AND X21 THEN
        good_received := good_received + 1;
        b_exit_wait := FALSE;
        b_exit_seen_occupied := FALSE;
    END_IF;
END_IF;

IF (a_to_eject > 0) AND X1A AND X1B AND (NOT a_exit_wait) THEN
    Y15 := TRUE;
    a_to_eject := a_to_eject - 1;
    a_exit_wait := TRUE;
    a_exit_seen_occupied := FALSE;
END_IF;

IF (b_to_eject > 0) AND X20 AND X21 AND (NOT b_exit_wait) THEN
    Y18 := TRUE;
    b_to_eject := b_to_eject - 1;
    b_exit_wait := TRUE;
    b_exit_seen_occupied := FALSE;
END_IF;

a_load_needed := FALSE;
IF accepted_a = 0 THEN
    a_load_needed := TRUE;
ELSIF (accepted_a = 1) AND (accepted_b >= 1) THEN
    a_load_needed := TRUE;
END_IF;

b_load_needed := accepted_b = 0;

IF a_feed_latch THEN
    IF X17 OR X19 OR X1A OR (NOT a_load_needed) THEN
        a_feed_latch := FALSE;
    END_IF;
END_IF;

IF b_feed_latch THEN
    IF X1D OR X1F OR X20 OR (NOT b_load_needed) THEN
        b_feed_latch := FALSE;
    END_IF;
END_IF;

IF (NOT a_feed_latch) AND a_load_needed AND X16 AND (NOT X17) AND (NOT X19) AND (NOT X1A) THEN
    a_feed_latch := TRUE;
END_IF;

IF (NOT b_feed_latch) AND b_load_needed AND X1C AND (NOT X1D) AND (NOT X1F) AND (NOT X20) THEN
    b_feed_latch := TRUE;
END_IF;

Y13 := a_feed_latch AND a_load_needed AND (NOT X17) AND (NOT X19) AND (NOT X1A);
Y16 := b_feed_latch AND b_load_needed AND (NOT X1D) AND (NOT X1F) AND (NOT X20);

load_value := D0 + D1;

b_can_start := (accepted_b < 1) AND X1D AND (NOT X1F) AND (NOT X20) AND (D7 = 2) AND X10 AND (NOT X11);

a_can_start := FALSE;
IF X17 AND (NOT X19) AND (NOT X1A) AND X10 AND (NOT X11) AND (accepted_a < 2) THEN
    IF (accepted_a = 0) AND (D5 = 1) THEN
        a_can_start := TRUE;
    ELSIF (accepted_a = 1) AND (accepted_b >= 1) AND swapped AND (D5 = 3) THEN
        a_can_start := TRUE;
    END_IF;
END_IF;

IF b_can_start AND ((load_value + b_size) <= cap_value) THEN
    Y17 := TRUE;
    accepted_b := accepted_b + 1;
    b_to_eject := b_to_eject + 1;
    load_value := load_value + b_size;
END_IF;

IF a_can_start AND ((load_value + a_size) <= cap_value) THEN
    Y14 := TRUE;
    accepted_a := accepted_a + 1;
    a_to_eject := a_to_eject + 1;
    load_value := load_value + a_size;
END_IF;

IF return_take_requested THEN
    IF X14 THEN
        return_busy_seen := TRUE;
    END_IF;
    IF return_busy_seen AND (NOT X14) THEN
        retrieval_occupied := FALSE;
        return_take_requested := FALSE;
        return_busy_seen := FALSE;
    END_IF;
END_IF;

IF retrieval_occupied AND (NOT return_take_requested) AND X13 AND (NOT X14) THEN
    Y11 := TRUE;
    return_take_requested := TRUE;
    return_busy_seen := FALSE;
END_IF;

IF (NOT swapped) AND (accepted_a >= 1) AND (accepted_b >= 1) AND (D1 = 0) AND X15 AND (D0 > 0) AND X10 AND (NOT X11) AND X12 AND (NOT retrieval_occupied) AND (NOT X14) THEN
    Y10 := TRUE;
    swapped := TRUE;
    swapped_count := D0;
    retrieval_occupied := TRUE;
    return_take_requested := FALSE;
    return_busy_seen := FALSE;
END_IF;

residual_total := swapped_count + D0;

IF (NOT complete_latched) THEN
    IF (accepted_a >= 2) AND (accepted_b >= 1) AND (good_received >= 3) AND swapped AND (D1 = 0) AND X15 AND (residual_total >= 8) AND X10 AND (NOT X11) AND (NOT retrieval_occupied) AND (NOT return_take_requested) AND (NOT X14) AND (NOT a_exit_wait) AND (NOT b_exit_wait) THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

Y12 := complete_latched;

END_PROGRAM