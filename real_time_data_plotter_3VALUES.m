%%real time data plot from a serial port
% Original script written by Moidu thavot.

%%Clear all variables
clc;
clear all;
close all;

if isempty(instrfind) == 0
    fclose(instrfind); % Close com ports
    delete(instrfind); % Clear com ports
end

%%Variables (Edit yourself)

SerialPort='com6'; %serial port
TimeInterval=0;%time interval between each input.
loop=inf;%count values
yMIN = -100;
yMAX = 100;
xWIDTH = 200;
%%Set up the serial port object
s = serial(SerialPort, 'BaudRate', 115200); % setup comport
fopen(s);

time = now;
y1 = 0;
y2 = 0;
y3 = 0;
%% Set up the figure
figureHandle = figure('NumberTitle','off',...
    'Name','Acceleration Plots',...
    'Color',[0 0 0],'Visible','off');

% Set axes
axesHandle = axes('Parent',figureHandle,...
    'YGrid','on',...
    'YColor',[0.9725 0.9725 0.9725],...
    'XGrid','on',...
    'XColor',[0.9725 0.9725 0.9725],...
    'Color',[0 0 0]);

hold on;

plotHandle1 = plot(axesHandle,time,y1,'LineWidth',1,'Color',[1 0 0]);
plotHandle2 = plot(axesHandle,time,y2,'LineWidth',1,'Color',[0 1 0]);
plotHandle3 = plot(axesHandle,time,y3,'LineWidth',1,'Color',[0 0 1]);

%xlim(axesHandle,[min(time) max(time+0.001)]);
%ylim([yMIN yMAX]);

% Create xlabel
xlabel('Time','FontWeight','bold','FontSize',14,'Color',[1 1 0]);

% Create ylabel
ylabel('Acceleration Values','FontWeight','bold','FontSize',14,'Color',[1 1 0]);

% Create title
title('Real Time Data','FontSize',15,'Color',[1 1 0]);

%% Initializing variables

y1(1)=0;
y2(1)=0;
y3(1)=0;
time(1)=0;
count = 2;
while ~isequal(count,loop)
    
    u = fscanf(s, '%f %f %f');
    y1(count) = u(1);
    y2(count) = u(2);
    y3(count) = u(3);
    
    time(count) = count;
    
    xlim([max(time-xWIDTH) max(time)]);
    
    set(plotHandle1,'YData',y1,'XData',time);
    set(plotHandle2,'YData',y2,'XData',time);
    set(plotHandle3,'YData',y3,'XData',time);
    set(figureHandle,'Visible','on');
    datetick('x','mm/DD HH:MM');
    
    pause(TimeInterval);
    count = count +1;
end

%% Clean up the serial port
fclose(s);
delete(s);
clear s;