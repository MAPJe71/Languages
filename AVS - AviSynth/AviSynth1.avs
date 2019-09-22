# This is a comment.  All lines starting with a '#' symbol are comments
# and are ignored by AviSynth.

# load the file "somevideo.avi" from the same directory as the script
AVISource("somevideo.avi")

# Trim specifies what frames to KEEP.  The following line keeps frames
# [0, 12000], [20000, 32000], [44000, end] and then splices them
# together, effectively removing frames [12001, 19999] and
# [32001, 43999]
#
# NOTE: the interval notation [a, b] means all frames from a through b,
#       inclusive.
#
Trim(0, 12000) ++ Trim(20000, 32000) ++ Trim(44000, 0)