function ofdmRadioParams = GetRadioParams(sysParams,radioDevice,sampleRate,centerFrequency,gain) 

ofdmRadioParams.RadioDevice     = radioDevice;
ofdmRadioParams.CenterFrequency = centerFrequency;
ofdmRadioParams.Gain            = gain;
ofdmRadioParams.SampleRate      = sampleRate;                % Sample rate of transmitted signal
ofdmRadioParams.NumFrames       = sysParams.numFrames;       % Number of frames for transmission/reception
ofdmRadioParams.txWaveformSize  = sysParams.txWaveformSize;  % Size of the transmitted waveform
ofdmRadioParams.modOrder        = sysParams.modOrder;

end
