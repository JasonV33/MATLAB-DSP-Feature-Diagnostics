function [t_formants, formantTracks] = computeFormantsLPC(signal, fs, frameDuration, hopDuration, numFormants)
% computeFormantsLPC - Estimates formant frequencies using LPC analysis per frame.
%
% Inputs:
%   signal       : 1D mono audio signal
%   fs           : Sampling rate (Hz)
%   frameDuration: Frame size in seconds (e.g., 0.03)
%   hopDuration  : Hop size in seconds (e.g., 0.01)
%   numFormants  : Max number of formants to track (e.g., 3–5)
%
% Outputs:
%   t_formants   : Time vector (frame centers)
%   formantTracks: Matrix of formants per frame (time x numFormants)
%
% Usage:
%   [t, F] = computeFormantsLPC(audio, fs, 0.03, 0.01, 3);
%   plot(t, F);

    if size(signal, 2) > 1
        signal = mean(signal, 2);  % Mono
    end

    frameLen = round(frameDuration * fs);
    hopLen   = round(hopDuration * fs);
    numFrames = floor((length(signal) - frameLen) / hopLen) + 1;

    formantTracks = zeros(numFrames, numFormants);
    t_formants = zeros(numFrames, 1);

    for i = 1:numFrames
        idxStart = (i-1)*hopLen + 1;
        idxEnd = idxStart + frameLen - 1;
        frame = signal(idxStart:idxEnd) .* hamming(frameLen);

        % LPC order (2*expected formants is a rule of thumb)
        lpcOrder = 2 * numFormants + 2;
        a = lpc(frame, lpcOrder);

        % Get roots of LPC polynomial
        rts = roots(a);
        rts = rts(imag(rts) >= 0.01);  % Keep complex roots only

        ang = atan2(imag(rts), real(rts));
        freqs = ang * (fs / (2*pi));  % Convert to Hz
        freqs = sort(freqs);          % Ascending order

        % Keep only lowest `numFormants`
        formantTracks(i, 1:min(numFormants, length(freqs))) = freqs(1:min(numFormants, length(freqs)));
        t_formants(i) = (idxStart + idxEnd) / (2 * fs);
    end
end

% Example Usage:
% if doFormants
%     [tFormants, F] = computeFormantsLPC(audio, fs, 0.03, 0.01, 3);  % Track first 3 formants
%     figure('Name', 'Formant Tracking (LPC)', 'Color', 'w');
%     plot(tFormants, F, 'LineWidth', 1.2);
%     title('Formants via LPC');
%     xlabel('Time (s)');
%     ylabel('Frequency (Hz)');
%     legend('F1','F2','F3'); grid on;
% end
