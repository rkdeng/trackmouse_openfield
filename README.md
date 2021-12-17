# trackmouse_openfield
A simple mouse tracking code for my homemade open field apparatus... Read more about open field test in here (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4354627/)  
It detects dark pixels in the video as the mouse. So... right now, it only works for black mice running in the bright background.  
  
Developed in MATLAB2018b with INTERX function from NS (https://www.mathworks.com/matlabcentral/fileexchange/22441-curve-intersections)  
  
How to use:
1. Use vd_click1.m to manually define the open field maze in the video. This create a mask to eliminate areas outside of the open field box. Because I need to eliminate unwanted dark pixels in the video... The clicked locations will be save in a mat file. You can check the clicked locations using vd_click1_1check.m.

pic  

2. Use vd_analyze1_mousexy.m to locate mouse in every frame. Load the file from vd_click1.m. At the beginning, click 4 points to crop the video. So the code can run faster.  

pic


3. Use vd_analyze2_extractdata.m to extract data. Load the files from vd_click1.m and vd_analyze1_mousexy.m. Key parameters and mouse movement trajectories will be generated.  


pic  


How to optimize the detection?  
Ah, email me, we can talk... Don't feel like to type anymore...

