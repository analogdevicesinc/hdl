clear all;
close all;

decim_rate = 50000;

h_cic = dsp.CICDecimator(decim_rate,1,6);
gainCIC = (h_cic.DecimationFactor*h_cic.DifferentialDelay)^h_cic.NumSections
[h1, w1] = h_cic.freqz();

fs = 1;
fPass = 0.20;
fStop = 0.50;
ast = 70;

CICCompDecim = dsp.CICCompensationDecimator(h_cic, ...
    'DecimationFactor',2,'PassbandFrequency',fPass, ...
    'StopbandFrequency',fStop,'SampleRate',fs, ...
    'StopbandAttenuation',ast);
[h2, w2] = CICCompDecim.freqz();
CICCompDecim.coeffs()

FC = dsp.FilterCascade(h_cic,CICCompDecim);
[h3, w3] = FC.freqz();

subplot(311); hold on;
plot(w1/pi, 20*log10(abs(h1)/gainCIC)); 
plot(w2/pi, 20*log10(abs(h2))); 
hold off; grid

subplot(312); plot(w3/pi, 20*log10(abs(h3)/gainCIC)); grid

% M   = 8;   % Decimation factor
% Fp  = 40;  % Passband-edge frequency
% Fst = 60;  % Stopband-edge frequency
% Ap  = 0.1; % Passband peak-to-peak ripple
% Ast = 80;  % Minimum stopband attenuation
% Fs  = 800; % Sampling frequency
% HfdDecim = fdesign.decimator(M,'lowpass',Fp,Fst,Ap,Ast,Fs);
% HNyqDecim = design(HfdDecim,'kaiserwin','SystemObject', true);
% 
% [h4, w4] = freqz(HNyqDecim);
% subplot(313); plot(w4/pi, 20*log10(abs(h4))); grid

nt = numerictype(1,12,11);
fdhdltool(h_cic, nt);
fdhdltool(CICCompDecim, nt)