function getOoeyGUI(workbench)
    f = findobj(gca, 'Tag', workbench.robot.model.name);
	if isempty(f)
		f = findobj(0, 'Tag', workbench.robot.model.name);
		if isempty(f)
			workbench.robot.model.plot(zeros(1, workbench.robot.model.n));
			ax = gca;
		else
			ax = get(c(1), 'Parent');
		end
	else
	ax = gca;
	end
	
	bgcol = [167 178 196]/255;
	handles.fig = get(ax, 'Parent');
	set(ax, 'Outerposition', [0.25 0 0.7 1]);
	handles.curax = ax;
	
	%GUI panel
	panel = uipanel(handles.fig, ...
		'Title', 'ooeyGUI', ...
		'BackgroundColor', bgcol, ...
		'Position', [0.25 0, 0.15, 0.25]);
	set(panel, 'Units', 'pixels');
	handles.panel = panel;
	set(handles.fig, 'Units', 'pixels');
	set(handles.fig, 'ResizeFcn', @(src,event) resize_callback(workbench.robot.model, handles));
	
	%% gui components
	%Exit button and callback
    uicontrol(panel, 'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [0.80 0.01 0.15 0.15], ...
        'FontUnits', 'normalized', ...
        'FontSize', 0.7, ...
        'CallBack', @(src,event) quit_callback(workbench.robot.model, handles), ...
        'BackgroundColor', 'white', ...
        'ForegroundColor', 'red', ...
        'String', 'X');
	
	%Start button
	handles.start = uicontrol(panel, 'Style', 'pushbutton', ...
		'Units', 'normalized', ...
		'String', 'Start', ...
		'Position', [0.12 0.4 0.3 0.3]);
	
	%Emergency stop button
	handles.emergencyStop = uicontrol(panel, 'Style', 'pushbutton', ...
		'Units', 'normalized', ...
		'String', '<html>EMERGENCY<br />STOP</html>', ...
		'BackgroundColor', 'red', ...
		'FontSize', 9, ...
		'Position', [0.12 0.05 0.3 0.3]);
	
	%continue button
	handles.continue = uicontrol(panel, 'Style', 'pushbutton', ...
		'Units', 'normalized', ...
		'String', '<html>continue</html>', ...
		'Position', [0.47, 0.4, 0.3, 0.3]);
		
	%% Callbacks
	%darkness slider callback
	set(handles.start, ...
		'Interruptible', 'on', ...
		'Callback', @(src, event)start_callback(src, workbench, handles));
	
	set(handles.emergencyStop, ...
		'Interruptible', 'off', ...
		'Callback', @(src, event)emergencyStop_callback(src, workbench, handles));

	set(handles.continue, ...
		'Interruptible', 'off', ...
		'Callback', @(src, event)continue_callback(src, workbench, handles));
	
end

%% Callback Functions
function start_callback(src, workbench, handles)
	workbench.stopState = 0;
	workbench.runAnimation();
end

function emergencyStop_callback(src, workbench, handles)
	workbench.continueState = 0;
	workbench.stopState = 1;
end

function continue_callback(src, workbench, handles)
	workbench.stopState = 0;
	workbench.continueState = 1;
end
%callback to quit gui
function quit_callback(robot, handles)
    set(handles.fig, 'ResizeFcn', '');
    delete(handles.panel);
    set(handles.curax, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1])
end

%callback to resize
function resize_callback(handles)
   fig = gcbo;
   fs = get(fig, 'Position');
   ps = get(handles.panel, 'Position');
   set(handles.curax, 'Units', 'normalized', ...
	   'OuterPosition', [ps(3) 0 fs(3)-ps(3) fs(4)]);
   set(handles.panel, 'Position', [1 fs(4)-ps(4) ps(3:4)]);
end