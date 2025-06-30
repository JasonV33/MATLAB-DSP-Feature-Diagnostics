function [S_logMel, f_mel, t_mel] = computeLogMelSpectrogram(signal, fs, frameDuration, hopDuration, numBands)
% computeLogMelSpectrogram - Computes log-compressed Mel spectrogram.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling frequency (Hz)
%   frameDuration : Frame size in seconds (e.g., 0.025)
%   hopDuration   : Hop size in seconds (e.g., 0.01)
%   numBands      : Number of mel bands (e.g., 40)
%
% Outputs:
%   S_logMel : Log-compressed Mel spectrogram (mel bands x time)
%   f_mel    : Mel band center frequencies (Hz)
%   t_mel    : Time axis (s)
%
% Usage:
%   [S_logMel, f, t] = computeLogMelSpectrogram(audio, fs, 0.025, 0.01, 40);
%   imagesc(t, f, S_logMel);

    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    winLength = round(frameDuration * fs);
    hopLength = round(hopDuration * fs);

    % Compute Mel spectrogram first
    [S_mel, f_mel, t_mel] = melSpectrogram(signal, fs, ...
        'WindowLength', winLength, ...
        'OverlapLength', winLength - hopLength, ...
        'NumBands', numBands, ...
        'FFTLength', winLength);

    % Apply log compression
    S_logMel = 10 * log10(S_mel + eps);  % Avoid log(0)
end

% Example Usage:
% if doLogMelSpectogram
%     [S_logMel, fLogMel, tLogMel] = computeLogMelSpectrogram(audio, fs, 0.025, 0.01, 40);
%     figure('Name', 'Log-Mel Spectrogram', 'Color', 'w');
%     imagesc(tLogMel, fLogMel, S_logMel);
%     axis xy; colormap jet;
%     title('Log-Mel Spectrogram');
%     xlabel('Time (s)'); ylabel('Frequency (Hz)');
%     colorbar;
% end
