clear; close; clc;

%% Set OFDM Frame Parameters
%The pilot subcarrier spacing and channel bandwidth parameters are fixed at 30 KHz and 3 MHz.
% The chosen set of OFDM parameters:
OFDMParams.FFTLength              = 128;   % FFT length.
OFDMParams.CPLength               = 32;    % Cyclic prefix length.
OFDMParams.NumSubcarriers         = 72;    % Number of sub-carriers in the band.
OFDMParams.Subcarrierspacing      = 30e3;  % Sub-carrier spacing of 30 KHz.
OFDMParams.PilotSubcarrierSpacing = 9;     % Pilot sub-carrier spacing.
OFDMParams.channelBW              = 3e6;   % Bandwidth of the channel 3 MHz.

dataParams.modOrder       = 4;  		   % Data modulation order. Supported Modulation Orders: QPSK, 16QAM, 64QAM, 256QAM, 1024QAM.
dataParams.coderate       = "1/2";         % Code rate.             Supported rates: 1/2, 2/3.
dataParams.numSymPerFrame = 30;			   % Number of data symbols per frame 20 for setup.
dataParams.numFrames      = 10000;         % Number of frames to transmit.

%% Initialize Transmitter Parameters
radioDevice            = "PLUTO";
centerFrequency        = 3e9;
gain                   = 0;

[sysParam,txParam,trBlk] = OFDMSetParamsSDR(OFDMParams,dataParams);                              % modify the helper function. give your bit stream instead of trBlk
sampleRate               = sysParam.scs*sysParam.FFTLen;                                               % Sample rate of signal
ofdmTx                   = GetRadioParams(sysParam,radioDevice,sampleRate,centerFrequency,gain); % modify the helper function. 

% Get the radio transmitter and spectrum analyzer system object system object for the user to visualize the transmitted waveform.
radio                    = GetRadioTxObj(ofdmTx); 

% Initialize transmitter
txObj = OFDMTxInit(sysParam); % you can use the function to apply pulse shaping
tunderrun = 0;                      % Initialize count for underruns

% A known payload is generated in the function helperOFDMSetParams with
% respect to the calculated trBlkSize
% Store data bits for BER calculations
txParam.txDataBits = trBlk;                                          % here, give your own bit stream. type of trBlk is double but it only has 0s and 1s.
txOut              = OFDMTx(txParam,sysParam,txObj); % remove txgrid and txDiagnostics

% Repeat the data in a buffer for PLUTO radio to make sure there are less
% underruns. The receiver decodes only one frame from where the first
% synchroization signal is received
txOutSize = length(txOut);
if contains(radioDevice,'PLUTO') && txOutSize < 48000
    frameCnt = ceil(48000/txOutSize);
    txWaveform = zeros(txOutSize*frameCnt,1);
    for i = 1:frameCnt
        txWaveform(txOutSize*(i-1)+1:i*txOutSize) = txOut;
    end
else
    txWaveform = txOut;
end

% Transmit Over Radio
for frameNum = 1:sysParam.numFrames+1
    underrun  = radio(txWaveform);
    tunderrun = tunderrun + underrun;  % Total underruns
end

% Clean up the radio System object
release(radio);
