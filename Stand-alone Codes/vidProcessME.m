clc;
clear all;
%71015test2.mp4 has roi=[110 160 120 40]
%71315test.mp4 has roi=[140 150 120 40]
%7152015test.mp4 has roi=[50 110 280 80]
%2_trial#0_Wind#3_Freq#40_Amp#70_Flexion#1_Mod.mp4 has roi=[68.5 133.5 524 112];
%3_trial#0_Wind#3_Freq#40_Amp#70_Flexion#1_Mod.mp4 has roi=[5.5 134.5 632 123];
vidTest=VideoReader('2_trial#0_Wind#3_Freq#40_Amp#70_Flexion#1_Mod.mp4'); %matlab will read the vid file and assign to vidTest

vidHeight = vidTest.Height;
vidWidth = vidTest.Width;

frames=read(vidTest); %create array "frames" that contains frames of video
nFrames=size(frames,4); %4th dimension contains frame indices, so the size is the # of frames

%imaqmontage(frames); %shows all frames in a large picture

firstFrame=frames(:,:,:,100); %call the first frame
%imcrop(firstFrame)

roi=[68.5 133.5 524 112]; %region of interest (roi), where [xmin ymin width height]
frameRegion=imcrop(firstFrame,roi); %crop frame to roi
regions = repmat(uint8(0), [size(frameRegion) nFrames]); %pre-allocate a new array of frames
for count = 1:nFrames, %this loop takes every frame of the original video and crops it to roi
    regions(:,:,:,count) = imcrop(frames(:,:,:,count), roi);
    imshow(regions(:,:,:,count));
end


greenThresh = 0.05; % Threshold for green detection

xCropSize=size(frameRegion,1);
yCropSize=size(frameRegion,2);

filt=zeros(xCropSize,yCropSize,nFrames); %pre-allocating a matrix of zeros
for count=1:nFrames
    processFrame=regions(:,:,2,count); %picks particular frame, "2" refers to green
    grayFrame=rgb2gray((regions(:,:,:,count))); %creates grayscale version of frame
    step1=imsubtract(processFrame,grayFrame); % Get green component of the image
    %imshow(green(:,:,count));
    %pause(0.05)
    step2=medfilt2(step1, [3 3]); % Filter out the noise by using median filter
    %imshow(green(:,:,count));
    %pause(0.05)
    filt(:,:,count)=im2bw(step2, greenThresh); % Convert the image into binary image with the green objects as white
    imshow(filt(:,:,count));
end

%Remove any blank frames due to filtering problems

%this loop goes through each frame and determines if it is blank or not
%if a frame is solid black, all the values in the frame's array will be 0
%find(filt(:,:,count)) will return a matrix of nonzero indices
%size(ditto,1) gives the number of non zero indices of each frame
%if this size is 0, that means the frame is solid black
%blankOrNot contains an integer or a zero for every frame

blankOrNot=zeros(count,1); %pre-allocating an array
for count=1:nFrames
    blankOrNot(count,1)=size((find(filt(:,:,count))),1);
end

%zeroLocations finds which frames have 0 in the blankOrNot array
zeroLocations=find(blankOrNot==0);
filt(:,:,zeroLocations)=[]; %this line removes any frames which are blank
nFrames=size(filt,3); %if any frames are deleted, the number of frames must be corrected



centroids=zeros(nFrames,2);
structDisk=strel('disk',3);

% Calculate the pendulum centers.
pendCenters=zeros(nFrames,2);
for count = 1:1:nFrames
    property = regionprops(filt(:, :, count), 'centroid');    
    pendCenters(count,:) = property.Centroid;
end

% Display the pendulum centers and adjust the plot.
figure;
x = pendCenters(:, 1);
y = pendCenters(:, 2);
plot(x, y, 'm.');
axis ij;
axis equal;
hold on;
xlabel('x');
ylabel('y');
title('Pendulum Centers');

% Solve the equation.
abc = [x y ones(length(x),1)] \ [-(x.^2 + y.^2)];
a = abc(1);
b = abc(2);
c = abc(3);
xc = -a/2;
yc = -b/2;
circleRadius = sqrt((xc^2 + yc^2) - c);

% Superimpose results onto the pendulum centers
circle_theta = pi/3:0.01:pi*2/3;
x_fit = circleRadius*cos(circle_theta) + xc;
y_fit = circleRadius*sin(circle_theta) + yc;
% titleStr = sprintf('Pendulum Length = %d pixels', circleRadius);
% text(xc-150, yc+100, titleStr);
xMin=min(x);
xMax=max(x);
y_Min=yc+(circleRadius^2-(xMin-xc)^2)^0.5;
y_Max=yc+(circleRadius^2-(xMax-xc)^2)^0.5;
axis('equal')
plot(x_fit, y_fit, 'b-');
plot(xc, yc, 'go','LineWidth', 2);
plot(xMin,y_Min,'go','LineWidth', 2);
plot(xMax,y_Max,'go','LineWidth', 2);
plot([xc xMax], [yc y_Max], 'r-');
plot([xc xMin], [yc y_Min], 'r-');
xx=[xMin xMax];
yy=[y_Min y_Max];
segLength=((xMax-xMin)^2+(y_Max-y_Min)^2)^0.5;

pk2pkAmp=acos((2*circleRadius^2-segLength^2)/(2*circleRadius^2))*180/pi

%}