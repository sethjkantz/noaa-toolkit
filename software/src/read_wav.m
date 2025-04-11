function [data, freq, success] = read_wav()
%{
 Function that will let you navigate to and open up a given wave file
 Returns data, frequency of wav file, and True or False (success)
%}
    data = [];
    freq = 0;
    success = false;


    [filename, pathname] = uigetfile({'*.wav', 'Wav Files';'*.*', 'All Files'}, 'Select a File');
    if filename ~= 0
        fullpath = fullfile(pathname, filename);
        disp(['Selected file: ', fullpath]);
        [data, freq] = audioread(fullpath);
        success = true;
    else
        disp('No file selected.');
    end   
    % todo only use stereo?
end