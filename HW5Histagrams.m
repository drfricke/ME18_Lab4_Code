%HW 5
%clear workspace
clear
close all;

%Switch Between W and NW
weight = 'W';

if weight == 'W'
    label = 'WITH WEIGHT';
end

if weight == 'NW';
    label = 'WITHOUT WEIGHT';
end


%Get data
file_list=dir(strcat('Data_',weight,'*.csv'));

for file=1:length(file_list)
    data=load(file_list(file).name);
    dataset_length{:,file}=length(data);
    dataset{:,file}=data;
end

%smallest file?
MinVal=min([dataset_length{:}]);

%Match file size
for item=1:length(file_list)
     correct_size = dataset{item}(1:MinVal,1:11);
     correct_size_dataset{:,item}=correct_size;
end

%need time values
t = 0:11/1000:(MinVal-1)*11/1000;
dt = 0.011; %sec

%make empty arrays
temporary= zeros(1,MinVal-1);
Velocity_Rot_X_Trial_1= zeros(1,MinVal-1);
Velocity_Rot_X_Trial_2= zeros(1,MinVal-1);
Velocity_Rot_X_Trial_3= zeros(1,MinVal-1);
Velocity_Rot_X_Trial_4= zeros(1,MinVal-1);
Velocity_Rot_X_Trial_5= zeros(1,MinVal-1);
%empty cell
Velocity_X_Cell = {Velocity_Rot_X_Trial_1, Velocity_Rot_X_Trial_2, Velocity_Rot_X_Trial_3, Velocity_Rot_X_Trial_4, Velocity_Rot_X_Trial_5};

%make empty arrays
Velocity_Rot_Y_Trial_1= zeros(1,MinVal-1);
Velocity_Rot_Y_Trial_2= zeros(1,MinVal-1);
Velocity_Rot_Y_Trial_3= zeros(1,MinVal-1);
Velocity_Rot_Y_Trial_4= zeros(1,MinVal-1);
Velocity_Rot_Y_Trial_5= zeros(1,MinVal-1);
%empty cell
Velocity_Y_Cell = {Velocity_Rot_Y_Trial_1, Velocity_Rot_Y_Trial_2, Velocity_Rot_Y_Trial_3, Velocity_Rot_Y_Trial_4, Velocity_Rot_Y_Trial_5};


%filling with data X
for i=1:length(file_list)
    Velocity = 0;
    for j=1:MinVal-1%cutting one data point
        Velocity = ((correct_size_dataset{i}(j+1,5) + correct_size_dataset{i}(j,5))/2)*dt + Velocity;
        temporary(j)= Velocity;
    end
    Velocity_X_Cell{i} = temporary;
end

%filling with data Y
for i=1:length(file_list)
    Velocity = 0;
    for j=1:MinVal-1%cutting one data point
        Velocity = ((correct_size_dataset{i}(j+1,6) + correct_size_dataset{i}(j,6))/2)*dt + Velocity;
        temporary(j)= Velocity;
    end
    Velocity_Y_Cell{i} = temporary;
end

%need to adjust t for the loss of one data point
new_t = 0:11/1000:(MinVal-2)*11/1000;


%plotting the results
for item=1:length(file_list)
    figure(item)% new figure for viewablilty
    subplot(211)
    %data needs reshaping done in DDD0
    DDD0 = [reshape(Velocity_X_Cell{item},MinVal-1,1) correct_size_dataset{item}(1:(MinVal-1),5)];
    nbins = 20;
    drange1 = [-1e1, -.5e6];
    drange2 = [+1e1, +.5e6];
    Hista_data = histcount2(DDD0,nbins,drange1,drange2);
    surf(Hista_data.X,Hista_data.Y,Hista_data.Z)
    title(strcat(label,"  Acc x vs. Velocity x"))
    xlabel('Velocity x (Degrees/sec)') 
    ylabel('Acc x (Degree/sec^2')
    view(3)
    caxis([0 20]) %simpifies the histogram a bit
    colormap(jet) %changes color scheme
    subplot(212) %Finds the spot
    DDD0 = [reshape(Velocity_Y_Cell{item},MinVal-1,1) correct_size_dataset{item}(1:(MinVal-1),6)];
    nbins = 20;
    drange1 = [-1e1, -.5e6];
    drange2 = [+1e1, +.5e6];
    Hista_data = histcount2(DDD0,nbins,drange1,drange2);
    surf(Hista_data.X,Hista_data.Y,Hista_data.Z) %plots the data
    title(strcat(label,"  Acc y vs. Velocity y"))
    xlabel('Velocity y (Degrees/sec)') 
    ylabel('Acc y (Degree/sec^2')
    view(3) %allows rotation
    caxis([0 20]) %simpifies the histogram a bit
    colormap(jet) %changes color scheme
    saveas(gcf,strcat('Trial ',num2str(item),label,'.pdf'))
end



%If acc and velocity is desired for comparsion
%compare 1 to 6, 2 to 7, 3 to 8....

% for item=1:length(file_list)
%     figure(item+5)
%     subplot(2,2,1)
%     plot(t,correct_size_dataset{item}(:,5),'r')
%     title("Acc x vs Time")
%     xlabel('Time (sec)') 
%     ylabel('Degrees/sec^2')
%     subplot(2,2,2)
%     plot(t,correct_size_dataset{item}(:,6),'r')
%     title("Acc y vs Time")
%     xlabel('Time (sec)') 
%     ylabel('Degrees/sec^2')
%     subplot(2,2,3)
%     plot(new_t,Velocity_X_Cell{item},'b')
%     title("Velocity x vs Time")
%     xlabel('Time (sec)') 
%     ylabel('Degrees/sec')
%     subplot(2,2,4)
%     plot(new_t,Velocity_Y_Cell{item},'b')
%     title("Velocity y vs Time")
%     xlabel('Time (sec)') 
%     ylabel('Degrees/sec')
% end

