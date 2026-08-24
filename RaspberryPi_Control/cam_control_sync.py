import picamera
import sys
if sys.version_info[0]==3:
    import tkinter as tk
    from tkinter import ttk

else:
    import Tkinter as tk
    import ttk
import time
from PIL import ImageTk, Image
from threading import Thread, Condition
import io
import sys
import os

camera = picamera.PiCamera()

RQS_0=0
RQS_COLOR=1
RQS_PREVIEW=2   #stop preview

RQS_CAPTURE=3   #image capture
RQS_CAPTURE_STACK=4   #stack image capture

RQS_VID_ON=5    #video start record
RQS_VID_OFF=6   #video stop record

RQS_SYNC_PUSH=7    #video start record
RQS_SYNC_PULL=8   #video stop record

RQS_QUIT=9
def camHandler():
    global rqs,mode_val,pix_res
    rqs = RQS_0
    mode_val = 0
    pix_res = (640,480)
    

    #stream = io.BytesIO()

    #set default
    camera.sharpness = 0
    camera.contrast = 0
    camera.brightness = 50
    camera.saturation = 0
    camera.ISO = 0
    camera.video_stabilization = False
    camera.exposure_compensation = 0
    camera.exposure_mode = 'auto'
    camera.meter_mode = 'average'
    camera.awb_mode = 'auto'
    camera.image_effect = 'none'
    camera.color_effects = None
    camera.rotation = 0
    #camera.rotation = 270
    camera.hflip = False
    camera.vflip = False
    camera.crop = (0.0, 0.0, 1.0, 1.0)
    camera.sensor_mode = 0
    camera.resolution = (640,480)
    camera.framerate = 25
    
    #time_s = 5
    #time_min = 0
    #end of set default
    
    res_preview = (640,480)
    res_max = (2592,1944)
    fps_preview = 25
    color_on = 1
    prev_on = 0

    while rqs != RQS_QUIT:
        if rqs == RQS_SYNC_PUSH:
            os.system('rclone sync -i ~/cam_space/ PolyScope-sync:PolyScope-sync')
            rqs = 0
            labelCapVal.set('Sync-Uploaded')
        elif rqs == RQS_SYNC_PULL:
            os.system('rclone sync -i PolyScope-sync:PolyScope-sync  ~/cam_space/')
            rqs = 0
            labelCapVal.set('Sync-Downloaded')
            
        elif rqs == RQS_COLOR:
            if color_on == 1:
               color_on = 0
               camera.color_effects = (128,128)
               rqs = 0
               labelCapVal.set('Mono Mode')
               
            elif color_on == 0:
                 color_on = 1
                 camera.color_effects = None
                 rqs = 0
                 labelCapVal.set('Color Mode')
              
        elif rqs == RQS_PREVIEW:
            if prev_on == 0:
                prev_on = 1
                camera.start_preview(alpha=240)
                #camera.sensor_mode = 7
                camera.resolution = res_preview
                
                camera.framerate = fps_preview
                rqs=0
                labelCapVal.set('Preview On')
            elif prev_on == 1:
                 prev_on = 0
                 camera.stop_preview()
                 rqs=0
                 labelCapVal.set('Preview Off')
            
            
        elif rqs == RQS_CAPTURE:
            print("Capture single")            
            timeStamp = time.strftime("%Y%m%d-%H%M%S")
            pngFile='img_'+timeStamp+'.png'
            #camera.sensor_mode=mode_val
            camera.resolution = pix_res
            
            camera.capture(pngFile,format='png')#,resize=pix_res,sensor_mode=mode_val)
            labelCapVal.set('Captured')
            #camera.sensor_mode = 7
            camera.resolution = res_preview
            rqs=0
            
            
        elif rqs == RQS_CAPTURE_STACK:
            #camera.stop_preview()
            print("Capture stack")
            time_s = scaleSeconds.get()
            time_min = scaleMinutes.get()
            #camera.sensor_mode = mode_val            
            camera.resolution = pix_res
            timeStamp = time.strftime("%Y%m%d-%H%M%S")
            os.mkdir(timeStamp)
            folder = str(timeStamp)            
            print('Create folder:' + folder)
            img_count = 1
            interval = time_min*60+time_s
            time_len = []
            start = time.time()            
            while True:
                pngFile='img_'+str(img_count)+'.png'
                camera.start_preview()
                camera.capture(folder+'/'+pngFile,format='png')#,resize=pix_res,sensor_mode=mode_val)
                now = time.time()
                camera.stop_preview()
                time_len.append(now-start)                
                img_count+=1
                labelCapVal.set(pngFile)
                time.sleep(interval)
                if rqs == RQS_VID_OFF:
                    break
            with open(folder+"/Log.txt", "w") as output:
                output.write(str(time_len))
                    
            rqs=0
            #camera.sensor_mode = 7
            camera.resolution = res_preview
            

        elif rqs == RQS_VID_ON:
            print("Record")
            time_s = scaleSeconds.get()
            time_min = scaleMinutes.get()            
            frt_fps = scaleFps.get()
            timeStamp = time.strftime("%Y%m%d-%H%M%S")
            os.mkdir(timeStamp)
            folder = str(timeStamp)
            print('Create folder:' + folder)
            vid_count = 1
            
            camera.sensor_mode = mode_val
            camera.resolution = pix_res  
            
            if pix_res!=res_max:
                camera.start_preview(alpha=240)
            else:camera.stop_preview()
            
            camera.framerate = frt_fps
            time_len = []            
            start = time.time()
            while True:            
                h264File='vid_'+str(vid_count)+'.h264'          
                camera.start_recording(folder+'/'+h264File, format='h264', quality=23)
                camera.wait_recording(time_min*60+time_s)
                now = time.time()
                time_len.append(now-start)
                camera.stop_recording()     #record videos of 5s until turned off.
                vid_count += 1
                labelCapVal.set('Recording vid'+str(vid_count))
                
                if rqs == RQS_CAPTURE:
                    rqs=RQS_VID_ON
                    timeStamp = time.strftime("%Y%m%d-%H%M%S")
                    pngFile=folder+'/'+'img_'+timeStamp+'.png'
                    camera.capture(pngFile)
                
                elif rqs == RQS_VID_OFF:
                    break
            with open(folder+"/Log.txt", "w") as output:
                output.write(str(time_len))
            rqs=0
            camera.stop_preview
            #camera.sensor_mode = 7
            camera.resolution = res_preview         
            camera.framerate = fps_preview
            labelCapVal.set('Record off')

    
