
close all; 
%% First we generate input data
birthdate = 19990301;  % Write the birth date on format yyyymmdd for oldest member in the group
format compact;
[lambdavec,Tvec,cvec] = getSPOdata(birthdate);   %yyyymmdd  Do not use clear command or change the values of these variables

% -------------------------------------------------------------------------------------------------------------------
%% Marginal Allocation
% Question 1 should be answered in the report

% Question 2 should described in the report, and submitted below
% Enter on the format EBO2 = [EBO_1(2) EBO_2(2) ... EBO_9(2)]      
% EBO_j(2) should be the EBO for two spares of LRU2
% Cost2 should be the total cost for the allocation of spares (scalar)
smax = 2;
cost = 0;
EBO2 = [];
for i=1:length(lambdavec)
    [p,R,EBO] = EBOcomp(lambdavec(i),Tvec(i), smax);
    EBO2 = [EBO2 EBO(smax+1)];
    cost = cost + costcomp(cvec(i),smax);
end 

Cost2 = cost;

Q2 = [EBO2 Cost2]; % Checking both at the same time in grader.

% Question 3, you should describe how the Marginal allocation is
% implemented in your own words in the report, and compute all efficient
% points.
%Step 0
it = 10;
k = 1;
nmrParts = size(lambdavec,2);
s = zeros(it,nmrParts);
C = zeros(it,1);
table = zeros(it, nmrParts);
tabletest = zeros(it, nmrParts);
for i=1:length(lambdavec)
    table(:,i) = Rcomp(lambdavec(i),Tvec(i),it)/cvec(i);
end
tabletest = table;
%generate EBO 0
EBO0 = lambdavec.*Tvec;

%Step 1 & 2
budget = 900;
spent = 0;
%svec = zeros(1, 9);
x = zeros(1,nmrParts);
X = x;
efficent_cost(1) = 0;
efficent_EBO(1) = sum(EBO0);

while budget > spent
    [r,c] = indexMax(table);
    spent = spent + cvec(c);
    if spent > budget
        break;
    end
    k = k+1;
    s(k,:) = s(k-1,:);
    s(k,c) = s(k-1,c) + 1;
    EBO0(c) = EBO0(c) - table(r,c) * cvec(c);
    if(EBO0(c) < 0)
        EBO0(c) = 0;
    end
    x(c) = x(c) + 1;
    X = [X; x];
    efficent_cost(k) = spent;
    efficent_EBO(k) = sum(EBO0);
    table(r,c) = 0;
end
%{
for i = 1:5
    [r,c] = indexMax(table);
    k = k+1;
    s(k,:) = s(k-1,:);
    s(k,c) = s(k-1,c) + 1;
    spent = spent + cvec(c);
    EBO0 = EBO0 - table(r,c) * cvec(c);
    x(c) = x(c) + 1;
    X(k-1, :) = x;
    efficent_cost(k - 1) = spent;
    efficent_EBO(k - 1) = EBO0;
    if(EBO0 < 0)
        efficent_EBO(k - 1) = 0;
    end
    table(r,c) = 0;
end
%}
%PLOT THE EFFICENT POINTS

figure
hold on;
plot(efficent_cost,efficent_EBO,'.-k','LineWidth',2,'MarkerSize',20)
plot(Cost2, sum(EBO2), 'ro', 'MarkerSize', 5)
legend('Efficient Points', '2 spare parts')
xlabel("Total Cost ",'FontSize',10,'interpreter','latex')
ylabel("EBO",'FontSize',10,'interpreter','latex')









% Question 4 should be answered in the report, with a figure and a table with
% all efficient points
% Furthermore, a table with first five efficient points should be submitted below
 
% Enter on the format EPtable = [ x0 EBO(x0) C(x0); x1 EB0(x1) C(x1); ... x4 EBO(x4) C(x4)]
% Where xj is the row vector with number of spare parts of each kind
% corresponding to the efficient points generated by the Marginal allocation algorithm
% EBO and C are the total values (scalars) for each allocation xj
EPcalc = zeros(5,11);
for i=1:k
    EPcalc(i,:) = [X(i,:), efficent_EBO(i), efficent_cost(i)];
end
EPtable = EPcalc(1:5,:);


% Question 5 should be discussed in the report

% You may use the commands below as a template to plot the figures.
% fig1 = figure(1)
% plot(total_cost,EBO_expect,'.-k','LineWidth',2,'MarkerSize',20)
% hold on   % Keeps old plots and adds new plots on top of the old
% hold off  % Replaces old plots with the new one
% grid on
% set(gca,'FontSize',20,'TickLabelInterpreter','latex')
% xlabel("Total Cost [-]",'FontSize',20,'interpreter','latex')
% ylabel("EBO [-]",'FontSize',20,'interpreter','latex')
% title('Efficient Solutions Curve','FontSize',20,'interpreter','latex')
% print(fig1, '-dpdf', 'myfigure.pdf'); % save to the 'myfigure.pdf' file

% -------------------------------------------------------------------------------------------------------------------
%% Dynamic Programming
% Question 6 should be answered in the report

% Question 7 should be answered in the report, and submitted below
% as a row vector with numbers of LRU1 used for budget 0 to 50.


LRU1vec = zeros(1,51);

for i = 1:51
    [x_optimal1, ~ ] =  dp_spare_parts2(i - 1, cvec(1), lambdavec(1), Tvec(1));
    LRU1vec(i) = x_optimal1;
end

LRU1 = LRU1vec;

% Question 8 should be answered in the report, and submitted below
% Enter on the format DynPtable = [ x0 EBO(x0) C(x0); x1 EB0(x1) C(x1); ... x4 EBO(x4) C(x4)]
% Where x0 to x4 are the row vectors with number of spare parts of each kind
% corresponding to the points optimal for budgets 0,100,150, 350, 500.
budgets =  [0,100,150, 350, 500];
dynP = zeros(5,11);
for i = 1:5
    budget = budgets(i);
    [x_optimal, EBO_optimal] = dp_spare_parts2(budget, cvec, lambdavec, Tvec);
    dynP(i, :) = [x_optimal, EBO_optimal, x_optimal*cvec'];
end


DynPtable = dynP;

% Question 9 should be answered in the report

% Question 10 should be answered in the report, and submitted below
NumberOfConfigurations = 6^9;













