addpath('./matrices')
load('mass_approx')
syms x y z e_0 e_1 e_2 e_3
syms u v w p q r

g = 9.81;

eta_1 = [x; y; z]
eta_2 = [e_0; e_1; e_2; e_3]

m = mass;
X_x = 0;
Y_y = 0;
Z_z = 0;

m_11 = m + X_x;
m_22 = m + Y_y;
m_33 = m + Z_z;
mass_v = [m_11 m_22 m_33];

K_x = 0;
K_z = 0;
M_y = 0;
N_x = 0;
N_z = 0;

I = I

I_11 = I(1,1) + K_x;
I_13 = I(1,3) + K_z;
I_22 = I(2,2) + M_y;
I_33 = I(3,3) + N_z;
I_31 = I(3,1) + N_x;
inertia_v = [I_11 I_13 I_22 I_33 I_31];

P1 = 2.5;
P2 = -5;
P = [P1 P2];

ni = [u v w p q r];

M_ni = [m_11 0 0 0 0 0;...
    0 m_22 0 0 0 0;...
    0 0 m_33 0 0 0;...
    0 0 0 I_11 0 I_13;...
    0 0 0 0 I_22 0;...
    0 0 0 I_13 0 I_33];

Xu = 1;
Yv = 2;
Zw = 2;
Lp = 1;
Mq = 1;
Nr = 1;

D_v = diag([-Xu -Yv -Zw -Lp -Mq -Nr]);
param = [Xu Yv Z_z];

C_ = matlabFunction(C_ni(mass_v, inertia_v, ni,param));
J_ = matlabFunction([R(eta_2) zeros(3,3);...
    zeros(4,3) J(eta_2)])
B_ = B_r(P);
B = mass*g*1;
zb = 0.1;
g_ = matlabFunction(g_ni(eta_2,mass,B,zb,g))

k = zeros(1,12);
kx = 2;     k(1) = kx;
ky = 0.4;   k(2) = ky;
kz = 0.8495;   k(3) = kz;

ke1 = 0.05; k(4) = ke1;
ke2 = 1.24; k(5) = ke2;
ke3 = 0.2;  k(6) = ke3;

ku = 2;     k(7) = ku;
kv = 0.5;   k(8) = kv;
kw = 1;     k(9) = kw;
kp = 0.4;   k(10) = kp;
kq = 1.6;   k(11) = kq;
kr = 0.05;  k(12) = kr;

eta = [0.5; -0.4; 0.5; 0.986; 0.098; 0.098; 0.098];
ni = [0; 0; 0; 0; 0; 0];
epsilon = 0.00001

t = 0;
tn = 0.01;
tend = 80;

t_history = []
ni_history = []
eta_history = []
tau_history = []



while(t < tend)
    ni_args = num2cell(ni);
    eta2_args = num2cell(eta(4:7,1));
    
    kur1 = C_(ni_args{:})*ni;
    kur2 = D_v*ni;
    kur3 = g_(eta2_args{:});
    kur4 = tau(k,eta,ni,inertia_v,P,Mq,Lp,Zw,B,zb,t,epsilon,m_33,mass);
    kur5 = inv(M_ni);
    
    ni_n = (kur5*(-kur1 - kur2 - kur3 + B_*kur4))*tn + ni;
    eta_n = J_(eta2_args{:})*ni*tn + eta;
    
    t_history = [t_history t];
    ni_history = [ni_history ni];
    eta_history = [eta_history eta];
    tau_history = [tau_history kur4];
    
    ni = ni_n;
    eta = eta_n;
    t = t + tn;
    
    if(t > 7)
        plot(t_history,eta_history)
        break;
    end
    
end