% Test function

function transformed = noaa_decode(signal, Fs)
    %{

    %}

    % Constants
    fc = 2400;  % APT subcarrier frequency
    bw = 400;   % Bandwidth
    line_duration = 0.5; % Seconds per line
    samples_per_line = round(line_duration * Fs);
    num_lines = floor(length(signal) / samples_per_line);

    % Preprocess the Signal
    signal = detrend(signal);  % Remove DC offset

    % Apply Band-Pass Filtering (Extract 2400 Hz Subcarrier)
    [b, a] = butter(5, [fc-bw, fc+bw] / (Fs/2), 'bandpass');
    filtered_signal = filtfilt(b, a, signal);

    % Demodulate the APT Signal (AM Demodulation)
    hilbert_transform = hilbert(filtered_signal);
    envelope = abs(hilbert_transform); % Extract envelope

    % Reshape Data into an Image
    % NOAA APT signals have a line sync pulse every 0.5 seconds
    image_matrix = reshape(envelope(1:num_lines * samples_per_line), samples_per_line, num_lines)';

    % Normalize Image
    transformed = rescale(image_matrix, 0, 255); 
end
