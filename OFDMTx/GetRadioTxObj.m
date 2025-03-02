function radio = GetRadioTxObj(ofdmTx)

radio                    = sdrtx('Pluto');
radio.BasebandSampleRate = ofdmTx.SampleRate;
radio.CenterFrequency    = ofdmTx.CenterFrequency;
radio.Gain               = ofdmTx.Gain;

end
