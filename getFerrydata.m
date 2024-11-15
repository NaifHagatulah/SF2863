
function [lambda1,lambda2,mu1,mu2,v1,v2,v] = getFerrydata(birthdate)   %yyyymmdd
    
ff=1;
lambda1=round(mod(birthdate/4,6)*ff)+10;
lambda2=round(mod(birthdate/3,5)*ff)+9;
mu1=round(mod(birthdate/6,4)*ff)+12;
mu2=round(mod(birthdate/7,6)*ff)+15;


v1=10;
v2=v1+round(mod(birthdate/7,6)*ff);
v=round(v2+v1/1.5);
  
end