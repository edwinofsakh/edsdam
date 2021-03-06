function out = viewProps( sid, rid, region, ebsd, tasks, varargin ) %#ok<INUSL>
% Draw maps and histogram for properties in the list
%
% Syntax
%   out = viewProps( sid, rid, region, ebsd, tasks, varargin )
%
% Output
%   out - not used
%
% Input
%   sid      - sample id: 's01', 's02', 's03', 's04', 't01', 'p01', 'p02'
%   rid      - region id
%   region   - region coordinate
%   ebsd     - EBSD (all phases) data if 0, try load useing function "[sid '_load']"
%   tasks    - list of tasks
%
% Tasks
%   'properties' - (param) list of properties
% 
% History
% 01.12.12  Add description of the function.
%           Add 'PropertyList' suppot.
% 14.04.13  Add saveing of comment.
% 26.03.14  New input system. 'THRD', 'MGS', 'EPSD' - from 'varargin'.
% 05.04.14  New output system.
% 18.06.15  Fix error. Add region id for histogram file prefix.
% 17.08.15  Makeup. Write wiki. Add parameters. Add titles.

out = {};

saveres = getpref('ebsdam','saveResult');

plist = get_option(tasks, 'properties', {'IQ', 'CI', 'MAD', 'BC', 'SEM', 'Fit'});

for i = 1:length(plist)
    pname = plist{i};
    if ( any(cellfun(@(x) strcmpi(x, pname), get(ebsd))))
        viewSingleProp(sid, rid, ebsd, pname, saveres);
    end
end
end


function viewSingleProp( sid, rid, ebsd, prop, saveres )
% Draw property maps and histogram
%
% Input
%   sid     - sample id: 's01', 's02', 's03', 's04' , 't01'
%   rid     - region id
%   ebsd    - EBSD data if 0, try load useing function "[sid '_load']"
%   prop    - name of property
%   saveres - save image to disk

if (~ischar(prop))
	error('Property must be characters');
end

OutDir = checkDir(sid, 'prop', saveres);

ebsd = checkEBSD(sid, ebsd, 'Fe');

comment = getComment();

% % Plot property
% figure();
% plot(ebsd, 'property',prop);
% colorbar;
% saveimg( saveres, 1, OutDir, sid, [rid '_map_' prop], 'png', comment );

% Plot property in grayscale
figure();
plot(ebsd, 'property',prop);
colormap(gray);
colorbar;
title(['Property ''' prop '''']);
saveimg( saveres, 1, OutDir, sid, [rid '_map_' prop '_gray'], 'png', comment );

% Plot property in grayscale without axes
figure();
plot(ebsd, 'property',prop); axis off;
colormap(gray);
saveimg( saveres, 1, OutDir, sid, [rid '_map_' prop '_gray_f'], 'png', comment );

% Extract the property values
propval = get(ebsd,prop);

% Plot a property histogram
figure('Name',[upper(prop) ' histogram'],'NumberTitle','off');
[n, xout] = hist(propval);
disp(['  ' upper(prop) '   ']);
disp( num2str([xout', n']) );
bar(xout, n);
title(['Histogram for property ''' prop '''']);
saveimg( saveres, 1, OutDir, sid, [rid '_hist_' prop], 'png', comment );

end
