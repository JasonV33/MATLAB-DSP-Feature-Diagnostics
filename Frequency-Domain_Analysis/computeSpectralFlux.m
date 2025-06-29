function [t_flux, fluxValues] = computeSpectralFlux(signal, fs, frameDuration, hopDuration)
% computeSpectralFlux - Computes spectral flux per frame.
%
% Inputs:
%   signal        : 1D mono audio signal
%   fs            : Sampling rate (Hz)
%   frameDuration : Frame size in seconds (e.g., 0.02)
%   hopDuration   : Hop size in seconds (e.g., 0.01)
%
% Outputs:
%   t_flux     : Time axis (frame centers, excludes first frame)
%   fluxValues : Spectral flux values per frame
%
% Usage:
%   [t, flux] = computeSpectralFlux(signal, fs, 0.02, 0.01);
%   plot(t, flux);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    frameLen = round(frameDuration * fs);
    hopLen   = round(hopDuration * fs);
    numFrames = floor((length(signal) - frameLen) / hopLen) + 1;

    win = hamming(frameLen);
    fluxValues = zeros(numFrames-1, 1);  % No flux on first frame
    t_flux = zeros(numFrames-1, 1);

    % Precompute spectra
    spectra = zeros(numFrames, floor(frameLen/2));
    for i = 1:numFrames
        idxStart = (i-1)*hopLen + 1;
        idxEnd   = idxStart + frameLen - 1;
        frame = signal(idxStart:idxEnd) .* win;

        magSpectrum = abs(fft(frame));
        spectra(i,:) = magSpectrum(1:floor(frameLen/2));
    end

    % Compute spectral flux
    for i = 2:numFrames
        diffVec = spectra(i,:) - spectra(i-1,:);
        fluxValues(i-1) = sqrt(sum(diffVec .^ 2));
        t_flux(i-1) = ((i-1)*hopLen + frameLen/2) / fs;
    end
end

% Example Usage:
% if doSpectralFlux
%     [tFlux, flux] = computeSpectralFlux(audio, fs, 0.02, 0.01);
%     nexttile;
%     plot(tFlux, flux, 'Color', [0.8 0.2 0.8]);
%     title('Spectral Flux');
%     xlabel('Time (s)');
%     ylabel('Flux');
%     grid on;
% end
