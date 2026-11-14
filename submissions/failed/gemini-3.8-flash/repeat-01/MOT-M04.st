D10;
- Trolley holds position at x_start:
  x_ref = x_start;
  v_ref = 0.0;
  a_ref = 0.0;
  theta_nom = 0.0;
  omega_nom = 0.0;
  Calculate feedback u_cmd and D21.
- Check if hoist has arrived:
  IF ABS(D11 - D10) <= 200 AND ABS(D12) <= 100 THEN
    hoist_settle_count := hoist_settle_count + 1;
  ELSE
    hoist_settle_count := 0;
  END_IF;
  IF hoist_settle_count >= 10 THEN // settled for 100 ms
    // Prepare Phase 2 (Trolley Move)
    L_target = D11 / 100.0;
    IF L_target < 500.0 THEN L_target := 500.0; END_IF;
    omega_0 = SQRT(9810.0 / L_target);
    T_pend = 2.0 * 3.14159265358979 / omega_0;
    x_goal = D17 / 100.0;
    total_dist = x_goal - x_start;
    // Choose v_max
    v_max = 450.0;
    // Ensure v_max * T_pend <= ABS(total_dist)
    IF v_max * T_pend > ABS(total_dist) * 0.9 THEN
        v_max := ABS(total_dist) * 0.9 / T_pend;
    END_IF;
    IF total_dist < 0.0 THEN
        v_max := - v_max;
    END_IF;
    t_cruise = (total_dist - v_max * T_pend) / v_max;
    IF t_cruise < 0.0 THEN t_cruise := 0.0; END_IF;
    t_acc = T_pend;
    t_dec = T_pend;
    t_total_prof = t_acc + t_cruise + t_dec;
    prof_time := 0.0;
    state := 20; // Trolley move phase
  END_IF;

State 20: Trolley Anti-Sway Move
- Y20 := TRUE;
- D20 := D10;
- prof_time := prof_time + 0.01; // dt = 10 ms
- If prof_time < t_acc:
    a_ref = v_max / t_acc;
    v_ref = a_ref * prof_time;
    x_ref = x_start + 0.5 * a_ref * prof_time * prof_time;
    theta_nom = - (a_ref / 9810.0) * (1.0 - COS(omega_0 * prof_time));
    omega_nom = - (a_ref / 9810.0) * omega_0 * SIN(omega_0 * prof_time);
  ELSIF prof_time < t_acc + t_cruise THEN
    a_ref = 0.0;
    v_ref = v_max;
    x_ref = x_start + 0.5 * v_max * t_acc + v_max * (prof_time - t_acc);
    theta_nom = 0.0;
    omega_nom = 0.0;
  ELSIF prof_time < t_total_prof THEN
    dt_dec = prof_time - (t_acc + t_cruise);
    a_ref = - v_max / t_dec;
    v_ref = v_max + a_ref * dt_dec;
    x_ref = x_start + 0.5 * v_max * t_acc + v_max * t_cruise + v_max * dt_dec + 0.5 * a_ref * dt_dec * dt_dec;
    theta_nom = - (a_ref / 9810.0) * (1.0 - COS(omega_0 * dt_dec));
    omega_nom = - (a_ref / 9810.0) * omega_0 * SIN(omega_0 * dt_dec);
  ELSE
    a_ref = 0.0;
    v_ref = 0.0;
    x_ref = x_goal;
    theta_nom = 0.0;
    omega_nom = 0.0;
    state := 30; // Final hold and stabilize phase
  END_IF;
- Compute controller u_cmd and D21.

State 30: Final Hold and Stabilize
- Y20 := TRUE;
- D20 := D10;
- a_ref = 0.0;
- v_ref = 0.0;
- x_ref = x_goal;
- theta_nom = 0.0;
- omega_nom = 0.0;
- Compute controller u_cmd and D21.
- Check completion criteria:
  IF ABS(D11 - D10) <= 100 AND ABS(D13 - D17) <= 100 AND ABS(D15 - D18) <= 20
     AND ABS(D12) <= 100 AND ABS(D14) <= 100 AND