clc;
g=imread('ER 组化染色 1.jpg');
%figure,imshow(g);title('原图像');
F=rgb2gray(g); %真彩图转化为灰度图
G=F;
[length, width] = size(G);
%figure;imshow(F);title('灰度图');
%figure;imhist(F);title('Histogram of Medical grayscale image')
F4 = imadjust(F,stretchlim(F),[0 1]);
Ft=medfilt2(F4,[5 5]);
%figure;imshow(Ft);title('灰度调整，中值滤波后的图像');
%figure;imhist(Ft);title('灰度调整，中值滤波后的直方图');
T=graythresh(Ft);
T=T*256-68;%超参数
[M,N1]=size(Ft);
for x=1:M
    for y=1:N1
        if Ft(x,y)<T				
            Ft(x,y)=0;		%低于阈值的值黑
        else
            Ft(x,y)=255;		%高于阈值的值白
        end
    end
end
%figure;imshow(Ft);title('阈值分割');
B=ones(10);
F0=imclose(Ft,B);
%figure;imshow(F0);title('闭运算，黑');
F10=~F0;
%figure;imshow(F10);title('反色，白');



gc=~F10;
D=bwdist(gc);
L=watershed(-D);
w=L==0;
g2=F10&-w;
F=g2+~F10;
%figure,imshow(~F);
F111=bwareaopen(~F,100,8);
%figure,imshow(F111);title('分水岭分割法');   



F20=~F111;
%figure;imshow(F20);title('再反色，黑');

I_light=double(g/255);  %转化为double类型并将矩阵值归一化

%RGB三路值
I_r = I_light(:,:,1);
I_g = I_light(:,:,2);
I_b = I_light(:,:,3);
[row,col]=size(I_r);%图片大小
%% 查看RGB分量图便于分析从哪个分量进行分析
 %figure,imshow(I_r),title('R')
%figure,imshow(I_g),title('G')
%figure,imshow(I_b),title('B')
 %figure,imshow(I),title('原图')

l=im2bw(I_b,T/255);   
%figure,imhist(I_b);
%figure,imshow(l);title('基本全局阈值分割法');
se=strel('disk',2);
go=imopen(l,se);    %开操作
%figure,imshow(go);title('开操作后');
se=strel('disk',8);
goc=imclose(go,se); %闭操作
%figure,imshow(goc);title('闭操作后');

se=strel('disk',5);%指定7像素的半径，以便填充最大的间隙

BW1=imerode(go,se);%腐蚀
%figure,imshow(BW1);   title('腐蚀');

F1=~BW1; 
%figure;imshow(F1);title('反色2');

BW2=bwareaopen(F1,40000);
%figure,imshow(BW2);  title('删除白色小面积');%删除白色小面积
F5=~BW2;
%figure,imshow(F5);  title('删除黑色小面积')

k1=F111.*F5;
figure,imshow(k1);title('浸润癌区');
%I1=log_filter(k1,1.1,7);
%figure;imshow(I1);title('log_filter');

%k22=~I1;
%figure,imshow(k22);title('log_filter反色');

[L,N1] = bwlabel(k1);  % N1即为目标个数
t=1;
%标记目标物
figure,imshow(g)
hold on 
for k = 1:N1
    [r,c] = find(L == k);%find()函数，该函数非常有用，会返回指定条件的索引值，在标记矩阵中的作用是返回对应对象的索引。表示的意思是连通域k中的数值所在向量的位置，获取相同标签号的位置，将位置信息存入[r,c]
    rbar = mean(r);%求r平均值
    cbar = mean(c);  
    %plot(cbar,rbar,'marker','D','markeredgecolor','r','markersize',7);
end 
% 对话框显示目标物个数 
%h = dialog('Name','目标个数','position',[580 300 220 100]);  % 创建一个对话框窗口
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('第',num2str(t),'张图浸润癌区强阳性癌细胞个数为',num2str(N1),'个')); 



k2=~k1;
%figure,imshow(k2);title('浸润癌区反色');
k3=F111.*k2;
%figure,imshow(k3);title('原润癌区');


[L,N2] = bwlabel(k3);  % N1即为目标个数
%标记目标物
%figure,imshow(g)
%hold on 
for k = 1:N2
    [r,c] = find(L == k);%find()函数，该函数非常有用，会返回指定条件的索引值，在标记矩阵中的作用是返回对应对象的索引。表示的意思是连通域k中的数值所在向量的位置，获取相同标签号的位置，将位置信息存入[r,c]
    rbar = mean(r);%求r平均值
    cbar = mean(c);  
    %plot(cbar,rbar,'marker','o','markeredgecolor','r','markersize',9);
