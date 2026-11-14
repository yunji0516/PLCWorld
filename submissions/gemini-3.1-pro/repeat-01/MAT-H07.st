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

    State : INT := 0;
    a_accepted : BOOL := FALSE;
    b_accepted : BOOL := FALSE;
    roll_count : INT := 0;
END_VAR

CASE State OF
  0:
    IF X0 THEN
      State := 10;
    END_IF;

  10:
    IF X10 AND NOT a_accepted THEN
      Y10 := TRUE;
      a_accepted := TRUE;
    ELSE
      Y10 := FALSE;
    END_IF;
    
    IF X11 AND NOT b_accepted THEN
      Y11 := TRUE;
      b_accepted := TRUE;
    ELSE
      Y11 := FALSE;
    END_IF;
    
    IF X12 AND X13 THEN
      Y10 := FALSE;
      Y11 := FALSE;
      State := 30;
    END_IF;

  30:
    Y14 := TRUE;
    IF D2 >= D0 THEN
      Y14 := FALSE;
      State := 40;
    END_IF;

  40:
    Y13 := TRUE;
    IF X15 THEN
      State := 50;
    END_IF;

  50:
    Y15 := TRUE;
    State := 51;
    
  51:
    Y15 := FALSE;
    IF X17 THEN
      State := 52;
    END_IF;
    
  52:
    Y16 := TRUE;
    State := 53;
    
  53:
    Y16 := FALSE;
    IF X16 THEN
      State := 100;
    END_IF;

  100:
    Y24 := TRUE;
    IF X2E THEN
      Y23 := TRUE;
      IF X2D THEN
        State := 101;
      END_IF;
    END_IF;

  101:
    Y17 := TRUE;
    State := 102;
    
  102:
    Y17 := FALSE;
    IF X19 THEN
      Y23 := FALSE;
      Y24 := FALSE;
      Y1E := FALSE;
      Y1F := TRUE;
      State := 103;
    END_IF;

  103:
    IF X1E AND X20 THEN
      State := 115;
    END_IF;

  115:
    Y25 := TRUE;
    IF X2F THEN
      Y26 := TRUE;
      IF X30 THEN
        State := 116;
      END_IF;
    END_IF;

  116:
    Y27 := TRUE;
    State := 117;
    
  117:
    Y27 := FALSE;
    IF X31 THEN
      Y25 := FALSE;
      State := 120;
    END_IF;

  120:
    Y18 := TRUE;
    Y19 := TRUE;
    IF X1B AND X1C THEN
      Y13 := FALSE;
      Y12 := FALSE;
      State := 121;
    END_IF;

  121:
    IF X24 AND X25 THEN
      State := 130;
    END_IF;

  130:
    Y1A := TRUE;
    IF D5 >= D4 THEN
      Y1A := FALSE;
      State := 140;
    END_IF;

  140:
    Y12 := TRUE;
    Y13 := TRUE;
    IF X14 AND X15 THEN
      State := 141;
    END_IF;

  141:
    Y1C := TRUE;
    Y1D := TRUE;
    State := 142;
    
  142:
    Y1C := FALSE;
    Y1D := FALSE;
    IF X27 AND X28 THEN
      State := 150;
    END_IF;

  150:
    Y1A := TRUE;
    IF X26 THEN
      Y1A := FALSE;
      State := 160;
    END_IF;

  160:
    Y28 := TRUE;
    State := 161;
    
  161:
    Y28 := FALSE;
    IF X33 AND NOT X32 THEN
      Y26 := FALSE;
      State := 170;
    END_IF;

  170:
    Y18 := FALSE;
    Y19 := FALSE;
    Y1B := TRUE;
    IF X1F THEN
      State := 171;
    END_IF;

  171:
    Y1F := FALSE;
    Y1E := TRUE;
    IF X1D THEN
      State := 180;
    END_IF;

  180:
    IF X34 THEN
      State := 181;
    END_IF;
    
  181:
    Y20 := TRUE;
    State := 182;
    
  182:
    Y20 := FALSE;
    IF X35 THEN
      Y29 := TRUE;
      State := 190;
    END_IF;

  190:
    IF X22 THEN
      State := 191;
    END_IF;
    
  191:
    Y21 := TRUE;
    State := 192;
    
  192:
    Y21 := FALSE;
    Y29 := FALSE;
    Y1B := FALSE;
    IF X34 THEN
      roll_count := roll_count + 1;
      IF roll_count < 3 THEN
        State := 100;
      ELSE
        State := 210;
      END_IF;
    END_IF;

  210:
    Y22 := TRUE;

END_CASE;

END_PROGRAM