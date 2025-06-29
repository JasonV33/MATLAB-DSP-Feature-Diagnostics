function [t_energy, energyPerFrame] = computeShortTimeEnergy(signal, fs, frameDuration, hopDuration)
% computeShortTimeEnergy - Computes short-time energy of the signal.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling rate in Hz
%   frameDuration : Frame length in seconds (e.g., 0.02 = 20ms)
%   hopDuration   : Hop length in seconds (e.g., 0.01 = 10ms)
%
% Outputs:
%   t_energy        : Time axis for energy values (center of each frame)
%   energyPerFrame  : Array of energy values per frame
%
% Usage:
%   [t, E] = computeShortTimeEnergy(signal, fs, 0.02, 0.01);
%   plot(t, E);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    % Frame and hop lengths in samples
    frameLen = round(frameDuration * fs);
    hopLen   = round(hopDuration * fs);

    % Zero-padding at the end to handle last frame
    numFrames = floor((length(signal) - frameLen) / hopLen) + 1;
    energyPerFrame = zeros(numFrames, 1);
    t_energy = zeros(numFrames, 1);

    % Compute energy per frame
    for i = 1:numFrames
        idxStart = (i-1) * hopLen + 1;
        idxEnd   = idxStart + frameLen - 1;
        frame = signal(idxStart:idxEnd);
        energyPerFrame(i) = sum(frame.^2);
        t_energy(i) = (idxStart + idxEnd) / (2*fs);  % frame center time
    end
end

% Example Usage
% if doShortTimeenergy
%     [tE, energy] = computeShortTimeEnergy(audio, fs, 0.02, 0.01);  % 20ms frames, 10ms hop
%     nexttile;
%     plot(tE, energy, 'b');
%     title('Short-Time Energy');
%     xlabel('Time (s)'); ylabel('Energy');
%     grid on;
% end
