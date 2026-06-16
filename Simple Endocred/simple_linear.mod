var 
PIE             // QoQ Inflation 
PIE4            // 1 year moving average of inflation  
PIE_EXP         // Inflation Expectations
C               // Credibility 
SIGNAL_CBP      // CB Credibility Signal
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
UNR_SS = 4.50;
RR_BAR_STAR = 0.50;
GAMMA1 = 0.50;
GAMMA2 = 1.50;
GAMMA4 = 0.20;



model;

Y = BETA1*Y(-1) + BETA2*Y(+1) - BETA3*RR_GAP(-1) + E_Y;

PIE = LAMBDA1*PIE_EXP + (1 - LAMBDA1)*PIE4(-1) + LAMBDA2*Y(-1) + E_PIE;

PIE_EXP = C*PIE4(+4) + (1 - C)*PIE4(-1) + 0.1*(1 - C) + E_PIE_EXP; 

C = 0.04*SIGNAL_CBP + (1-0.04)*C(-1) + E_C;

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

histval;
C(0) = 0.95;
Y(0) = 1.0;
RS(0) = 4.3; // Average Effective Fed Funds Rate 2025Q1
PIE(0) = 3.0; //2.1;  // Nowcast for Core PCE 2025Q1, QoQ Annualized, April 29, 2025
UNR_BAR(0)  = 4.5;
UNR(0)  = 4.1; //2025Q1
UNR_GAP(0) = 0.4;
end;


scenario!(name = :E_PIE, period = 1, value = 1.0);
scenario!(name = :E_PIE, period = 2, value = 0.8);
scenario!(name = :E_PIE, period = 3, value = 0.5);
scenario!(name = :E_Y, period = 1, value = -1.0);

// simul(periods=80);
perfect_foresight_setup(periods=80);
perfect_foresight_solver(lmmcp);