end 
% 对话框显示目标物个数 
%h = dialog('Name','目标个数','position',[580 300 220 100]);  % 创建一个对话框窗口 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('第',num2str(t),'张图原位癌区强阳性癌细胞个数为',num2str(N2),'个')); 


clc;
g=imread('ER 组化染色 1.jpg');
%figure,imshow(g);title('原图像');
F=rgb2gray(g); %真彩图转化为灰度图
%figure;imshow(F);title('灰度图');
%figure;imhist(F);title('直方图');
F4 = imadjust(F,stretchlim(F),[0 1]);
Ft=medfilt2(F4,[5 5]);
%figure;imshow(Ft);title('灰度调整，中值滤波后的图像');
%figure;imhist(Ft);title('灰度调整，中值滤波后的直方图');
T=graythresh(Ft);
T=T*256;
[M,N3]=size(Ft);
for x=1:M
    for y=1:N3
        if Ft(x,y)<T				
            Ft(x,y)=0;		%低于阈值的值黑
        else
            Ft(x,y)=255;		%高于阈值的值白
        end
    end
end
%figure;imshow(Ft);title('二值化结果');
B=ones(10);
F0=imclose(Ft,B);
%figure;imshow(F0);title('闭运算，黑');
F10=~F0;
%figure;imshow(F10);title('反色，白');

gc=~F10;
D=bwdist(gc);
L=watershed(-D);
w=L==0;
g2=F10&-w;
F=g2+~F10;
%figure,imshow(~F);
F111=bwareaopen(~F,100,8);
%figure,imshow(F111);title('分水岭分割法');  




F20=~F111;
%figure;imshow(F20);title('再反色，黑');

I_light=double(g/255);  %转化为double类型并将矩阵值归一化

%RGB三路值
I_r = I_light(:,:,1);
I_g = I_light(:,:,2);
I_b = I_light(:,:,3);
[row,col]=size(I_r);%图片大小
%% 查看RGB分量图便于分析从哪个分量进行分析
 %figure,imshow(I_r),title('R')
%figure,imshow(I_g),title('G')
% figure,imshow(I_b),title('B')
 %figure,imshow(I),title('原图')

l=im2bw(I_b,T/255);   
%figure,imhist(I_b);
%figure,imshow(l);title('基本全局阈值分割法');
se=strel('disk',2);
go=imopen(l,se);    %开操作
%figure,imshow(go);title('开操作后');
se=strel('disk',8);
goc=imclose(go,se); %闭操作
%figure,imshow(goc);title('闭操作后');
se=strel('disk',5);%指定7像素的半径，以便填充最大的间隙
BW1=imerode(go,se);%腐蚀
%figure,imshow(BW1);   title('腐蚀');

F1=~BW1; 
%figure;imshow(F1);title('反色2');

BW2=bwareaopen(F1,40000);
%figure,imshow(BW2);  title('删除白色小面积');%删除白色小面积
F5=~BW2;
%figure,imshow(F5);  title('删除黑色小面积')

k4=F111.*F5;
%figure,imshow(k4);title('浸润癌区');
BW10=bwareaopen(k4,20);
%figure,imshow(BW10);  title('删除白色小面积1');%删除白色小面积
%k20=~k1;
%figure,imshow(k20);title('浸润癌区');
%k10=k4.*(k20);
%figure,imshow(k10);title('浸润癌区');

[L,N3] = bwlabel(BW10);  % N1即为目标个数
t=1;
%标记目标物
%figure,imshow(g)
%hold on 
for k = 1:N3
    [r,c] = find(L == k);%find()函数，该函数非常有用，会返回指定条件的索引值，在标记矩阵中的作用是返回对应对象的索引。表示的意思是连通域k中的数值所在向量的位置，获取相同标签号的位置，将位置信息存入[r,c]
    rbar = mean(r);%求r平均值
    cbar = mean(c);  
    %plot(cbar,rbar,'marker','D','markeredgecolor','g','markersize',7);
end 
% 对话框显示目标物个数 
%h = dialog('Name','目标个数','position',[580 300 220 100]);  % 创建一个对话框窗口
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('第',num2str(t),'张图浸润癌区强阳性和中性癌细胞个数总和为',num2str(N3),'个')); 



