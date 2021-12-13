function myhoughline(img, rho, theta)

    % Retrieving the size of the image
    height = size(img,1);
    width = size(img,2);

    % Defining the line
    x = -size(img,2):size(img,2);
    y = (rho - x* cos(theta) )/ sin(theta); 
    
    % Plotting
    figure;
    imshow(img);
    title(['myhoughline function: \rho = ', num2str(rho),'  \theta = ', num2str(theta)]);
    hold on
    axis on
    %(creating a plane to visualize lines out of bounds)
    axis([-size(img,2) size(img,2) -size(img,2) size(img,2)]); 
    xline(0);
    yline(0);
    plot(0,0,'ko','LineWidth',2,'MarkerSize',5);
    
    if theta == 0 || theta == 180 || theta == -180
       disp('Vertical line case...')
       xline(rho,'color','r','LineWidth',2);
    else
       disp('Non-vertical line case...')
       plot(x,y,'color','r','LineWidth',2);
    end


end
