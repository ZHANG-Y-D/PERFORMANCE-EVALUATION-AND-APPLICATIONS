clear

MuOff = 1;
MuOn = 0.1;
MuSen = 3;
MuProc = 5;

PAct = 0.1;

EpsilonOff = 0.1;
EpsilonOn = 1;
EpsilonProc = 5;
EpsilonAct = 50;


% Extra information from Trace file
filename = 'Trace13.txt';
action_duration = read_action_duration_from_txt_file(filename);
N = size(action_duration,1);


% The first four moments
M1 = mean(action_duration);
M2 = mean(action_duration.^2);
M3 = mean(action_duration.^3);
M4 = mean(action_duration.^4);


% Sort
sorted_traces = sort(action_duration(:,1));

% Method of moments
% fsolve Parameters for Hyper Exponential Distribution
fun = @(p)MM_HyperExp(p,M1,M2,M3,1);
HE_pars_MM = fsolve(fun,[0.8/M1, 1.2/M1,0.4]);

% fsolve Parameters for Hypo Exponential Distribution
fun = @(p)MM_HypoExp(p,M1,M2,1);
HypoExp_pars_MM = fsolve(fun,[ 1/(0.3*M1),1/(0.7*M1)]);



figure;
subplot(2,1,1);
title("Method of moments of Trace ");
hold on;


% Trace
plot(sorted_traces, find(sorted_traces==sorted_traces)/size(sorted_traces,1), '.','Color','#627CCB');


t = (0:1000)/10;
% Exponential Distribution
plot(t,1-exp(-t/M1),"+","Color","#86CC66",'LineWidth',0.5);


% Hyper Exponential Distribution
F_HyperExp = 1 - HE_pars_MM(3) * exp(-t*HE_pars_MM(1)) - (1-HE_pars_MM(3))*exp(-t*HE_pars_MM(2));
plot(t,F_HyperExp,"Color","#C4724F",'LineWidth',1.5);


% Hypo Exponential Distribution
F_HypoExp = 1 - HypoExp_pars_MM(2)*exp(-HypoExp_pars_MM(1)*t)/(HypoExp_pars_MM(2)-HypoExp_pars_MM(1)) + HypoExp_pars_MM(1)*exp(-HypoExp_pars_MM(2)*t)/(HypoExp_pars_MM(2)-HypoExp_pars_MM(1));
plot(t,F_HypoExp,"Color","#C1BA44",'LineWidth',1);




legend('Trace','Exp','Hyper Exp','Hypo Exp');
xlim([0 10]);
ylim([0 1]);
hold off;


% Method of maximum likelihood

% PDF of Exponential Distribution
Exp_pars_MLE = mle(action_duration(:,1),'pdf', ...
    @Exp_pdf,'start',0.5, ...
    'LowerBound',0,'UpperBound',Inf);


% PDF of Hyper Exponential Distribution
HE_pars_MLE = mle(action_duration,'pdf', ...
    @HyperExp_pdf,'start',[0.8/M1, 1.2/M1,0.4], ...
    'LowerBound',[0,0,0],'UpperBound',[Inf,Inf,1]);

% PDF of Hypo Exponential Distribution
HypoExp_pars_MLE = mle(action_duration,'pdf', ...
    @HypoExp_pdf,'start',[ 1/(0.3*M1),1/(0.7*M1)], ...
    'LowerBound',[0,0],'UpperBound',[Inf,Inf]);


subplot(2,1,2);
hold on;
title("Method of maximum likelihood of Trace ");

% Trace
plot(sorted_traces, find(sorted_traces==sorted_traces)/size(sorted_traces,1), '.','Color','#627CCB');

% Exponential Distribution 
plot(t,1-exp(-t*Exp_pars_MLE),"+","Color","#86CC66",'LineWidth',0.5);


% Hyper Exponential Distribution 
plot(t,1 - HE_pars_MLE(3) * exp(-t*HE_pars_MLE(1)) - (1-HE_pars_MLE(3))*exp(-t*HE_pars_MLE(2)),"Color","#C4724F",'LineWidth',1);

% Hypo Exponential Distribution 
plot(t,1 - (HypoExp_pars_MLE(2) * exp(-t*HypoExp_pars_MLE(1)))/(HypoExp_pars_MLE(2)-HypoExp_pars_MLE(1)) + (HypoExp_pars_MLE(1) * exp(-t*HypoExp_pars_MLE(2)))/(HypoExp_pars_MLE(2)-HypoExp_pars_MLE(1)),"Color","#C1BA44",'LineWidth',1);


legend('Trace','Exp','Hyper Exp','Hypo Exp');
xlim([0 10]);
ylim([0 1]);
hold off;




% From the fitting result, the MLE is a bit better than Method of moments.  
% So Use the Parameter from the MLE result.
lambda1_action = HE_pars_MLE(1);
lambda2_action = HE_pars_MLE(2);
P1_action = HE_pars_MLE(3);
P2_action = 1 - HE_pars_MLE(3);


% Infinitesimal generator
Q = zeros(5,5);
Q(1,2) = MuOn;
Q(1,1) = -Q(1,2);

Q(2,1) = MuOff;
Q(2,3) = MuSen;
Q(2,2) = -Q(2,1)-Q(2,3);

Q(3,2) = (1-PAct)*MuProc;
Q(3,4) = P1_action*PAct*MuProc;
Q(3,5) = P2_action*PAct*MuProc; % P2_action = 1 - P1_action;
Q(3,3) = -Q(3,2)-Q(3,4)-Q(3,5);

Q(4,2) = lambda1_action;
Q(4,4) = -Q(4,2);

Q(5,2) = lambda2_action;
Q(5,5) = -Q(5,2);


% Initial: Off state
p0 = [1, 0, 0, 0, 0];

% state rewards
alphaOff = [EpsilonOff,0,0,0,0];
alphaOn = [0,EpsilonOn,0,0,0];
alphaProcessing = [0,0,EpsilonProc,0,0];
alphaAction = [0,0,0,EpsilonAct,EpsilonAct];


% transition reward of On state
xi_On = [0,1,0,0,0;
         0,0,0,0,0;
         0,1,0,0,0;
         0,1,0,0,0
         0,1,0,0,0];


% Column vector
[t, Sol]=ode45(@(t,x) Q'*x, [0 20], p0');
figure;
plot(t, Sol, "-");
legend('1-Off','2-On','3-Processing','4-Action a','5-Action b');

[t, Sol]=ode45(@(t,x) Q'*x, [0 100000], p0');
figure;
plot(t, Sol, "-");
legend('1-Off','2-On','3-Processing','4-Action a','5-Action b');

Qprime = Q;
Qprime(:,1) = ones(5,1);

u = [1, 0, 0, 0, 0];
pi = u* inv(Qprime);


% the average energy consumption(steady-state)
Avg_energy_consumption_steady_state = alphaOff*pi' + alphaOn*pi' + alphaProcessing*pi' + alphaAction*pi';


% on frequency
Omega_On = 0;
for i = 1:size(Q,1)
    for j = 1:size(Q,1)
        if i ~= j
            Omega_On = sum(Omega_On+pi(1,i)*Q(i,j)*xi_On(i,j));
        end
    end
end


