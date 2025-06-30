function [S, f, t] = computeSpectrogramSTFT(signal, fs, windowDuration, overlapRatio, nFFT)
% computeSpectrogramSTFT - Computes magnitude spectrogram using STFT.
%
% Inputs:
%   signal         : 1D mono audio signal
%   fs             : Sampling frequency (Hz)
%   windowDuration : Window length in seconds (e.g., 0.025)
%   overlapRatio   : Fractional overlap (e.g., 0.5 = 50% overlap)
%   nFFT           : Number of FFT points (e.g., 512)
%
% Outputs:
%   S : Spectrogram (magnitude)
%   f : Frequency vector (Hz)
%   t : Time vector (s)
%
% Usage:
%   [S, f, t] = computeSpectrogramSTFT(signal, fs, 0.025, 0.5, 512);
%   imagesc(t, f, 20*log10(S));

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    % Parameters
    winLen = round(windowDuration * fs);
    hopLen = round(winLen * (1 - overlapRatio));
    win = hamming(winLen, 'periodic');

    % STFT
    [S, f, t] = spectrogram(signal, win, winLen - hopLen, nFFT, fs, 'yaxis');
    S = abs(S);  % Magnitude only
end

% Example Usage:
% if doSTFTSpectogram
%     [S, fS, tS] = computeSpectrogramSTFT(audio, fs, 0.025, 0.5, 512);
%     figure('Name', 'STFT Spectrogram', 'Color', 'w');
%     imagesc(tS, fS, 20*log10(S + eps)); axis xy;
%     title('STFT Magnitude Spectrogram');
%     xlabel('Time (s)'); ylabel('Frequency (Hz)');
%     colormap jet; colorbar;
% end
