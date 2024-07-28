clc;
g=imread('ER �黯Ⱦɫ 1.jpg');
%figure,imshow(g);title('ԭͼ��');
F=rgb2gray(g); %���ͼת��Ϊ�Ҷ�ͼ
G=F;
[length, width] = size(G);
%figure;imshow(F);title('�Ҷ�ͼ');
%figure;imhist(F);title('Histogram of Medical grayscale image')
F4 = imadjust(F,stretchlim(F),[0 1]);
Ft=medfilt2(F4,[5 5]);
%figure;imshow(Ft);title('�Ҷȵ�������ֵ�˲����ͼ��');
%figure;imhist(Ft);title('�Ҷȵ�������ֵ�˲����ֱ��ͼ');
T=graythresh(Ft);
T=T*256-68;%������
[M,N1]=size(Ft);
for x=1:M
    for y=1:N1
        if Ft(x,y)<T				
            Ft(x,y)=0;		%������ֵ��ֵ��
        else
            Ft(x,y)=255;		%������ֵ��ֵ��
        end
    end
end
%figure;imshow(Ft);title('��ֵ�ָ�');
B=ones(10);
F0=imclose(Ft,B);
%figure;imshow(F0);title('�����㣬��');
F10=~F0;
%figure;imshow(F10);title('��ɫ����');



gc=~F10;
D=bwdist(gc);
L=watershed(-D);
w=L==0;
g2=F10&-w;
F=g2+~F10;
%figure,imshow(~F);
F111=bwareaopen(~F,100,8);
%figure,imshow(F111);title('��ˮ��ָ');   



F20=~F111;
%figure;imshow(F20);title('�ٷ�ɫ����');

I_light=double(g/255);  %ת��Ϊdouble���Ͳ�������ֵ��һ��

%RGB��·ֵ
I_r = I_light(:,:,1);
I_g = I_light(:,:,2);
I_b = I_light(:,:,3);
[row,col]=size(I_r);%ͼƬ��С
%% �鿴RGB����ͼ���ڷ������ĸ��������з���
 %figure,imshow(I_r),title('R')
%figure,imshow(I_g),title('G')
%figure,imshow(I_b),title('B')
 %figure,imshow(I),title('ԭͼ')

l=im2bw(I_b,T/255);   
%figure,imhist(I_b);
%figure,imshow(l);title('����ȫ����ֵ�ָ');
se=strel('disk',2);
go=imopen(l,se);    %������
%figure,imshow(go);title('��������');
se=strel('disk',8);
goc=imclose(go,se); %�ղ���
%figure,imshow(goc);title('�ղ�����');

se=strel('disk',5);%ָ��7���صİ뾶���Ա�������ļ�϶

BW1=imerode(go,se);%��ʴ
%figure,imshow(BW1);   title('��ʴ');

F1=~BW1; 
%figure;imshow(F1);title('��ɫ2');

BW2=bwareaopen(F1,40000);
%figure,imshow(BW2);  title('ɾ����ɫС���');%ɾ����ɫС���
F5=~BW2;
%figure,imshow(F5);  title('ɾ����ɫС���')

k1=F111.*F5;
figure,imshow(k1);title('������');
%I1=log_filter(k1,1.1,7);
%figure;imshow(I1);title('log_filter');

%k22=~I1;
%figure,imshow(k22);title('log_filter��ɫ');

[L,N1] = bwlabel(k1);  % N1��ΪĿ�����
t=1;
%���Ŀ����
figure,imshow(g)
hold on 
for k = 1:N1
    [r,c] = find(L == k);%find()�������ú����ǳ����ã��᷵��ָ������������ֵ���ڱ�Ǿ����е������Ƿ��ض�Ӧ�������������ʾ����˼����ͨ��k�е���ֵ����������λ�ã���ȡ��ͬ��ǩ�ŵ�λ�ã���λ����Ϣ����[r,c]
    rbar = mean(r);%��rƽ��ֵ
    cbar = mean(c);  
    %plot(cbar,rbar,'marker','D','markeredgecolor','r','markersize',7);
end 
% �Ի�����ʾĿ������� 
%h = dialog('Name','Ŀ�����','position',[580 300 220 100]);  % ����һ���Ի��򴰿�
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('��',num2str(t),'��ͼ������ǿ���԰�ϸ������Ϊ',num2str(N1),'��')); 



k2=~k1;
%figure,imshow(k2);title('��������ɫ');
k3=F111.*k2;
%figure,imshow(k3);title('ԭ����');


