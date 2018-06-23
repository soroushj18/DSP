clear all
clc
%% WNG
noise=1:.2:1000;                             % WGN will plot against these numbers
Wgn_1=wgn(4996,1,0);                         % WGN making

%% Digital Filter Specifications
wp = 0.2*pi;                                 % digital Passband freq in rad
ws = 0.35*pi;                                % digital Stopband freq in rad
Rp = -db(.12000);                            % Passband ripple in dB
As = -db(.1000);                             % Stopband attenuation in dB

%% Analog Prototype Specifications
T = 1;                                       % Set T=1
Wpn = (2/T)*tan(wp/2);                       % Prewarp Prototype Passband freq
Wsn = (2/T)*tan(ws/2);                       % Prewarp Prototype Stopband freq

%% Analog Prototype Order Calculation
N = ceil(log10(((1/.1)^(2)-1)/((1/.88)^(2)-1))/(2*log10(tan(ws/2)/tan(wp/2)))); % Butterworth Filter Order
fprintf('\n*** Butterworth Filter Order = %2.0f \n',N)
Wc = Wpn/(((1/.88)^2-1)^(1/(2*N)))         % Analog BW prototype cutoff
wn = 2*atan((Wc*T)/2);                       % Digital BW cutoff freq

%% Digital Butterworth Filter Design
wn = wn/pi;                                 % Digital Butter cutoff in pi units
[b,a] = butter(N,wn);

%% plots
[H,w] = freqz(b,a);
grp = grpdelay(b,a,w);
subplot(221);plot(w/pi,abs(H));grid on;ylabel('Magnitude')
subplot(222);plot(w/pi,20*log10(abs(H) + eps));grid on;ylabel('Magnitude (dB)')
subplot(223);plot(w/pi,angle(H));grid on;ylabel('Phase')
subplot(224);plot(w/pi,grp);grid on;ylabel('Group Delay');

% input signal
t = 1:50;
x1 = [cos(.4*pi*t).*(bartlett(length(t))') zeros(1,150)];                         % signal with .4*pi frequency
x2 = [zeros(1,60) cos(.2*pi*t).*(bartlett(length(t))') zeros(1,90)];              % signal with .2*pi frequency
x3 = [zeros(1,120) cos(.9*pi*t).*(bartlett(length(t))') zeros(1,30)];             % signal with .9*pi frequency
x = x1 + x2 + x3;
figure
subplot(211);plot(x);grid on;title('Input Signal')

%% Passing the input signal through the filter
y = filter(b,a,x);                                              % giving filter X 
subplot(212);plot(y);grid on;title('Ouput Signal')
figure
IIR_Wgn=filter(b,a,Wgn_1);plot(IIR_Wgn);title('IIR_Wgn')        % giving filter WNG
figure;
plot(noise,Wgn_1);title('Wgn_1'); 
figure
wgn_PSD=psd(IIR_Wgn);                                           % PSD of filterd WGN
subplot(211);plot(wgn_PSD); title('PSD of IIR test WGN');
subplot(212); plot(abs(H.*H)); title('impulse response Magnitude power by 2 ');