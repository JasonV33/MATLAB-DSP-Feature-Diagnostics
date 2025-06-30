function [S_mel, f_mel, t_mel] = computeMelSpectrogram(signal, fs, frameDuration, hopDuration, numBands)
% computeMelSpectrogram - Computes Mel-scaled spectrogram of the audio signal.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling frequency (Hz)
%   frameDuration : Frame size in seconds (e.g., 0.025)
%   hopDuration   : Hop size in seconds (e.g., 0.01)
%   numBands      : Number of mel bands (e.g., 40)
%
% Outputs:
%   S_mel  : Mel spectrogram (mel bands x time)
%   f_mel  : Mel band center frequencies (Hz)
%   t_mel  : Time axis (s)
%
% Usage:
%   [S_mel, f_mel, t_mel] = computeMelSpectrogram(signal, fs, 0.025, 0.01, 40);
%   imagesc(t_mel, f_mel, 10*log10(S_mel + eps));

    if size(signal, 2) > 1
        signal = mean(signal, 2); % Mono
    end

    winLength = round(frameDuration * fs);
    hopLength = round(hopDuration * fs);

    % Compute Mel spectrogram using built-in function
    [S_mel, f_mel, t_mel] = melSpectrogram(signal, fs, ...
        'WindowLength', winLength, ...
        'OverlapLength', winLength - hopLength, ...
        'NumBands', numBands, ...
        'FFTLength', winLength);
end

% Example Usage:
% if doMelSpectogram
%     [S_mel, fMel, tMel] = computeMelSpectrogram(audio, fs, 0.025, 0.01, 40);
%     figure('Name', 'Mel Spectrogram', 'Color', 'w');
%     imagesc(tMel, fMel, 10*log10(S_mel + eps));
%     axis xy; colormap jet;
%     title('Mel Spectrogram');
%     xlabel('Time (s)'); ylabel('Frequency (Hz)');
%     colorbar;
% end