[L,N2] = bwlabel(k3);  % N1��ΪĿ�����
%���Ŀ����
%figure,imshow(g)
%hold on 
for k = 1:N2
    [r,c] = find(L == k);%find()�������ú����ǳ����ã��᷵��ָ������������ֵ���ڱ�Ǿ����е������Ƿ��ض�Ӧ�������������ʾ����˼����ͨ��k�е���ֵ����������λ�ã���ȡ��ͬ��ǩ�ŵ�λ�ã���λ����Ϣ����[r,c]
    rbar = mean(r);%��rƽ��ֵ
    cbar = mean(c);  
    %plot(cbar,rbar,'marker','o','markeredgecolor','r','markersize',9);
end 
% �Ի�����ʾĿ������� 
%h = dialog('Name','Ŀ�����','position',[580 300 220 100]);  % ����һ���Ի��򴰿� 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('��',num2str(t),'��ͼԭλ����ǿ���԰�ϸ������Ϊ',num2str(N2),'��')); 


clc;
g=imread('ER �黯Ⱦɫ 1.jpg');
%figure,imshow(g);title('ԭͼ��');
F=rgb2gray(g); %���ͼת��Ϊ�Ҷ�ͼ
%figure;imshow(F);title('�Ҷ�ͼ');
%figure;imhist(F);title('ֱ��ͼ');
F4 = imadjust(F,stretchlim(F),[0 1]);
Ft=medfilt2(F4,[5 5]);
%figure;imshow(Ft);title('�Ҷȵ�������ֵ�˲����ͼ��');
%figure;imhist(Ft);title('�Ҷȵ�������ֵ�˲����ֱ��ͼ');
T=graythresh(Ft);
T=T*256;
[M,N3]=size(Ft);
for x=1:M
    for y=1:N3
        if Ft(x,y)<T				
            Ft(x,y)=0;		%������ֵ��ֵ��
        else
            Ft(x,y)=255;		%������ֵ��ֵ��
        end
    end
end
%figure;imshow(Ft);title('��ֵ�����');
B=ones(10);
F0=imclose(Ft,B);
%figure;imshow(F0);title('�����㣬��');
F10=~F0;
%figure;imshow(F10);title('��ɫ����');

gc=~F10;
D=bwdist(gc);
L=watershed(-D);
w=L==0;
g2=F10&-w;
F=g2+~F10;
%figure,imshow(~F);
F111=bwareaopen(~F,100,8);
%figure,imshow(F111);title('��ˮ��ָ');  




F20=~F111;
%figure;imshow(F20);title('�ٷ�ɫ����');

I_light=double(g/255);  %ת��Ϊdouble���Ͳ�������ֵ��һ��

%RGB��·ֵ
I_r = I_light(:,:,1);
I_g = I_light(:,:,2);
I_b = I_light(:,:,3);
[row,col]=size(I_r);%ͼƬ��С
%% �鿴RGB����ͼ���ڷ������ĸ��������з���
 %figure,imshow(I_r),title('R')
%figure,imshow(I_g),title('G')
% figure,imshow(I_b),title('B')
 %figure,imshow(I),title('ԭͼ')

l=im2bw(I_b,T/255);   
%figure,imhist(I_b);
%figure,imshow(l);title('����ȫ����ֵ�ָ');
se=strel('disk',2);
go=imopen(l,se);    %������
%figure,imshow(go);title('��������');
se=strel('disk',8);
goc=imclose(go,se); %�ղ���
%figure,imshow(goc);title('�ղ�����');
se=strel('disk',5);%ָ��7���صİ뾶���Ա�������ļ�϶
BW1=imerode(go,se);%��ʴ
%figure,imshow(BW1);   title('��ʴ');

F1=~BW1; 
%figure;imshow(F1);title('��ɫ2');

BW2=bwareaopen(F1,40000);
%figure,imshow(BW2);  title('ɾ����ɫС���');%ɾ����ɫС���
F5=~BW2;
%figure,imshow(F5);  title('ɾ����ɫС���')

k4=F111.*F5;
%figure,imshow(k4);title('������');
BW10=bwareaopen(k4,20);
%figure,imshow(BW10);  title('ɾ����ɫС���1');%ɾ����ɫС���
%k20=~k1;
%figure,imshow(k20);title('������');
%k10=k4.*(k20);
%figure,imshow(k10);title('������');

