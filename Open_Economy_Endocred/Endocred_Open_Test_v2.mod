// ============================================================
//  Open-economy endogenous-credibility FPAS Mark II model - ENDOCRED
// ============================================================

var
// --- inflation ---
    PIE          // inflation (QoQ)
    PIE4         // inflation (YoY)
    PIE_GAP      // YoY inflation gap
    PGAP         // price-level gap

// --- credibility & expectations ---
    C            // credibility
    DC DCNEG     // change / negative change in credibility
    SIGNAL_CBP   // CB performance index
    RES_PIE4_LOW RES_PIE4_HIGH   // regime residuals
    PIE4EXP4     // 1y-ahead YoY inflation expectations
    INF_B        // bias term in 1y-ahead expectations
    PIE4EXP_LOW PIE4EXP_HIGH      // 1y expectation by regime

// --- output ---
    Y           //Output Gap
    YNEG        //Negative Output Gap
    CUMSUMY     //Cumulative Output Gap

// --- interest rates ---
    RS           // policy rate (Ramsey instrument)
    RS4          // 1-year nominal rate
    RR RR4       // real rate / 1-year real rate
    RR_BAR RR_BAR4   // real rate trend
    RR_GAP       // real rate trend
    DRS          // change in interest rates

// --- exchange-rate block (in changes) ---
    delta_Z      // change in real exchange rate
    delta_Z_BAR  // change in real exchange rate trend
    Z_GAP        // real exchange rate gap
    PREM         // country risk premium
    g_Z          // persistent component in trend depreciation

// --- external ---
    RR_US        // US real rate
    RR_BAR_US    // US real rate trend
    Y_WORLD      // world output gap

// --- unemployment ---
    UNR          // unemployment rate (actual)
    UNR_GAP      // unemployment gap (actual − NAIRU); cyclical, Okun-type link to the output gap
    UNR_BAR      // equilibrium unemployment / NAIRU (random walk)
    g_UNR        // drift in the NAIRU — persistent trend in equilibrium unemployment

// --- GDP ---
    DL_GDP       // real GDP growth, YoY (= potential growth + 4-quarter change in the output gap)
    DL_GDP_BAR   // potential (trend) real GDP growth, YoY
    G_GDP_BAR    // persistent component of potential growth (mean-reverts to growth_ss)

// --- reporting ---
    PGAPNEG      // negative part of the price-level gap = min(PGAP, 0) — reporting only
    LOSS;         // period policy-loss value (PIE_GAP² + Y² + DRS² + PGAP² terms) — reporting only

varexo
    E_PIE E_Y E_C E_PIE4EXP4 E_RR_BAR
    E_PREM E_PREM_SHOCK E_Z_BAR E_Z_g
    E_RR_US E_RR_BAR_US E_Y_WORLD
    E_UNR E_UNR_BAR E_UNR_g
    E_DL_GDP_BAR E_G_GDP_BAR;

parameters PIE_STAR RR_BAR_STAR RR_US_BAR_STAR growth_ss exch_trend_ss;

PIE_STAR       =  4.0;    // inflation target
RR_BAR_STAR    =  4.0;    // domestic real equilibrium rate
RR_US_BAR_STAR =  1.5;    // US real equilibrium rate
growth_ss      =  3.5;    // steady-state GDP growth
exch_trend_ss  = -0.25;   // steady-state trend real depreciation (<0 = appreciation)

model;

// ===== Inflation ====================================================
// Non-linear Phillips curve: convex output term + real-FX channel
PIE = 0.55*PIE4EXP4 + (1-0.55)*PIE4(-1) + 0.4*(6*Y(-1)/(6 - Y(-1)))
      + 0.05*Z_GAP(-1) + 0.05*(delta_Z - exch_trend_ss) + E_PIE;

PIE4    = 0.25*(PIE + PIE(-1) + PIE(-2) + PIE(-3));
PGAP    = PGAP(-1) + 0.25*(PIE - PIE_STAR);
PIE_GAP = PIE4 - PIE_STAR;

// ===== Endogenous credibility & expectations ========================
RES_PIE4_LOW  = PIE4 - (0.5*PIE_STAR + 0.5*PIE4(-1));
RES_PIE4_HIGH = PIE4 - (0.1*10       + 0.9*PIE4(-1));
SIGNAL_CBP    = RES_PIE4_HIGH^2 / (RES_PIE4_HIGH^2 + RES_PIE4_LOW^2);
C             = 0.1*SIGNAL_CBP + (1-0.1)*C(-1) + E_C;

