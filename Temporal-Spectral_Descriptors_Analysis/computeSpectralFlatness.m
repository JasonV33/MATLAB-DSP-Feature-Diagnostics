function [t_flatness, flatnessValues] = computeSpectralFlatness(signal, fs, frameDuration, hopDuration)
% computeSpectralFlatness - Computes spectral flatness per frame.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling frequency in Hz
%   frameDuration : Frame size in seconds (e.g., 0.02)
%   hopDuration   : Hop size in seconds (e.g., 0.01)
%
% Outputs:
%   t_flatness    : Time axis (frame centers)
%   flatnessValues: Flatness values per frame (0 to 1)
%
% Usage:
%   [t, sf] = computeSpectralFlatness(signal, fs, 0.02, 0.01);
%   plot(t, sf);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    frameLen = round(frameDuration * fs);
    hopLen   = round(hopDuration * fs);
    numFrames = floor((length(signal) - frameLen) / hopLen) + 1;

    flatnessValues = zeros(numFrames, 1);
    t_flatness = zeros(numFrames, 1);
    win = hamming(frameLen);

    for i = 1:numFrames
        idxStart = (i-1)*hopLen + 1;
        idxEnd   = idxStart + frameLen - 1;
        frame = signal(idxStart:idxEnd) .* win;

        % FFT
        spectrum = abs(fft(frame));
        spectrum = spectrum(1:floor(end/2));

        % Avoid log(0) by replacing 0s
        spectrum(spectrum == 0) = eps;

        % Compute flatness
        geoMean = exp(mean(log(spectrum)));
        arithMean = mean(spectrum);
        flatnessValues(i) = geoMean / arithMean;

        t_flatness(i) = (idxStart + idxEnd) / (2 * fs);
    end
end

% Example Usage: 
% if doSpectralFlatness
%     [tFlat, flat] = computeSpectralFlatness(audio, fs, 0.02, 0.01);
%     nexttile;
%     plot(tFlat, flat, 'Color', [0.5 0.5 1]);
%     title('Spectral Flatness');
%     xlabel('Time (s)');
%     ylabel('Flatness (0 = tonal, 1 = noise-like)');
%     grid on;
% end
