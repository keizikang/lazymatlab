clear
close all
clc

Fs = 4000;      % 4k is maybe enough...?
dT = 1/Fs;      % time inverval
bpm = 142;      % original bpm
t16 = 60/bpm/4; % duration of 16th note
lvl = 0.2;      % sound level, 0.2 is fine.

freq_table = get_freq_table();

len_tt16 = round(t16/dT);
tt16 = linspace(0, t16, len_tt16);
tt8 = linspace(0, t16*2, len_tt16*2);

[intro, treb, bass] = nyan_cat();

nyancat_intr = vertcat(intro{:});
nyancat_treb = vertcat(treb{:});
nyancat_bass = vertcat(bass{:});

y_intro = [];
for i=1:size(nyancat_intr, 1)
    hz = freq_table{nyancat_intr(i, 1), nyancat_intr(i, 2)};
    switch nyancat_intr(i, 3)
        case "8"
            y_intro = [y_intro lvl*sin(tt8*2*pi*hz)];
        case "16"
            y_intro = [y_intro lvl*sin(tt16*2*pi*hz)];
        otherwise
            error('not implemented yet')
    end
end

y_treb = [];
for i=1:size(nyancat_treb, 1)
    hz = freq_table{nyancat_treb(i, 1), nyancat_treb(i, 2)};
    switch nyancat_treb(i, 3)
        case "8"
            y_treb = [y_treb lvl*sin(tt8*2*pi*hz)];
        case "16"
            y_treb = [y_treb lvl*sin(tt16*2*pi*hz)];
        otherwise
            error('not implemented yet')
    end
end

y_bass = [];
for i=1:size(nyancat_bass, 1)
    hz = freq_table{nyancat_bass(i, 1), nyancat_bass(i, 2)};
    switch nyancat_bass(i, 3)
        case "8"
            y_bass = [y_bass lvl*sin(tt8*2*pi*hz)];
        case "16"
            y_bass = [y_bass lvl*sin(tt16*2*pi*hz)];
        otherwise
            error('not implemented yet')
    end
end

y = y_treb + y_bass;
y = [y_intro y];

player = audioplayer(y, Fs);
play(player)



function freq_table = get_freq_table()
% frequency table
% rows = C, C# D, D#, ... A#, B
% cols = octaves, center at 5th
%
% ref: https://cosmosproject.tistory.com/255

freq_table = [
    16.35 	32.70 	65.41 	130.81 	261.63 	523.25 	1046.50 	2093.00 	4186.01
    17.32 	34.65 	69.30 	138.59 	277.18 	554.37 	1108.73 	2217.46 	4434.92
    18.35 	36.71 	73.42 	146.83 	293.66 	587.33 	1174.66 	2349.32 	4698.64
    19.45 	38.89 	77.78 	155.56 	311.13 	622.25 	1244.51 	2489.02 	4978.03
    20.60 	41.20 	82.41 	164.81 	329.63 	659.26 	1318.51 	2637.02 	5274.04
    21.83 	43.65 	87.31 	174.61 	349.23 	698.46 	1396.91 	2793.83 	5587.65
    23.12 	46.25 	92.50 	185.00 	369.99 	739.99 	1479.98 	2959.96 	5919.91
    24.50 	49.00 	98.00 	196.00 	392.00 	783.99 	1567.98 	3135.96 	6271.93
    25.96 	51.91 	103.83 	207.65 	415.30 	830.61 	1661.22 	3322.44 	6644.88
    27.50 	55.00 	110.00 	220.00 	440.00 	880.00 	1760.00 	3520.00 	7040.00
    29.14 	58.27 	116.54 	233.08 	466.16 	932.33 	1864.66 	3729.31 	7458.62
    30.87 	61.74 	123.47 	246.94 	493.88 	987.77 	1975.53 	3951.07 	7902.13
    ];

