PROGRAM Main
VAR
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D18 : DINT;
    D19 : DINT;
    D20 : DINT;
    D21 : DINT;
    D100 : DINT;
    X30 : BOOL;
    X32 : BOOL;
    D104 : DINT;
    D103 : DINT;
    D110 : DINT;
    X31 : BOOL;
    X33 : BOOL;
    D114 : DINT;
    D113 : DINT;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    D93 : DINT;
    D94 : DINT;
    D95 : DINT;
    D96 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    X54 : BOOL;
    X55 : BOOL;
    X56 : BOOL;
    X57 : BOOL;
    D150 : DINT;
    D151 : DINT;
    D200 : DINT;
    D201 : DINT;
    Y20 : BOOL;
    D204 : DINT;
    D205 : DINT;
    Y21 : BOOL;
    D208 : DINT;
    D209 : DINT;
    Y22 : BOOL;
    D212 : DINT;
    D213 : DINT;
    Y23 : BOOL;
    D216 : DINT;
    D217 : DINT;
    Y24 : BOOL;
    D220 : DINT;
    D221 : DINT;
    Y25 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y2 : BOOL;

    (* ---- internal constants ---- *)
    PORT_HOISTA : DINT := -90000;
    PORT_HOISTB : DINT := -35000;
    PORT_STANDBY : DINT := 15000;
    PORT_TABLE : DINT := 85000;
    FORK_CONNECT : DINT := 18000;
    LIFT_CONNECT : DINT := 73250;
    SLIDE_RETRACT : DINT := 5000;
    POS_TOL : DINT := 20;
    SPD_TOL : DINT := 100;

    (* ---- shared resources ---- *)
    shuttle_owner : INT := 0;
    table_owner : INT := 0;
    seq : DINT := 0;

    (* ---- lane 0 (request A / Lift A) ---- *)
    phase0 : INT := 0;
    leg_step0 : INT := 0;
    leg_from_station0 : DINT;
    leg_to_station0 : DINT;
    leg_from_port0 : DINT;
    leg_to_port0 : DINT;
    leg_next_phase0 : INT;
    cmd_issued0 : BOOL;
    last_id0 : DINT := 0;

    (* ---- lane 1 (request B / Lift B) ---- *)
    phase1 : INT := 0;
    leg_step1 : INT := 0;
    leg_from_station1 : DINT;
    leg_to_station1 : DINT;
    leg_from_port1 : DINT;
    leg_to_port1 : DINT;
    leg_next_phase1 : INT;
    cmd_issued1 : BOOL;
    last_id1 : DINT := 0;

    (* ---- final completion ---- *)
    final_ready : BOOL;
    y2_latch : BOOL := FALSE;
    ton100 : TON;
END_VAR

(* fixed drive ratios *)
D201 := 1000;
D205 := 1000;
D209 := 1000;
D213 := 1000;
D217 := 1000;
D221 := 1000;

(* ============================================================= *)
(* Lane 0 macro state machine                                    *)
(* ============================================================= *)
CASE phase0 OF

0:
    IF D100 <> 0 AND D100 <> last_id0 THEN
        last_id0 := D100;
        phase0 := 1;
    END_IF;

1:
    IF table_owner = 0 OR table_owner = 1 THEN
        table_owner := 1;
        leg_from_station0 := 1;
        leg_from_port0 := PORT_HOISTA;
        leg_to_station0 := 4;
        leg_to_port0 := PORT_TABLE;
        leg_next_phase0 := 3;
    ELSE
        leg_from_station0 := 1;
        leg_from_port0 := PORT_HOISTA;
        leg_to_station0 := 3;
        leg_to_port0 := PORT_STANDBY;
        leg_next_phase0 := 20;
    END_IF;
    phase0 := 2;
    leg_step0 := 0;

