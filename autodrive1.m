%brick.MoveMotor('A', 50)
%brick.StopMotor('A')
%brick.ResetMotorAngle('A')
%brick.MoveMotorAngleRel('A', speed, degrees, 'Brake')
%brick.StopAllMotors('Coast')
%brick.WaitForMotor('A')
%brick.LightReflect(3)
%red = 5 green = 3 yellow = 4 blue = 2
%brick.TouchPressed(2)
%brick.UltrasonicDist(4)
%brick.SetColorMode(3, 2);
global key
InitKeyboard();
left = 0.925;
right = 1.1;
brick.SetColorMode(3, 4);
stage = 1;
prev = 0;
dist = 1.1;
correct = 0.2;
curr = 0;
timer = 0;
buffer = 5;
leftBuffer = 8;
leftTimer = leftBuffer - 2;
while stage ~= 6 % GO UNTIL YELLOW
    if stage ~= 2 && stage ~= 4
        brick.MoveMotor('A', 50);
        brick.MoveMotor('B', 44);
        prev = curr;
        curr = brick.UltrasonicDist(4);
        color = brick.ColorRGB(3);
        timer = timer + 1;
        leftTimer = leftTimer + 1;
        % CORRECTIONS
        if prev ~= 0 && curr - prev >= dist && curr-prev < 1.5 && curr < 45 && timer > buffer
            brick.StopAllMotors('Brake');
            brick.MoveMotor('B', 50);
            pause(correct);
            brick.StopAllMotors('Brake');
            timer = 0;
        end
        if prev ~= 0 && curr - prev <= -dist && curr-prev > -1.5 && curr < 45 && timer > buffer
            brick.StopAllMotors('Brake');
            brick.MoveMotor('A', 50);
            pause(correct);
            brick.StopAllMotors('Brake');
            timer = 0;
        end
        % ULTRA-SONIC TURNING
        if curr > 45 && leftTimer > leftBuffer
            pause(0.5);
            brick.StopAllMotors('Brake');
            brick.MoveMotor('B', 50);
            pause(left);
            brick.StopAllMotors('Brake');
            leftTimer = 0;
        end
        % BUMP SENSOR TURNING
        if brick.TouchPressed(1) == 1 || brick.TouchPressed(2) == 1
            brick.StopAllMotors('Brake');
            brick.MoveMotor('AB', -50);
            pause(1.5);
            brick.StopAllMotors('Brake');
            brick.MoveMotor('A', 50);
            pause(right);
            brick.StopAllMotors('Brake');
        end
    end
    % COLOR WORK
    if color(1) > 80 && color(2) < 60 && color(3) < 60  % RED
        brick.StopAllMotors('Brake');
        pause(1); 
        brick.MoveMotor('AB', 50);
        pause(1);   
        disp("Stop Sign!");
    end
    if stage == 1 && color(3) > 100 && color(1) < 100 && color(2) < 100 % BLUE
        pause(0.5);
        brick.StopAllMotors('Brake');
        brick.beep();
        pause(1);
        brick.beep();
        pause(1);
        stage=stage+1;
        disp("s1");
    elseif stage == 3 && color(2) > 60 && color(1) < 50 && color(3) < 50 % GREEN
        pause(0.5);
        brick.StopAllMotors('Brake');
        brick.beep();
        pause(1);
        brick.beep();
        pause(1);
        brick.beep();
        pause(1);
        stage=stage+1;
        disp("s3");
    elseif stage == 5 && color(1) > 140 && color(2) > 135 && color(3) < 55 % YELLOW
        pause(1);
        stage = stage + 1;
        brick.StopAllMotors('Brake');
        brick.StopAllMotors('AB');
        disp("s5");
    end
    if stage == 2 || stage == 4
        while 1
            pause(0.1);
            brick.StopAllMotors('Coast');
            switch key
                case 'w'
                    brick.MoveMotor('A', 50);
                    brick.MoveMotor('B', 48);
        
                case 'a'
                    brick.MoveMotor('B', 50);
        
                case 's'
                    brick.MoveMotor('AB', -50);
        
                case 'd'
                    brick.MoveMotor('A', 50);
        
                case 'o'
                    brick.MoveMotor('C', 50);
        
                case 'p'
                    brick.MoveMotor('C', -50);
        
                case 'q' % Quit
                    break;
            end
        end
        stage=stage+1;
    end
end
CloseKeyboard();