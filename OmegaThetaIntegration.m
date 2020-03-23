%HW 5

%
%clear workspace
clear
close all;

%Switch Between Weighted data (W) and Non Weighted (NW)
weight = 'NW'

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
MinVal=min([dataset_length{:}])

%Match file size
for item=1:length(file_list)
     correct_size = dataset{item}(1:MinVal,1:11);
     correct_size_dataset{:,item}=correct_size;
end

%need time values
t = 0:11/1000:(MinVal-1)*11/1000;

VelocityTrial_1= zeros(1,MinVal-1);
VelocityTrial_2= zeros(1,MinVal-1);
VelocityTrial_3= zeros(1,MinVal-1);
VelocityTrial_4= zeros(1,MinVal-1);
VelocityTrial_5= zeros(1,MinVal-1);

dt = 0.011 % sec
Velocity = 0; % assume 0 start
for j=1:MinVal-1%cutting one data point
    Velocity = ((correct_size_dataset{1}(j+1,1) + correct_size_dataset{1}(j,1))/2)*dt + Velocity;
    VelocityTrial_1(j)= Velocity;
end

Velocity = 0;
for j=1:MinVal-1%cutting one data point
    Velocity = ((correct_size_dataset{2}(j+1,1) + correct_size_dataset{2}(j,1))/2)*dt + Velocity;
    VelocityTrial_2(j)= Velocity;
end

Velocity = 0;
for j=1:MinVal-1%cutting one data point
    Velocity = ((correct_size_dataset{3}(j+1,1) + correct_size_dataset{3}(j,1))/2)*dt + Velocity;
    VelocityTrial_3(j)= Velocity;
end

Velocity = 0;
for j=1:MinVal-1%cutting one data point
    Velocity = ((correct_size_dataset{4}(j+1,1) + correct_size_dataset{4}(j,1))/2)*dt + Velocity;
    VelocityTrial_4(j)= Velocity;
end

Velocity = 0;
for j=1:MinVal-1%cutting one data point
    Velocity = ((correct_size_dataset{5}(j+1,1) + correct_size_dataset{5}(j,1))/2)*dt + Velocity;
    VelocityTrial_5(j)= Velocity;
end

arm_length = 12*0.0254 %approx (12 inch*0.0254m/inch)
Omega_Cell = {VelocityTrial_1/arm_length,VelocityTrial_2/arm_length,VelocityTrial_3/arm_length,VelocityTrial_4/arm_length,VelocityTrial_5/arm_length}

t = 0:11/1000:(MinVal-2)*11/1000;%lost one more data point

ThetaTrial_1= zeros(1,MinVal-2);
ThetaTrial_2= zeros(1,MinVal-2);
ThetaTrial_3= zeros(1,MinVal-2);
ThetaTrial_4= zeros(1,MinVal-2);
ThetaTrial_5= zeros(1,MinVal-2);

Theta = 0; % assume 0 start

for j=1:MinVal-2%cutting one data point
    Theta = ((VelocityTrial_1(1,1+j) + VelocityTrial_1(1,j))/2)*dt + Theta;
    ThetaTrial_1(j)= Theta;
end

Theta = 0;

for j=1:MinVal-2%cutting one data point
    Theta = ((VelocityTrial_2(1,1+j) + VelocityTrial_2(1,j))/2)*dt + Theta;
    ThetaTrial_2(j)= Theta;
end

Theta = 0;

for j=1:MinVal-2%cutting one data point
    Theta = ((VelocityTrial_3(1,1+j) + VelocityTrial_3(1,j))/2)*dt + Theta;
    ThetaTrial_3(j)= Theta;
end

Theta = 0;

for j=1:MinVal-2%cutting one data point
    Theta = ((VelocityTrial_4(1,1+j) + VelocityTrial_4(1,j))/2)*dt + Theta;
    ThetaTrial_4(j)= Theta;
end

Theta = 0;

for j=1:MinVal-2%cutting one data point
    Theta = ((VelocityTrial_5(1,1+j) + VelocityTrial_5(1,j))/2)*dt + Theta;
    ThetaTrial_5(j)= Theta;
end

Theta_Cell = {ThetaTrial_1,ThetaTrial_2,ThetaTrial_3,ThetaTrial_4,ThetaTrial_5}

new_t = 0:11/1000:(MinVal-3)*11/1000;%lost another data point due to process

for item=1:length(Omega_Cell)
    figure
    subplot(211)
    plot(new_t,Theta_Cell{item})
    title(strcat(label," 'Theta' vs Time"))
    xlabel('Time (sec)')
    ylabel('Degrees')
    subplot(212)
    plot(t,Omega_Cell{item})
    title(strcat(label," 'Omega' vs Time"))
    xlabel('Time (sec)') 
    ylabel('Degrees/Sec')
    saveas(gcf,strcat('AnglesOmegaFromIMU',num2str(item),label,'.pdf'))
end