PIE4EXP4 = C*PIE4(+4) + (1-C)*PIE4(-1) + INF_B + E_PIE4EXP4;
INF_B    = 0.10*(C*PIE4EXP_LOW + (1-C)*PIE4EXP_HIGH - PIE_STAR);
PIE4EXP_LOW  = 0.5*PIE_STAR + 0.5*PIE_STAR*0.5 + 0.5*PIE_STAR*0.5*0.5
             + 0.5*PIE_STAR*0.5*0.5*0.5 + 0.5*0.5*0.5*0.5*PIE4;
PIE4EXP_HIGH = 0.1*10 + 0.1*10*0.9 + 0.1*10*0.9*0.9
             + 0.1*10*0.9*0.9*0.9 + 0.9*0.9*0.9*0.9*PIE4;

// ===== Output gap ===================================================
Y       = 0.7*Y(-1) + 0.12*Y(+1) - 0.18*RR_GAP(-1) + 0.15*Z_GAP(-1) + 0.12*Y_WORLD + E_Y;
CUMSUMY = CUMSUMY(-1) + Y/4;
YNEG    = (Y - ABS(Y))/2;

// ===== Interest rates ===============================================
RR  = RS - PIE(+1);
RR4 = (1/4)*(RR + RR(+1) + RR(+2) + RR(+3));
RS4 = (1/4)*(RS + RS(+1) + RS(+2) + RS(+3));

RR_BAR4 = (1/4)*(RR_BAR + RR_BAR(+1) + RR_BAR(+2) + RR_BAR(+3));
RR_BAR  = 0.95*RR_BAR(-1) + (1-0.95)*RR_BAR_STAR + E_RR_BAR;
RR_GAP  = RR - RR_BAR;
DRS     = RS - RS(-1);

// ===== Real exchange-rate block (in changes) ========================
delta_Z = delta_Z_BAR + Z_GAP - Z_GAP(-1);

// Modified UIP, written in changes. Kept verbatim: the trailing -0.15 is an
// SS-balancing constant and E_PREM enters with this sign — do NOT multiply
// the equation through by -1 without also flipping the E_PREM shock values.
-0.7*delta_Z(+1) = -0.3*delta_Z - (RR - RR_US - PREM)/4
                 + 0.66*INF_B + 2.3*(INF_B - INF_B(-1)) + E_PREM - 0.15;

// Risk premium uses TREND rates (RR_BAR, RR_BAR_US), so the policy rate gap
// is retained in the UIP channel.
PREM        = 4*(-delta_Z_BAR(+1)) + (RR_BAR - RR_BAR_US) + E_PREM_SHOCK;
delta_Z_BAR = g_Z + E_Z_BAR;
g_Z         = (1-0.1)*g_Z(-1) + 0.1*exch_trend_ss + E_Z_g;

// ===== External block (exogenous, driven by shock paths) ============
RR_US     = RR_US_BAR_STAR + E_RR_US;
RR_BAR_US = RR_US_BAR_STAR + E_RR_BAR_US;
Y_WORLD   = E_Y_WORLD;

// ===== Unemployment =================================================
UNR     = UNR_BAR + UNR_GAP;                         // gap = actual - NAIRU
UNR_BAR = UNR_BAR(-1) + g_UNR + E_UNR_BAR;           // NAIRU random walk
g_UNR   = (1-0.4)*g_UNR(-1) + E_UNR_g;
UNR_GAP = -0.15*Y + 0.8*UNR_GAP(-1) - 0.05*Y(+1) + E_UNR;

// ===== GDP ==========================================================
DL_GDP     = DL_GDP_BAR + (Y - Y(-4));
DL_GDP_BAR = G_GDP_BAR + E_DL_GDP_BAR;
G_GDP_BAR  = (1-0.05)*G_GDP_BAR(-1) + 0.05*growth_ss + E_G_GDP_BAR;

// ===== Definitions / reporting ======================================
DC      = C - C(-1);
DCNEG   = (DC - ABS(DC))/2;
PGAPNEG = (PGAP - ABS(PGAP))/2;
LOSS    = PIE_GAP^2 + 1.0*Y^2 + 0.5*DRS^2 + 0.1*PGAP^2;

end;