2:
    CASE leg_step0 OF
    0:
        IF shuttle_owner = 0 OR shuttle_owner = 1 THEN
            shuttle_owner := 1;
            IF D12 <= 4000 THEN
                D200 := leg_from_port0;
            END_IF;
            Y20 := TRUE;
            leg_step0 := 1;
        END_IF;
    1:
        IF ABS(D10 - leg_from_port0) <= POS_TOL AND ABS(D11) <= SPD_TOL THEN
            leg_step0 := 2;
        END_IF;
    2:
        CASE leg_from_station0 OF
        1:
            D208 := LIFT_CONNECT;
            Y22 := TRUE;
            IF X54 THEN
                leg_step0 := 3;
            END_IF;
        3:
            leg_step0 := 3;
        4:
            IF X56 THEN
                leg_step0 := 3;
            END_IF;
        END_CASE;
    3:
        D204 := FORK_CONNECT;
        Y21 := TRUE;
        IF ABS(D12 - FORK_CONNECT) <= POS_TOL AND ABS(D13) <= SPD_TOL THEN
            leg_step0 := 4;
        END_IF;
    4:
        IF NOT cmd_issued0 THEN
            seq := seq + 1;
            D80 := 1;
            D81 := leg_from_station0;
            D82 := seq;
            cmd_issued0 := TRUE;
        END_IF;
        IF D104 = 0 THEN
            cmd_issued0 := FALSE;
            leg_step0 := 5;
        END_IF;
    5:
        D204 := 0;
        IF ABS(D12 - 0) <= POS_TOL AND ABS(D13) <= SPD_TOL THEN
            IF leg_from_station0 = 4 THEN
                table_owner := 0;
            END_IF;
            leg_step0 := 6;
        END_IF;
    6:
        IF D12 <= 4000 THEN
            D200 := leg_to_port0;
        END_IF;
        leg_step0 := 7;
    7:
        IF ABS(D10 - leg_to_port0) <= POS_TOL AND ABS(D11) <= SPD_TOL THEN
            leg_step0 := 8;
        END_IF;
    8:
        CASE leg_to_station0 OF
        1:
            D208 := LIFT_CONNECT;
            Y22 := TRUE;
            IF X54 THEN
                leg_step0 := 9;
            END_IF;
        3:
            leg_step0 := 9;
        4:
            IF X56 THEN
                leg_step0 := 9;
            END_IF;
        END_CASE;
    9:
        D204 := FORK_CONNECT;
        IF ABS(D12 - FORK_CONNECT) <= POS_TOL AND ABS(D13) <= SPD_TOL THEN
            leg_step0 := 10;
        END_IF;
    10:
        IF NOT cmd_issued0 THEN
            seq := seq + 1;
            D80 := 2;
            D81 := leg_to_station0;
            D82 := seq;
            cmd_issued0 := TRUE;
        END_IF;
        IF D104 = leg_to_station0 THEN
            cmd_issued0 := FALSE;
            leg_step0 := 11;
        END_IF;
    11:
        D204 := 0;
        IF ABS(D12 - 0) <= POS_TOL AND ABS(D13) <= SPD_TOL THEN
            shuttle_owner := 0;
            phase0 := leg_next_phase0;
            leg_step0 := 0;
        END_IF;
    END_CASE;

3:
    D216 := D94;
    Y24 := TRUE;
    IF X53 THEN
        phase0 := 4;
    END_IF;

4:
    D220 := D95;
    Y25 := TRUE;
    IF X30 THEN
        phase0 := 5;
    END_IF;

5:
    D220 := SLIDE_RETRACT;
    IF ABS(D20 - SLIDE_RETRACT) <= POS_TOL AND ABS(D21) <= SPD_TOL THEN
        phase0 := 6;
    END_IF;

6:
    D216 := 0;
    IF ABS(D18 - 0) <= POS_TOL AND ABS(D19) <= SPD_TOL THEN
        leg_from_station0 := 4;
        leg_from_port0 := PORT_TABLE;
        leg_to_station0 := 1;
        leg_to_port0 := PORT_HOISTA;
        leg_next_phase0 := 7;
        phase0 := 2;
        leg_step0 := 0;
    END_IF;

7:
    D208 := D150;
    Y22 := TRUE;
    IF X32 THEN
        phase0 := 8;
    END_IF;

8:
    D300 := last_id0;
    D301 := 1;
    phase0 := 9;

9:
    IF D100 <> 0 AND D100 <> last_id0 THEN
        phase0 := 0;
    END_IF;

20:
    IF table_owner = 0 THEN
        table_owner := 1;
        leg_from_station0 := 3;
        leg_from_port0 := PORT_STANDBY;
        leg_to_station0 := 4;
        leg_to_port0 := PORT_TABLE;
        leg_next_phase0 := 3;
        phase0 := 2;
        leg_step0 := 0;
    END_IF;

END_CASE;

(* ============================================================= *)
(* Lane 1 macro state machine                                    *)
(* ============================================================= *)
CASE phase1 OF

0:
    IF D110 <> 0 AND D110 <> last_id1 THEN
        last_id1 := D110;
        phase1 := 1;
    END_IF;

1:
    IF table_owner = 0 OR table_owner = 2 THEN
        table_owner := 2;
        leg_from_station1 := 2;
        leg_from_port1 := PORT_HOISTB;
        leg_to_station1 := 4;
        leg_to_port1 := PORT_TABLE;
        leg_next_phase1 := 3;
    ELSE
        leg_from_station1 := 2;
        leg_from_port1 := PORT_HOISTB;
        leg_to_station1 := 3;
        leg_to_port1 := PORT_STANDBY;
        leg_next_phase1 := 20;
    END_IF;
    phase1 := 2;
    leg_step1 := 0;

