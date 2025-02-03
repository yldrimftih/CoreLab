clc; clear; close all;

% Parameters
ModulationOrder     = 4;       % QPSK modulation
NumberOfSymbols     = 1024;    % Total number of symbols
NumberOfSubCarriers = 64;      % Number of OFDM subcarriers
SNRdB               = 10;      % Signal-to-Noise Ratio (in dB)

% Generate Random QPSK Data
GeneratedDatas   = randi([0 ModulationOrder-1], NumberOfSymbols, 1);

% QPSK Modulation
GeneratedSymbols = pskmod(GeneratedDatas, ModulationOrder, pi/ModulationOrder);

% Reshape Data for OFDM Transmission 
NumberOfOFDMSymbols = NumberOfSymbols / NumberOfSubCarriers;
SubCarrierSymbols   = reshape(GeneratedSymbols, NumberOfSubCarriers, NumberOfOFDMSymbols);

% IFFT to Convert to Time Domain
TimeDomainSymbols = ifft(SubCarrierSymbols);

% Serialize for Transmission
TransmittedSignal = TimeDomainSymbols(:);

% AWGN Channel 

% Compute Signal Power
SignalPower = mean(abs(TransmittedSignal).^2);

% Convert SNR from dB to Linear Scale
SNRLinear = 10^(SNRdB/10);

% Compute Noise Power
NoisePower = SignalPower / SNRLinear;

% Generate Complex Gaussian Noise
Noise = sqrt(NoisePower/2) * (randn(size(TransmittedSignal)) + 1j * randn(size(TransmittedSignal)));

% Add Noise to the Transmitted Signal
ReceivedSignal = TransmittedSignal + Noise;

% Reshape Back into OFDM Symbols
ReceivedSymbolsMatrix = reshape(ReceivedSignal, NumberOfSubCarriers, NumberOfOFDMSymbols);

% FFT to Convert Back to Frequency Domain
RecoveredSubCarrierSymbols = fft(ReceivedSymbolsMatrix);

% QPSK Demodulation
DemodulatedSymbols = pskdemod(RecoveredSubCarrierSymbols(:), ModulationOrder, pi/ModulationOrder);

% BER Calculation
BitErrors = sum(GeneratedDatas ~= DemodulatedSymbols);
BER = BitErrors / length(GeneratedDatas);
disp(['Bit Error Rate (BER): ', num2str(BER)]);

% Scatter Plot: Received Symbols After AWGN
figure;
scatterplot(RecoveredSubCarrierSymbols(:));
title(['Received QPSK Constellation After OFDM Transmission (SNR = ', num2str(SNRdB), ' dB)']);
grid on;

% Time-Domain Signal Visualization
figure;
subplot(2,1,1);
plot(real(TransmittedSignal));
title('Transmitted OFDM Signal (Time Domain)');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(real(ReceivedSignal));
title('Received OFDM Signal After AWGN (Time Domain)');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;
