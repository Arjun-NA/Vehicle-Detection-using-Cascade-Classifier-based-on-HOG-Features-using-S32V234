function cars_detection_s32v234_camera_main(varargin)  %#codegen
    
    width = uint32(1280);
    height = uint32(720);
    
    if (nargin ~= 1 && coder.target('MATLAB'))
        error("Invalid parameters. Usage: face_detection_s32v234_camera_main('192.168.1.0')");
    end
    
    if nargin == 1
        ipAddress = varargin{:};
        s32Obj = nxpvt.s32v234(ipAddress);
        % Cleanup after Ctrl+C
        cleanupObj = onCleanup(@() destroyObj(s32Obj));
    end
    
    if coder.target('MATLAB')
        input = nxpvt.cameraboard(s32Obj, 1, 'Resolution', '720x1280');
    else
        input = nxpvt.videoinput('sony', 1, width, height, true, false);
    end
    
    newdetector = nxpvt.CascadeObjectDetector( 'ClassificationModel','carTraindata.xml', 'Width',width, 'Height',height);
    
    fNum = int32(0);
    fps = int32(0);
    while true
        nxpvt.tic;
        fNum = fNum + 1;
        
        if coder.target('MATLAB')
            frame = input.snapshot();
        else
            frame = input.getsnapshot();
        end
        frame = nxpvt.cv.rgb2gray(frame);
        % Get cars.
        [bbox, l] = step(newdetector, frame);
        
        nxpvt.cv.rectangle(frame, bbox, [255, 0 ,0], 5);

        nxpvt.imshow(frame);
        
        fps = int32(fix(1/nxpvt.toc));
        fprintf('[%d] FPS: %d, cars detected: %d, \n', fNum, fps, int32(l));
    end
end
function destroyObj(s32Obj)
    % Send Ctrl + C to the board
    s32Obj.disconnect();
end