k5=~k4;
%figure,imshow(k2);title('浸润癌区反色');
k6=F111.*k5;
%figure,imshow(k6);title('原润癌区');
%k11=k6.*(~k3);
%figure,imshow(11);title('原润癌区');

[L,N4] = bwlabel(k6);  % N1即为目标个数
%标记目标物
%figure,imshow(g)
%hold on 
for k = 1:N4
    [r,c] = find(L == k);%find()函数，该函数非常有用，会返回指定条件的索引值，在标记矩阵中的作用是返回对应对象的索引。表示的意思是连通域k中的数值所在向量的位置，获取相同标签号的位置，将位置信息存入[r,c]
    rbar = mean(r);%求r平均值
    cbar = mean(c);  
    %plot(cbar,rbar,'marker','o','markeredgecolor','g','markersize',9);
end 
% 对话框显示目标物个数 
%h = dialog('Name','目标个数','position',[580 300 220 100]);  % 创建一个对话框窗口 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('第',num2str(t),'张图原位癌区强阳性和中性癌细胞个数总和为',num2str(N4),'个')); 




clc;
g=imread('ER 组化染色 1.jpg');
%figure,imshow(g);title('原图像');
F=rgb2gray(g); %真彩图转化为灰度图
%figure;imshow(F);title('灰度图');
%figure;imhist(F);title('直方图');
F4 = imadjust(F,stretchlim(F),[0 1]);
Ft=medfilt2(F4,[5 5]);
%figure;imshow(Ft);title('灰度调整，中值滤波后的图像');
%figure;imhist(Ft);title('灰度调整，中值滤波后的直方图');
T=graythresh(Ft);
T=T*256;
[M,N5]=size(Ft);
for x=1:M
    for y=1:N5
        if Ft(x,y)<T				
            Ft(x,y)=0;		%低于阈值的值黑
        else
            Ft(x,y)=255;		%高于阈值的值白
        end
    end
end
%figure;imshow(Ft);title('二值化结果');
B=ones(7);
F0=imclose(Ft,B);
%figure;imshow(F0);title('闭运算，黑');
F10=~F0;
%figure;imshow(F10);title('反色，白');

gc=~F10;
D=bwdist(gc);
L=watershed(-D);
w=L==0;
g2=F10&-w;
F=g2+~F10;
%figure,imshow(~F);
F111=bwareaopen(~F,100,8);
%figure,imshow(F111);title('分水岭分割法');  



F20=~F111;
%figure;imshow(F20);title('再反色，黑');

I_light=double(g/255);  %转化为double类型并将矩阵值归一化

%RGB三路值
I_r = I_light(:,:,1);
I_g = I_light(:,:,2);
I_b = I_light(:,:,3);
[row,col]=size(I_r);%图片大小
%% 查看RGB分量图便于分析从哪个分量进行分析
 %figure,imshow(I_r),title('R')
%figure,imshow(I_g),title('G')
% figure,imshow(I_b),title('B')
 %figure,imshow(I),title('原图')
 %imwrite(I_b,'result2.jpg');

l=im2bw(I_b,T/255);   
%figure,imhist(I_b);
%figure,imshow(l);title('基本全局阈值分割法');
se=strel('disk',2);
go=imopen(l,se);    %开操作
%figure,imshow(go);title('开操作后');
se=strel('disk',8);
goc=imclose(go,se); %闭操作
%figure,imshow(goc);title('闭操作后');

se=strel('disk',5);%指定7像素的半径，以便填充最大的间隙

BW1=imerode(go,se);%腐蚀
%figure,imshow(BW1);   title('腐蚀');

F1=~BW1; 
%figure;imshow(F1);title('反色2');

BW2=bwareaopen(F1,40000);
%figure,imshow(BW2);  title('删除白色小面积');%删除白色小面积
F5=~BW2;
%figure,imshow(F5);  title('删除黑色小面积')

k7=F111.*F5;
%figure,imshow(k7);title('浸润癌区');
%figure;imhist(k7);title('Histogram of IDC')
BW20=bwareaopen(k7,20);
%figure,imshow(BW20);  title('删除白色小面积2');%删除白色小面积


