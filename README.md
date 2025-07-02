# MATLAB DSP Feature Diagnostics

A modular MATLAB-based tool for extracting and visualizing diagnostic features from 1D signals (acoustic, biomedical, mechanical, etc.). This utility was developed to support structured and interpretable feature engineering during signal-based machine learning and statistical modeling tasks.

## Key Features

The tool provides grouped diagnostic modules with toggle-based execution, enabling easy comparative analysis and simplified visualization of temporal, spectral, and joint-domain signal characteristics.

### Time-Series Analysis

* **Signal Envelope** (Hilbert & RMS)
* **Short-Time Energy**
* **Zero-Crossing Rate (ZCR)**
* **Pitch Tracking**
* **Autocorrelation**
* **Statistical Descriptors** (mean, variance, kurtosis, skewness)

### Frequency-Domain Analysis

* **FFT Magnitude Spectrum**
* **Spectral Centroid**
* **Spectral Bandwidth**
* **Spectral Rolloff (85%)**
* **Spectral Flatness**
* **Spectral Flux**
* **Envelope Spectrum**

### Time-Frequency Analysis

* **STFT Spectrogram**
* **Mel Spectrogram**
* **Log-Mel Spectrogram**
* **MFCCs**
* **Delta & Delta-Delta MFCCs**
* **CWT Scalogram**
* **CQT (Constant-Q Transform)**
* **Formant Tracking (LPC)**

---

## File Structure

```
MATLAB-DSP-Feature-Diagnostics/
├── main_DSP_Feature_Diagnostics.m                 # Main controller script
├── Time-Series_Analysis/
│   ├── computeSignalEnvelope.m
│   ├── computeShortTimeEnergy.m
│   ├── computeZCR.m
│   ├── estimatePitch.m
│   ├── computeAutocorrelation.m
│   └── computeSignalStatistics.m
├── Temporal-Spectral_Descriptors_Analysis/
│   ├── computeFFT.m
│   ├── computeSpectralCentroid.m
│   ├── computeSpectralBandwidth.m
│   ├── computeSpectralRolloff.m
│   ├── computeSpectralFlatness.m
│   ├── computeSpectralFlux.m
│   └── computeEnvelopeSpectrum.m
├── Time-Frequency_Analysis/
│   ├── computeSpectrogramSTFT.m
│   ├── computeMelSpectrogram.m
│   ├── computeLogMelSpectrogram.m
│   ├── computeMFCC.m
│   ├── computeDeltaMFCC.m
│   ├── computeCWT.m
│   ├── computeCQT.m
│   └── computeFormantsLPC.m
```

## Usage

* Modify the toggles in `main_DSP_Feature_Diagnostics.m` to enable/disable specific features.
* Set the `signal_dir` to your target `.wav` file.
* Run the main script. Visualizations will be grouped by domain (time, frequency, time-frequency).

## Applications

* Feature extraction for machine learning classification
* Acoustic and biomedical signal exploration
* Temporal-spectral pattern analysis
* Interpretability benchmarking

---

## Author

**Jason Menard Vasallo**
Master’s Student in Electronics Engineering
De La Salle University

---

## Upcoming Techniques (Planned Modules)

We are continuously improving the DSP Feature Diagnostics Tool to support more advanced and modern signal processing techniques. Below is a list of upcoming modules under research and development:

| Technique                    | Theory Description                                         | Purpose                                    | Planned Visualization        | Status   |
|-----------------------------|------------------------------------------------------------|--------------------------------------------|-------------------------------|----------|
| Teager–Kaiser Energy (TKEO) | Instantaneous nonlinear energy operator                    | Reveal fine AM/FM features                 | Energy envelope               | Pending  |
| Cepstrum Analysis           | FFT of log spectrum (quefrency domain)                     | Pitch detection, source-filter separation  | Quefrency plot                | Pending  |
| Group Delay Functions       | Derivative of phase spectrum                               | Emphasize formants and transitions         | Delay vs frequency            | Pending  |
| Reassigned Spectrogram      | Spectrogram with localized energy redistribution           | High-res time-frequency view               | Enhanced spectrogram          | Pending  |
| EMD (Empirical Mode Decomposition) | Adaptive mode decomposition                         | Nonlinear signal decomposition             | IMF plots                     | Pending  |
| Wigner–Ville Distribution   | Quadratic time-frequency representation                    | Rich joint analysis                        | Time-frequency map            | Pending  |
| Gammatonegram               | Human auditory-based filterbank                            | Better perceptual features                 | Gammatonegram                 | Pending  |
| Synchrosqueezing Transform  | Refined time-frequency transformation                      | Spectral energy concentration              | High-res time-freq plot       | Pending  |
| Tonnetz Features            | Harmonic interval mapping in tonal space                  | Chord and emotion analysis                 | Tonnetz graph                 | Pending  |
| Modulation Spectrum         | Spectrum of envelope modulation                            | Rhythm and AM pattern detection            | Modulation vs frequency plot  | Pending  |
| Recurrence Plot             | Recurring patterns in signal trajectories                  | Chaos/cycle detection                      | Recurrence matrix             | Pending  |
| Self-Similarity Matrix      | Measures internal structure similarity                     | Music segmentation, repetition detection   | Similarity matrix             | Pending  |
| Permutation Entropy         | Complexity measure via ordinal patterns                    | Quantify randomness and disorder           | Scalar or entropy curve       | Pending  |
| Spectrogram of Spectrogram  | Second-order spectro-temporal representation               | Capture long-term modulations              | 2D map                        | Pending  |

> These techniques are currently under research, validation, or awaiting implementation. We welcome contributions or feedback on their inclusion.


## Project Status

This project is actively maintained. I am currently expanding the toolbox with new diagnostic techniques, incorporating recent signal processing theories, and still refining unreleased documentations for broader usability.

Stay tuned for updates!
