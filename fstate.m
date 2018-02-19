function f= fstate(x,u,w_k,model_parameters)

T_s = model_parameters;

f = [ x(1)+T_s*u;...
      x(2)+T_s*x(1)];