[L,N5] = bwlabel(BW20);  % N3即为目标个数
t=1;
%figure,imshow(g)
hold on 
count1=0;
count2=0;
count3=0;
%标记目标物
%figure,imshow(g)
%hold on 
for k = 1:N5
    [r,c] = find(L == k);%find()函数，该函数非常有用，会返回指定条件的索引值，在标记矩阵中的作用是返回对应对象的索引。表示的意思是连通域k中的数值所在向量的位置，获取相同标签号的位置，将位置信息存入[r,c]
    rbar = mean(r);%求r平均值
    cbar = mean(c); 
    a1=round(rbar);b1=round(cbar);
    a=G(max(a1-3,1):min(a1+3,length),max(b1-3,1):min(b1+3,width));
    S=(min(a1+3,length)-max(a1-3,1)+1) * (min(b1+3,width)-max(b1-3,1)+1);
    b=mean(mean(a)); 
     if b<=63
         plot(cbar,rbar,'marker','o','markeredgecolor','r','markersize',7);
         count1=count1+1;
    elseif 63<b && b<=95
         plot(cbar,rbar,'marker','o','markeredgecolor','g','markersize',7);count2=count2+1;
    else
         plot(cbar,rbar,'marker','o','markeredgecolor','b','markersize',7);  count3=count3+1;
    end
    %plot(cbar,rbar,'marker','D','markeredgecolor','b','markersize',7);
end 
%imwrite(g,'result.jpg');
% 对话框显示目标物个数 
%h = dialog('Name','目标个数','position',[580 300 220 100]);  % 创建一个对话框窗口
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('第',num2str(t),'张图浸润癌区所有癌细胞个数总和为',num2str(N5),'个')); 



k8=~k7;
%figure,imshow(k2);title('浸润癌区反色');
k9=F111.*k8;
%figure,imshow(k9);title('原润癌区');
%figure;imhist(k9);title('Histogram of DCIS')

[L,N6] = bwlabel(k9);  % N1即为目标个数
 
count4=0;
count5=0;
count6=0;
%标记目标物
%figure,imshow(g)
%hold on 
for k = 1:N6
    [r,c] = find(L == k);%find()函数，该函数非常有用，会返回指定条件的索引值，在标记矩阵中的作用是返回对应对象的索引。表示的意思是连通域k中的数值所在向量的位置，获取相同标签号的位置，将位置信息存入[r,c]
    rbar = mean(r);%求r平均值
    cbar = mean(c); 
    a1=round(rbar);b1=round(cbar);
    a=G(max(a1-3,1):min(a1+3,length),max(b1-3,1):min(b1+3,width));
    S=(min(a1+3,length)-max(a1-3,1)+1) * (min(b1+3,width)-max(b1-3,1)+1);
    b=mean(mean(a)); 
     if b<=63
         plot(cbar,rbar,'marker','o','markeredgecolor','r','markersize',7);
         count4=count4+1;
    elseif 63<b && b<=95
         plot(cbar,rbar,'marker','o','markeredgecolor','g','markersize',7);count5=count5+1;
    else
         plot(cbar,rbar,'marker','o','markeredgecolor','b','markersize',7);  count6=count6+1;
    end
    %plot(cbar,rbar,'marker','o','markeredgecolor','b','markersize',9);
end 
imwrite(g,'result2.jpg');
% 对话框显示目标物个数 
%h = dialog('Name','目标个数','position',[580 300 220 100]);  % 创建一个对话框窗口 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('第',num2str(t),'张图原位癌区所有癌细胞个数总和为',num2str(N6),'个')); 



%figure,imshow(g)
%hold on 
N7=N1/N5;
N8=(N3-N1)/N5;
N9=(N5-N3)/N5;
N10=N2/N6;
N11=(N4-N2)/N6;
N12=(N6-N4)/N6;

% 对话框显示目标物个数 
h = dialog('Name','目标个数','position',[880 500 220 100]);  % 创建一个对话框窗口 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',6,'parent',h,'string',strcat('第',num2str(t),'张图的浸润癌区和原位癌区强、中、弱各自比例分别为',num2str(N7),'∶',num2str(N8),'∶',num2str(N9),'、',num2str(N10),'∶',num2str(N11),'∶',num2str(N12))); 

uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',6,'parent',h,'string',strcat('第',num2str(t),'张图的浸润癌区和原位癌区强、中、弱各自比例分别为',num2str(N1),'∶',num2str(N3-N1),'∶',num2str(N5-N3),'、',num2str(N2),'∶',num2str(N4-N2),'∶',num2str(N6-N4))); 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',6,'parent',h,'string',strcat('第',num2str(t),'张图的原位癌区强、中、弱各自比例为',num2str(N10),'∶',num2str(N11),'∶',num2str(N12))); 

