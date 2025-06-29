function [t_rolloff, rolloffHz] = computeSpectralRolloff(signal, fs, frameDuration, hopDuration, rollPercent)
% computeSpectralRolloff - Computes spectral roll-off frequency per frame.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling frequency (Hz)
%   frameDuration : Frame length in seconds (e.g., 0.02)
%   hopDuration   : Hop size in seconds (e.g., 0.01)
%   rollPercent   : Percentage of total energy to include (e.g., 0.85)
%
% Outputs:
%   t_rolloff     : Time axis (frame centers)
%   rolloffHz     : Roll-off frequency per frame (Hz)
%
% Usage:
%   [t, r] = computeSpectralRolloff(signal, fs, 0.02, 0.01, 0.85);
%   plot(t, r);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    frameLen = round(frameDuration * fs);
    hopLen   = round(hopDuration * fs);
    numFrames = floor((length(signal) - frameLen) / hopLen) + 1;

    rolloffHz = zeros(numFrames, 1);
    t_rolloff = zeros(numFrames, 1);
    win = hamming(frameLen);

    for i = 1:numFrames
        idxStart = (i-1)*hopLen + 1;
        idxEnd   = idxStart + frameLen - 1;
        frame = signal(idxStart:idxEnd) .* win;

        % FFT
        spectrum = abs(fft(frame));
        spectrum = spectrum(1:floor(end/2));
        f = linspace(0, fs/2, length(spectrum));

        totalEnergy = sum(spectrum);
        cumulativeEnergy = cumsum(spectrum);
        idx = find(cumulativeEnergy >= rollPercent * totalEnergy, 1, 'first');

        if ~isempty(idx)
            rolloffHz(i) = f(idx);
        else
            rolloffHz(i) = 0;
        end

        t_rolloff(i) = (idxStart + idxEnd) / (2 * fs);
    end
end

% Example Usage:
% if doSpectralRolloff
%     [tRoll, roll] = computeSpectralRolloff(audio, fs, 0.02, 0.01, 0.85);  % 85% rolloff
%     nexttile;
%     plot(tRoll, roll, 'Color', [0.9 0.4 0.1]);
%     title('Spectral Roll-off (85%)');
%     xlabel('Time (s)');
%     ylabel('Frequency (Hz)');
%     grid on;
% end
