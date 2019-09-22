AVISource("somevideo.avi")

# TemporalSoften is one of many noise-reducing filters
TemporalSoften(4, 4, 8, scenechange=15, mode=2)

# increase the gamma (relative brightness) of the video
Levels(0, 1.2, 255, 0, 255)

# fade-in the first 15 frames from black
FadeIn(15)

# fade-out the last 15 frames to black
FadeOut(15)