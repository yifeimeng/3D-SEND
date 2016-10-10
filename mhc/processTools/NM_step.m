function [v0,f0]=NM_step(Fn,V,max_i,epsilon,step)
 [mm,n]=size(V);
 
 %Calculate every vertex
 Y=zeros(1,n+1);
 for j=1:n+1
  Z=V(j,1:n);
  Y(j)=feval(Fn,Z);
 end
 
 %Find the low, high, second_low and second_high vertices
 [mm,low]=min(Y);
 [mm,high]=max(Y);
 low_s=high;
 high_s=low;
 for j=1:n+1
  if (j~=low) && (j~=high) && (Y(j)<Y(low_s)), low_s=j; end
  if (j~=low) && (j~=high) && (Y(j)>Y(high_s)), high_s=j; end
 end
 
 %Start the loop
 count=0;
 while (Y(high)-Y(low)>epsilon) && (count<=max_i) 
   S=zeros(1,n);
   for j=1:n+1
       S=S+V(j,1:n);
   end
   
   M=(S-V(high,1:n))/n;
   R=2*M-V(high,1:n);
   
   M=(round(M/step))*step;
   R=(round(R/step))*step;
   
   yR=feval(Fn,R);
   if yR<Y(high_s)
    if yR>Y(low_s)
        V(high,1:n)=R;
        Y(high)=yR;
    else
        E=2*R-M;
        E=(round(E/step))*step;
        yE=feval(Fn,E);
        if yE<Y(low_s)
            V(high,1:n)=E;
            Y(high)=yE;
        else
            V(high,1:n)=R;
            Y(high)=yR;
        end
    end
   else
    if yR<Y(high)
        V(high,1:n)=R;
        Y(high)=yR;
    end
    C_in=(V(high,1:n)+M)/2;
    C_out=(M+R)/2;
    C_in=(round(C_in/step))*step;
    C_out=(round(C_out/step))*step;
    yC_in=feval(Fn,C_in);
    yC_out=feval(Fn,C_out);
    if yC_out<yC_in
        C_in=C_out;
        yC_in=yC_out;
    end
    if yC_in<Y(high)
        V(high,1:n)=C_in;
        Y(high)=yC_in;
    else
        for j=1:n+1
            if j~=low
                V(j,1:n)=(V(j,1:n)+V(low,1:n))/2;
                K=V(j,1:n);
                K=(round(K/step))*step;
                V(j,1:n)=K;
                Y(j)=feval(Fn,K);
            end
        end
    end   
       
   end
 [mm,low]=min(Y);
 [mm,high]=max(Y);
 low_s=high;
 high_s=low;
 for j=1:n+1
  if (j~=low) && (j~=high) && (Y(j)<Y(low_s)), low_s=j; end
  if (j~=low) && (j~=high) && (Y(j)>Y(high_s)), high_s=j; end
 end
  
 count=count+1;
 
 display([count,Y(low),V(low,1:n)]);
   
 end
   
 v0=V(low,1:n);
 f0=Y(low);
   
   
end