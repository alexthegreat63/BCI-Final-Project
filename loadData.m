clc
clear
close all

%% Subject 1
session = IEEGSession('I521_A0012_D001', 'shashank', 'sha_ieeglogin.bin');
sample_rate = session.data.rawChannels(1).sampleRate;
n_samples = 310000;
n_chan = 62;
sub1_ecog = session.data.getvalues(1:n_samples, 1:n_chan);

session = IEEGSession('I521_A0012_D002', 'shashank', 'sha_ieeglogin.bin');
n_chan = 5;
sub1_glove = session.data.getvalues(1:n_samples, 1:n_chan);

session = IEEGSession('I521_A0012_D003', 'shashank', 'sha_ieeglogin.bin');
n_samples = 147500;
n_chan = 62;
sub1_ecog_test = session.data.getvalues(1:n_samples, 1:n_chan);


%% Subject 2

session = IEEGSession('I521_A0013_D001', 'shashank', 'sha_ieeglogin.bin');
sample_rate = session.data.rawChannels(1).sampleRate;
n_samples = 310000;
n_chan = 48;
sub2_ecog = session.data.getvalues(1:n_samples, 1:n_chan);

session = IEEGSession('I521_A0013_D002', 'shashank', 'sha_ieeglogin.bin');
n_chan = 5;
sub2_glove = session.data.getvalues(1:n_samples, 1:n_chan);

session = IEEGSession('I521_A0013_D003', 'shashank', 'sha_ieeglogin.bin');
n_samples = 147500;
n_chan = 48;
sub2_ecog_test = session.data.getvalues(1:n_samples, 1:n_chan);


%% Subject 3

session = IEEGSession('I521_A0014_D001', 'shashank', 'sha_ieeglogin.bin');
sample_rate = session.data.rawChannels(1).sampleRate;
n_samples = 310000;
n_chan = 64;
sub3_ecog = session.data.getvalues(1:n_samples, 1:n_chan);

session = IEEGSession('I521_A0014_D002', 'shashank', 'sha_ieeglogin.bin');
n_chan = 5;
sub3_glove = session.data.getvalues(1:n_samples, 1:n_chan);

session = IEEGSession('I521_A0014_D003', 'shashank', 'sha_ieeglogin.bin');
n_samples = 147500;
n_chan = 64;
sub3_ecog_test = session.data.getvalues(1:n_samples, 1:n_chan);

save('data', 'sub1_ecog', 'sub1_ecog_test', 'sub1_glove', 'sub2_ecog', 'sub2_ecog_test', 'sub2_glove', 'sub3_ecog', 'sub3_ecog_test', 'sub3_glove')