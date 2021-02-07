function cars_detection_camera_main()  %#codegen
    
    width = uint32(1280);
    height = uint32(720);
    
    if coder.target('MATLAB')
        input = nxpvt.videoinput('winvideo', 1, width, height);
    else
        input = nxpvt.videoinput('sony', 1, width, height, true, false);
    end
    
    newdetector = nxpvt.CascadeObjectDetector( 'ClassificationModel','carTraindata.xml', 'Width',width, 'Height',height);
    
    fNum = int32(0);
    fps = int32(0);
    while true
        nxpvt.tic;
        fNum = fNum + 1;
        
        frame = input.getsnapshot();

        frame = nxpvt.cv.rgb2gray(frame);
        % Get cars.
        [bbox, l] = step(newdetector, frame);
        
        nxpvt.cv.rectangle(frame, bbox, [255, 0 ,0], 5);

        nxpvt.imshow(frame);
        
        fps = int32(fix(1/nxpvt.toc));
        fprintf('[%d] FPS: %d, cars detected: %d, \n', fNum, fps, int32(l));
    end
end
