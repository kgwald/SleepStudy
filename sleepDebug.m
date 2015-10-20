% A script to loop through the Asimov sleep debug text files 
% and add them all to single data file. 
% Also adds a column for pID and session.

mainFolder = '/Users/beemanlab/Desktop/SleepStudy_Data_ASIMOV';
folders = dir(mainFolder);
bigTable = table();

% gets rid of the junk folders
folders(~[folders.isdir]) = [];
tf = ismember( {folders.name}, {'.', '..'});
folders(tf) = [];
% now the # of folders just includes the ones we want
numberOfFolders = length(folders);

for K = 1: numberOfFolders
    display('hello');
    
    % enter the correct folder by cd'ing into it
    thisFolder = folders(K).name;
    folderPath = [mainFolder '/' thisFolder];
    fullfileName = fullfile(folderPath);
    cd(fullfileName)
    
    % displays the current directory so that we know we're in the right one
    pwd
    files = dir('*_debug.txt');
        for file = files'
            if file.bytes > 1000
                display('in file loop')
                
                % counts the # of rows in the file
                % creates 2 new columns
                rows = height(readtable(file.name, 'ReadVariableNames', false));    
                newColumns = cell(rows, 2);              

                % changes column header names to what we want
                T = readtable(file.name, 'ReadVariableNames', false);
                T.Date = T.Var1;
                T.Sleep = T.Var2;
                T.SleepStage = T.Var3;
                T(:,{'Var1' 'Var2' 'Var3'}) = [];

                % splits the file name into 7 different parts
                split = strsplit(file.name, '_');       
                C = cellstr(split);

                newColumns(:,1) = C(3);                 % this is the ID number
                newColumns(:,2) = C(4);                 % this is the session number

                T2 = cell2table(newColumns, 'VariableNames',{'ID' 'Session'});

                % adds new columns to original table
                temp = [T T2];                          

                ds = cat(1, bigTable, temp);

                bigTable = ds;
                   
            end
        end
        cd ../
end
