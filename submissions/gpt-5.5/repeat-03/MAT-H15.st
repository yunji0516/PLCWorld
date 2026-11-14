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
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    initialized : BOOL;
    started : BOOL;
    a_accept_done : BOOL;
    b_accept_done : BOOL;
    phase : INT;
    fork_task : INT;
    fork_state : INT;
    fork_side_cmd : INT;
    fork_done : BOOL;
    head_state : INT;
    head_target_side : INT;
    head_expected_kind : INT;
    a_support_target : INT;
    b_support_target : INT;
    receipt_count : INT;
    complete_latched : BOOL;
    a_expected : INT;
    b_expected : INT;
    stack_side : INT;
    stack_expected : INT;
    stack_ready : BOOL;
    a_stack_complete : BOOL;
    b_stack_complete : BOOL;
    all_layers_complete : BOOL;
    recvTimer : TON;
END_VAR

IF NOT initialized THEN
    initialized := TRUE;
    started := FALSE;
    a_accept_done := FALSE;
    b_accept_done := FALSE;
    phase := 0;
    fork_task := 0;
    fork_state := 0;
    fork_side_cmd := 0;
    fork_done := FALSE;
    head_state := 0;
    head_target_side := 0;
    head_expected_kind := 0;
    a_support_target := 850;
    b_support_target := 850;
    receipt_count := 0;
    complete_latched := FALSE;
    D200 := 0;
    D201 := 0;
    D202 := 850;
    D203 := 850;
    D204 := 850;
END_IF;

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
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

IF X0 THEN
    started := TRUE;
END_IF;

IF X1D OR X1F THEN
    a_accept_done := TRUE;
END_IF;
IF X1E OR X20 THEN
    b_accept_done := TRUE;
END_IF;

IF started AND (NOT a_accept_done) AND X1B THEN
    Y10 := TRUE;
    a_accept_done := TRUE;
END_IF;

IF started AND (NOT b_accept_done) AND X1C THEN
    Y11 := TRUE;
    b_accept_done := TRUE;
END_IF;

a_stack_complete := X1F OR (D11 >= 3);
b_stack_complete := X20 OR (D12 >= 4);
all_layers_complete := (a_stack_complete AND b_stack_complete);

a_expected := D7;
IF (a_expected <> 1) AND (a_expected <> 2) THEN
    IF D11 <= 0 THEN
        a_expected := 1;
    ELSIF D11 = 1 THEN
        a_expected := 2;
    ELSIF D11 = 2 THEN
        a_expected := 1;
    ELSE
        a_expected := 0;
    END_IF;
END_IF;

b_expected := D8;
IF (b_expected <> 1) AND (b_expected <> 2) THEN
    IF D12 <= 0 THEN
        b_expected := 2;
    ELSIF D12 = 1 THEN
        b_expected := 1;
    ELSIF D12 = 2 THEN
        b_expected := 2;
    ELSIF D12 = 3 THEN
        b_expected := 1;
    ELSE
        b_expected := 0;
    END_IF;
END_IF;

IF phase = 0 THEN
    IF started THEN
        phase := 5;
    END_IF;
END_IF;

IF phase = 5 THEN
    IF a_accept_done THEN
        phase := 10;
    END_IF;
END_IF;

IF phase = 10 THEN
    IF fork_done THEN
        fork_done := FALSE;
        fork_task := 0;
        fork_state := 0;
        phase := 20;
    ELSIF fork_task = 0 THEN
        fork_task := 1;
        fork_side_cmd := 1;
        fork_state := 1;
        fork_done := FALSE;
    END_IF;
END_IF;

IF phase = 20 THEN
    IF a_stack_complete AND (head_state = 0) AND (NOT X12) AND (NOT X13) THEN
        phase := 30;
    END_IF;
END_IF;

IF phase = 30 THEN
    IF fork_done THEN
        fork_done := FALSE;
        fork_task := 0;
        fork_state := 0;
        phase := 40;
    ELSIF fork_task = 0 THEN
        fork_task := 2;
        fork_side_cmd := 1;
        fork_state := 20;
        fork_done := FALSE;
    END_IF;
END_IF;

IF phase = 40 THEN
    IF b_accept_done AND X21 THEN
        IF fork_done THEN
            fork_done := FALSE;
            fork_task := 0;
            fork_state := 0;
            phase := 50;
        ELSIF fork_task = 0 THEN
            fork_task := 1;
            fork_side_cmd := 2;
            fork_state := 1;
            fork_done := FALSE;
        END_IF;
    END_IF;
END_IF;

IF phase = 50 THEN
    IF b_stack_complete AND (head_state = 0) AND (NOT X12) AND (NOT X13) THEN
        phase := 60;
    END_IF;
END_IF;

IF phase = 60 THEN
    IF fork_done THEN
        fork_done := FALSE;
        fork_task := 0;
        fork_state := 0;
        phase := 70;
    ELSIF fork_task = 0 THEN
        fork_task := 2;
        fork_side_cmd := 2;
        fork_state := 20;
        fork_done := FALSE;
    END_IF;
END_IF;

IF phase = 70 THEN
    IF (receipt_count >= 2) AND all_layers_complete AND (X1A OR all_layers_complete) AND X21 AND X22 AND X18 AND (NOT X12) AND (NOT X13) AND (fork_task = 0) THEN
        complete_latched := TRUE;
        phase := 80;
    END_IF;
END_IF;

