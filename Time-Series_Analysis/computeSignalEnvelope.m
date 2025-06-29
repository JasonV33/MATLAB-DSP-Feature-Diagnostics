function [t, envelopeHilbert, envelopeRMS] = computeSignalEnvelope(signal, fs)
% computeSignalEnvelope - Computes the signal envelope using two methods:
%   1. Hilbert Transform Envelope
%   2. Moving RMS Envelope
%
% Inputs:
%   signal : 1D audio signal (mono)
%   fs     : Sampling frequency in Hz
%
% Outputs:
%   t               : Time axis (s)
%   envelopeHilbert : Envelope using Hilbert transform
%   envelopeRMS     : Envelope using RMS with a 50 ms window
%
% Usage:
%   [t, eH, eR] = computeSignalEnvelope(signal, fs);
%   plot(t, eH); hold on; plot(t, eR);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    % Time axis
    t = (0:length(signal)-1) / fs;

    % Hilbert Envelope
    analyticSignal = hilbert(signal);
    envelopeHilbert = abs(analyticSignal);

    % RMS Envelope
    winSize = round(0.05 * fs);  % 50ms window
    if mod(winSize, 2) == 0, winSize = winSize + 1; end
    envelopeRMS = sqrt(movmean(signal.^2, winSize));
end


% Example Usage
% if doSignalEnvelop
%     [t, envH, envR] = computeSignalEnvelope(audio, fs);
%     nexttile;
%     plot(t, audio, 'Color', [0.6 0.6 0.6], 'DisplayName', 'Original'); hold on;
%     plot(t, envH, 'r', 'LineWidth', 1.2, 'DisplayName', 'Hilbert');
%     plot(t, envR, 'g', 'LineWidth', 1.2, 'DisplayName', 'RMS');
%     title('Signal Envelope'); xlabel('Time (s)'); ylabel('Amplitude');
%     legend(); grid on;
% end
