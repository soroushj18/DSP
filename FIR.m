clear all
clc


%% Digital Filter Specifications 
wp = 0.2*pi;                                      % digital Passband freq in rad
ws = 0.35*pi;                                     % digital Stopband freq in rad
As = 20;                                          % Stopband attenuation in dB
tr_width = ws - wp;                               % tr_width freq in rad Ws-Wp
                                                  %           As-8
M = ceil((As-7.95)/(2.285*tr_width)+1)+1          % M+2 ---------------
                                                  %      2.285*tr_width
beta = 0.1102*(As - 8.7);                         % beta for kaiser window shape
wc = (ws+wp)/2;                                   % digital cutoffband freq in rad

alpha = (M - 1)/2;                                % alpha
n = 0:1:M - 1;
m = n - alpha;
fc = wc/pi;
hd = fc*sinc(fc*m);                               % making sinc function 

w_ham = hamming(M)';                              % hamming window for compare
ham = hd .* w_ham;                                % making hamming window desire

w_kai = kaiser(M,beta)';                          % kaiser window                    
h =hd .* w_kai;                                   % making kaiser window desire
  
noise=1:.2:1000;                                  % WGN will plot against these numbers
Wgn_1=wgn(4996,1,0);                              % WGN making


delta_w = 2*pi/1000;
Rp = -(min(db(1:1:wp/delta_w + 1)))               % Actual Passband Ripple Rp
As = -round(max(db(ws/delta_w + 1:1:501)))        % Min Stopband attenuation As

%% plots
% kaiser window   
[H,w] = freqz(h,1);
subplot(2,2,1); stem(n,hd); title('Ideal Impulse Response')
axis([0 M-1 -0.1 0.3]);
xlabel('n'); ylabel('hd(n)')
subplot(2,2,2); stem(n,w_kai); title('kaiser window  ')
axis([0 M-1 0 1.1]);
xlabel('n'); ylabel('w(n)')
subplot(2,2,3); stem(n,h); title('Actual Impulse Response')
axis([0 M-1 -0.1 0.3]);
xlabel('n'); ylabel('h(n)')
subplot(2,2,4); plot(w/pi,20*log10(abs(H) + eps)); title('Magnitude Response in dB'); grid
axis([0 1 -100 10]);
xlabel('frequency in pi units'); ylabel('Decibels')
%%hamming window
figure
[Ham,w] = freqz(h,1);
subplot(2,2,1); stem(n,hd); title('Ideal Impulse Response')
axis([0 M-1 -0.1 0.3]);
xlabel('n'); ylabel('hd(n)')
subplot(2,2,2); stem(n,w_ham); title('Magnitude Response ')
axis([0 M-1 0 1.1]);
xlabel('n'); ylabel('w(n)')
subplot(2,2,3); stem(n,ham); title('Actual Impulse Response')
axis([0 M-1 -0.1 0.3]);
xlabel('n'); ylabel('h(n)')
subplot(2,2,4); plot(w/pi,20*log10(abs(Ham) + eps)); title('Magnitude Response in dB'); grid
axis([0 1 -100 10]);
xlabel('frequency in pi units'); ylabel('Decibels')


t=1:100;                                                                      % inputs signal time 
x1 = [cos(.4*pi*t).*(bartlett(length(t))') zeros(1,150)];                     % signal with .4*pi frequency
x2 = [zeros(1,60) cos(.2*pi*t).*(bartlett(length(t))') zeros(1,90)];          % signal with .2*pi frequency
x3 = [zeros(1,120) cos(.9*pi*t).*(bartlett(length(t))') zeros(1,30)];         % signal with .9*pi frequency
x = x1 + x2 + x3;
figure
subplot(211);plot(x);grid on;title('Input Signal')

%% Passing the input signal through the filter
y = filter(h,1,x);                                                           % X filtering
subplot(212);plot(y);grid on;title('Ouput Signal')
figure
FIR_Wgn=filter(h,1,Wgn_1);plot(FIR_Wgn);title('FIR_Wgn')                     % WGN filtering
figure;
plot(noise,Wgn_1);title('Wgn_1'); 
figure
wgn_PSD=psd(FIR_Wgn);                                                        % PSD of WNG after filtering
subplot(211);plot(wgn_PSD); title('PSD of FIR test by WGN');
subplot(212); plot(abs(H.*H)); title('impulse response Magnitude power by 2');