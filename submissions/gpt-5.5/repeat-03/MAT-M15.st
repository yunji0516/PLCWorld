PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    (* Add internal variables here. *)
    start_edge : R_TRIG;
    started : BOOL;
    completed : BOOL;
    dispatching : BOOL;
    req_count : INT;
    net_count : INT;
    zone : INT;
    prev_zone : INT;
    pass_state : INT;
    fwd_pulse : BOOL;
    rev_pulse : BOOL;
    normal_wait : BOOL;
    pending_after_forward : BOOL;
    pending_wait_clear : BOOL;
    pulse_on : BOOL := TRUE;
    pulse_counter : INT;
    post_counter : INT;
END_VAR

start_edge(CLK := X10);

fwd_pulse := FALSE;
rev_pulse := FALSE;

IF X20 THEN
    IF X21 THEN
        zone := 3;
    ELSE
        zone := 1;
    END_IF;
ELSE
    IF X21 THEN
        zone := 2;
    ELSE
        zone := 0;
    END_IF;
END_IF;

IF zone <> prev_zone THEN
    CASE pass_state OF
        0:
            IF zone = 1 THEN
                pass_state := 1;
            ELSIF zone = 2 THEN
                pass_state := 5;
            ELSE
                pass_state := 0;
            END_IF;
        1:
            IF zone = 3 THEN
                pass_state := 2;
            ELSIF zone = 0 THEN
                pass_state := 0;
            ELSIF zone = 2 THEN
                pass_state := 5;
            END_IF;
        2:
            IF zone = 2 THEN
                pass_state := 3;
            ELSIF zone = 1 THEN
                pass_state := 1;
            ELSIF zone = 0 THEN
                pass_state := 0;
            END_IF;
        3:
            IF zone = 0 THEN
                fwd_pulse := TRUE;
                pass_state := 0;
            ELSIF zone = 3 THEN
                pass_state := 2;
            ELSIF zone = 1 THEN
                pass_state := 1;
            END_IF;
        5:
            IF zone = 3 THEN
                pass_state := 6;
            ELSIF zone = 0 THEN
                pass_state := 0;
            ELSIF zone = 1 THEN
                pass_state := 1;
            END_IF;
        6:
            IF zone = 1 THEN
                pass_state := 7;
            ELSIF zone = 2 THEN
                pass_state := 5;
            ELSIF zone = 0 THEN
                pass_state := 0;
            END_IF;
        7:
            IF zone = 0 THEN
                rev_pulse := TRUE;
                pass_state := 0;
            ELSIF zone = 3 THEN
                pass_state := 6;
            ELSIF zone = 2 THEN
                pass_state := 5;
            END_IF;
    ELSE
        pass_state := 0;
    END_CASE;
    prev_zone := zone;
END_IF;

IF start_edge.Q AND NOT started THEN
    started := TRUE;
    completed := FALSE;
    dispatching := FALSE;
    net_count := 0;
    normal_wait := FALSE;
    pending_after_forward := FALSE;
    pending_wait_clear := FALSE;
    pulse_on := TRUE;
    pulse_counter := 0;
    post_counter := 0;
    pass_state := 0;
    prev_zone := zone;
    IF D10 <= 2 THEN
        req_count := 2;
    ELSE
        req_count := 3;
    END_IF;
END_IF;

IF started AND NOT completed THEN
    IF fwd_pulse THEN
        IF net_count < 5 THEN
            net_count := net_count + 1;
        END_IF;
        IF X22 THEN
            pending_after_forward := TRUE;
            pending_wait_clear := FALSE;
            post_counter := 0;
            normal_wait := FALSE;
        ELSE
            normal_wait := TRUE;
        END_IF;
    END_IF;

    IF rev_pulse THEN
        IF net_count > 0 THEN
            net_count := net_count - 1;
        END_IF;
        normal_wait := FALSE;
        pending_after_forward := FALSE;
        IF X22 THEN
            pending_wait_clear := TRUE;
        ELSE
            pending_wait_clear := FALSE;
        END_IF;
    END_IF;

    IF (NOT X22) AND X23 AND X24 AND (zone = 0) THEN
        normal_wait := FALSE;
    END_IF;

    IF NOT X22 THEN
        pending_after_forward := FALSE;
        pending_wait_clear := FALSE;
        pulse_on := TRUE;
        pulse_counter := 0;
        post_counter := 0;
    END_IF;
END_IF;

IF NOT started THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
ELSIF completed THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
ELSE
    Y2 := FALSE;

    IF dispatching THEN
        Y20 := FALSE;
        IF X25 THEN
            Y21 := FALSE;
            Y2 := TRUE;
            completed := TRUE;
            dispatching := FALSE;
        ELSE
            Y21 := TRUE;
        END_IF;
    ELSE
        IF (net_count = req_count) AND (NOT X22) AND X23 AND X24 AND (zone = 0) THEN
            Y20 := FALSE;
            IF X25 THEN
                Y21 := FALSE;
                Y2 := TRUE;
                completed := TRUE;
            ELSE
                Y21 := TRUE;
                dispatching := TRUE;
            END_IF;
        ELSE
            Y21 := FALSE;

            IF X22 THEN
                IF pending_wait_clear THEN
                    Y20 := FALSE;
                ELSIF pending_after_forward THEN
                    IF post_counter < 70 THEN
                        Y20 := TRUE;
                        post_counter := post_counter + 1;
                    ELSE
                        Y20 := FALSE;
                        pending_wait_clear := TRUE;
                    END_IF;
                ELSE
                    IF pulse_on THEN
                        Y20 := TRUE;
                        IF pulse_counter < 40 THEN
                            pulse_counter := pulse_counter + 1;
                        ELSE
                            pulse_counter := 0;
                            pulse_on := FALSE;
                        END_IF;
                    ELSE
                        Y20 := FALSE;
                        IF pulse_counter < 150 THEN
                            pulse_counter := pulse_counter + 1;
                        ELSE
                            pulse_counter := 0;
                            pulse_on := TRUE;
                        END_IF;
                    END_IF;
                END_IF;
            ELSE
                IF normal_wait THEN
                    Y20 := FALSE;
                ELSIF net_count < req_count THEN
                    Y20 := TRUE;
                ELSE
                    Y20 := FALSE;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM