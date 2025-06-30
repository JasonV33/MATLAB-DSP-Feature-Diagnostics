function [magCQT, fCQT, tCQT] = computeCQT(signal, fs)
% computeCQT - Computes Constant-Q Transform magnitude.
%
% Inputs:
%   signal : 1D mono audio signal
%   fs     : Sampling rate (Hz)
%
% Outputs:
%   cqtMag : Magnitude CQT coefficients (frequency x time)
%   f_cqt  : Center frequencies (Hz)
%   t_cqt  : Time vector (s)
%
% Usage:
%   [mag, f, t] = computeCQT(audio, fs);
%   imagesc(t, f, mag);

    % Run CQT
    cqtResult = cqt(signal, 'SamplingFrequency', fs);

    % Handle shape [bins x frames x channels]
    if ndims(cqtResult) == 3
        % Average across channels (stereo → mono)
        magCQT = abs(mean(cqtResult, 3));  % [bins x frames]
    elseif ismatrix(cqtResult)
        magCQT = abs(cqtResult);
    else
        error('Unhandled cqtResult dimensions.');
    end

    % Estimate time and frequency axes
    [numBins, numFrames] = size(magCQT);
    tCQT = linspace(0, length(signal)/fs, numFrames);
    fCQT = logspace(log10(20), log10(fs/2), numBins);  % log-distributed freq bins


% Example Usage:
% if doCQT
%     [magCQT, fCQT, tCQT] = computeCQT(audio, fs);
%     figure('Name', 'Constant-Q Transform (CQT)', 'Color', 'w');
%     imagesc(tCQT, fCQT, 20*log10(magCQT + eps));  % log scale
%     axis xy; colormap jet;
%     title('Constant-Q Transform');
%     xlabel('Time (s)'); ylabel('Frequency (Hz)');
%     colorbar;
% end
