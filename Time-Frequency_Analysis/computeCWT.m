function [cfs, f_cwt, t_cwt] = computeCWT(signal, fs)
% computeCWT - Computes Continuous Wavelet Transform (CWT) using analytic wavelets.
%
% Inputs:
%   signal : 1D mono audio signal
%   fs     : Sampling frequency (Hz)
%
% Outputs:
%   cfs    : CWT coefficients (frequency x time)
%   f_cwt  : Frequency vector (Hz)
%   t_cwt  : Time vector (s)
%
% Usage:
%   [cfs, f, t] = computeCWT(audio, fs);
%   imagesc(t, f, abs(cfs)); axis xy;

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    % Compute CWT using Morse wavelet (requires Signal Processing Toolbox)
    [cfs, f_cwt] = cwt(signal, fs);
    t_cwt = (0:length(signal)-1) / fs;
end

% Example Usage:
% if doCWT
%     [cfs, fCWT, tCWT] = computeCWT(audio, fs);
%     figure('Name', 'CWT Scalogram', 'Color', 'w');
%     imagesc(tCWT, fCWT, abs(cfs));
%     axis xy; colormap jet;
%     title('Continuous Wavelet Transform (Scalogram)');
%     xlabel('Time (s)');
%     ylabel('Frequency (Hz)');
%     colorbar;
% end
