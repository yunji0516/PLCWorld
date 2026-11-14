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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D100 : INT;
    D101 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    
    seq_step : INT := 0;
    current_part : INT := 0;
    A_processed : INT := 0;
    B_processed : INT := 0;
    destination : INT := 0;
    reject_idx : INT := 0;
END_VAR

(* Continuously run the normal outfeed conveyor *)
Y13 := TRUE;

CASE seq_step OF
  0:
    Y11 := TRUE; Y10 := FALSE;
    Y15 := TRUE; Y16 := FALSE;
    Y18 := TRUE; Y17 := FALSE;
    Y1A := TRUE; Y1B := FALSE;
    Y1D := TRUE; Y1C := FALSE;
    Y19 := FALSE; Y1E := FALSE;
    Y12 := FALSE;
    Y14 := FALSE;
    IF X0 THEN
      seq_step := 10;
    END_IF;

  10:
    IF A_processed < 2 THEN
      current_part := 1;
      seq_step := 20;
    ELSIF B_processed < 2 THEN
      current_part := 2;
      seq_step := 20;
    ELSE
      seq_step := 999;
    END_IF;

  20:
    IF NOT X10 THEN
      IF current_part = 1 THEN
        Y15 := TRUE; Y16 := FALSE;
        Y18 := TRUE; Y17 := FALSE;
        D100 := 1;
      ELSE
        Y1A := TRUE; Y1B := FALSE;
        Y1D := TRUE; Y1C := FALSE;
        D100 := 2;
      END_IF;
      D101 := D101 + 1;
      seq_step := 21;
    END_IF;

  21:
    IF D1 = D101 AND D0 = D100 AND NOT X10 THEN
      Y10 := TRUE; Y11 := FALSE;
      seq_step := 22;
    END_IF;

  22:
    IF X13 AND X12 THEN
      seq_step := 23;
    END_IF;

  23:
    IF NOT X10 THEN
      IF current_part = 1 THEN
        IF X21 AND X23 AND X1E AND X26 THEN
          D100 := 3;
          D101 := D101 + 1;
          seq_step := 24;
        END_IF;
      ELSE
        IF X2C AND X2E AND X29 AND X31 THEN
          D100 := 4;
          D101 := D101 + 1;
          seq_step := 24;
        END_IF;
      END_IF;
    END_IF;

  24:
    IF D1 = D101 AND D0 = D100 AND NOT X10 THEN
      Y11 := TRUE; Y10 := FALSE;
      seq_step := 25;
    END_IF;

  25:
    IF NOT X10 AND X11 AND NOT X13 THEN
      D100 := 0;
      D101 := D101 + 1;
      seq_step := 26;
    END_IF;

  26:
    IF D1 = D101 AND D0 = 0 AND NOT X10 THEN
      IF current_part = 1 THEN
        IF X25 THEN 
          Y16 := TRUE; Y15 := FALSE;
          Y17 := TRUE; Y18 := FALSE;
          seq_step := 27;
        END_IF;
      ELSE
        IF X30 THEN 
          Y1B := TRUE; Y1A := FALSE;
          Y1C := TRUE; Y1D := FALSE;
          seq_step := 27;
        END_IF;
      END_IF;
    END_IF;

  27:
    IF current_part = 1 THEN
      IF X22 AND X24 AND X27 AND X1D THEN
        Y19 := TRUE;
        seq_step := 28;
      END_IF;
    ELSE
      IF X2D AND X2F AND X32 AND X28 THEN
        Y1E := TRUE;
        seq_step := 28;
      END_IF;
    END_IF;

  28:
    IF current_part = 1 THEN
      IF X20 THEN Y19 := FALSE; END_IF;
      IF X1F THEN 
        Y19 := FALSE;
        Y15 := TRUE; Y16 := FALSE;
        Y18 := TRUE; Y17 := FALSE;
        seq_step := 29;
      END_IF;
    ELSE
      IF X2B THEN Y1E := FALSE; END_IF;
      IF X2A THEN 
        Y1E := FALSE;
        Y1A := TRUE; Y1B := FALSE;
        Y1D := TRUE; Y1C := FALSE;
        seq_step := 29;
      END_IF;
    END_IF;

  29:
    IF NOT X10 THEN
      IF current_part = 1 THEN
        IF X21 AND X23 AND X26 THEN
          D100 := 3;
          D101 := D101 + 1;
          seq_step := 30;
        END_IF;
      ELSE
        IF X2C AND X2E AND X31 THEN
          D100 := 4;
          D101 := D101 + 1;
          seq_step := 30;
        END_IF;
      END_IF;
    END_IF;

  30:
    IF D1 = D101 AND D0 = D100 AND NOT X10 THEN
      Y10 := TRUE; Y11 := FALSE;
      seq_step := 31;
    END_IF;

  31:
    IF NOT X10 AND X13 AND X12 THEN
      D100 := 5;
      D101 := D101 + 1;
      seq_step := 32;
    END_IF;

  32:
    IF D1 = D101 AND D0 = 5 AND NOT X10 THEN
      Y11 := TRUE; Y10 := FALSE;
      seq_step := 33;
    END_IF;

  33:
    IF NOT X10 AND X11 AND NOT X13 THEN
      D100 := 0;
      D101 := D101 + 1;
      seq_step := 34;
    END_IF;

  34:
    IF D1 = D101 AND D0 = 0 AND NOT X10 THEN
      IF X1C AND X14 THEN
        Y12 := TRUE;
        seq_step := 35;
      END_IF;
    END_IF;

  35:
    IF X15 OR X16 THEN
      Y12 := FALSE;
      seq_step := 36;
    END_IF;

  36:
    IF NOT X10 AND X16 AND NOT X15 THEN
      Y12 := FALSE;
      IF (D4 >= 5800 AND D4 <= 6200) AND (D5 >= 5800 AND D5 <= 6200) THEN
        destination := 7;
      ELSE
        destination := 8 + reject_idx;
        reject_idx := reject_idx + 1;
      END_IF;
      D100 := 5;
      D101 := D101 + 1;
      seq_step := 37;
    END_IF;

  37:
    IF D1 = D101 AND D0 = 5 AND NOT X10 THEN
      Y10 := TRUE; Y11 := FALSE;
      seq_step := 38;
    END_IF;

  38:
    IF NOT X10 AND X13 AND X12 THEN
      IF destination = 7 THEN
        IF X1A THEN
          D100 := destination;
          D101 := D101 + 1;
          seq_step := 39;
        END_IF;
      ELSE
        D100 := destination;
        D101 := D101 + 1;
        seq_step := 39;
      END_IF;
    END_IF;

  39:
    IF D1 = D101 AND D0 = destination AND NOT X10 THEN
      Y11 := TRUE; Y10 := FALSE;
      seq_step := 40;
    END_IF;

  40:
    IF NOT X10 AND X11 AND NOT X13 THEN
      D100 := 0;
      D101 := D101 + 1;
      IF current_part = 1 THEN
        A_processed := A_processed + 1;
      ELSE
        B_processed := B_processed + 1;
      END_IF;
      seq_step := 10;
    END_IF;

  999:
    IF D1 = D101 AND D0 = 0 AND NOT X10 AND X1B THEN
      Y14 := TRUE;
    END_IF;
END_CASE;

END_PROGRAM