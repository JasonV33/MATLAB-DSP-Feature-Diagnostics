function [t_zcr, zcrPerFrame] = computeZCR(signal, fs, frameDuration, hopDuration)
% computeZCR - Computes the zero-crossing rate (ZCR) of the signal.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling rate in Hz
%   frameDuration : Frame length in seconds (e.g., 0.02 = 20ms)
%   hopDuration   : Hop length in seconds (e.g., 0.01 = 10ms)
%
% Outputs:
%   t_zcr         : Time axis for ZCR values (center of each frame)
%   zcrPerFrame   : Array of zero-crossing counts per frame (normalized)
%
% Usage:
%   [t, zcr] = computeZCR(signal, fs, 0.02, 0.01);
%   plot(t, zcr);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    frameLen = round(frameDuration * fs);
    hopLen   = round(hopDuration * fs);
    numFrames = floor((length(signal) - frameLen) / hopLen) + 1;

    zcrPerFrame = zeros(numFrames, 1);
    t_zcr       = zeros(numFrames, 1);

    for i = 1:numFrames
        idxStart = (i-1) * hopLen + 1;
        idxEnd   = idxStart + frameLen - 1;
        frame = signal(idxStart:idxEnd);

        % ZCR calculation
        signs = sign(frame);
        signChanges = sum(abs(diff(signs)) > 0);
        zcrPerFrame(i) = signChanges / frameLen;

        % Time axis (center of frame)
        t_zcr(i) = (idxStart + idxEnd) / (2 * fs);
    end
end

% Example Usage:
% if doZeroCrossingRate
%     [tZCR, zcr] = computeZCR(audio, fs, 0.02, 0.01);  % 20ms frame, 10ms hop
%     nexttile;
%     plot(tZCR, zcr, 'k');
%     title('Zero-Crossing Rate');
%     xlabel('Time (s)'); ylabel('ZCR (per frame)');
%     grid on;
% end