2:
    CASE leg_step1 OF
    0:
        IF shuttle_owner = 0 OR shuttle_owner = 2 THEN
            shuttle_owner := 2;
            IF D12 <= 4000 THEN
                D200 := leg_from_port1;
            END_IF;
            Y20 := TRUE;
            leg_step1 := 1;
        END_IF;
    1:
        IF ABS(D10 - leg_from_port1) <= POS_TOL AND ABS(D11) <= SPD_TOL THEN
            leg_step1 := 2;
        END_IF;
    2:
        CASE leg_from_station1 OF
        2:
            D212 := LIFT_CONNECT;
            Y23 := TRUE;
            IF X55 THEN
                leg_step1 := 3;
            END_IF;
        3:
            leg_step1 := 3;
        4:
            IF X56 THEN
                leg_step1 := 3;
            END_IF;
        END_CASE;
    3:
        D204 := FORK_CONNECT;
        Y21 := TRUE;
        IF ABS(D12 - FORK_CONNECT) <= POS_TOL AND ABS(D13) <= SPD_TOL THEN
            leg_step1 := 4;
        END_IF;
    4:
        IF NOT cmd_issued1 THEN
            seq := seq + 1;
            D80 := 1;
            D81 := leg_from_station1;
            D82 := seq;
            cmd_issued1 := TRUE;
        END_IF;
        IF D114 = 0 THEN
            cmd_issued1 := FALSE;
            leg_step1 := 5;
        END_IF;
    5:
        D204 := 0;
        IF ABS(D12 - 0) <= POS_TOL AND ABS(D13) <= SPD_TOL THEN
            IF leg_from_station1 = 4 THEN
                table_owner := 0;
            END_IF;
            leg_step1 := 6;
        END_IF;
    6:
        IF D12 <= 4000 THEN
            D200 := leg_to_port1;
        END_IF;
        leg_step1 := 7;
    7:
        IF ABS(D10 - leg_to_port1) <= POS_TOL AND ABS(D11) <= SPD_TOL THEN
            leg_step1 := 8;
        END_IF;
    8:
        CASE leg_to_station1 OF
        2:
            D212 := LIFT_CONNECT;
            Y23 := TRUE;
            IF X55 THEN
                leg_step1 := 9;
            END_IF;
        3:
            leg_step1 := 9;
        4:
            IF X56 THEN
                leg_step1 := 9;
            END_IF;
        END_CASE;
    9:
        D204 := FORK_CONNECT;
        IF ABS(D12 - FORK_CONNECT) <= POS_TOL AND ABS(D13) <= SPD_TOL THEN
            leg_step1 := 10;
        END_IF;
    10:
        IF NOT cmd_issued1 THEN
            seq := seq + 1;
            D80 := 2;
            D81 := leg_to_station1;
            D82 := seq;
            cmd_issued1 := TRUE;
        END_IF;
        IF D114 = leg_to_station1 THEN
            cmd_issued1 := FALSE;
            leg_step1 := 11;
        END_IF;
    11:
        D204 := 0;
        IF ABS(D12 - 0) <= POS_TOL AND ABS(D13) <= SPD_TOL THEN
            shuttle_owner := 0;
            phase1 := leg_next_phase1;
            leg_step1 := 0;
        END_IF;
    END_CASE;

3:
    D216 := D94;
    Y24 := TRUE;
    IF X53 THEN
        phase1 := 4;
    END_IF;

4:
    D220 := D95;
    Y25 := TRUE;
    IF X31 THEN
        phase1 := 5;
    END_IF;

5:
    D220 := SLIDE_RETRACT;
    IF ABS(D20 - SLIDE_RETRACT) <= POS_TOL AND ABS(D21) <= SPD_TOL THEN
        phase1 := 6;
    END_IF;

6:
    D216 := 0;
    IF ABS(D18 - 0) <= POS_TOL AND ABS(D19) <= SPD_TOL THEN
        leg_from_station1 := 4;
        leg_from_port1 := PORT_TABLE;
        leg_to_station1 := 2;
        leg_to_port1 := PORT_HOISTB;
        leg_next_phase1 := 7;
        phase1 := 2;
        leg_step1 := 0;
    END_IF;

7:
    D212 := D151;
    Y23 := TRUE;
    IF X33 THEN
        phase1 := 8;
    END_IF;

8:
    D302 := last_id1;
    D303 := 1;
    phase1 := 9;

9:
    IF D110 <> 0 AND D110 <> last_id1 THEN
        phase1 := 0;
    END_IF;

20:
    IF table_owner = 0 THEN
        table_owner := 2;
        leg_from_station1 := 3;
        leg_from_port1 := PORT_STANDBY;
        leg_to_station1 := 4;
        leg_to_port1 := PORT_TABLE;
        leg_next_phase1 := 3;
        phase1 := 2;
        leg_step1 := 0;
    END_IF;

END_CASE;

(* ============================================================= *)
(* Final completion supervision                                  *)
(* ============================================================= *)
final_ready := X51
    AND ABS(D10 - 0) <= POS_TOL AND ABS(D11) <= SPD_TOL
    AND ABS(D12 - 0) <= POS_TOL AND ABS(D13) <= SPD_TOL
    AND ABS(D18 - 0) <= POS_TOL AND ABS(D19) <= SPD_TOL
    AND ABS(D20 - SLIDE_RETRACT) <= POS_TOL AND ABS(D21) <= SPD_TOL
    AND ABS(D14 - D150) <= POS_TOL AND ABS(D15) <= SPD_TOL
    AND ABS(D16 - D151) <= POS_TOL AND ABS(D17) <= SPD_TOL
    AND D90 = 0 AND D91 = 0 AND D92 = 0;

ton100(IN := final_ready, PT := T#100ms);

IF ton100.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM