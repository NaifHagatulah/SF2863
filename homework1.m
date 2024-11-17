birthdate = 19990301;   % Write the birth date on format yyyymmdd for oldest member
format compact;
[lambda1,lambda2,mu1,mu2,V1,V2,V] = getFerrydata(birthdate);  % Do not clear or redefine these variables.
h=0.001; % Discretization step

%% ANALYTIC SOLUTION
% Question 1 should be answered in the report

% Question 2 should be answered in the report, and submitted below
Qfunc= @(n1, n2) [-(lambda1 + lambda2), lambda1, lambda2, 0;
                  3*mu1, -(lambda2 + 3*mu1)    , 0      , lambda2;
                  3*mu2,     0,  -(lambda1 + 3*mu2), lambda1 ;
                  0,     n2*mu2,     n1*mu1, -(n1*mu1 + n2*mu2)];

                                    

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
PIi  = pi_calc(Qi)';
PIisort=sort(PIi); % We compare the sorted vectors
PIii = pi_calc(Qii)'; 
PIiisort=sort(PIii);
PIiii = pi_calc(Qiii)';
PIiiisort=sort(PIiii);
PIiv = pi_calc(Qiv)';
PIivsort=sort(PIiv);

% Question 5 should be answered in the report, describe how you do it, and 


average_speed_i = PIi(1) * V + PIi(2) * V2 + PIi(3) * V1  + PIi(4) * 0;
average_speed_ii = PIii(1) * V + PIii(2) * V2 + PIii(3) * V1 + PIii(4) * 0;
average_speed_iii = PIiii(1) * V + PIiii(2) * V2 + PIiii(3) * V1 + PIiii(4) * 0;
average_speed_v = PIiv(1) * V + PIiv(2) * V2 + PIiv(3) * V1 + PIiv(4) * 0;

AVi = average_speed_i 
AVii = average_speed_ii 
AViii = average_speed_iii
AViv = average_speed_v 

AV= [AVi AVii AViii AViv];

%% CONTINUOUS TIME SIMULATION
% Question 6a should be answered in the report

% Question 7a should be answered in the report, describe how you do it, and check that the result agrees with the analytic result
[prob1, speed1] = quesiton7a(Qi, 11000, V, V1, V2);
[prob2, speed2] = quesiton7a(Qi, 11000, V, V1, V2);
error = max(abs(prob1 - prob2)./prob1)       ;

% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below
times = zeros(10000,1);
for i=1:10000
      [time] = quesiton7a_mod(Qi);
      times(i) = time;
end

AVtTF = sum(times)/10000   % This will be the answer to the new question, I will describe it in the pdf.
% Describe in the report how you do this. 

%% DISCRETE TIME SIMULATION
% Question 6b should be answered in the report, describe how you determine the transition matrix and enter below
N = 10000;
h = 0.001;
P = zeros(4,4);
Pexp = expm(Qi * h);
for i =1:4
      for j = 1:4
            if i == j
                  P(i,i) = 1 + Qi(i,i)*h;
            else
                  P(i,j) = Qi(i,j)*h;
            end
      end
end
P = P;
% Question 7b should be answered in the report, describe how you do it, and check that the result agrees with the analytic result
[prob3, speed3] = question7b(P, V, V1, V2, h, N);
[prob4, speed4] = question7b(P, V, V1, V2, h, N);
error2 = max(abs(prob3 - prob4)./prob3);
numbers = zeros(100,1);

% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below
speed3;

% Question 9a should be answered in the report, describe how you do it, do the calculations and enter results below
P10states = [1,0,0,0]*(Pexp^10);
Probfail10 = P10states(4)

b = ones(3,1);
h = (eye(3)-P(1:3,1:3))\b;
ETtTF = h(1)




