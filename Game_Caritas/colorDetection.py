import cv2
import argparse
import numpy as np
import socket
import struct

def traceCircle(frame, mask):
	# find contours in the mask and initialize the current
	# (x, y) center of the ball
	cnts = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL,
		cv2.CHAIN_APPROX_SIMPLE)[-2]

	# only proceed if at least one contour was found
	if len(cnts) > 0:
		# find the largest contour in the mask, then use
		# it to compute the minimum enclosing circle
		c = max(cnts, key=cv2.contourArea)
		((x, y), radius) = cv2.minEnclosingCircle(c)


		# only proceed if the radius meets a minimum size
		if radius > 10:
			# draw the circle on the frame
			cv2.circle(frame, (int(x), int(y)), int(radius),
				(0, 255, 255), 2)


sok = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

kernel = np.ones((8 ,8), np.uint8)
data1 = (float(0), float(0),float(0), float(0), float(0), float(0))
#data2 = (float(0), float(0),float(0), float(0), float(0), float(0))
video = cv2.VideoCapture(0)

while True:
    _, frame = video.read()

    hsv_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    #RED COLOR ---------------------------------------------------------------------------
    lower_red=np.array([150, 200,  50])
    upper_red=np.array([250, 255, 255])
    mask_red = cv2.inRange(hsv_frame, lower_red, upper_red)
    mask_red = cv2.erode(mask_red , None, iterations=5)
    mask_red = cv2.dilate(mask_red, None, iterations=5)
    traceCircle(frame, mask_red)
    red = cv2.bitwise_and(frame,frame, mask= mask_red)

    #BLU COLOR ----------------------------------------------------------------------------
    lower_blu = np.array([90, 100, 100])
    upper_blu = np.array([150, 255, 255])
    mask_blu = cv2.inRange(hsv_frame, lower_blu, upper_blu)
    mask_blu = cv2.erode(mask_blu , None, iterations=5)
    mask_blu = cv2.dilate(mask_blu, None, iterations=5)
    traceCircle(frame, mask_blu)
    blu = cv2.bitwise_and(frame, frame, mask=mask_blu)


    opening1 = cv2.morphologyEx(mask_red, cv2.MORPH_OPEN, kernel)
    opening2 = cv2.morphologyEx(mask_blu, cv2.MORPH_OPEN, kernel)
    x, y, w, h = cv2.boundingRect(opening1)
    x1, y1, w1, h1 = cv2.boundingRect(opening2)

    #print("Red", x, ",", y )
    print("Blue", x1, ",", y1)
    data1 = (float(x1), float(y1),float(x), float(y), float(0), float(0))
    #data2 = (float(x1), float(y1),float(0), float(0), float(0), float(0))

    packer = struct.Struct('f f f f f f')
    packed_data1 = packer.pack(*data1)
    #packed_data2 = packer.pack(*data2)
    sok.sendto(packed_data1, ('127.0.0.1', 4124))
    #sok.sendto(packed_data2, ('127.0.0.1', 4124))


    cv2.imshow('Red', red)
    cv2.imshow('Blu', blu)
    cv2.imshow('Frame',frame)  #Video Footage

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break


# Destroys all of the HighGUI windows. 
cv2.destroyAllWindows() 
  
# release the captured frame 
cap.release() 

#close socket
s.close()