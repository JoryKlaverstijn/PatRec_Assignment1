%% Parameters range
%theta: [-90:1:90] --> [-pi/2:1:pi/2]
%rho:   [-diagonal:1:diagonal] --> [height/width*sgrt(2)] (assuming square picture)

%% Function 
function [acc_arr, theta, rho] = myhough(image)

image = edge(image,'Canny'); 

%Check the size of the built-in function
[H,theta_default,rho_default] = hough(image);  

% Define parameter rho range
rhoSize = nearest(size(image,1) * sqrt(2));
shift = rhoSize +1;

% Initialize and prelocate output matrices
theta = [-90:1:90];
rho = [-rhoSize:1:rhoSize];
acc_arr = zeros(size(rho,2),size(theta,2));


% Identification of edge pixels
for r = 1:size(image,1)
    for c = 1:size(image,2)
        if isequal(image(r,c),1)
            
            % Accumulator array
             for theta_idx = 1:size(theta,2)
               rho_val = c*cos(deg2rad(theta(theta_idx))) + r*sin(deg2rad(theta(theta_idx)));
               rho_val = round(rho_val);
               
               % Rho values into idx
               rho_idx = find(rho == rho_val);
               
               % Increment the accumulator base on index pairs
               acc_arr(rho_idx,theta_idx) = acc_arr(rho_idx,theta_idx) + 1; 
               
             end               
        end
    end
end

% Comparison with the built-in function
figure(1); 
subplot(1,2,1);
imshow(imadjust(rescale(H)),[],'XData',theta_default,'YData',rho_default,'InitialMagnification','fit');
xlabel('\theta (degrees)'); 
ylabel('\rho'); 
title('Accumulator array - Matlab function')
axis on; 
axis normal; 
colormap(gca,hot)

subplot(1,2,2);
imshow(imadjust(rescale(acc_arr)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta (degrees)'); 
ylabel('\rho'); 
title('Accumulator array - myhoough function')
axis on; 
axis normal; 
colormap(gca,hot)

end



