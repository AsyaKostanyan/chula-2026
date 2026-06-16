var PIE   // Inflation 
PIE4      // YoY Inflation

RS        // Fed Funds Rate 
RS4       // 1-Year Nominal Rate
RS8       // 2-Year Nominal Rate
RS20      // 5-Year Nominal Rate
RS40      // 10-Year Nominal Rate

RR        // Real Ineterest Rate
RR4       // 1-Year Real Rate
RR_BAR     // Equilibrium Real Inetrest Rate 
RRGAP     // Real Interest Rate Gap 
Y         // Output Gap

RES_PIE4_LOW    // Low Inflation Regime
RES_PIE4_HIGH   // High Inflation Regime
SIGNAL_CBP      // Central Bank Performance Indicator
C               // Central Bank Credibility
PIE4EXP4        // 1-Year Ahead Inflation Expectations
PIE4EXP8        // 2-Year Ahead Inflation Expectations
PIE4EXP20      // 5-Year Ahead Inflation Expectations
PIE4EXP40      // 10-Year Ahead Inflation Expectations

TERM10YR      // 10-Year Term Premium
RS10YR        // Nominal 10 Year Interest Rate
RR_BAR4       // Real 1-Year Interest Rate Trend
LR            // Long Run Interest Rate
LR_BAR        // Long Run interest Rate Trend
LR_GAP        // Long Run Interest Rate Gap

UNR_GAP,  // Unemployment Gap
UNR_BAR,  // NAIRU
UNR,      // Unemplyment Rate
g_UNR,    // Persistent component in NAIRU

DL_GDP,      // Real GDP Growth (100*log difference)
DL_GDP_BAR,  // Potential GDP Growth
g_GDP_BAR   // Persistant Component in Potential GDP Growth

CUMSUMY     // Cummulative Output Gap
PIE_GAP     // Inflation Gap
DRS         // Interest Rate Difference
LOSS;       // Loss

varexo eps_Y, eps_PIE, eps_RR_BAR, eps_UNR_BAR, eps_UNR_GAP, eps_g_UNR, eps_DL_GDP_BAR, 
       eps_g_GDP_BAR eps_C eps_PIE4EXP4, eps_PIE4EXP8, eps_PIE4EXP20, eps_PIE4EXP40, eps_TERM10YR; //eps_R

parameters RR_BAR_SS, PIE_SS, UNR_SS, GROWTH_SS, TERM10YR_SS, 
           RHO, ALPHA1, ALPHA2, ALPHA3, ALPHA4, ALPHA5, ALPHA6, ALPHA7, ALPHA8, ALPHA9
           BETA1, BETA2, GAMMA1, GAMMA2, GAMMA3;


RR_BAR_SS = 1;
PIE_SS = 2;
UNR_SS = 5;
GROWTH_SS = 2.0;
TERM10YR_SS = 1.5;

RHO = 0.9;

ALPHA1 = 0.9;
ALPHA2 = 0.4;
ALPHA3 = 0.7;
ALPHA4 = 0.1;
ALPHA5 = 0.1;

ALPHA6 = 0.9;
ALPHA7 = 0.9;

ALPHA8 = 0.7;
ALPHA9 = 0.1;

BETA1 = 0.05;
BETA2 = 0.25;

GAMMA1 = 0.57;
GAMMA2 = 0.19;
GAMMA3 = 0.19;

model;
// PIE = 0.5*PIE(-1) + 0.5*PIE(+1) + 0.5*Y + eps_PIE; // Linear Philipps Curve
PIE = ALPHA8*PIE4EXP4 + (1-ALPHA8)*PIE4(-1) + ALPHA9*(5*Y(-1)/(5 - Y(-1))) + eps_PIE;
PIE4 = 0.25*(PIE+PIE(-1)+PIE(-2)+PIE(-3));

// Credibility
// Low Inflation Regime
RES_PIE4_LOW = PIE4 - (0.5*PIE_SS + 0.5*PIE4(-1));

// High Inflation Regime
RES_PIE4_HIGH = PIE4 - (0.1*10 + 0.9*PIE4(-1));

SIGNAL_CBP = (RES_PIE4_HIGH^2)/(RES_PIE4_HIGH^2 + RES_PIE4_LOW^2);

C = 0.04*SIGNAL_CBP + (1-0.04)*C(-1) + eps_C;

PIE4EXP4 = C*PIE4(+4) + (1-C)*PIE4(-1) + eps_PIE4EXP4 + 0.1*(1-C);
PIE4EXP8 = C*PIE4(+8) + (1-C)*PIE4(+3) + eps_PIE4EXP8;
PIE4EXP20 = C*PIE4(+20) + (1-C)*PIE4(+15) + eps_PIE4EXP20;
PIE4EXP40 = C*PIE4(+40) + (1-C)*PIE4(+35) + eps_PIE4EXP40;


