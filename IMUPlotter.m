fclose(instrfind);
delete(instrfind);
close all;
k = 35;
mode=1;
s = serial('/dev/ttyACM0');
%fclose(s);
set(s,'Databits',8);
set(s,'Stopbits',1);
set(s,'Baudrate',115200);
set(s,'Parity','none');
fopen(s);
pause(1);%wait for communication to start
if(mode)
    line1 = line(nan, nan, 'color', 'red');
    line2 = line(nan, nan, 'color', 'blue');
    line3 = line(nan, nan, 'color', 'green');
    legend('YAW','PITCH','ROLL');
    xlabel('Time(s)');
    ylabel('Angles(degrees)');
    i = 0;
    check = 0;
end
initial = fgets(s);
while(check == 0)
    if(length(initial) == 9)
        initial
        if(initial(1:8) == '$GETEU,*')
           check = 1;
        end
    end
    if(check == 0)
        initial = fgets(s);
    end
end
if(mode)
    while 1
        data = fgets(s);
        C = strsplit(data, ',');
        if(length(C) == 5)
            D = cell2mat(C(1,5));
            D = D(1);       
            if(cell2mat(C(1,1)) == '$' && D == '*')
                yaw = str2double(C(1,2));
                pitch = str2double(C(1,3));
                roll = str2double(C(1,4));
                %pause(0.1);
                C
                x1 = get(line1, 'xData');
                y1 = get(line1, 'yData');
                x2 = get(line2, 'xData');
                y2 = get(line2, 'yData');
                x3 = get(line3, 'xData');
                y3 = get(line3, 'yData');

    %             x1 = [x1 i];
    %             y1 = [y1 yaw];
    %             x2 = [x2 i];
    %             y2 = [y2 pitch];
    %             x3 = [x3 i];
    %             y3 = [y3 roll];

                if(length(x1) > k && length(y1) > k)
                    x1 = [x1((length(x1)-k):length(x1)) i];
                    y1 = [y1((length(y1)-k):length(y1)) yaw];
                else
                    x1 = [x1 i];
                    y1 = [y1 yaw]; 
                end

                if(length(x2) > k && length(y2) > k)
                    x2 = [x2((length(x2)-k):length(x2)) i];
                    y2 = [y2((length(y2)-k):length(y2)) pitch];
                else
                    x2 = [x2 i];
                    y2 = [y2 pitch]; 
                end

                if(length(x3) > k && length(y3) > k)
                    x3 = [x3((length(x3)-k):length(x3)) i];
                    y3 = [y3((length(y3)-k):length(y3)) roll];
                else
                    x3 = [x3 i];
                    y3 = [y3 roll]; 
                end

                set(line1, 'xData', x1, 'yData', y1);
                set(line2, 'xData', x2, 'yData', y2);
                set(line3, 'xData', x3, 'yData', y3);
                drawnow();
                i = i + 0.1;
                %if(i > 2)
                %    i2 = i2 + 0.1;
                %end
                %pause(0.05);
            end
        end
    end
end
if(~mode)
    while 1
        data = fgets(s);
        C = strsplit(data, ',');
        if(length(C) == 5)
            D = cell2mat(C(1,5));
            D = D(1);       
            if(cell2mat(C(1,1)) == '$' && D == '*')
                yaw = str2double(C(1,2));
                pitch = str2double(C(1,3));
                roll = str2double(C(1,4));
                %pause(0.1);
                C

                if(length(x1) > k && length(y1) > k)
                    x1 = [x1((length(x1)-k):length(x1)) i];
                    y1 = [y1((length(y1)-k):length(y1)) yaw];
                else
                    x1 = [x1 i];
                    y1 = [y1 yaw]; 
                end

                if(length(x2) > k && length(y2) > k)
                    x2 = [x2((length(x2)-k):length(x2)) i];
                    y2 = [y2((length(y2)-k):length(y2)) pitch];
                else
                    x2 = [x2 i];
                    y2 = [y2 pitch]; 
                end

                if(length(x3) > k && length(y3) > k)
                    x3 = [x3((length(x3)-k):length(x3)) i];
                    y3 = [y3((length(y3)-k):length(y3)) roll];
                else
                    x3 = [x3 i];
                    y3 = [y3 roll]; 
                end

                set(line1, 'xData', x1, 'yData', y1);
                set(line2, 'xData', x2, 'yData', y2);
                set(line3, 'xData', x3, 'yData', y3);
                subplot(1,3,1);
                polarplot(x1,y1);
                subplot(1,3,2);
                polarplot(x2,y2);
                subplot(1,3,3);
                polarplot(x3,y3);
                drawnow();
                i = i + 0.1;
                %if(i > 2)
                %    i2 = i2 + 0.1;
                %end
                %pause(0.05);
            end
        end
    end
    
end
