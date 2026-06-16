var 
PIE             // QoQ Inflation 
PIE4            // 1 year moving average of inflation  
PIE_EXP         // Inflation Expectations
C               // Credibility 
SIGNAL_CBP      // CBA Credibility 
RES_PIE4_LOW    // 
RES_PIE4_HIGH   // 
Y               // Output gap
RS              // Nominal interest rate
RR              // Real interest rate
RR_BAR          // Real interest rate trend
RR_GAP          // Real interest rate gap
UNR             // Unemployment rate
UNR_GAP         // Unemployment GAP
UNR_BAR         // Equilibrium Unemployment Rate (NAIRU)
g_UNR           // Persistent component in NAIRU
DL_GDP          // Real GDP, Q-o-Q Log Growth
DL_GDP_BAR      // Potential GDP, Q-o-Q Log Growth
G_GDP_BAR       // Persistent Component in Potential GDP Growth
;


varexo 
E_Y             // Output Gap shock
E_PIE           // Inflation Shock
E_DL_GDP_BAR    // Potential GDP Shock
E_G_GDP_BAR     // Persistent Shock of Potential GDP Growth
E_UNR_BAR       // NAIRU Shock 
E_UNR_g         // Persistent Shock of NAIRU 
E_UNR           // Unemployment Gap Shock 
E_RS            // Interest Rate Shock
E_RR_BAR        // Real Interest Rate Trend Shock
E_PIE_EXP       // Shock to Inflation Expectations 
E_C             // Credibility Shock 
;

parameters BETA1, BETA2, BETA3, LAMBDA1, LAMBDA2, GROWTH_SS, ALPHA1, ALPHA2, ALPHA3, ALPHA4,
           ALPHA5, ALPHA6, ALPHA7, ALPHA8, PIE_SS, UNR_SS, RR_BAR_STAR, GAMMA1, GAMMA2, GAMMA4;

BETA1 = 0.75;
BETA2 = 0.15;
BETA3 = 0.20;
LAMBDA1 = 0.50;
LAMBDA2 = 0.25;
GROWTH_SS = 2.50;
ALPHA1 = 0.90;
ALPHA2 = 0.90;
ALPHA3 = 0.90;
ALPHA4 = 0.50;
ALPHA5 = 0.80;
ALPHA6 = 0.30;
ALPHA7 = 0.15;
ALPHA8 = 0.90;
PIE_SS = 2.0;
UNR_SS = 5.50;
RR_BAR_STAR = 0.50;
GAMMA1 = 0.50;
GAMMA2 = 1.50;
GAMMA4 = 0.20;



model;

Y = BETA1*Y(-1) + BETA2*Y(+1) - BETA3*RR_GAP(-1) + E_Y;

//PIE = LAMBDA1*PIE_EXP + (1 - LAMBDA1)*PIE4(-1) + LAMBDA2*(5*Y(-1)/(5-Y(-1))) + E_PIE;
PIE = LAMBDA1*PIE_EXP + (1 - LAMBDA1)*PIE4(-1) + LAMBDA2*Y(-1) + E_PIE;

PIE_EXP = C*PIE4(+4) + (1 - C)*PIE4(-1) + 0.1*(1 - C) + E_PIE_EXP; 

//C = 0.04*SIGNAL_CBP + (1-0.04)*C(-1) + E_C;
C = 1 + E_C;

SIGNAL_CBP =  RES_PIE4_HIGH^2/(RES_PIE4_HIGH^2+RES_PIE4_LOW^2) ; 

// RES_PIE4_LOW =    Actual           -          Forecast
RES_PIE4_LOW =       PIE4    -      (   0.5*PIE_SS+0.5*PIE4(-1))   ;

// RES_PIE4_HIGH =    Actual           -          Forecast
RES_PIE4_HIGH =       PIE4    -      (   0.1*10 + 0.9*PIE4(-1))   ;

PIE4 = 0.25*(PIE+PIE(-1)+PIE(-2)+PIE(-3));

DL_GDP = DL_GDP_BAR + (Y - Y(-1));

DL_GDP_BAR = ALPHA1*DL_GDP_BAR(-1) + (1-ALPHA1)*G_GDP_BAR + E_DL_GDP_BAR;

G_GDP_BAR = ALPHA2*G_GDP_BAR(-1) + (1-ALPHA2)*GROWTH_SS + E_G_GDP_BAR;

RR = RS-PIE(+1);

RR_BAR = ALPHA3*RR_BAR(-1) + (1-ALPHA3)*RR_BAR_STAR + E_RR_BAR;

RR_GAP = RR - RR_BAR;

UNR_GAP = UNR_BAR - UNR;

UNR_BAR = ALPHA8*UNR_BAR(-1) + (1-ALPHA8)*UNR_SS + g_UNR + E_UNR_BAR;

g_UNR = (1-ALPHA4)*g_UNR(-1) + E_UNR_g;

UNR_GAP = ALPHA5*UNR_GAP(-1) + ALPHA6*Y + ALPHA7*Y(+1) + E_UNR;

RS = GAMMA1*RS(-1) + (1 - GAMMA1)*(RR_BAR + PIE4(+3) + GAMMA2*(PIE4(+3) - PIE_SS) + GAMMA4*Y) + E_RS;

end;



steady_state_model;
PIE = PIE_SS;
PIE4 = PIE_SS;
Y = 0;
G_GDP_BAR = GROWTH_SS;
DL_GDP_BAR = GROWTH_SS;
DL_GDP = GROWTH_SS;
RR_BAR = RR_BAR_STAR;
RR = RR_BAR_STAR;
RR_GAP = 0;
RS = RR + PIE;
UNR = UNR_SS;
UNR_GAP = 0;
UNR_BAR = UNR_SS;
g_UNR = 0;
SIGNAL_CBP = 1;
C = 1;
PIE_EXP = PIE_SS;
RES_PIE4_LOW = 0;
RES_PIE4_HIGH = -0.8;
end;



steady;


shocks;
var E_PIE;
periods 1:2;
values 1;

end;


// simul(periods=80);
perfect_foresight_setup(periods=80);
perfect_foresight_solver(lmmcp);

// perfect_foresight_solver; 

% --- Pull series directly from the simulation -------------------
lag = M_.maximum_lag;
idx = @(v) find(strcmp(M_.endo_names, v));

RS_p     = oo_.endo_simul(idx('RS'),     lag+1:end);
PIE_p    = oo_.endo_simul(idx('PIE'),    lag+1:end);
Y_p      = oo_.endo_simul(idx('Y'),      lag+1:end);
C_p      = oo_.endo_simul(idx('C'),      lag+1:end);
DL_GDP_p = oo_.endo_simul(idx('DL_GDP'), lag+1:end);
UNR_p    = oo_.endo_simul(idx('UNR'),    lag+1:end);

% --- Plot (one figure, 3x2 subplots) ----------------------------
figure()

subplot(3,2,1); plot(RS_p(1:40));     yline(2.5, '--', 'Neutral = 3.0%'); title('Fed Funds Rate')
subplot(3,2,2); plot(PIE_p(1:40));    yline(2.0, '--', 'Target = 2.0%');  title('CORE PCE Y-o-Y Inflation')
subplot(3,2,3); plot(Y_p(1:40));      yline(0, '--', '');                 title('Output Gap')
subplot(3,2,4); plot(C_p(1:40));      ylim([0 1]);                        title('CB Credibility Index')
subplot(3,2,5); plot(DL_GDP_p(1:40)); yline(2, '--', '');                 title('Real GDP Growth')
subplot(3,2,6); plot(UNR_p(1:40));    yline(5.5, '--', '');               title('Unemployment Rate')