recvTimer(IN := ((fork_task = 2) AND (fork_state = 28)), PT := T#8200ms);

CASE fork_state OF
    1:
        IF (fork_task = 1) AND X27 AND X18 AND (NOT X14) THEN
            Y1C := TRUE;
            fork_state := 2;
        END_IF;
    2:
        IF X2A THEN
            fork_state := 3;
        END_IF;
    3:
        IF NOT X14 THEN
            Y1D := TRUE;
            fork_state := 4;
        END_IF;
    4:
        IF X2B THEN
            fork_state := 5;
        END_IF;
    5:
        IF NOT X14 THEN
            D201 := fork_side_cmd;
            Y1E := TRUE;
            fork_state := 6;
        END_IF;
    6:
        IF X2C THEN
            fork_state := 7;
        END_IF;
    7:
        IF NOT X14 THEN
            Y1F := TRUE;
            fork_state := 8;
        END_IF;
    8:
        IF X18 AND (NOT X14) THEN
            IF ((fork_side_cmd = 1) AND X28 AND X25) OR ((fork_side_cmd = 2) AND X29 AND X26) THEN
                fork_done := TRUE;
            END_IF;
        END_IF;
    20:
        IF X18 AND (NOT X14) AND (NOT X12) AND (NOT X13) THEN
            IF fork_side_cmd = 1 THEN
                IF a_stack_complete AND X21 AND X25 THEN
                    D201 := 1;
                    Y16 := TRUE;
                    fork_state := 21;
                END_IF;
            ELSIF fork_side_cmd = 2 THEN
                IF b_stack_complete AND X22 AND X26 THEN
                    D201 := 2;
                    Y16 := TRUE;
                    fork_state := 21;
                END_IF;
            END_IF;
        END_IF;
    21:
        IF X15 THEN
            fork_state := 22;
        END_IF;
    22:
        IF NOT X14 THEN
            D201 := fork_side_cmd;
            Y17 := TRUE;
            fork_state := 23;
        END_IF;
    23:
        IF X16 THEN
            fork_state := 24;
        END_IF;
    24:
        IF fork_side_cmd = 1 THEN
            a_support_target := 780;
            IF X23 THEN
                fork_state := 25;
            END_IF;
        ELSIF fork_side_cmd = 2 THEN
            b_support_target := 780;
            IF X24 THEN
                fork_state := 25;
            END_IF;
        END_IF;
    25:
        IF NOT X14 THEN
            D201 := fork_side_cmd;
            Y18 := TRUE;
            fork_state := 26;
        END_IF;
    26:
        IF X17 THEN
            fork_state := 27;
        END_IF;
    27:
        IF NOT X14 THEN
            Y19 := TRUE;
            IF fork_side_cmd = 1 THEN
                a_support_target := 850;
            ELSIF fork_side_cmd = 2 THEN
                b_support_target := 850;
            END_IF;
            fork_state := 28;
        END_IF;
    28:
        IF X18 AND recvTimer.Q THEN
            Y1A := TRUE;
            receipt_count := receipt_count + 1;
            fork_done := TRUE;
        END_IF;
ELSE
END_CASE;

stack_side := 0;
stack_expected := 0;
stack_ready := FALSE;

IF phase = 20 THEN
    stack_side := 1;
    stack_expected := a_expected;
    IF (NOT a_stack_complete) AND X28 AND X25 AND X21 AND X1D THEN
        stack_ready := TRUE;
    END_IF;
ELSIF phase = 50 THEN
    stack_side := 2;
    stack_expected := b_expected;
    IF (NOT b_stack_complete) AND X29 AND X26 AND X22 AND X1E THEN
        stack_ready := TRUE;
    END_IF;
END_IF;

CASE head_state OF
    0:
        IF stack_ready AND (stack_expected >= 1) AND (stack_expected <= 2) AND (NOT X12) AND (NOT X13) THEN
            IF ((stack_expected = 1) AND X10) OR ((stack_expected = 2) AND X11) THEN
                D200 := stack_expected;
                Y12 := TRUE;
                head_target_side := stack_side;
                head_expected_kind := stack_expected;
                head_state := 1;
            END_IF;
        END_IF;
    1:
        IF X13 AND (NOT X12) AND (D5 = head_expected_kind) THEN
            head_state := 2;
        END_IF;
    2:
        IF X13 AND (NOT X12) AND (D5 = head_expected_kind) THEN
            IF head_target_side = 1 THEN
                IF X25 AND X28 THEN
                    D201 := 1;
                    D202 := D9;
                    Y13 := TRUE;
                    head_state := 3;
                END_IF;
            ELSIF head_target_side = 2 THEN
                IF X26 AND X29 THEN
                    D201 := 2;
                    D202 := D10;
                    Y13 := TRUE;
                    head_state := 3;
                END_IF;
            END_IF;
        END_IF;
    3:
        IF (NOT X12) AND (NOT X13) THEN
            head_state := 0;
            head_target_side := 0;
            head_expected_kind := 0;
        END_IF;
ELSE
    head_state := 0;
END_CASE;

D203 := a_support_target;
D204 := b_support_target;

IF (a_support_target = 850) THEN
    IF NOT X21 THEN
        Y14 := TRUE;
    END_IF;
ELSIF (a_support_target = 780) THEN
    IF NOT X23 THEN
        Y14 := TRUE;
    END_IF;
END_IF;

IF (b_support_target = 850) THEN
    IF NOT X22 THEN
        Y15 := TRUE;
    END_IF;
ELSIF (b_support_target = 780) THEN
    IF NOT X24 THEN
        Y15 := TRUE;
    END_IF;
END_IF;

IF complete_latched THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF;

END_PROGRAM