% This example prepends a cyclic prefix to OFDM-modulated 16-QAM data.
% To be effective for equalization the cyclic prefix (CP) length must equal or exceed the channel length.

clear; close; clc;
% Define variables for QAM and OFDM processing. Generate symbols, QAM-modulate, OFDM-modulate, and then add a CP to the signal.
%  Multiple OFDM symbols can be processed simultaneously and then serialized.

ModulationOrder      = 4;    % Number of bits per symbol
NumberOfSymbols      = 2^ModulationOrder;  % Modulation order
OFDMSubcarrierNumber = 128; % Number of FFT bins
CPLength             = 8;    % CP length

Datas          = randi([0 NumberOfSymbols-1],OFDMSubcarrierNumber,1);
ModulatedDatas = qammod(Datas,NumberOfSymbols,UnitAveragePower=true);
OFDMOutData    = ifft(ModulatedDatas,OFDMSubcarrierNumber);
% To process multiple symbols, vectorize the OFDMOutData matrix
OFDMOutData    = OFDMOutData(:);
CPDatas = OFDMOutData(OFDMSubcarrierNumber-CPLength+1:OFDMSubcarrierNumber);
OFDMOutData = [CPDatas; OFDMOutData];

% Filter the transmission through a channel that adds noise, frequency dependency, and delay to the received signal.
ChannelCoefficients = [0.4 1 0.4].';
ReceivedSignalsWithAWGN = awgn(OFDMOutData,40);       % Add noise
ReceivedSignalsWithAWGNAndChannelEffect = conv(ReceivedSignalsWithAWGN,ChannelCoefficients);     % Add frequency dependency
ChannelDelay = dsp.Delay(1); % Could use fractional delay
ReceivedSignalAddedChannelDelay = channelDelay(ReceivedSignalsWithAWGNAndChannelEffect);   % Add delay

% Add a random offset less than the CP length. An offset setting of zero models perfect synchronization between transmitted and received signals.
% Any timing offset less than the CP length can be compensated by equalization via an additional linear phase.
RandomOffset = randi(CPLength) - 1; % random offset less than length of CP


% Remove CP and synchronize the received signal
SyncedReceivedSignal = ReceivedSignalAddedChannelDelay(CPLength+1+channelDelay.Length-RandomOffset:end);
ReceivedSignaRemovedCP = fft(SyncedReceivedSignal(1:OFDMSubcarrierNumber),OFDMSubcarrierNumber);

% Practical systems require estimation of the channel as part of the signal recovery process.
% The combination of OFDM and a CP simplifies equalization to a complex scalar for each frequency bin.
% As long as the latency falls within the length of the CP, synchronization is accomplished by the channel estimator.
% A control here allows you to experiment by disabling the equalization at receiver front end. Compare the transmitted signal with the receiver output.

useEqualizer = true;
if useEqualizer
    ChannelImpulseResponse = fft(ChannelCoefficients,OFDMSubcarrierNumber);
    % Linear phase term related to timing offset
    FrequencyOffset = exp(-1i * 2*pi*RandomOffset * (0:OFDMSubcarrierNumber-1).'/OFDMSubcarrierNumber);
    OFDMDemodulatedReceivedSignal = ReceivedSignaRemovedCP ./ (ChannelImpulseResponse .* FrequencyOffset);
else % Without equalization errors occur
    OFDMDemodulatedReceivedSignal = ReceivedSignaRemovedCP;
end
ReceivedDatas = qamdemod(OFDMDemodulatedReceivedSignal,NumberOfSymbols,UnitAveragePower=true);

if max(Datas - ReceivedDatas) < 1e-8
    disp("Receiver output matches transmitter input.");
else
    disp("Received symbols do not match transmitted symbols.")
end