// Y = 0.5*Y(-1) + 0.5*Y(+1) - 0.2*RRGAP + eps_Y;
Y = GAMMA1*Y(-1) - GAMMA2*LR_GAP(-1) - GAMMA3*(TERM10YR - TERM10YR_SS) + eps_Y;
 
// Linear Reaction Function
// RS = RR_BAR + PIE(+1) + 1.5*(PIE(+1) - PIE_SS) + 0.2*Y + eps_R;


RS4 = 0.25*(RS + RS(+1) + RS(+2) + RS(+3));
RS8 = (1/8)*(RS + RS(+1) + RS(+2) + RS(+3) + RS(+4) + RS(+5) + RS(+6) + RS(+7));
RS20 = (1/20)*(RS + RS(+1) + RS(+2) + RS(+3) + RS(+4) + RS(+5) + RS(+6) + RS(+7) 
              + RS(+8) + RS(+9) + RS(+10) + RS(+11) + RS(+12) + RS(+13) + RS(+14)
              + RS(+15) + RS(+16) + RS(+17) + RS(+18) + RS(+19));

RS40 = (1/40)*(RS + RS(+1) + RS(+2) + RS(+3) + RS(+4) + RS(+5) + RS(+6) + RS(+7) 
              + RS(+8) + RS(+9) + RS(+10) + RS(+11) + RS(+12) + RS(+13) + RS(+14)
              + RS(+15) + RS(+16) + RS(+17) + RS(+18) + RS(+19) + RS(+20)
              + RS(+21) + RS(+22) + RS(+23) + RS(+24) + RS(+25) + RS(+26)
              + RS(+27) + RS(+28) + RS(+29) + RS(+30) + RS(+31) + RS(+32)
              + RS(+33) + RS(+34) + RS(+35) + RS(+36) + RS(+37) + RS(+38) + RS(+39));


RR = RS - PIE(+1);
RR_BAR4 = 0.25*(RR_BAR + RR_BAR(+1) + RR_BAR(+2) + RR_BAR(+3)); // !!!correct

TERM10YR = BETA1*TERM10YR_SS + (1-BETA1)*TERM10YR(-1) + BETA2*(1-C) + eps_TERM10YR;

RS10YR = RS40 + TERM10YR;

RR_BAR4 = 0.25*(RR_BAR4 + RR_BAR4(+1) + RR_BAR4(+2) + RR_BAR4(+3));
LR = 0.1*RR + 0.35*RR4 + (0.35/3)*(RR4 + RR4(+4) + RR4(+8)) + (0.2/5)* (RR4 + RR4(+4) + RR4(+8) + RR4(+12) + RR4(+16));
LR_BAR = 0.1*RR_BAR + 0.35*RR_BAR4 + (0.35/3)*(RR_BAR4 + RR_BAR4(+4) + RR_BAR4(+8)) + (0.2/5)* (RR_BAR4 + RR_BAR4(+4) + RR_BAR4(+8) + RR_BAR4(+12) + RR_BAR4(+16));
LR_GAP = LR - LR_BAR;

RR_BAR = RHO*RR_BAR(-1) + (1 - RHO)*RR_BAR_SS + eps_RR_BAR;
RRGAP = RR - RR_BAR;

// Unemployment Block
UNR_GAP = UNR_BAR - UNR;
UNR_BAR = ALPHA1*UNR_BAR(-1) + (1-ALPHA1)*UNR_SS + g_UNR + eps_UNR_BAR;
g_UNR = ALPHA2*g_UNR(-1) + eps_g_UNR;
UNR_GAP = ALPHA3*UNR_GAP(-1) + ALPHA4*Y + ALPHA5*Y(+1) + eps_UNR_GAP;

// GDP Block
DL_GDP = DL_GDP_BAR + (Y-Y(-1));
DL_GDP_BAR = ALPHA6*DL_GDP_BAR(-1) + (1-ALPHA6)*g_GDP_BAR + eps_DL_GDP_BAR;
g_GDP_BAR = ALPHA7*g_GDP_BAR(-1) + (1-ALPHA7)*GROWTH_SS + eps_g_GDP_BAR;

// Definintions
CUMSUMY = CUMSUMY(-1) + Y/4;
PIE_GAP = PIE4 - PIE_SS;  //correct
DRS = RS - RS(-1);
LOSS = 1.0*PIE_GAP^2 + 1.0*Y^2 + DRS^2;


end;

steady_state_model;
Y = 0;
PIE = PIE_SS;
PIE4 = PIE_SS;
PIE4EXP8 = PIE_SS;
PIE4EXP20 = PIE_SS;
PIE4EXP40 = PIE_SS;

