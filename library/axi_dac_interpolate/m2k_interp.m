clear all;
close all;

interp_rate = 50000;

h_cic = dsp.CICInterpolator('InterpolationFactor', interp_rate, 'NumSections',6 );%, ...
                            %'FixedPointDataType','Specify word and fraction lengths', ... 
                            %'SectionWordLengths', [12 20 28 35 43 51], ...
                            %'SectionFractionLengths', [11 11 11 11 11 11], ...
                            %'OutputWordLength', 12, ...
                            %'OutputFractionLength', 11);
                        
gainCIC = (h_cic.InterpolationFactor*h_cic.DifferentialDelay)^h_cic.NumSections
[h1, w1] = h_cic.freqz();

fs = 1;
fPass = 0.20;
fStop = 0.50;
ast = 70;
prip = 0.05;
CICCompInterp = dsp.CICCompensationInterpolator(h_cic, ...
    'InterpolationFactor',2,'PassbandFrequency',fPass, ...
    'StopbandFrequency',fStop,'StopbandAttenuation',ast, ...
    'SampleRate',fs);

[h2, w2] = CICCompInterp.freqz();
CICCompInterp.coeffs()

FC = dsp.FilterCascade(CICCompInterp, h_cic);
[h3, w3] = FC.freqz();

subplot(211); hold on;
plot(w1/pi, 20*log10(abs(h1)/gainCIC)); 
plot(w2/pi, 20*log10(abs(h2))); 
hold off; grid

subplot(212); plot(w3/pi, 20*log10(abs(h3)/gainCIC/sum(CICCompInterp.coeffs().Numerator))); grid

nt = numerictype(1,16,15);
fdhdltool(CICCompInterp, nt);
nt = numerictype(1,36,30);
fdhdltool(h_cic,nt);

