# My Diploma Thesis on Emotion Recognition from EEG-signals

This repo contains all the coding part related to the work I have done for my Diploma thesis 
during the last year of my undergraduate studies at the Electrical and Computer Engineering department
of National Technical University of Athens (NTUA).

The whole code is in Matlab and there will be a small description of the functionality of each script 
in every .m file.

This project consists of the 3 following phases:

## Phase 1: Feature Extraction

The features that were extracted fall into the following categories:
  - time domain features (Signal Statistics, Hjorth Features, Non-Stationary Index, Higher Order Crossings)
  - frequency domain features (STFT, Higher Order Spectra)
  - time-freqequency domain features (Hilbert-Huang Spectrum, Discrete Wavelet Transform)
  - electrodes combinations features (Rational && Differential Assymetry)

## Phase 2: Feature Selection

5 discete Selection methods were used:

  - ReliefF
  - Cohen's f^2
  - minimum Redundancy Maximum Relevance
  - Fast Correlation Based Filter
  - infinite Feature Selection

## Phase 3: Classification

4 discrete classifiers and 1 type of neural network were used for the Classification part:
  - QDA
  - KNN
  - SVM
  - Random Forest
  - Deep Belief Network