RR_BAR = RR_BAR_SS;
RRGAP = 0;
RR = RR_BAR;
RR4 = RR;

RS = RR + PIE;
RS4 = RS;
RS8 = RS;
RS20 = RS;
RS40 = RS;

TERM10YR = TERM10YR_SS;
RS10YR = RS + TERM10YR;
RR_BAR4 = RR_BAR_SS;
LR = RR4;
LR_BAR = RR_BAR4;
LR_GAP = 0;

UNR_GAP = 0;
UNR_BAR = UNR_SS;
UNR = UNR_BAR;     
g_UNR = 0; 

DL_GDP = GROWTH_SS;
DL_GDP_BAR = GROWTH_SS;
g_GDP_BAR = GROWTH_SS;   

RES_PIE4_LOW  = 0;
RES_PIE4_HIGH = -0.8;
SIGNAL_CBP = 1;
C = 1;
PIE4EXP4 = PIE_SS;

CUMSUMY  = 0;
PIE_GAP  = 0;
DRS  = 0;
LOSS  = 0;
 
end;

planner_objective 1.0*PIE_GAP^2 + 1.0*Y^2 + 0.5*DRS^2;
ramsey_model(planner_discount=0.95, instruments = (RS));

steady;

shocks;
var eps_Y; periods 1 2; values 1.0 0.0;       // Output Gap Shock
var eps_PIE; periods 1 2; values 0.0 0.0;       // Inflation Shock
end;


check;

perfect_foresight_setup(periods=80);
perfect_foresight_solver(lmmcp);

// ===================== PLOTTING =====================
//figure;
//for j = 1:M_.endo_nbr
//    subplot(3,2,j);
//    plot(oo_.endo_simul(j,:)', 'LineWidth', 1.5);
//    title(M_.endo_names{j});
//    grid on;
//end
//sgtitle('Perfect-foresight simulation');
// ====================================================

// ===================== PLOTTING - Alternative =====================
lag = M_.maximum_lag;
idx = @(v)find(strcmp(M_.endo_names,v));

RS_p = oo_.endo_simul(idx('RS'), lag+1:end);
RR_p = oo_.endo_simul(idx('RR'), lag+1:end);
PIE_p = oo_.endo_simul(idx('PIE'), lag+1:end);
UNR_p = oo_.endo_simul(idx('UNR'), lag+1:end);
UNR_BAR_p = oo_.endo_simul(idx('UNR_BAR'), lag+1:end);
Y_p = oo_.endo_simul(idx('Y'), lag+1:end);
PIE4EXP4_p = oo_.endo_simul(idx('PIE4EXP4'), lag+1:end);
C_p = oo_.endo_simul(idx('C'), lag+1:end);
DL_GDP_p = oo_.endo_simul(idx('DL_GDP'), lag+1:end);
RS10YR_p = oo_.endo_simul(idx('RS10YR'), lag+1:end);


// === Subplots ===
figure()
subplot(4,2,1); plot(RS_p(1:40)); yline(3, '--', 'Neutral = 3%'); title('Fed Funds Rate');
subplot(4,2,2); plot(RR_p(1:40)); yline(1, '--', 'Neutral = 1%'); title('Real Interest Rates');
subplot(4,2,3); plot(PIE_p(1:40)); yline(2, '--', 'Target = 2%'); title('Inflation');
subplot(4,2,4); plot(UNR_p(1:40)); yline(5, '--', 'NAIRU SS = 5%'); title('Unemployment Rate');
subplot(4,2,5); plot(DL_GDP_p(1:40)); yline(2, '--', 'Potential Growth = 2%'); title('GDP Growth');
subplot(4,2,6); plot(Y_p(1:40)); yline(0, '--'); title('Output Gap');
subplot(4,2,7); plot(C_p(1:40)); yline(0, '--'); title('Central Bank Credibility');
subplot(4,2,8); plot(RS10YR_p(1:40)); title('10-Year Nominal Rates');


// ==== Generate Excel Output ====
vars = {'RS', 'RR', 'PIE', 'PIE4', 'Y', 'UNR', 'UNR_BAR', 'DL_GDP', 'C', 'RS10YR'};
rows = cellfun(idx, vars);
simout = oo_.endo_simul(rows, lag:end).';
T = array2table(simout, 'VariableNames', vars);
T = addvars(T, (1:size(T,1)).', 'Before',1, 'NewVariableNames', 'Period');
writetable(T, 'simulation_results.xlsx');

// ==== PDF Report Generation ===
exportgraphics(gcf, 'simulation_results.pdf', 'ContentType', 'vector');
