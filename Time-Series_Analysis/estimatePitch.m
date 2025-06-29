function [t_pitch, pitchHz] = estimatePitch(signal, fs, frameDuration, hopDuration, minF0, maxF0)
% estimatePitch - Estimates pitch using time-domain autocorrelation method.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling rate (Hz)
%   frameDuration : Duration of analysis frame (e.g., 0.03 = 30 ms)
%   hopDuration   : Hop between frames (e.g., 0.01 = 10 ms)
%   minF0         : Minimum expected pitch frequency (e.g., 50 Hz)
%   maxF0         : Maximum expected pitch frequency (e.g., 500 Hz)
%
% Outputs:
%   t_pitch : Time axis (center of each frame)
%   pitchHz : Detected pitch per frame (0 if unvoiced)
%
% Usage:
%   [t, pitch] = estimatePitch(audio, fs, 0.03, 0.01, 50, 500);
%   plot(t, pitch);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    % Frame settings
    frameLen = round(frameDuration * fs);
    hopLen   = round(hopDuration * fs);
    numFrames = floor((length(signal) - frameLen) / hopLen) + 1;

    % Pitch range in samples
    minLag = floor(fs / maxF0);
    maxLag = ceil(fs / minF0);

    pitchHz = zeros(numFrames, 1);
    t_pitch = zeros(numFrames, 1);

    for i = 1:numFrames
        idxStart = (i-1) * hopLen + 1;
        idxEnd   = idxStart + frameLen - 1;
        frame = signal(idxStart:idxEnd) .* hamming(frameLen);  % Windowed

        % Autocorrelation
        acf = xcorr(frame, maxLag, 'coeff');
        acf = acf(maxLag+1:end);  % Keep positive lags only

        % Find peak in valid pitch range
        [~, lag] = max(acf(minLag:maxLag));
        lag = lag + minLag - 1;

        % Voicing check
        if acf(lag) > 0.3  % ACF peak threshold
            pitchHz(i) = fs / lag;
        else
            pitchHz(i) = 0;  % Unvoiced
        end

        % Time at center of frame
        t_pitch(i) = (idxStart + idxEnd) / (2 * fs);
    end
end