def startCamHandler():
    camThread = Thread(target=camHandler)
    camThread.start()

def preview():
    global rqs
    rqs=RQS_PREVIEW
    labelCapVal.set("Preview ON/OFF")
    
def color():
    global rqs 
    rqs=RQS_COLOR
    labelCapVal.set("Color/Mono")

def quit():
    global rqs
    rqs=RQS_QUIT

    global tkTop
    tkTop.destroy()
    
    exit()

def capture():
    global rqs
    rqs = RQS_CAPTURE
    labelCapVal.set("capturing...")
    
def capture_stack():
    global rqs
    rqs = RQS_CAPTURE_STACK
    labelCapVal.set("stack capturing...")
    
def v_on():
    global rqs
    rqs = RQS_VID_ON
    labelCapVal.set("recording...")

def v_off():
    global rqs
    rqs = RQS_VID_OFF
    labelCapVal.set("Loop killed")
    
def sync_push():
    global rqs
    rqs = RQS_SYNC_PUSH
    labelCapVal.set("Sync Uploading")
    
def sync_pull():
    global rqs
    rqs = RQS_SYNC_PULL
    labelCapVal.set("Sync Downloading")

#Create window panel
tkTop = tk.Tk()
tkTop.wm_title("PolyScpe Camera")
tkTop.geometry('240x400')
tkTop.configure(bg='white')
tkTop.wm_attributes('-topmost',1)

#Create tabs
tabControl = ttk.Notebook(tkTop)
tab1 = tk.Frame(tabControl,bg='white')
tabControl.add(tab1,text = 'Actions')
tab2 = tk.Frame(tabControl,bg='white')
tabControl.add(tab2,text = 'Settings')
#tabControl.configure(bg='white')
tabControl.pack(expand=1,fill="both")

#Tab1: action buttons
tkButtonPreview = tk.Button(
    tab1, text="Color/Mono", bg = 'blue', command=color)
tkButtonPreview.grid(column=0,row=0,sticky='n',rowspan=1)

tkButtonPreviewOff = tk.Button(
    tab1, text=" Preview_ON/OFF", bg = 'green',command=preview)
tkButtonPreviewOff.grid(column=0,row=1,sticky='n',rowspan=1)

tkButtonCapture = tk.Button(
    tab1, text="Capture_single", bg = 'green',command=capture)
tkButtonCapture.grid(column=0,row=2,sticky='N',rowspan=1)

tkButtonCaptureStack = tk.Button(
    tab1, text="Capture_stack", bg = 'green',command=capture_stack)
tkButtonCaptureStack.grid(column=0,row=3,sticky='N',rowspan=1)

tkButtonVidOn = tk.Button(
    tab1, text="Vid_ON", bg = 'green',command=v_on)
tkButtonVidOn.grid(column=0,row=4,sticky='n',rowspan=1)

tkButtonVidOff = tk.Button(
    tab1, text="Kill_loop", bg = 'yellow',command=v_off)
