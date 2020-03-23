%HW 5

%This code finds theta and angular velocity from the pot readings

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
MinVal=min([dataset_length{:}]);

%Match file size
for item=1:length(file_list)
     correct_size = dataset{item}(1:MinVal,1:11);
     correct_size_dataset{:,item}=correct_size;
end

%need time values
t = 0:11/1000:(MinVal-1)*11/1000;

DeltaThetaTrial_1= zeros(1,MinVal-1);
DeltaThetaTrial_2= zeros(1,MinVal-1);
DeltaThetaTrial_3= zeros(1,MinVal-1);
DeltaThetaTrial_4= zeros(1,MinVal-1);
DeltaThetaTrial_5= zeros(1,MinVal-1);


for j=1:MinVal-1%cutting one data point
    deltaTheta = correct_size_dataset{1}(j+1,7) - correct_size_dataset{1}(j,7);
    DeltaThetaTrial_1(j)= deltaTheta;
end

for j=1:MinVal-1%cutting one data point
    deltaTheta = correct_size_dataset{2}(j+1,7) - correct_size_dataset{2}(j,7);
    DeltaThetaTrial_2(j)= deltaTheta;
end

for j=1:MinVal-1%cutting one data point
    deltaTheta = correct_size_dataset{3}(j+1,7) - correct_size_dataset{3}(j,7);
    DeltaThetaTrial_3(j)= deltaTheta;
end

for j=1:MinVal-1%cutting one data point
    deltaTheta = correct_size_dataset{4}(j+1,7) - correct_size_dataset{4}(j,7);
    DeltaThetaTrial_4(j)= deltaTheta;
end

for j=1:MinVal-1%cutting one data point
    deltaTheta = correct_size_dataset{5}(j+1,7) - correct_size_dataset{5}(j,7);
    DeltaThetaTrial_5(j)= deltaTheta/0.011;
end


Delta_Theta_Cell= {DeltaThetaTrial_1,DeltaThetaTrial_2,DeltaThetaTrial_3,DeltaThetaTrial_4,DeltaThetaTrial_5};

new_t = 0:11/1000:(length(t)-2)*11/1000;

for item=1:length(file_list)
    figure
    subplot(211)
    plot(t,correct_size_dataset{item}(:,7),'b')
    title("'Theta2' vs Time")
    xlabel('Time (sec)') 
    ylabel('Degrees')
    subplot(212)
    plot(new_t,Delta_Theta_Cell{item}(1,:),'r') %same figure diff subplots
    title("'Theta2' Angular Velocity vs Time")
    xlabel('Time (sec)') 
    ylabel('Degrees/Sec')
    saveas(gcf,strcat('AnglesOmegaFromPot',num2str(item),label,'.pdf'))
end

%Notes dataset 1 looks best.
%data also seems to lag for first ~samples. This must be the interval,
%when Robert said go. My delay was ~0.75 seconds.



