clc; clear; close all;

% Parameters
ModulationOrder  = 4;       % QPSK modulation
Variance         = 0.01;    % Variance. Since the Signal has unit energy, the variance must be selected between 0:0.01:1
NumberOfSymbols  = 1000;    % Number of symbols

% Generating Random Data Symbols
GeneratedDatas   = randi([0 ModulationOrder-1], NumberOfSymbols, 1);

% PSK Modulation
GeneratedSymbols = pskmod(GeneratedDatas, ModulationOrder, pi/ModulationOrder);

% Generate complex AWGN noise (manual implementation)
NoiseReal        = sqrt(Variance / 2) * randn(NumberOfSymbols, 1); % Real part
NoiseImaginary   = sqrt(Variance / 2) * randn(NumberOfSymbols, 1); % Imaginary part
AWGNNoise        = NoiseReal + 1j * NoiseImaginary; % Complex noise

% Add noise to the signal
ReceivedSymbols  = GeneratedSymbols + AWGNNoise;

SNRdB            = mean(abs(GeneratedSymbols).^2) / mean(abs(AWGNNoise).^2);

scatterplot(ReceivedSymbols)