tkButtonVidOff.grid(column=0,row=5,sticky='n',rowspan=1)

tkButtonVidOff = tk.Button(
    tab1, text="Sync_push", bg = 'blue',command=sync_push)
tkButtonVidOff.grid(column=0,row=6,sticky='n',rowspan=1)

tkButtonVidOff = tk.Button(
    tab1, text="Sync_pull", bg = 'blue',command=sync_pull)
tkButtonVidOff.grid(column=0,row=7,sticky='n',rowspan=1)

tkButtonQuit = tk.Button(
    tab1, text="Quit", bg = 'red',command=quit)
tkButtonQuit.grid(column=0,row=8,sticky='n',rowspan=1)

# Display action
labelCapVal = tk.StringVar()
tk.Label(tab1, textvariable=labelCapVal).grid(column=0,row=9,rowspan=1)

#Tab2: Settings
SCALE_WIDTH = 200;

group_1 = tk.LabelFrame(tab2,text="Select unit video length:",padx=5,pady=5,bg='white')
group_1.grid(padx=1,pady=1)

scaleSeconds = tk.Scale(
    group_1,
    from_=0, to=59,
    length=SCALE_WIDTH/2,
    orient=tk.HORIZONTAL,
    label="sec",bg='white')
scaleSeconds.set(5)
scaleSeconds.grid(column=1,row=0,sticky='n')

scaleMinutes = tk.Scale(
    group_1,
    from_=0, to=59,
    length=SCALE_WIDTH/2,
    orient=tk.HORIZONTAL,
    label="min",bg='white')
scaleMinutes.set(0)
scaleMinutes.grid(column=0,row=0,sticky='n')

group_2 = tk.LabelFrame(tab2,text="Select Frame Rate:",padx=5,pady=5,bg='white')
group_2.grid(padx=1,pady=11)

scaleFps = tk.Scale(
    group_2,
    from_=5, to=150,
    length=SCALE_WIDTH,
    orient=tk.HORIZONTAL,
    label="FPS",bg='white')
scaleFps.set(25)
scaleFps.grid(column=0,row=0,sticky='n')

group = tk.LabelFrame(tab2,text="Select Resolution:",padx=5,pady=5)
group.grid(padx=1,pady=1)
RES=[
    ('480P',0),
    ('730P',1),
    ('1080P',2),
    ('Max',3)]

'''
def resCall():
    res_val = v.get()
    global pix_res
    if res_val ==0: pix_res = (640,480)
    elif res_val ==1: pix_res = (1280,720)
    elif res_val ==2: pix_res = (1920,1080)
    elif res_val ==3: pix_res = (2592,1944)
'''  

def resCall():
    res_val = v.get()
    global pix_res, mode_val
    if res_val ==0:
        pix_res = (640,480)
        mode_val = 7 #480p
    elif res_val ==1:
        pix_res = (1296,730)
        mode_val = 5#730p
    elif res_val ==2:
        pix_res = (1920,1080)
        mode_val = 1#1080p
    elif res_val ==3:
        pix_res = (2592,1944)
        mode_val = 2#max res

v = tk.IntVar()
v.set(0)
for long,num in RES:
    res_button = tk.Radiobutton(group,text=long,variable=v,value=num,command=resCall)
    res_button.pack(side=tk.TOP)


'''

scaleSharpness = tk.Scale(
    tkTop,
    from_=-100, to=100,
    length=SCALE_WIDTH,
    orient=tk.HORIZONTAL,
    label="sharpness")
scaleSharpness.set(0)
scaleSharpness.pack(anchor=tk.CENTER)

scaleContrast = tk.Scale(
    tkTop,
    from_=-100, to=100,
    length=SCALE_WIDTH,
    orient=tk.HORIZONTAL,
    label="contrast")
scaleContrast.set(0)
scaleContrast.pack(anchor=tk.CENTER)

scalebrightness = tk.Scale(
    tkTop,
    from_=0, to=100,
    length=SCALE_WIDTH,
    orient=tk.HORIZONTAL,
    label="brightness")
scalebrightness.set(50)
scalebrightness.pack(anchor=tk.CENTER)

scaleSaturation = tk.Scale(
    tkTop,
    from_=-100, to=100,
    length=SCALE_WIDTH,
    orient=tk.HORIZONTAL,
    label="saturation")
scaleSaturation.set(0)
scaleSaturation.pack(anchor=tk.CENTER)

scaleExpCompensation = tk.Scale(
    tkTop,
    from_=-25, to=25,
    length=SCALE_WIDTH,
    orient=tk.HORIZONTAL,
    label="exposure_compensation")
scaleExpCompensation.set(0)
scaleExpCompensation.pack(anchor=tk.CENTER)
'''
print("start")
startCamHandler()

tk.mainloop()