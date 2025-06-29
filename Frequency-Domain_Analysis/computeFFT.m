function [f, magnitudeSpectrum] = computeFFT(signal, fs)
% computeFFT - Computes the single-sided magnitude FFT of the signal.
%
% Inputs:
%   signal : 1D mono audio signal
%   fs     : Sampling rate (Hz)
%
% Outputs:
%   f                : Frequency axis (Hz)
%   magnitudeSpectrum: Magnitude of FFT (normalized)
%
% Usage:
%   [f, mag] = computeFFT(signal, fs);
%   plot(f, mag);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    % Normalize
    signal = signal / max(abs(signal));

    N = length(signal);        % Number of samples
    fftData = fft(signal);     % Full FFT
    mag = abs(fftData) / N;    % Magnitude and normalization

    % Single-sided spectrum
    if mod(N, 2) == 0
        mag = mag(1:N/2+1);
        mag(2:end-1) = 2 * mag(2:end-1);
        f = fs * (0:N/2) / N;
    else
        mag = mag(1:(N+1)/2);
        mag(2:end) = 2 * mag(2:end);
        f = fs * (0:(N-1)/2) / N;
    end

    magnitudeSpectrum = mag;
end

% Example Usage:
% if doFFT
%     [f, magFFT] = computeFFT(audio, fs);
%     figure('Name', 'FFT - Magnitude Spectrum', 'Color', 'w');
%     plot(f, magFFT, 'b');
%     title('FFT Magnitude Spectrum');
%     xlabel('Frequency (Hz)');
%     ylabel('Magnitude');
%     xlim([0 fs/2]);
%     grid on;
% end
