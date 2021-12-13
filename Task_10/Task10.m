%% Transforms (15p)
% Each part of the Task can be run separately, by running respective sections.
%% Part 1
clc; clear all; close all;

% 1. Reading input image
A = imread('cameraman.tif');        
figure(1); 
imshow(A); 
title('Camerman picture');

% 2. Edge Map using Canny method
EdgeMap = edge(A,'Canny');          
figure(2); 
imshow(EdgeMap); 
title('Camerman picture - Canny edge map');

% 3. & 4. Hough transform accumalor array + Plot
[H,theta,rho] = hough(EdgeMap);     
figure(3); 
imshow(imadjust(rescale(H)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta (degrees)'); 
ylabel('\rho'); 
title('Accumulator array');
axis on; 
axis normal; 
colormap(gca,hot);

% 5. & 6. Thresholding the image and finding local maxima
P_max_coords = houghpeaks(H);
% Strongest local maxima:
P_max = H(P_max_coords(1),P_max_coords(2)); 
Threshold = P_max * 0.9;    %With this threshold - 5 maxima remain
H_temp = H(:); 
%sort(H_temp);
% Removing H values below the threshold:
H_temp(H_temp < Threshold) = 0;            
%sort(H_temp);

% 7. Accumulator array with the five strongest maxima points marked    
figure(4); 
imshow(imadjust(rescale(H)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta (degrees)'); 
ylabel('\rho'); 
title('Accumulator array - 5 strongest local maxima marked')
axis on; 
axis normal; 
colormap(gca,hot);
hold on
colormap(gca,hot)
% Coordinates of 5 strongest local maxima points:
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:)))); 
x = theta(P(:,2)); 
y = rho(P(:,1)); 
plot(x,y,'s','LineWidth',5,'color','green');


% 8. Original image with the strongest line overlaided
line = houghlines(EdgeMap,theta,rho,P_max_coords,'FillGap',2); 
figure(5);
imshow(A);
title('Longest line superimposed');
hold on
xy = [line.point1; line.point2];
plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
hold off

% 'myhoughline' function with exemplary input
rho = 5;
theta = 30;
myhoughline(A, rho, theta)

%% Part 2
clc; clear all; close all;

image = imread('cameraman.tif'); 
[acc_arr, theta, rho] = myhough(image)
%% Part 3
clc; clear all; close all;

% Input image
A = zeros(500,500); 

% 1. Hough transform with 1 white pixel
A1 = A; 
A1(200,300) = 255; 
[H1,theta1,rho1] = hough(A1);

% 2.Hough transform with 3 white pixels: non-aligned
A2 = A; 
A2(200,300) = 255; A2(300,220) = 255; A2(455,400) = 255;
[H2,theta2,rho2] = hough(A2);  

% 3. Hough transform with 3 white pixels: aligned
A3 = A; 
A3(200,300) = 255; A3(200,400) = 255; A3(200,200) = 255;
[H3,theta3,rho3] = hough(A3); 

% 5. & 6. Houghpeaks (loc. max.) + Houglines: 3 aligned pixels
P3 = houghpeaks(H3); %[508 1]
x3 = theta3(P3(:,2)); y3 = rho3(P3(:,1));
line3 = houghlines(logical(A3),theta3,rho3,P3,'FillGap',200,'MinLength',2);
xy3 = [line3.point1; line3.point2];

% Figures:
figure(1); 
subplot(2,3,1); 
imshow(A); 
title('Input Image: 1 white pixel');

subplot(2,3,4); 
imshow(imadjust(rescale(H1)),[],'XData',theta1,'YData',rho1,'InitialMagnification','fit');
xlabel('\theta (degrees)'); 
ylabel('\rho'); 
title('Hough space: 1 white pixel');
axis on; 
axis normal;

subplot(2,3,2);  
imshow(A2); 
title('Input Image: 3 non-aligned white pixels');

subplot(2,3,5);
imshow(imadjust(rescale(H2)),[],'XData',theta2,'YData',rho2,'InitialMagnification','fit');
xlabel('\theta (degrees)'); 
ylabel('\rho'); 
title('Hough space: 3 non-aligned white pixels');
axis on; 
axis normal;

subplot(2,3,3);
imshow(A3); 
title('Input Image: 3 aligned white pixels');

subplot(2,3,6);
imshow(imadjust(rescale(H3)),[],'XData',theta3,'YData',rho3,'InitialMagnification','fit');
xlabel('\theta (degrees)'); 
ylabel('\rho'); 
title('Hough space: 3 aligned white pixels');
axis on; 
axis normal;

figure(2);
subplot(2,2,1);
imshow(A3);
title('Input Image: 3 white pixels');

subplot(2,2,3);
imshow(A3); 
title('Input Image: 3 white pixels + overlaid line ');
hold on;
plot(xy3(:,1),xy3(:,2),'LineWidth',5,'Color','green');

subplot(2,2,[2,4]);
imshow(imadjust(rescale(H3)),[],'XData',theta3,'YData',rho3,'InitialMagnification','fit');
xlabel('\theta (degrees)'); 
ylabel('\rho'); 
title('Hough space: 3 aligned white pixels')
axis on; 
axis normal; 
hold on
plot(x3,y3,'s','LineWidth',5,'color','green');
%% Part 4
clc; clear all; close all;

% 1. Reading input image
A = im2double(imread('HeadTool0002.bmp'));
figure(1);
imshow(A);
title('Input Image');

% 2. Contrast-limited adaptive histogram equalization
A2= adapthisteq(A);
figure(2);
imshow(A2);
title('Input Image with contrast-limited adaptive histogram equalization');

% 3. Finding circles: finding at least 6 circles
figure(3);
imshow(A2);
hold on
title('Enhanced image with 6 circles overlaid');
[centers, radii] = imfindcircles(A2,[20 40],'Sensitivity', 0.9);
centersStrong6 = centers(1:6,:); 
radiiStrong6 = radii(1:6);

% 4. Finding circles: cirles visualized
viscircles(centersStrong6, radiiStrong6,'EdgeColor','b');

% 5. Finding circles: 2 strongest cirles visualized
figure(4);
imshow(A2);
hold on
title('Enhanced image with the 2 strongest circles overlaid');
[centers2, radii2] = imfindcircles(A2,[20 40],'Sensitivity', 0.875);
viscircles(centers2, radii2,'EdgeColor','b');