freq_table = array2table(freq_table, ...
    'RowNames', {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'}, ...
    'VariableNames', {'-4', '-3', '-2', '-1', '0', '+1', '+2', '+3', '+4'});

end

function [intro, treb, bass] = nyan_cat()
% nyan cat piano sheet: https://musescore.com/user/30297723/scores/6427079
intro{1} = [
    "D#","+1","16"
    "E","+1","16"
    "F#","+1","8"
    "B","+1","8"
    "D#","+1","16"
    "E","+1","16"
    "F#","+1","16"
    "B","+1","16"
    "C#","+2","16"
    "D#","+2","16"
    "C#","+2","16"
    "A#","+1","16"
    "B","+1","16"
    "D#","+2","16"];

intro{2} = [
    "F#","+1","8"
    "D#","+1","16"
    "E","+1","16"
    "F#","+1","8"
    "B","+1","8"
    "C#","+2","16"
    "A#","+1","16"
    "B","+1","16"
    "C#","+2","16"
    "E","+2","16"
    "D#","+2","16"
    "E","+2","16"
    "C#","+2","16"
    ];

treb{1} = [
    "F#","+1","8"
    "G#","+1","8"
    "C#","+1","16"
    "D#","+1","8"
    "B","0","16"
    "D","+1","16"
    "C#","+1","16"
    "B","0","8"
    "B","0","8"
    "C#","+1","8"
    ];

treb{2} = [
    "D","+1","8"
    "D","+1","16"
    "C#","+1","16"
    "B","0","16"
    "C#","+1","16"
    "D#","+1","16"
    "F#","+1","16"
    "G#","+1","16"
    "D#","+1","16"
    "F#","+1","16"
    "C#","+1","16"
    "D","+1","16"
    "B","0","16"
    "C#","+1","16"
    "B","0","16"
    ];

treb{3} = [
    "D#","+1","8"
    "F#","+1","8"
    "G#","+1","16"
    "D#","+1","16"
    "F#","+1","16"
    "C#","+1","16"
    "D#","+1","16"
    "B","0","16"
    "D","+1","16"
    "D#","+1","16"
    "D","+1","16"
    "C#","+1","16"
    "B","0","16"
    "C#","+1","16"
    ];

treb{4} = [
    "D","+1","8"
    "B","0","16"
    "C#","+1","16"
    "D#","+1","16"
    "F#","+1","16"
    "C#","+1","16"
    "D","+1","16"
    "C#","+1","16"
    "B","0","16"
    "C#","+1","8"
    "B","0","8"
    "C#","+1","8"
    ];

bass{1} = [
    "E","-1","8"
    "E","0","8"
    "F#","-1","8"
    "F#","0","8"
    "D#","-1","8"
    "D#","0","8"
    "G#","-1","8"
    "G#","0","8"
    ];

bass{2} = [
    "C#","-1","8"
    "C#","0","8"
    "F#","-1","8"
    "F#","0","8"
    "B","-2","8"
    "B","-1","8"
    "D#","-1","8"
    "D#","0","8"
    ];

bass{3} = bass{1};
bass{4} = bass{2};
bass{4}(7:8,:) = bass{4}(5:6,:);
bass{5} = bass{1};
bass{6} = bass{2};
bass{7} = bass{3};
bass{8} = bass{4};

% repeat of first part, except the very last note
treb{5} = treb{1};
treb{6} = treb{2};
treb{7} = treb{3};
treb{8} = treb{4};
treb{8}(end,:) = treb{8}(end-1,:);

% new sequences
treb{9} = [
    "B","0","8"
    "F#","0","16"
    "G#","0","16"
    "B","0","8"
    "F#","0","16"
    "G#","0","16"
    "B","0","16"
    "C#","+1","16"
    "D#","+1","16"
    "B","0","16"
    "E","+1","16"
    "D#","+1","16"
    "E","+1","16"
    "F#","+1","16"
    ];

treb{10} = [
    "B","0","8"
    "B","0","8"
    "F#","0","16"
    "G#","0","16"
    "B","0","16"
    "F#","0","16"
    "E","+1","16"
    "D#","+1","16"
    "C#","+1","16"
    "B","0","16"
    "F#","0","16"
    "D#","0","16"
    "E","0","16"
    "F#","0","16"
    ];

treb{11} = [
    "B","0","8"
    "F#","0","16"
    "G#","0","16"
    "B","0","8"
    "F#","0","16"
    "G#","0","16"
    "B","0","16"
    "B","0","16"
    "C#","+1","16"
    "D#","+1","16"
    "B","0","16"
    "F#","0","16"
    "G#","0","16"
    "B","0","16"
    ];

treb{12} = [
    "B","0","8"
    "B","0","16"
    "A#","0","16"
    "B","0","16"
    "F#","0","16"
    "G#","0","16"
    "B","0","16"
    "E","+1","16"
    "D#","+1","16"
    "E","+1","16"
    "F#","+1","16"
    "B","0","8"
    "A#","0","8"
    ];

treb{13} = treb{9};
treb{14} = treb{10};
treb{15} = treb{11};
treb{16} = treb{12};
treb{16}(end,:) = ["C#","+1","8"];

bass{9} = bass{5};
bass{10} = bass{6};
bass{11} = bass{7};
bass{12} = bass{8};
bass{13} = bass{5};
bass{14} = bass{6};
bass{15} = bass{7};
bass{16} = bass{8};

end