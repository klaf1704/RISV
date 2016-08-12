Matlab Toolbox: Reference Impairment System for Video (RISV)
===
Written by Falk Schiffner M.Sc. (Technische Universität Berlin, Germany) <br />
Collaborator: Gabriel Lucas Sobral de Araujo (artifical Edge Busyness) <br />
This toolbox is tested with MATLAB R2015a (64-bit) on a Window 7 machine.
- - -

This toolbox allows to create video impairments to video input files according to the [ITU-T P.930 Rec]( https://www.itu.int/rec/T-REC-P.930-199608-I/en )

- - -
List of impairment types:
+ artifical Blockiness    => 'block' => insert block artefacts into the 
                                         image
+ artifical Blurring      => 'blurr' => blurring filter to reduce the 
                                         sharpness of the image
+ artifical Edge Busyness => 'edgeB' => creates flickering effects on edges in the video
+ artifical Noise (quant) => 'noiseQ'=> simulated Salt'n'Pepper Noise
+ artifical Jerkiness     => 'jerki' => insert "stop'n'go" / jerki motion
                                         in the video file
- - - 		
Note: You can process all your files accordingly to the ITU-T-REC-P.930, but there are some additional adjustments to created even more impairments, such as more intense blurring or heterogeneous block artefacts. (See descriptions for more details!)

- - - 										 
All impairments can be further specified. For more details, please have a closer look into the descriptions of the functions.
       
+  The toolbox is build to process one impairment at one time. If you want to include a second impairment to one file, you need to rerun the toolbox and set the parameter and 	paths accordingly.

+  The naming of the outputfile ist set as followed:
      The name of the source file is kept and the impairment with it's "degree" is add. The reason behind that is, that you can see the processing steps directly in the file name.
      e.g.: source file: testfile.avi , 1st impairment: edgeB -10, 2nd impairment jerki 6 --> output filename: testfile_edgeB-10_jerki6.avi
        
+ The source files need to be avi-files 
+ There is NO support for audio, since only video is regarded
+ The output files are stored as motion-jpeg in an avi container 
+ The output files has NO audio
+ To insert audio you need e.g. ffmpeg <br />
    ==> there is an example ("mergeAV_ffmpeg_Host.m" and "mergeAV_ffmpeg.m")
        of merging the impaired video with the audio of the source file, but this is not part of the toolbox, since ffmpeg needs to be setup separately but can be run out of MATLAB.
- - -

<h3> LIST OF FILES </h3>
<h4> Main functions for the RISV </h4>

1. HOST_RISV_Processing.m ==> Host script to start from. In that script you need to define the path to the source files. Furthermore you choose which impairment you want to process and define the "degree" of the impairment. The selection of the impairment type goes via the command line. You will be ask to define the "degree" of the impairment. 

2. artificalBlockiness.m ==> This function creates block artefacts into the image. You can decide how big your blocks should be (e.g. 8 for 8x8 pixel block or 5 for 5x5 pixel blocks a.s.o). You can further decide, if the impairment should be homogeneous over the whole video as described in the ITU Rec. or you can choose the amount of blocks in a single frame and the amount of frames you want to randomly impaired. Both values are given in percent of the blocks in a frame or number of frames.
+ e.g. (homogeneous) testfile_blocki_5_framesimp_100_blocksimp_100.avi --> 5x5 pixel blocks, 100% of all frames impaired, 100% of all blocks in a single image impaired
+ e.g. (heterogeneous) testfile_blocki_20_framesimp_35_blocksimp_30.avi --> 20x20 pixel blocks, 35% of all frames impaired, 30% of all blocks in a single image impaired

3. artificalBlurring.m ==>
4. artificalEdgeBusynee.m ==>
5. artificalJerkiness.m ==>
6. artificalQuantNoise.m ==>
7. Blurring_rowColumnsMovAveage.m ==>
8. convertRGBtoYCBCR_frame.m ==>
9. convertYCBCRtoRGB_frame.m ==>
10. readVideoInput.m ==>
- - -
<h4> Additional functions: </h4>
<p> Impairment of the Luminance and example for merging Audio with Video </p>
11. HOST_LuminanzImpairment.m ==>
12. luminanz_impairment.m ==>
13. mergeAV_ffmpeg_Host.m ==>
14. mergeAV_ffmpeg.m ==>
- - -
<h4> Short description of the additional GUI: </h4>
12. RISV.m ==>





































