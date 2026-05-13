clc,clear all,close all;

%we use degree and mm, so may need trans to rad when in calculation

%define point
now_0513=[3500;0;0;];

%create axis in space(you can also try this to get point evenly in a sphere:
%https://stackoverflow.com/questions/9600801/evenly-distributing-n-points-on-a-sphere/26127012#26127012)
omega=[];
my_theta=0.5;
step=0.01;

for x=0:step:my_theta
    max_y=sqrt(max(0, my_theta^2 - x^2));

    for y=0:step:max_y
        temp = my_theta^2 - x^2 - y^2;
        if abs(temp) < 1e-12
            temp = 0;
        end
        z = sqrt(temp);

        omega=[omega; x,y,z];
    end
end

num=size(omega,1);
for i=1:num

    v=omega(i,:).*pi/180;
    norm_v=norm(v);
    k=v/norm_v;
    theta=my_theta*pi/180;
    I=eye(3);
    K=[0,-k(1,3),k(1,2);k(1,3),0,-k(1,1);-k(1,2),k(1,1),0;];
    rot=I+K.*sin(theta)+K*K.*(1-cos(theta));

    now_0513t=rot*now_0513;
    dis_now_0513=get_dis(now_0513,now_0513t);
    now_dis(i,:)=dis_now_0513;

    ttt=0;%for debug
end

figure;
hold on;grid on;
plot(omega);
xlabel('data number');
ylabel('/°');
title('omega');

figure;
hold on;grid on;
plot(now_dis);
max___=max(now_dis(:,1));
disp(max___);

function [dis]=get_dis(point1,point2)
    t1=point1(1,1)-point2(1,1);
    t2=point1(2,1)-point2(2,1);
    t3=point1(3,1)-point2(3,1);
    dis=sqrt(t1*t1+t2*t2+t3*t3);
end

function [theta]=get_angle(line1,line2)
    dpd=dot(line1,line2);
    norm1=norm(line1);
    norm2=norm(line2);
    cos_theta=dpd/(norm1*norm2);
    cos_theta=min(max(cos_theta,-1),1);
    theta=acos(cos_theta);
    theta=theta*180/pi;
end

function [angle]=get_angle_i(line1,line2)

    cnt=dot(line1,line2);

    angle=acos(cnt);

end