steady_state_model;
  // inflation
  PIE     = PIE_STAR;
  PIE4    = PIE_STAR;
  PIE_GAP = 0;
  PGAP    = 0;
  // credibility & expectations
  C             = 1;
  SIGNAL_CBP    = 1;
  RES_PIE4_LOW  = 0;
  RES_PIE4_HIGH = -0.6;
  PIE4EXP4      = PIE_STAR;
  INF_B         = 0;
  PIE4EXP_LOW   = PIE_STAR;
  PIE4EXP_HIGH  = 0.1*10 + 0.1*10*0.9 + 0.1*10*0.9*0.9 + 0.1*10*0.9*0.9*0.9 + 0.9*0.9*0.9*0.9*PIE_STAR;
  // output
  Y       = 0;
  YNEG    = 0;
  CUMSUMY = 0;
  // interest rates
  RS      = PIE_STAR + RR_BAR_STAR;
  RR      = RS - PIE;
  RR4     = RR;
  RS4     = RS;
  RR_BAR  = RR_BAR_STAR;
  RR_BAR4 = RR_BAR_STAR;
  RR_GAP  = 0;
  DRS     = 0;
  RS_TAY  = RR_BAR + PIE4 + 0.5*(PIE4 - PIE_STAR) + 0.5*Y;
  // exchange rate
  Z_GAP       = 0;
  delta_Z_BAR = exch_trend_ss;
  delta_Z     = exch_trend_ss;
  g_Z         = exch_trend_ss;
  PREM        = RR_BAR_STAR - RR_US_BAR_STAR - 4*exch_trend_ss;   // = 3.5
  // external
  RR_US     = RR_US_BAR_STAR;
  RR_BAR_US = RR_US_BAR_STAR;
  Y_WORLD   = 0;
  // unemployment
  UNR_BAR = 15;
  UNR     = 15;
  UNR_GAP = 0;
  g_UNR   = 0;
  // GDP
  G_GDP_BAR  = growth_ss;
  DL_GDP_BAR = G_GDP_BAR;
  DL_GDP     = DL_GDP_BAR;
  // reporting
  DC      = 0;
  DCNEG   = 0;
  PGAPNEG = 0;
  LOSS    = 0;
end;

// ===== Optimal policy ===============================================
planner_objective 2.0*PIE_GAP^2 + 1.0*Y^2 + 0.5*DRS^2;
ramsey_model(planner_discount = 0.95, instruments = (RS));

initval;
  RS = 8.0;
end;

steady;

histval;
  // QoQ core inflation
  PIE(-2) = 2.4;   PIE(-1) = 3.9;   PIE(0) = 3.8;
  // YoY core inflation
  PIE4(-2) = 2.6;  PIE4(-1) = 4.5;  PIE4(0) = 7.0;
  // rates
  RS(0) = 9.5;     RR_BAR(0) = 2.7; RR(0) = 2.9;
  // output gap
  Y(0) = 4.2;
  // potential / actual GDP growth (YoY)
  DL_GDP_BAR(0) = 10.6;  DL_GDP(0) = 15.8;  G_GDP_BAR(0) = 8;
  // unemployment
  UNR(0) = 11;     UNR_BAR(0) = 13.5;  UNR_GAP(0) = -2.0;  g_UNR(0) = 1;
  // credibility
  C(0) = 0.9;      SIGNAL_CBP(0) = 0.5;
  // exchange rate
  PREM(0) = 6;     Z_GAP(0) = -15.7;   g_Z(0) = -1.2;      delta_Z(0) = -10;
end;

shocks;
  // World output gap, from 2022Q4 (29 periods, 29 values)
  var E_Y_WORLD;
  periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29;
  values -0.6 -0.69 -0.67 -0.68 -0.7 -0.7 -0.64 -0.54 -0.49 -0.42 -0.36 -0.29 -0.23 -0.18 -0.16 -0.15 -0.14 -0.13 -0.11 -0.1 -0.09 -0.08 -0.07 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01;

  // US real interest rate (37 periods, 37 values)
  var E_RR_US;
  periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37;
  values -2.72 -2.3 -0.69 -0.28 -0.54 -0.61 -0.72 -0.78 -0.82 -0.81 -0.79 -0.75 -0.7 -1.22 -1.19 -1.08 -1.05 -1.03 -1.0 -0.97 -0.94 -0.9 -0.87 -0.83 -0.79 -0.74 -0.7 -0.65 -0.6 -0.55 -0.49 -0.43 -0.36 -0.3 -0.22 -0.15 -0.07;

  // US real trend interest rate (20 periods, 20 values)
  var E_RR_BAR_US;
  periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20;
  values -1.28 -1.23 -1.18 -1.06 -0.95 -0.86 -0.77 -0.69 -0.62 -0.56 -0.51 -0.46 -0.41 -0.37 -0.31 -0.27 -0.22 -0.17 -0.11 -0.06;

  // Domestic tax-rate change, 2023Q1
  var E_PIE;
  periods 2;
  values 0.6;

  // Tourism inflow (calibrated to the non-linear model)
  var E_Y;
  periods 1 2 3 4 5;
  values 1.7 1.2 0.76 0.43 0.27;

  var E_PREM;
  periods 1 2 3 4 5;
  values -1.5 -1 -0.66 -0.33 -0.17;
