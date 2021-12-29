  csi_trace = read_bf_file('1220demo1.dat');
%     load('user1-1-1-1-1-1-1e-07-100-20-100000-L0.mat') 
len = length (csi_trace);
for i=1:len
     %length(csi_trace)%这里是取的数据包的个s数
        timeline(i)=(csi_trace{i}.timestamp_low  - csi_trace{1}.timestamp_low  )/1000000;%以时间戳来画原始数据，单位s表示
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry); %提取csi矩阵
%         rssi = get_scaled_rssia(csi_entry); %提取rssi矩阵
        csi =csi(1,:,:);
        csi1=db(abs(squeeze(csi).'));          %提取幅值(降维+转置)
        a=db(get_eff_SNRs_sm(csi), 'pow');
    for k=1:30    %30个子载波数据
		B(1,:,k)=csi(1,:,k);
		csi_one=squeeze(B).';	
		csi_phase=angle(csi_one);%angle求复数矩阵相位角的弧度值，取值-pi到pi
		csi_amplitude=abs(csi_one);%angle求复数矩阵的绝对值
		phase(k,i)=csi_phase(k);	%第i个数据包的第k个子载波的相位值        【子载波，数据包】

    end

%         phase(1,i)=csi_phase(1);



        %只取一根天线的数据
        first_ant_csi(:,i)=csi1(:,1);       %提取第1条信道的全部子载波    %直接取第一列数据(不需要for循环取)
        second_ant_csi(:,i)=csi1(:,2);     %提取第2条信道的全部子载波
        third_ant_csi(:,i)=csi1(:,3);      %提取第3条信道的全部子载波
        csi_f(i,:)=csi1(30,1);  %提取第1条信道的第30个子载波
        csi_s(i,:)=csi1(30,2);  %提取第2条信道的第30个子载波
        csi_t(i,:)=csi1(30,3);  %提取第3条信道的第30个子载波
        phase_f=phase(1,:);
                %third_ant_csi(:,i)=csi1(:,3);        
end

% shading interp 
figure(1)
subplot(3,1,1);%设置画图格式为6行1列，最后的1是只这个图排在第一个，也就是第一行第一列
plot(timeline,first_ant_csi.')%第一条信道
title('信道1');
xlabel('时间 / s');
ylabel('振幅 / dB');
subplot(3,1,2);
% figure
plot(timeline,second_ant_csi.')%第二条信道
title('信道2');
xlabel('时间 / s');
ylabel('振幅 / dB');
subplot(3,1,3);
% figure
plot(timeline,third_ant_csi.')%第三条信道
title('信道3');
xlabel('时间 / s');
ylabel('振幅 / dB');
figure(2)
subplot(3,1,1);
plot(timeline,csi_f.')%第1条信道的第30个子载波
title('信道1');
 f = csi_f.';
subplot(3,1,2);
plot(timeline,csi_s.')%第2条信道的第30个子载波
title('信道2');
 s = csi_s.';
 subplot(3,1,3);
plot(timeline,csi_t.')%第3条信道的第30个子载波
title('信道3');
 t = csi_t.';
 
figure(3)
 subplot(3,1,1);                                      % 新建窗口
 s1=wden(f,'minimaxi','s','one',5,'db3');   % 选用 db3 小波对信号进行5层分解，并对细节系数选用 minimaxi 阈值模式和尺度噪声 
 plot(timeline,s1);                                               % 画出db3小波降噪后的波形
%   plot(s1); 
 title('信道1');
 subplot(3,1,2);                                      % 新建窗口
 s2=wden(s,'minimaxi','s','one',5,'db3');   % 选用 db3 小波对信号进行5层分解，并对细节系数选用 minimaxi 阈值模式和尺度噪声 
 plot(timeline,s2);
 hold on;
 title('信道2');
  subplot(3,1,3);                                      % 新建窗口
 s3=wden(t,'minimaxi','s','one',5,'db3');   % 选用 db3 小波对信号进行5层分解，并对细节系数选用 minimaxi 阈值模式和尺度噪声 
 plot(timeline,s3);
 title('信道3');
 
 figure(4)
%  ph=(180*unwrap(phase(:,i))/pi);
s3=wden(phase_f,'minimaxi','s','one',5,'db3');
 plot(timeline,s3);
 
 figure(5)
c = bt100;
b=filter(c,second_ant_csi.');%巴特沃斯低通滤波器
 plot(timeline,b);
 
figure(6)
plot(timeline,csi_s.')%第2条信道的第30个子载波
title('信道2');

figure(11)
plot(timeline,third_ant_csi.')%第3条信道的第30个子载波
title('信道3原始');

figure(7)
y1 = third_ant_csi.';
% 设置高斯模板大小和标准差
r        = 5;
sigma    = 1;
%高斯滤波
y_filted = Gaussianfilter(r, sigma, y1);
c = bt100;
j=filter(c,y_filted.');%巴特沃斯低通滤波器
j1=filter(c,j);%巴特沃斯低通滤波器
% j2=filter(c,j1);%巴特沃斯低通滤波器
plot(timeline,j1);
title('信道3');

figure(8)
 s2=wden(s,'minimaxi','s','one',5,'db3');   % 选用 db3 小波对信号进行5层分解，并对细节系数选用 minimaxi 阈值模式和尺度噪声 
 plot(timeline,s2);
 title('信道2');
 
 figure(9)
 t = csi_t.';
 s3=wden(t,'minimaxi','s','one',5,'db3');   % 选用 db3 小波对信号进行5层分解，并对细节系数选用 minimaxi 阈值模式和尺度噪声 
 plot(timeline,s3);
 title('信道3');
 
 figure(10)
plot(timeline,second_ant_csi.'); 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  figure(10)
% [c,l]=wavedec(s,6,'db5');
% % Compute and reshape DWT to compare with CWT.
% cfd=zeros(6,len);
% for k=1:6
%     d=detcoef(c,l,k);
%     d=d(ones(1,2^k),:);
%     cfd(k,:)=wkeep(d(:)',len);
% end
% cfd=cfd(:);
% I=find(abs(cfd) <sqrt(eps));
% cfd(I)=zeros(size(I));
% cfd=reshape(cfd,6,len);
% % Plot DWT.
% subplot(3,1,1); plot(s2); title('Analyzed signal.');
% % set(gca,'xlim',[0 510]);
% subplot(3,1,2); 
% image(flipud(wcodemat(cfd,255,'row')));
% colormap(pink(255));
% set(gca,'yticklabel',[]);
% title('Discrete Transform,absolute coefficients');
% ylabel('Level');
% % Compute CWT and compare with DWT
% subplot(3,1,3);
% % ccfs=cwt(s,1:32,'db5','plot');
% ccfs=cwt(s,1:32,'db5','plot');
% title('Continuous Transform, absolute coefficients');
% set(gca,'yticklabel',[]);
% ylabel('Scale');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  y = mapminmax(s1',0,1);
%  plot(y);
%  

%  figure %这个应该是画频谱图的，但是缺参数，所以画出来的图啥也看不出来
%  xff = fft(e,44957);
%  plot(xff);
% %  colormap(blue)
%  axis off
%   set(gca,'YDir','normal')
  
%   figure  %将第三条信道的所有子载波单独在一张figure上显示
%   plot(third_ant_csi.')%第三条信道

%时域柱状图
% csi_ifft=ifft(s2(:,1));
%  
% T_amp=abs(csi_ifft);
%  figure
%  plot(T_amp);
%  
%  set(gca,'XTick',[0 10 20 30]);
%  
%  set(gca,'xticklabel',{'0','0.5','1','1.5'});
%  
%  xlabel('Delay (ms)');
%  
%  ylabel('Amplitude(dB)');

