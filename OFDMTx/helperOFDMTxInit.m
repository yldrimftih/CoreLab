function txObj = helperOFDMTxInit(sysParam)

% Create a tx filter object for baseband filtering
txFilterCoef       = helperOFDMFrontEndFilter(sysParam);
txObj.txFilter     = dsp.FIRFilter('Numerator',txFilterCoef);

% Configure PN sequencer for additive scrambler
txObj.pnSeq        = comm.PNSequence(Polynomial= 'x^-7 + x^-3 + 1', InitialConditionsSource="Input port", Mask=sysParam.scrMask, SamplesPerFrame=sysParam.trBlkSize+sysParam.CRCLen);

% Initialize CRC parameters
txObj.crcHeaderGen = crcConfig('Polynomial',sysParam.headerCRCPoly);
txObj.crcDataGen   = crcConfig('Polynomial',sysParam.CRCPoly);

end
