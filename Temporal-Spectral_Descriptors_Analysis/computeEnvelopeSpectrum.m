function [f_env, mag_env] = computeEnvelopeSpectrum(signal, fs)
% computeEnvelopeSpectrum - Computes the spectrum of the signal's amplitude envelope.
%
% Inputs:
%   signal : 1D mono audio signal
%   fs     : Sampling frequency (Hz)
%
% Outputs:
%   f_env  : Frequency axis for envelope spectrum (Hz)
%   mag_env: Magnitude of FFT of the envelope
%
% Usage:
%   [f, mag] = computeEnvelopeSpectrum(signal, fs);
%   plot(f, mag);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    % Compute envelope using Hilbert Transform
    envelope = abs(hilbert(signal));
    envelope = envelope / max(envelope);  % Normalize

    % FFT of the envelope
    N = length(envelope);
    fft_env = fft(envelope);
    mag = abs(fft_env) / N;

    % Single-sided spectrum
    if mod(N, 2) == 0
        mag = mag(1:N/2+1);
        mag(2:end-1) = 2 * mag(2:end-1);
        f_env = fs * (0:N/2) / N;
    else
        mag = mag(1:(N+1)/2);
        mag(2:end) = 2 * mag(2:end);
        f_env = fs * (0:(N-1)/2) / N;
    end

    mag_env = mag;
end

% Example Usage:
% if doEnvelopeSpectrum
%     [fEnv, magEnv] = computeEnvelopeSpectrum(audio, fs);
%     figure('Name', 'Envelope Spectrum', 'Color', 'w');
%     plot(fEnv, magEnv, 'Color', [0.3 0.7 0.7]);
%     title('Envelope Spectrum (Hilbert)');
%     xlabel('Modulation Frequency (Hz)');
%     ylabel('Envelope Magnitude');
%     xlim([0 50]);  % Usually low-frequency AM content
%     grid on;
% end