% Some of the following commands may be useful for the implementation when repeating steps over and over
% for, while, switch, break
function [t] = quesiton7a_mod(Q)     
      state = 1;
      t = 0;
      t_in_states = zeros(4,1);
      speed = 0;
      while true
            switch state
                  case 1
                        % Code to execute if expression == value1
                        %sample from exponential distribution with rate lambda1 and lambda2
                        %update state
                        %update time
                        
                        q12 = exprnd(1/Q(1,2));
                        q13 = exprnd(1/Q(1,3));
                        if(q12 < q13)
                              state = 2;
                              t = t + q12;
                              t_in_states(1) = t_in_states(1) + q12; 
                              %speed = speed +  V*q12;
                        else
                              state = 3;
                              t = t + q13;
                              t_in_states(1) = t_in_states(1) + q13; 
                              %speed = speed +  V*q13;
                        end
                        

                  case 2
                        q21 = exprnd(1/Q(2,1));
                        q24 = exprnd(1/Q(2,4));
                        if(q21 < q24)
                              state = 1;
                              t = t + q21;
                              t_in_states(2) = t_in_states(2) + q21; 
                              %speed = speed + V2*q21;
                        else
                              state = 4;
                              t = t + q24;
                              t_in_states(2) = t_in_states(2) + q24; 
                              %speed = speed + V2*q24;
                        end
                  case 3
                        q31 = exprnd(1/Q(3,1));
                        q34 = exprnd(1/Q(3,4));
                        if(q31 < q34)
                              state = 1;
                              t = t + q31;
                              t_in_states(3) = t_in_states(3) + q31; 
                              %speed = speed + V1*q31;
                        else
                              state = 4;
                              t = t + q34;
                              t_in_states(3) = t_in_states(3) + q34; 
                              %speed = speed + V1*q34; 
                        end
                  case 5
                        q42 = exprnd(1/Q(4,2)) * (Q(4,2) > 0) + 1000000 * (Q(4,2) == 0);
                        q43 = exprnd(1/Q(4,3)) * (Q(4,3) > 0) + 1000000 * (Q(4,3) == 0);
                        
                        if(q42 < q43)
                              state = 2;
                              t = t + q42;
                              t_in_states(4) = t_in_states(4) + q42; 
                        else
                              state = 3;
                              t = t + q43;
                              t_in_states(4) = t_in_states(4) + q43;
                        end
                  otherwise
                        break;
                        
            end
      end

end



function [stationary_state_prob, speed] = quesiton7a(Q, T, V, V1, V2)     
      state = 1;
      t = 0;
      t_in_states = zeros(4,1);
      speed = 0;
      while t < T
            switch state
                  case 1
                        % Code to execute if expression == value1
                        %sample from exponential distribution with rate lambda1 and lambda2
                        %update state
                        %update time
                        
                        q12 = exprnd(1/Q(1,2));
                        q13 = exprnd(1/Q(1,3));
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
                        q21 = exprnd(1/Q(2,1));
                        q24 = exprnd(1/Q(2,4));
                        if(q21 < q24)
                              state = 1;
                              t = t + q21;
                              t_in_states(2) = t_in_states(2) + q21; 
                              speed = speed + V2*q21;
                        else
                              state = 4;
                              t = t + q24;
                              t_in_states(2) = t_in_states(2) + q24; 
                              speed = speed + V2*q24;
                        end
                  case 3
                        q31 = exprnd(1/Q(3,1));
                        q34 = exprnd(1/Q(3,4));
                        if(q31 < q34)
                              state = 1;
                              t = t + q31;
                              t_in_states(3) = t_in_states(3) + q31; 
                              speed = speed + V1*q31;
                        else
                              state = 4;
                              t = t + q34;
                              t_in_states(3) = t_in_states(3) + q34; 
                              speed = speed + V1*q34; 
                        end
                  case 5
                        q42 = exprnd(1/Q(4,2)) * (Q(4,2) > 0) + 1000000 * (Q(4,2) == 0);
                        q43 = exprnd(1/Q(4,3)) * (Q(4,3) > 0) + 1000000 * (Q(4,3) == 0);
                        
                        if(q42 < q43)
                              state = 2;
                              t = t + q42;
                              t_in_states(4) = t_in_states(4) + q42; 
                        else
                              state = 3;
                              t = t + q43;
                              t_in_states(4) = t_in_states(4) + q43;
                        end
                  otherwise
                        q43 = exprnd(1/Q(4,3));
                        state = 3;
                        t = t + q43;
                        t_in_states(4) = t_in_states(4) + q43;
            end
      end
      speed = speed/t;
      stationary_state_prob = t_in_states/t;

end

