function [x_optimal,f_optimal,k]=Steepest__Descent(f_test,g_test,x_initial,tolerance)
%==========================================================================
%函数调用格式：
%[x_optimal,f_optimal,k]=Steepest__Descent(@f_test,@g_test,x_initial,tolerance)
%--------------------------------------------------------------------------
%输入参数说明
%--------------------------------------------------------------------------
%f_test：目标函数
%g_test：目标函数对变量x的梯度
%x_initial：指定的初始点
%tolerance:指定误差
%--------------------------------------------------------------------------
%输出参数
%--------------------------------------------------------------------------
%x_optimal：最优点
%f_optimal：对应x_optimal的函数值
%k：完成最速下降法所需的迭代次数
%==========================================================================
%==========================================================================
%主程序及说明
%--------------------------------------------------------------------------
%在调用本程序的上级程序中定义f_test和g_test的表达式
%x_current：最速下降法迭代过程中变量的当前点
%f_current：f_test在x_current处的函数值
%g_current：g_test在x_current处的梯度值
%d_current：目标函数在x_current处的最速下降方向
%x_next:最速下降法搜索到的下一点
%f_next:f(x_next)
%收敛准则：变量变化量小于tol，或，梯度值范数小于tol
%搜索步长采用Wolfe_search非精确方法（检测||d||≠0），其中步长最小值可精确到1e-15
%实际中，采用步长最小值不小于1e-6
%--------
%%[alpha_acceptable,x_next,f_next,k]=Wolfe__search(@f_test,@g_test,x_current,d_current,rho,sigma)
%----
%--------------------------------------------------------------------------
k=0;

x_current=x_initial;
f_current=f_test(x_current);
g_current=g_test(x_current);
d_current=-g_current;

%-------------------------------------------------------------------------
%将迭代次数、迭代点、目标函数值写入文件“testdata.txt”
%----------------------------------------------------------------------
fileID2=fopen('testdata.txt','w');
fprintf(fileID2,'%5s %20s %25s\r\n','k','x^(k)','f^(k)');
fprintf(fileID2,'%4.0f%15.4f%15.4f%15.4f\r\n',k,x_current,f_current);
%----------------------------------------------------------------------
[x_next,f_next]=Wolfe__Search(f_test,g_test,x_current,d_current);
%-------------------------------------------------------------------------
%将迭代次数、迭代点、目标函数值写入文件“testdata.txt”
%----------------------------------------------------------------------
fprintf(fileID2,'%4.0f%15.4f%15.4f%15.4f\r\n',k+1,x_next,f_next);
%----------------------------------------------------------------------
while(norm(x_next-x_current)>tolerance)
      k=k+1;
      x_current=x_next;
      g_current=g_test(x_current);
   % if(norm(g_current)>100*tolerance)
      d_current=-g_current;
      [x_next,f_next]=Wolfe__Search(f_test,g_test,x_current,d_current);
      fprintf(fileID2,'%4.0f%15.4f%15.4f%15.4f\r\n',k+1,x_next,f_next);
   % else
    %  x_optimal=x_next;
    %  f_optimal=f_next; 
    %  fprintf(fileID2,'%4.0f%15.4f%15.4f%15.4f\r\n',k+1,x_next,f_next);
    %  x_current=x_next;%为了结束while
    %  break
    %end
end
x_optimal=x_next;
f_optimal=f_next;
%fprintf(fileID2,'%4.0f%15.4f%15.4f%15.4f\r\n',k+1,x_next,f_next);
end
%==========================================================================

