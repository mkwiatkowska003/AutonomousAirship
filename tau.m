function [out,debug] = tau(k, eta, ni, Iv, P, Mq, Lp, Zw, B, zb, t, ep, m33, m)
g = 9.81;

I11 = Iv(1);
I13 = Iv(2);
I22 = Iv(3);
I33 = Iv(4);

kx = k(1);
ky = k(2);
kz = k(3);
ke1 = k(4);
ke2 = k(5);
ke3 = k(6);

ku = k(7);
kv = k(8);
kw = k(9);
kp = k(10);
kq = k(11);
kr = k(12);

u = ni(1);
v = ni(2);
w = ni(3);
p = ni(4);
q = ni(5);
r = ni(6);

eta1 = eta(1:3,1);
eta2 = eta(4:7,1);

x = eta1(1);
y = eta1(2);
z = eta1(3);

e0 = eta2(1);
e1 = eta2(2);
e2 = eta2(3);
e3 = eta2(4);

P1 = P(1);
P2 = P(2);

delta = I13^2 - I11*I33;

pd_stage1 = (kv*v + ky*y)/sqrt(abs(v) + abs(y));
wd_stage1 = 2*sqrt(abs(v) + abs(y));

pd_elem1 = -kr*r;
pd_elem2 = -ke3*e3;
pd_elem3 = -ke1*e1;
pd_elem4 = pd_stage1*sin(t/ep);

wd_elem1 = -kz*z;
wd_elem2 = wd_stage1*sin(t/ep);

qd_elem1 = -ke2*e2;
qd_elem2 = -kx*x;
qd_elem3 = -ku*u;

pd =  pd_elem1 + pd_elem2 + pd_elem3 + pd_elem4;
wd = wd_elem1 + wd_elem2;
qd = qd_elem1 + qd_elem2 + qd_elem3;

tau1_elem1 = 1/P1^3 * (-(I22*kq + Mq)*q);
tau1_elem2 = 1/P1^3 * (I22*kq*qd);
tau1_elem3 = 1/P1^3 * (2*B*zb*e2);

tau2_elem1 = 1/(P2*I13) * ((delta*kp + Lp*I33)*p);
tau2_elem2 = 1/(P2*I13) * (-delta*kp*pd);
tau2_elem3 = 1/(P2*I13) * (- 2*B*zb*e1*I33);

tau3_elem1 = -(m33*kw + Zw)*w;
tau3_elem2 = m33*kw*wd;
tau3_elem3 = (B - m*g);

tau1 = tau1_elem1 + tau1_elem2 + tau1_elem3;
tau2 = tau2_elem1 + tau2_elem2 + tau2_elem3;
tau3 = tau3_elem1 + tau3_elem2 + tau3_elem3;

out = [tau1; tau2; tau3];
debug = [pd_elem1; pd_elem2; pd_elem3; pd_elem4; wd_elem1; wd_elem2; qd_elem1;
    qd_elem2; qd_elem3; tau1_elem1; tau1_elem2; tau1_elem3; tau2_elem1; tau2_elem2; tau2_elem3;
    tau3_elem1; tau3_elem2; tau3_elem3];
end

