
switch intersectionName
    
    case 'GreenFirst';
        filenames{1} = 'TT_FirstAndGreen1.xls';
        filenames{2} = 'TT_FirstAndGreen_ZeroFlow.xls';
        filenames{3} = 'TT_FirstAndGreen2a.xls';
        observedPhases{1} =     [1,2,...
                                 1,2,1,2,1,2,1,2,1,2,1,2];
        observedPhases{2} =     [1,2,1,2,1,2,...
                                 1,2,1,2,1,2,1,2,1,2];
        observedPhases{3} = observedPhases{2}; 
        %observedPhases{1} =     [1,2,1,2,1,2,1,2,1,2,...
        %                         1,2,1,2,1,2,1,2,1,2];

    case 'GreenFirstVisSim'    
        %filenames{1} = 'delayVisSim.xls';
        %observedPhases{1} =     [1,2,1,2,1,2,1,2,1,2];
        filenames{1} = 'convexVisSim_new2.xls';
        filenames{2} = 'convexVisSim_new.xls';
        observedPhases{1} =     [1,2,1,2,1,2,1,2,1,2,...
                                1,2,1,2];
        observedPhases{2} = observedPhases{1};
        observedPhases{3} = observedPhases{1};
        
    
    case '116Broadway';
        filenames{1} = '116th&Broadway.xls';
        observedPhases{1} = [   1,2,1,2,1,2,1,2,1,2,...
                                1,2,1,2,1,2,1,2,1,2,...
                                1,2,1,2,1,2,1,2,1,2,...
                                1,2,1,2,1,2,1,2,1,2,...
                                1,2,1,2,1,2,1,2,1,2,...
                                1,2,1,2,1,2,1,2,1,2,...
                                1,2,1,2,1,2,1,2         ];
        %filenames{1} = '116th&Broadway-Short.xls';
        %observedPhases{1} =     [1,2,1,2,1,2,1,2,...
        %                         1,2,1,2,1,2,1,2,1,2];
        

    case 'SpringfieldFirst';
        filenames{1} = 'Springfield&First.xls';
        observedPhases{1} = [1,2,1,7,2,5,1,8,2,1,2,1,7,2,5,1,8,2,5,1,2,1,4,2,5,1,7,2,1,2,1,7,2];
        %filenames{1} = 'Springfield&First - Truncated.xls';
        %observedPhases{1} = [1,2,1,7,2,5,1,8,2,1,2,1,7,2,5,1,8,2,5,1,2];
        %filenames{1} = 'Springfield&First - TruncatedShort.xls';
        %observedPhases{1} = [1,2,1,7,2,5,1,8,2];
        %observedPhases{1} = [1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,...
        %                   1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2];
        

    case 'StMarysFirst';
        filenames{1} = 'StMarysProcessed.xls';
        observedPhases{1} = [3,2,1,4,3,2,1,4,3,2,1];
        
    
    otherwise
        error('intersectionName not found or undefined.');
        
end