[L,N3] = bwlabel(BW10);  % N1��ΪĿ�����
t=1;
%���Ŀ����
%figure,imshow(g)
%hold on 
for k = 1:N3
    [r,c] = find(L == k);%find()�������ú����ǳ����ã��᷵��ָ������������ֵ���ڱ�Ǿ����е������Ƿ��ض�Ӧ�������������ʾ����˼����ͨ��k�е���ֵ����������λ�ã���ȡ��ͬ��ǩ�ŵ�λ�ã���λ����Ϣ����[r,c]
    rbar = mean(r);%��rƽ��ֵ
    cbar = mean(c);  
    %plot(cbar,rbar,'marker','D','markeredgecolor','g','markersize',7);
end 
% �Ի�����ʾĿ������� 
%h = dialog('Name','Ŀ�����','position',[580 300 220 100]);  % ����һ���Ի��򴰿�
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('��',num2str(t),'��ͼ������ǿ���Ժ����԰�ϸ�������ܺ�Ϊ',num2str(N3),'��')); 



k5=~k4;
%figure,imshow(k2);title('��������ɫ');
k6=F111.*k5;
%figure,imshow(k6);title('ԭ����');
%k11=k6.*(~k3);
%figure,imshow(11);title('ԭ����');

[L,N4] = bwlabel(k6);  % N1��ΪĿ�����
%���Ŀ����
%figure,imshow(g)
%hold on 
for k = 1:N4
    [r,c] = find(L == k);%find()�������ú����ǳ����ã��᷵��ָ������������ֵ���ڱ�Ǿ����е������Ƿ��ض�Ӧ�������������ʾ����˼����ͨ��k�е���ֵ����������λ�ã���ȡ��ͬ��ǩ�ŵ�λ�ã���λ����Ϣ����[r,c]
    rbar = mean(r);%��rƽ��ֵ
    cbar = mean(c);  
    %plot(cbar,rbar,'marker','o','markeredgecolor','g','markersize',9);
end 
% �Ի�����ʾĿ������� 
%h = dialog('Name','Ŀ�����','position',[580 300 220 100]);  % ����һ���Ի��򴰿� 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('��',num2str(t),'��ͼԭλ����ǿ���Ժ����԰�ϸ�������ܺ�Ϊ',num2str(N4),'��')); 




clc;
g=imread('ER �黯Ⱦɫ 1.jpg');
%figure,imshow(g);title('ԭͼ��');
F=rgb2gray(g); %���ͼת��Ϊ�Ҷ�ͼ
%figure;imshow(F);title('�Ҷ�ͼ');
%figure;imhist(F);title('ֱ��ͼ');
F4 = imadjust(F,stretchlim(F),[0 1]);
Ft=medfilt2(F4,[5 5]);
%figure;imshow(Ft);title('�Ҷȵ�������ֵ�˲����ͼ��');
%figure;imhist(Ft);title('�Ҷȵ�������ֵ�˲����ֱ��ͼ');
T=graythresh(Ft);
T=T*256;
[M,N5]=size(Ft);
for x=1:M
    for y=1:N5
        if Ft(x,y)<T				
            Ft(x,y)=0;		%������ֵ��ֵ��
        else
            Ft(x,y)=255;		%������ֵ��ֵ��
        end
    end
end
%figure;imshow(Ft);title('��ֵ�����');
B=ones(7);
F0=imclose(Ft,B);
%figure;imshow(F0);title('�����㣬��');
F10=~F0;
%figure;imshow(F10);title('��ɫ����');

gc=~F10;
D=bwdist(gc);
L=watershed(-D);
w=L==0;
g2=F10&-w;
F=g2+~F10;
%figure,imshow(~F);
F111=bwareaopen(~F,100,8);
%figure,imshow(F111);title('��ˮ��ָ');  



F20=~F111;
%figure;imshow(F20);title('�ٷ�ɫ����');

I_light=double(g/255);  %ת��Ϊdouble���Ͳ�������ֵ��һ��

%RGB��·ֵ
I_r = I_light(:,:,1);
I_g = I_light(:,:,2);
I_b = I_light(:,:,3);
[row,col]=size(I_r);%ͼƬ��С
%% �鿴RGB����ͼ���ڷ������ĸ��������з���
 %figure,imshow(I_r),title('R')
%figure,imshow(I_g),title('G')
% figure,imshow(I_b),title('B')
 %figure,imshow(I),title('ԭͼ')
 %imwrite(I_b,'result2.jpg');

