function [audio_clip,Fs,ch,T]=read_file()
[Name, folder] = uigetfile('*.wav;*.mp3;*.ogg');
filename = fullfile(folder, Name);
clear sound;
[audio_clip,Fs] = audioread(filename);
Clip_info=audioinfo(filename);
ch=Clip_info.NumChannels;
T=Clip_info.TotalSamples;
end