end;

ramsey_constraints;
  RS > -300;   // effectively no floor; set to ~0 to impose a ZLB
end;

// ===== Two-pass perfect-foresight solve =============================
// Pass 1: solve, store, take period-2 state as the new initial condition
perfect_foresight_setup(periods=150);
perfect_foresight_solver(lmmcp);

results = struct();
results = simulation_sheet(results, oo_, M_);
current_period_values = oo_.endo_simul(:, 2);

// Pass 2: re-solve from the updated initial condition
perfect_foresight_setup(periods=150);
oo_.endo_simul(:,1) = current_period_values;
perfect_foresight_solver(lmmcp);
disp(oo_.endo_simul(:,1:4))

results = simulation_sheet(results, oo_, M_);

// ===== Rebuild named series for plotting ============================
// NOTE: simulation_sheet returns a STRUCT. Assigning it back with
// `oo_.endo_simul = results;` replaces the numeric solution matrix with a
// 1x1 struct, which is what triggered "Index ... must not exceed 1".
// Instead build the plot series directly from the genuine pass-2 matrix.
// (Name-based, so each row maps to the right variable despite Ramsey reordering.)
names = cellstr(M_.endo_names);
for i = 1:numel(names)
    assignin('base', names{i}, oo_.endo_simul(i,:)');
end

// ===== Figure 1: core macro ==========================================
figure()
subplot(3,3,1); plot(PIE(1:60));     yline(4.0, '--', 'Target = 4.0%');  title('CORE PCE Q-o-Q Inflation')
subplot(3,3,2); plot(PIE4(1:60));    yline(4.0, '--', 'Target = 4.0%');  title('CORE PCE Y-o-Y Inflation')
subplot(3,3,3); plot(Y(1:60));       yline(0, '--', "");                 title('Output Gap')
subplot(3,3,4); plot(C(1:60));                                           title('Credibility')
subplot(3,3,5); plot(SIGNAL_CBP(1:60));                                  title('CB Performance Index')
subplot(3,3,6); plot(RR(1:60));      yline(4.0, '--', 'Neutral = 4.0%'); title('Real Interest Rate')
subplot(3,3,7); plot(RS(1:60));      yline(8.0, '--', 'Neutral = 8.0%'); title('Nominal Interest Rate')
subplot(3,3,8); plot(CUMSUMY(1:60)); yline(0, '--', "");                 title('Cumulative Output Gap')
subplot(3,3,9); plot(PGAP(1:60));    yline(0, '--', "");                 title('Price Level Gap')

// ===== Figure 2: rates, GDP, exchange rate ===========================
figure()
subplot(3,3,1); plot(RR_BAR(1:60));      yline(4.0, '--', 'Neutral = 4.0%');               title('Real Equilibrium Interest Rate')
subplot(3,3,2); plot(RR_GAP(1:60));      yline(0, '--', "");                               title('Real Interest Rate Gap')
subplot(3,3,3); plot(PIE4EXP4(1:60));    yline(4.0, '--', 'Target = 4.0%');                title('4Q-Ahead YoY Inflation')
subplot(3,3,4); plot(DL_GDP(1:60));      yline(3.5, '--', 'Steady state = 3.5%');          title('Real GDP, YoY Growth')
subplot(3,3,5); plot(DL_GDP_BAR(1:60));  yline(3.5, '--', 'Steady state = 3.5%');          title('Potential GDP, YoY Growth')
subplot(3,3,6); plot(delta_Z(1:60));     yline(-0.25, '--', 'Trend appreciation = -0.25%'); title('Change in Real Exchange Rate')
subplot(3,3,7); plot(delta_Z_BAR(1:60)); yline(-0.25, '--', 'Trend appreciation = -0.25%'); title('Change in Equilibrium Real Exch. Rate')
subplot(3,3,8); plot(Z_GAP(1:60));       yline(0, '--', "");                               title('Real Exchange Rate Gap')
subplot(3,3,9); plot(PREM(1:60));        yline(3.5, '--', 'SS risk premium = 3.5%');       title('Country Risk Premium')

// ===== Figure 3: external block ======================================
figure()
subplot(3,3,1); plot(RR_US(1:60));     yline(1.5, '--', 'Equilibrium = 1.5%'); title('US Real Interest Rate')
subplot(3,3,2); plot(RR_BAR_US(1:60)); yline(1.5, '--', "");                   title('US Equilibrium Real Interest Rate')
subplot(3,3,3); plot(Y_WORLD(1:60));   yline(0, '--', "");                     title('World Output Gap')
