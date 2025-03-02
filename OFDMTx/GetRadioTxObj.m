function radio = helperGetRadioTxObj(ofdmTx)

radio                    = sdrtx('Pluto');
radio.BasebandSampleRate = ofdmTx.SampleRate;
radio.CenterFrequency    = ofdmTx.CenterFrequency;
radio.Gain               = ofdmTx.Gain;

end
