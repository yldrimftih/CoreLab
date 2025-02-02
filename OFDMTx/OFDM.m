clc; clear; close all;

% Parameters
ModulationOrder     = 4;       % QPSK modulation
Variance            = 0.01;    % Variance. Since the Signal has unit energy, the variance must be selected between 0:0.01:1
NumberOfSymbols     = 1024;    % Number of symbols
NumberOfSubCarriers = 64;

% Generating Random Data Symbols
GeneratedDatas   = randi([0 ModulationOrder-1], NumberOfSymbols, 1);

% PSK Modulation
GeneratedSymbols = pskmod(GeneratedDatas', ModulationOrder, pi/ModulationOrder);

NumberOfOFDMSymbols = NumberOfSymbols / NumberOfSubCarriers;
SubCarrierSymbols = reshape(GeneratedSymbols,NumberOfSubCarriers, NumberOfOFDMSymbols);
TimeDomainSymbols = ifft(SubCarrierSymbols);

TransmittedOFDMSymbols = TimeDomainSymbols(:);

plot(real(TransmittedOFDMSymbols));
hold on;
plot(imag(TransmittedOFDMSymbols));

% Generate complex AWGN noise 
NoiseReal        = sqrt(Variance / 2) * randn(NumberOfSymbols, 1); % Real part
NoiseImaginary   = sqrt(Variance / 2) * randn(NumberOfSymbols, 1); % Imaginary part
AWGNNoise        = NoiseReal + 1j * NoiseImaginary; % Complex noise

% Add noise to the signal
%ReceivedSymbols  = GeneratedSymbols + AWGNNoise;

%SNRdB            = mean(abs(GeneratedSymbols).^2) / mean(abs(AWGNNoise).^2);

%scatterplot(ReceivedSymbols)