l=im2bw(I_b,T/255);   
%figure,imhist(I_b);
%figure,imshow(l);title('����ȫ����ֵ�ָ');
se=strel('disk',2);
go=imopen(l,se);    %������
%figure,imshow(go);title('��������');
se=strel('disk',8);
goc=imclose(go,se); %�ղ���
%figure,imshow(goc);title('�ղ�����');

se=strel('disk',5);%ָ��7���صİ뾶���Ա�������ļ�϶

BW1=imerode(go,se);%��ʴ
%figure,imshow(BW1);   title('��ʴ');

F1=~BW1; 
%figure;imshow(F1);title('��ɫ2');

BW2=bwareaopen(F1,40000);
%figure,imshow(BW2);  title('ɾ����ɫС���');%ɾ����ɫС���
F5=~BW2;
%figure,imshow(F5);  title('ɾ����ɫС���')

k7=F111.*F5;
%figure,imshow(k7);title('������');
%figure;imhist(k7);title('Histogram of IDC')
BW20=bwareaopen(k7,20);
%figure,imshow(BW20);  title('ɾ����ɫС���2');%ɾ����ɫС���


[L,N5] = bwlabel(BW20);  % N3��ΪĿ�����
t=1;
%figure,imshow(g)
hold on 
count1=0;
count2=0;
count3=0;
%���Ŀ����
%figure,imshow(g)
%hold on 
for k = 1:N5
    [r,c] = find(L == k);%find()�������ú����ǳ����ã��᷵��ָ������������ֵ���ڱ�Ǿ����е������Ƿ��ض�Ӧ�������������ʾ����˼����ͨ��k�е���ֵ����������λ�ã���ȡ��ͬ��ǩ�ŵ�λ�ã���λ����Ϣ����[r,c]
    rbar = mean(r);%��rƽ��ֵ
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
% �Ի�����ʾĿ������� 
%h = dialog('Name','Ŀ�����','position',[580 300 220 100]);  % ����һ���Ի��򴰿�
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('��',num2str(t),'��ͼ���������а�ϸ�������ܺ�Ϊ',num2str(N5),'��')); 



k8=~k7;
%figure,imshow(k2);title('��������ɫ');
k9=F111.*k8;
%figure,imshow(k9);title('ԭ����');
%figure;imhist(k9);title('Histogram of DCIS')

[L,N6] = bwlabel(k9);  % N1��ΪĿ�����
 
count4=0;
count5=0;
count6=0;
%���Ŀ����
%figure,imshow(g)
%hold on 
for k = 1:N6
    [r,c] = find(L == k);%find()�������ú����ǳ����ã��᷵��ָ������������ֵ���ڱ�Ǿ����е������Ƿ��ض�Ӧ�������������ʾ����˼����ͨ��k�е���ֵ����������λ�ã���ȡ��ͬ��ǩ�ŵ�λ�ã���λ����Ϣ����[r,c]
    rbar = mean(r);%��rƽ��ֵ
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
% �Ի�����ʾĿ������� 
%h = dialog('Name','Ŀ�����','position',[580 300 220 100]);  % ����һ���Ի��򴰿� 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',10,'parent',h,'string',strcat('��',num2str(t),'��ͼԭλ�������а�ϸ�������ܺ�Ϊ',num2str(N6),'��')); 



%figure,imshow(g)
%hold on 
N7=N1/N5;
N8=(N3-N1)/N5;
N9=(N5-N3)/N5;
N10=N2/N6;
N11=(N4-N2)/N6;
N12=(N6-N4)/N6;

% �Ի�����ʾĿ������� 
h = dialog('Name','Ŀ�����','position',[880 500 220 100]);  % ����һ���Ի��򴰿� 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',6,'parent',h,'string',strcat('��',num2str(t),'��ͼ�Ľ�������ԭλ����ǿ���С������Ա����ֱ�Ϊ',num2str(N7),'��',num2str(N8),'��',num2str(N9),'��',num2str(N10),'��',num2str(N11),'��',num2str(N12))); 

uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',6,'parent',h,'string',strcat('��',num2str(t),'��ͼ�Ľ�������ԭλ����ǿ���С������Ա����ֱ�Ϊ',num2str(N1),'��',num2str(N3-N1),'��',num2str(N5-N3),'��',num2str(N2),'��',num2str(N4-N2),'��',num2str(N6-N4))); 
%uicontrol('Style','text','units','pixels','position',[45 40 120 50],'fontsize',6,'parent',h,'string',strcat('��',num2str(t),'��ͼ��ԭλ����ǿ���С������Ա���Ϊ',num2str(N10),'��',num2str(N11),'��',num2str(N12))); 

