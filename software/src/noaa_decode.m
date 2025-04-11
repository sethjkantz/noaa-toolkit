% Test function

function [transformed, raw, offset] = noaa_decode(signal, Fs)
    %{

    %}

    % Constants
    fc = 2400;  % APT subcarrier frequency
    bw = 400;   % Bandwidth
    thresh = 200;
    line_duration = 0.5; % Seconds per line
    samples_per_line = round(line_duration * Fs);
    num_lines = floor(length(signal) / samples_per_line);
    num_consec = 50;

    % Preprocess the Signal
    signal = detrend(signal);  % Remove DC offset

    % Apply Band-Pass Filtering (Extract 2400 Hz Subcarrier)
    [b, a] = butter(5, [fc-bw, fc+bw] / (Fs/2), 'bandpass');
    filtered_signal = filtfilt(b, a, signal);

    % Demodulate the APT Signal (AM Demodulation)
    hilbert_transform = hilbert(filtered_signal);
    envelope = abs(hilbert_transform); % Extract envelope

    new_test = rescale(envelope,0,255);

    % Reshape Data into an Image
    % NOAA APT signals have a line sync pulse every 0.5 seconds
    num_lines = floor(length(new_test) / samples_per_line);

    shaped = reshape(new_test(1:num_lines * samples_per_line), samples_per_line, num_lines)';
    offset_vals = [];
    raw_img = shaped;
    for i = 1:size(shaped,1)
        swap_loc = 1;
        consecutive = 0;
        cur_row = shaped(i,:);
        for j = 1:size(cur_row,2)
            if cur_row(j) > thresh
                consecutive = consecutive + 1;
            else
                consecutive = 0;
            end
            if consecutive > num_consec
                swap_loc = j - num_consec;
                break
            end
        end
        %if swap_loc < 5000
        %    swap_loc = 1%6501
        %end
        offset_vals = [offset_vals swap_loc];
        temp = cur_row(1:swap_loc);
        temp_rear = cur_row(swap_loc+1:end);
        %cur_row(1:swap_loc) = cur_row(swap_loc+1:end);
        %cur_row(n+1:end) = temp;    
        shaped(i,:) = [temp_rear temp];
    end


    transformed = shaped;
    raw = raw_img;
    offset = offset_vals;
    %image_matrix = reshape(envelope(1:num_lines * samples_per_line), samples_per_line, num_lines)';

    % Normalize Image
    %transformed = rescale(image_matrix, 0, 255); 
end
