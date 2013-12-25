function [] = loadIntersection(intersectionName)

global noOfLinks;
global leftTurnLinks;
global phaseSequence;
global mandatoryPhases;
global maneuvers;
global lInitial;
global phaseSets;

switch intersectionName
    case 'GreenFirst'
        noOfLinks = 4;              % Common to all datasets
        leftTurnLinks = [];
        phaseSequence = [1,2];
        mandatoryPhases = [1,2];
        maneuvers = cell(1,noOfLinks);
        maneuvers{3} = [68513,68529,68532];
        maneuvers{4} = [68524,68515,68530];
        maneuvers{1} = [68528,68522,68531];
        maneuvers{2} = [68523,68514,68533];
        lInitial{1} = [5 0 5 0];     % Initial queue lengths at each link
        lInitial{2} = [5 0 5 0];
        lInitial{3} = lInitial{2};
        phaseSets{1} = [1,2];       % Contains the indices of the links that have a green in phase 1
        phaseSets{2} = [3,4];       % Contains the indices of the links that have a green in phase 2
        
    case 'GreenFirstVisSim'
        noOfLinks = 4;              % Common to all datasets
        leftTurnLinks = [];
        phaseSequence = [1,2];
        mandatoryPhases = [1,2];
        maneuvers = cell(1,noOfLinks);
        maneuvers{1} = [1,2,3];
        maneuvers{2} = [7,8,9];
        maneuvers{3} = [4,5,6];
        maneuvers{4} = [10,11,12];
        lInitial{1} = [0 7 0 7];     % Initial queue lengths at each link
        lInitial{2} = [0 15 0 12];
        phaseSets{1} = [1,2];       % Contains the indices of the links that have a green in phase 1
        phaseSets{2} = [3,4];       % Contains the indices of the links that have a green in phase 2
    case 'SpringfieldFirst'
        noOfLinks = 8;              % Common to all datasets
        leftTurnLinks = [2,4,6,8];
        phaseSequence = [3,5,6,1,4,7,8,2];
        mandatoryPhases = [1,2];
        maneuvers = cell(1,noOfLinks);
        maneuvers{1} = [68509, 36288];
        maneuvers{2} = [68490];
        maneuvers{3} = [68482, 68491];
        maneuvers{4} = [36290];
        maneuvers{5} = [68492,68511];
        maneuvers{6} = [68483];
        maneuvers{7} = [36289, 68481];
        maneuvers{8} = [68510];
        lInitial{1} = [5 1 5 1 5 1 5 1]; % Initial queue lengths at each link
        phaseSets{1} = [1,2,3,4];       % Contains the indices of the links that have a green in phase 1
        phaseSets{2} = [5,6,7,8];       % Contains the indices of the links that have a green in phase 2
        phaseSets{3} = [2,4];           % Contains the indices of the links that have a green in phase 3
        phaseSets{4} = [6,8];           % Contains the indices of the links that have a green in phase 4
        phaseSets{5} = [1,2];           % Contains the indices of the links that have a green in phase 5
        phaseSets{6} = [3,4];           % Contains the indices of the links that have a green in phase 6
        phaseSets{7} = [5,6];           % Contains the indices of the links that have a green in phase 7
        phaseSets{8} = [7,8];           % Contains the indices of the links that have a green in phase 8
    
    case '116Broadway'
        noOfLinks = 3;              % Common to all datasets
        leftTurnLinks = [];
        phaseSequence = [1,2];
        mandatoryPhases = [1,2];
        maneuvers = cell(1,noOfLinks);
        maneuvers{1} = [8942,41124];
        maneuvers{2} = [36346,41122];
        maneuvers{3} = [8943,36348,41123];
        phaseSets{1} = [1,2];       % Contains the indices of the links that have a green in phase 1
        phaseSets{2} = [3];       % Contains the indices of the links that have a green in phase 2
        lInitial{1} = [5 5 1]; % Initial queue lengths at each link
        
    case 'StMarysFirst'
        noOfLinks = 4;
        leftTurnLinks = [];
        phaseSequence = [3,2,1,4];
        mandatoryPhases = [];
        maneuvers = cell(1,noOfLinks);
        maneuvers{1} = [1,2,3];
        maneuvers{2} = [4,5,6];
        maneuvers{3} = [7,8,9];
        maneuvers{4} = [10,11,12];
        phaseSets{1} = [1];
        phaseSets{2} = [2];
        phaseSets{3} = [3];
        phaseSets{4} = [4];
        phaseSets{5} = [];
        lInitial{1} = [5 5 5 5];
        
    otherwise
        error('Intersection not recognized. Make sure the name is spelled correctly.');        
end
