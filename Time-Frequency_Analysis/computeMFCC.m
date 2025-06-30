function [mfccs, t] = computeMFCC(signal, fs, frameLength, frameHop, numCoeffs)
% computeMFCC - Computes MFCCs from an audio signal
%
% Inputs:
%   signal      : Audio waveform
%   fs          : Sampling frequency
%   frameLength : Frame length in seconds (e.g., 0.025)
%   frameHop    : Hop size in seconds (e.g., 0.01)
%   numCoeffs   : Number of MFCC coefficients to return
%
% Outputs:
%   mfccs       : MFCC coefficient matrix
%   t           : Time axis for MFCC frames

    winSamples  = round(frameLength * fs);
    hopSamples  = round(frameHop * fs);
    win         = hamming(winSamples, 'periodic');

    [mfccs, t] = mfcc(signal, fs, ...
        'Window', win, ...
        'OverlapLength', winSamples - hopSamples, ...
        'NumCoeffs', numCoeffs);
end


% Example Usage:
% if doMFCC
%     [mfccs, tMFCC] = computeMFCC(audio, fs, 0.025, 0.01, 13);
%     figure('Name', 'MFCCs', 'Color', 'w');
%     imagesc(tMFCC, 1:13, mfccs'); axis xy;
%     colormap jet; colorbar;
%     title('Mel-Frequency Cepstral Coefficients (MFCCs)');
%     xlabel('Time (s)');
%     ylabel('Coefficient Index');
% end
