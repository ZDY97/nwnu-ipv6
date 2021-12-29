  csi_trace = read_bf_file('1220demo1.dat');
%     load('user1-1-1-1-1-1-1e-07-100-20-100000-L0.mat') 
len = length (csi_trace);
for i=1:len
     %length(csi_trace)%������ȡ�����ݰ��ĸ�s��
        timeline(i)=(csi_trace{i}.timestamp_low  - csi_trace{1}.timestamp_low  )/1000000;%��ʱ�������ԭʼ���ݣ���λs��ʾ
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry); %��ȡcsi����
%         rssi = get_scaled_rssia(csi_entry); %��ȡrssi����
        csi =csi(1,:,:);
        csi1=db(abs(squeeze(csi).'));          %��ȡ��ֵ(��ά+ת��)
        a=db(get_eff_SNRs_sm(csi), 'pow');
    for k=1:30    %30�����ز�����
		B(1,:,k)=csi(1,:,k);
		csi_one=squeeze(B).';	
		csi_phase=angle(csi_one);%angle����������λ�ǵĻ���ֵ��ȡֵ-pi��pi
		csi_amplitude=abs(csi_one);%angle��������ľ���ֵ
		phase(k,i)=csi_phase(k);	%��i�����ݰ��ĵ�k�����ز�����λֵ        �����ز������ݰ���

    end

%         phase(1,i)=csi_phase(1);



        %ֻȡһ�����ߵ�����
        first_ant_csi(:,i)=csi1(:,1);       %��ȡ��1���ŵ���ȫ�����ز�    %ֱ��ȡ��һ������(����Ҫforѭ��ȡ)
        second_ant_csi(:,i)=csi1(:,2);     %��ȡ��2���ŵ���ȫ�����ز�
        third_ant_csi(:,i)=csi1(:,3);      %��ȡ��3���ŵ���ȫ�����ز�
        csi_f(i,:)=csi1(30,1);  %��ȡ��1���ŵ��ĵ�30�����ز�
        csi_s(i,:)=csi1(30,2);  %��ȡ��2���ŵ��ĵ�30�����ز�
        csi_t(i,:)=csi1(30,3);  %��ȡ��3���ŵ��ĵ�30�����ز�
        phase_f=phase(1,:);
                %third_ant_csi(:,i)=csi1(:,3);        
end

% shading interp 
figure(1)
subplot(3,1,1);%���û�ͼ��ʽΪ6��1�У�����1��ֻ���ͼ���ڵ�һ����Ҳ���ǵ�һ�е�һ��
plot(timeline,first_ant_csi.')%��һ���ŵ�
title('�ŵ�1');
xlabel('ʱ�� / s');
ylabel('��� / dB');
subplot(3,1,2);
% figure
plot(timeline,second_ant_csi.')%�ڶ����ŵ�
title('�ŵ�2');
xlabel('ʱ�� / s');
ylabel('��� / dB');
subplot(3,1,3);
% figure
plot(timeline,third_ant_csi.')%�������ŵ�
title('�ŵ�3');
xlabel('ʱ�� / s');
ylabel('��� / dB');
figure(2)
subplot(3,1,1);
plot(timeline,csi_f.')%��1���ŵ��ĵ�30�����ز�
title('�ŵ�1');
 f = csi_f.';
subplot(3,1,2);
plot(timeline,csi_s.')%��2���ŵ��ĵ�30�����ز�
title('�ŵ�2');
 s = csi_s.';
 subplot(3,1,3);
plot(timeline,csi_t.')%��3���ŵ��ĵ�30�����ز�
title('�ŵ�3');
 t = csi_t.';
 
figure(3)
 subplot(3,1,1);                                      % �½�����
 s1=wden(f,'minimaxi','s','one',5,'db3');   % ѡ�� db3 С�����źŽ���5��ֽ⣬����ϸ��ϵ��ѡ�� minimaxi ��ֵģʽ�ͳ߶����� 
 plot(timeline,s1);                                               % ����db3С�������Ĳ���
%   plot(s1); 
 title('�ŵ�1');
 subplot(3,1,2);                                      % �½�����
 s2=wden(s,'minimaxi','s','one',5,'db3');   % ѡ�� db3 С�����źŽ���5��ֽ⣬����ϸ��ϵ��ѡ�� minimaxi ��ֵģʽ�ͳ߶����� 
 plot(timeline,s2);
 hold on;
 title('�ŵ�2');
  subplot(3,1,3);                                      % �½�����
 s3=wden(t,'minimaxi','s','one',5,'db3');   % ѡ�� db3 С�����źŽ���5��ֽ⣬����ϸ��ϵ��ѡ�� minimaxi ��ֵģʽ�ͳ߶����� 
 plot(timeline,s3);
 title('�ŵ�3');
 
 figure(4)
%  ph=(180*unwrap(phase(:,i))/pi);
s3=wden(phase_f,'minimaxi','s','one',5,'db3');
 plot(timeline,s3);
 
 figure(5)
c = bt100;
b=filter(c,second_ant_csi.');%������˹��ͨ�˲���
 plot(timeline,b);
 
figure(6)
plot(timeline,csi_s.')%��2���ŵ��ĵ�30�����ز�
title('�ŵ�2');

figure(11)
plot(timeline,third_ant_csi.')%��3���ŵ��ĵ�30�����ز�
title('�ŵ�3ԭʼ');

figure(7)
y1 = third_ant_csi.';
% ���ø�˹ģ���С�ͱ�׼��
r        = 5;
sigma    = 1;
%��˹�˲�
y_filted = Gaussianfilter(r, sigma, y1);
c = bt100;
j=filter(c,y_filted.');%������˹��ͨ�˲���
j1=filter(c,j);%������˹��ͨ�˲���
% j2=filter(c,j1);%������˹��ͨ�˲���
plot(timeline,j1);
title('�ŵ�3');

figure(8)
 s2=wden(s,'minimaxi','s','one',5,'db3');   % ѡ�� db3 С�����źŽ���5��ֽ⣬����ϸ��ϵ��ѡ�� minimaxi ��ֵģʽ�ͳ߶����� 
 plot(timeline,s2);
 title('�ŵ�2');
 
 figure(9)
 t = csi_t.';
 s3=wden(t,'minimaxi','s','one',5,'db3');   % ѡ�� db3 С�����źŽ���5��ֽ⣬����ϸ��ϵ��ѡ�� minimaxi ��ֵģʽ�ͳ߶����� 
 plot(timeline,s3);
 title('�ŵ�3');
 
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

%  figure %���Ӧ���ǻ�Ƶ��ͼ�ģ�����ȱ���������Ի�������ͼɶҲ��������
%  xff = fft(e,44957);
%  plot(xff);
% %  colormap(blue)
%  axis off
%   set(gca,'YDir','normal')
  
%   figure  %���������ŵ����������ز�������һ��figure����ʾ
%   plot(third_ant_csi.')%�������ŵ�

%ʱ����״ͼ
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

