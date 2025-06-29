function [t_bw, bandwidthHz] = computeSpectralBandwidth(signal, fs, frameDuration, hopDuration)
% computeSpectralBandwidth - Computes spectral bandwidth per frame.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling frequency in Hz
%   frameDuration : Duration of each frame in seconds (e.g., 0.02)
%   hopDuration   : Hop size in seconds (e.g., 0.01)
%
% Outputs:
%   t_bw          : Time axis (frame centers)
%   bandwidthHz   : Spectral bandwidth per frame in Hz
%
% Usage:
%   [t, bw] = computeSpectralBandwidth(signal, fs, 0.02, 0.01);
%   plot(t, bw);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    frameLen = round(frameDuration * fs);
    hopLen   = round(hopDuration * fs);
    numFrames = floor((length(signal) - frameLen) / hopLen) + 1;

    bandwidthHz = zeros(numFrames, 1);
    t_bw = zeros(numFrames, 1);
    win = hamming(frameLen);

    for i = 1:numFrames
        idxStart = (i-1)*hopLen + 1;
        idxEnd = idxStart + frameLen - 1;
        frame = signal(idxStart:idxEnd) .* win;

        % FFT
        spectrum = abs(fft(frame));
        spectrum = spectrum(1:floor(end/2));
        f = linspace(0, fs/2, length(spectrum));

        % Spectral Centroid
        if sum(spectrum) > 0
            centroid = sum(f .* spectrum') / sum(spectrum);
            % Spectral Bandwidth
            bandwidthHz(i) = sqrt(sum(((f - centroid).^2) .* spectrum') / sum(spectrum));
        else
            bandwidthHz(i) = 0;
        end

        t_bw(i) = (idxStart + idxEnd) / (2 * fs);
    end
end

% Example Usage:
% if doSpectralBandwith
%     [tBW, bw] = computeSpectralBandwidth(audio, fs, 0.02, 0.01);
%     nexttile;
%     plot(tBW, bw, 'Color', [0.2 0.8 0.2]);
%     title('Spectral Bandwidth');
%     xlabel('Time (s)');
%     ylabel('Bandwidth (Hz)');
%     grid on;
% end
