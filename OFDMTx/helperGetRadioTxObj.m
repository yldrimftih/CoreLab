function radio = helperGetRadioTxObj(ofdmTx)
%helperGetRadioTxObj(OFDMTX) returns the radio system object RADIO, based
%   on the chosen radio device and radio parameters such as Gain,
%   CenterFrequency, MasterClockRate, and Interpolation factor from the
%   radioParameter structure OFDMTX. The function also returns the spectrumAnalyzer
%   systemobject SPECTRUMANALYZE inorder to view the transmitted waveform


radio                    = sdrtx('Pluto');
radio.BasebandSampleRate = ofdmTx.SampleRate;
radio.CenterFrequency    = ofdmTx.CenterFrequency;
radio.Gain               = ofdmTx.Gain;

end