function [stationary_state_prob, speed] = question7b(P,V,V1,V2,h,N)
      state = 1;
      t_in_states = zeros(4,1);
      speed = 0;

      for t = linspace(0,N,N/h)
            sample = rand();
            switch state
                  case 1
                       tot = cumsum(P(1,:));
                        if sample < tot(1)
                              state = 1;
                              t_in_states(1) = t_in_states(1) + h;
                              speed = speed + V*h;
                        elseif sample < tot(2)  
                              state = 2;
                              t_in_states(1) = t_in_states(1) + h;
                              speed = speed + V*h;
                        elseif sample < tot(3)
                              state = 3;
                              t_in_states(1) = t_in_states(1) + h;
                              speed = speed + V*h;
                        else 
                              state = 4;
                              t_in_states(1) = t_in_states(1) + h;
                              speed = speed + V*h;
                        end
                       
                  case 2
                        
                        tot = cumsum(P(2,:));
                              if sample < tot(1)
                                    state = 1;
                                    t_in_states(2) = t_in_states(2) + h;
                                    speed = speed + V2*h;
                              elseif sample < tot(2)  
                                    state = 2;
                                    t_in_states(2) = t_in_states(2) + h;
                                    speed = speed + V2*h;
                              elseif sample < tot(3)
                                    state = 3;
                                    t_in_states(2) = t_in_states(2) + h;
                                    speed = speed + V2*h;
                              else 
                                    state = 4;
                                    t_in_states(2) = t_in_states(2) + h;
                                    speed = speed + V2*h;
                              end
                        
                  case 3 
                        tot = cumsum(P(3,:));
                              if sample < tot(1)
                                    state = 1;
                                    t_in_states(3) = t_in_states(3) + h;
                                    speed = speed + V1*h;
                              elseif sample < tot(2)  
                                    state = 3;
                                    t_in_states(3) = t_in_states(3) + h;
                                    speed = speed + V1*h;
                              elseif sample < tot(3)
                                    state = 3;
                                    t_in_states(3) = t_in_states(3) + h;
                                    speed = speed + V1*h;
                              else
                                    state = 4;
                                    t_in_states(3) = t_in_states(3) + h;
                                    speed = speed + V1*h;
                              end

                  case 4 
                        tot = cumsum(P(4,:));
                        if(sample < tot(1))
                              state = 1;
                              t_in_states(4) = t_in_states(4) + h;
                        elseif (sample < tot(2))  
                              state = 2;
                              t_in_states(4) = t_in_states(4) + h;
                        elseif sample < tot(3)  
                              state = 3;
                              t_in_states(4) = t_in_states(4) + h;
                        else
                              state = 4;
                              t_in_states(4) = t_in_states(4) + h;
                                    
                        end
            end
            
      end
      
      stationary_state_prob = t_in_states/N;
      speed = speed/N;
end


function [int] = question7b_mod(P,V,V1,V2,h,N)
      state = 1;
      t_in_states = zeros(4,1);
      speed = 0;
      int = 0;
      counter = 0;
      for t = linspace(0,N,N/h)
            sample = rand();
            counter = counter + 1;
            if(counter > 10)
                  break;
            end
            switch state
                  case 1
                       tot = cumsum(P(1,:));
                        if sample < tot(1)
                              state = 1;
                              t_in_states(1) = t_in_states(1) + h;
                              speed = speed + V*h;
                        elseif sample < tot(2)  
                              state = 2;
                              t_in_states(1) = t_in_states(1) + h;
                              speed = speed + V*h;
                        elseif sample < tot(3)
                              state = 3;
                              t_in_states(1) = t_in_states(1) + h;
                              speed = speed + V*h;
                        else 
                              state = 4;
                              t_in_states(1) = t_in_states(1) + h;
                              speed = speed + V*h;
                        end
                       
                  case 2
                        
                        tot = cumsum(P(2,:));
                              if sample < tot(1)
                                    state = 1;
                                    t_in_states(2) = t_in_states(2) + h;
                                    speed = speed + V2*h;
                              elseif sample < tot(2)  
                                    state = 2;
                                    t_in_states(2) = t_in_states(2) + h;
                                    speed = speed + V2*h;
                              elseif sample < tot(3)
                                    state = 3;
                                    t_in_states(2) = t_in_states(2) + h;
                                    speed = speed + V2*h;
                              else 
                                    state = 4;
                                    t_in_states(2) = t_in_states(2) + h;
                                    speed = speed + V2*h;
                              end
                        
                  case 3 
                        tot = cumsum(P(3,:));
                              if sample < tot(1)
                                    state = 1;
                                    t_in_states(3) = t_in_states(3) + h;
                                    speed = speed + V1*h;
                              elseif sample < tot(2)  
                                    state = 3;
                                    t_in_states(3) = t_in_states(3) + h;
                                    speed = speed + V1*h;
                              elseif sample < tot(3)
                                    state = 3;
                                    t_in_states(3) = t_in_states(3) + h;
                                    speed = speed + V1*h;
                              else
                                    state = 4;
                                    t_in_states(3) = t_in_states(3) + h;
                                    speed = speed + V1*h;
                              end

                  case 4 
                        tot = cumsum(P(4,:));
                        int = 1;
                        break;
                        if(sample < tot(1))
                              state = 1;
                              t_in_states(4) = t_in_states(4) + h;
                        elseif (sample < tot(2))  
                              state = 2;
                              t_in_states(4) = t_in_states(4) + h;
                        elseif sample < tot(3)  
                              state = 3;
                              t_in_states(4) = t_in_states(4) + h;
                        else
                              state = 4;
                              t_in_states(4) = t_in_states(4) + h;
                                    
                        end
            end
            
      end
      
      stationary_state_prob = t_in_states/N;
      speed = speed/N;
end