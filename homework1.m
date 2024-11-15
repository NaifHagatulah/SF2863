birthdate = 19990301;   % Write the birth date on format yyyymmdd for oldest member
format long;
[lambda1,lambda2,mu1,mu2,V1,V2,V] = getFerrydata(birthdate);  % Do not clear or redefine these variables.
h=0.001; % Discretization step

%% ANALYTIC SOLUTION
% Question 1 should be answered in the report

% Question 2 should be answered in the report, and submitted below
Qfunc= @(n1, n2) [-(lambda1 + lambda2), lambda1, lambda2, 0;
                  3*mu1, -(lambda2 + 3*mu1)    , 0      , lambda2;
                  3*mu2,     0,  -(lambda1 + 3*mu2), lambda1 ;
                  0,     n2*lambda2,     n1*lambda1, -(n1*lambda1 + n2*lambda2)];

                                    

Qi = Qfunc(3, 0);
 
      
Qieig=sort(eig(Qi)); % We compare the eigenvalues
% To make sure that the order of your states will not change the result
Qii = Qfunc(2,1);
Qiieig=sort(eig(Qii));
Qiii = Qfunc(1,2);
Qiiieig=sort(eig(Qiii));
Qiv = Qfunc(0,3);
Qiveig=sort(eig(Qiv));

% Question 3 should be answered in the report

pi_calc = @(Q) [Q'; ones(1,size(Q,1))]\[0;0;0;0;1];
PIi  = pi_calc(Qi);
PIisort=sort(PIi); % We compare the sorted vectors
PIii = pi_calc(Qii); 
PIiisort=sort(PIii);
PIiii = pi_calc(Qiii);
PIiiisort=sort(PIiii);
PIiv = pi_calc(Qiv);
PIivsort=sort(PIiv);

% Question 5 should be answered in the report, describe how you do it, and 


average_speed_i = PIi(1) * V + PIi(2) * V1 + PIi(3) * V2 + PIi(4) * 0;
average_speed_ii = PIii(1) * V + PIii(2) * V1 + PIii(3) * V2 + PIii(4) * 0;
average_speed_iii = PIiii(1) * V + PIiii(2) * V1 + PIiii(3) * V2 + PIiii(4) * 0;
average_speed_v = PIiv(1) * V + PIiv(2) * V1 + PIiv(3) * V2 + PIiv(4) * 0;

AVi = average_speed_i 
AVii = average_speed_ii 
AViii = average_speed_iii
AViv = average_speed_v 

AV= [AVi AVii AViii AViv];

%% CONTINUOUS TIME SIMULATION
% Question 6a should be answered in the report

% Question 7a should be answered in the report, describe how you do it, and check that the result agrees with the analytic result
[prob, speed] = quesiton7a(Qi, 100, V, V1, V2);
% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below

AVtTF = "to do"   % This will be the answer to the new question, I will describe it in the pdf.
% Describe in the report how you do this. 

%% DISCRETE TIME SIMULATION
% Question 6b should be answered in the report, describe how you determine the transition matrix and enter below

P = "to do"

% Question 7b should be answered in the report, describe how you do it, and check that the result agrees with the analytic result

% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below


% Question 9a should be answered in the report, describe how you do it, do the calculations and enter results below

Probfail10 = "to do"

ETtTF = "to do"


% Some of the following commands may be useful for the implementation when repeating steps over and over
% for, while, switch, break
function [stationary_state_prob, speed] = quesiton7a(Q, T, V, V1, V2)     
      state = 1;
      t = 0;
      t_in_states = zeros(1,4);
      speed = 0;
      while t < T
            switch state
                  case 1
                        % Code to execute if expression == value1
                        %sample from exponential distribution with rate lambda1 and lambda2
                        %update state
                        %update time
                        q12 = exprnd(Q(1,2)) * (Q(1,2) > 0) + 1000000 * (Q(1,2) == 0);
                        q13 = exprnd(Q(1,3)) * (Q(1,3) > 0) + 1000000 * (Q(1,3) == 0);
                        if(q12 < q13)
                              state = 2;
                              t = t + q12;
                              t_in_states(1) = t_in_states(1) + q12; 
                              speed = speed +  V*q12;
                        else
                              state = 3;
                              t = t + q13;
                              t_in_states(1) = t_in_states(1) + q13; 
                              speed = speed +  V*q13;
                        end
                        

                  case 2
                        q21 = exprnd(Q(2,1)) * (Q(2,1) > 0) + 1000000 * (Q(2,1) == 0);
                        q24 = exprnd(Q(2,4)) * (Q(2,4) > 0) + 1000000 * (Q(2,4) == 0);
                        if(q21 < q24)
                              state = 1;
                              t = t + q21;
                              t_in_states(2) = t_in_states(2) + q21; 
                              speed = speed + V1*q21;
                        else
                              state = 4;
                              t = t + q24;
                              t_in_states(2) = t_in_states(2) + q24; 
                              speed = speed + V1*q24;
                        end
                  case 3
                        q31 = exprnd(Q(3,1)) * (Q(3,1) > 0) + 1000000 * (Q(3,1) == 0);
                        q34 = exprnd(Q(3,4)) * (Q(3,4) > 0) + 1000000 * (Q(3,4) == 0);
                        if(q31 < q34)
                              state = 1;
                              t = t + q31;
                              t_in_states(3) = t_in_states(3) + q31; 
                              speed = speed + V2*q31;
                        else
                              state = 4;
                              t = t + q34;
                              t_in_states(3) = t_in_states(3) + q34; 
                              speed = speed + V2*q34; 
                        end
                  case 4
                        q42 = exprnd(Q(4,2)) * (Q(4,2) > 0) + 1000000 * (Q(4,2) == 0);
                        q43 = exprnd(Q(4,3)) * (Q(4,3) > 0) + 1000000 * (Q(4,3) == 0);
                        
                        if(q42 < q43)
                              state = 2;
                              t = t + q42;
                              t_in_states(4) = t_in_states(4) + q42; 
                        else
                              state = 3;
                              t = t + q43;
                              t_in_states(4) = t_in_states(4) + q43;
                        end
            end
      end
      speed = speed/t;
      stationary_state_prob = t_in_states/t;

end