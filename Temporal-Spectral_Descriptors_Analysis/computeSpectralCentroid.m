function [t_centroid, centroidHz] = computeSpectralCentroid(signal, fs, frameDuration, hopDuration)
% computeSpectralCentroid - Computes the spectral centroid per frame.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling frequency (Hz)
%   frameDuration : Frame length in seconds (e.g., 0.02 = 20ms)
%   hopDuration   : Hop size in seconds (e.g., 0.01 = 10ms)
%
% Outputs:
%   t_centroid    : Time axis (frame centers)
%   centroidHz    : Spectral centroid per frame (Hz)
%
% Usage:
%   [t, centroid] = computeSpectralCentroid(signal, fs, 0.02, 0.01);
%   plot(t, centroid);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    frameLen = round(frameDuration * fs);
    hopLen   = round(hopDuration * fs);
    N = length(signal);
    numFrames = floor((N - frameLen) / hopLen) + 1;

    centroidHz = zeros(numFrames, 1);
    t_centroid = zeros(numFrames, 1);
    win = hamming(frameLen);

    for i = 1:numFrames
        idxStart = (i-1)*hopLen + 1;
        idxEnd = idxStart + frameLen - 1;
        frame = signal(idxStart:idxEnd) .* win;

        % FFT
        spectrum = abs(fft(frame));
        spectrum = spectrum(1:floor(end/2));
        f = linspace(0, fs/2, length(spectrum));

        % Spectral Centroid formula
        if sum(spectrum) > 0
            centroidHz(i) = sum(f .* spectrum') / sum(spectrum);
        else
            centroidHz(i) = 0;
        end

        t_centroid(i) = (idxStart + idxEnd) / (2 * fs);
    end
end

% Example Usage:
% if doSpectralCentroid
%     [tCentroid, centroid] = computeSpectralCentroid(audio, fs, 0.02, 0.01);
%     nexttile;
%     plot(tCentroid, centroid, 'Color', [0.1 0.6 0.9]);
%     title('Spectral Centroid');
%     xlabel('Time (s)');
%     ylabel('Centroid (Hz)');
%     grid on;
% end
