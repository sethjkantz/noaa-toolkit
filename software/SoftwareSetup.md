# Software 

This folder will contain all of the software necessary for running and receiving the noaa signals.  The files are located in src/ and an example usage can be found in main.mlx

## noaa_decode.m
This file takes in a noaa transmissions data and frequency.  It will then return a normalized image (weighted 0-255) as a 2d array, ready for graphing or further analysis.

## read_wav.m
This file will open file explorer, allowing you to navigate to the desired .wav file.  It will then return three values in an array form [signal, freq, success], where signal is the stream from the wav file, freq is the frequency, and success is the validity of the data (if False, the system was unable to open the file and the data should not be used for futher computations).
