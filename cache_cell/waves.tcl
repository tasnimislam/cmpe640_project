;# initial.tcl — works inside SimVision
database -open waves -shm
probe -create : -all -depth all -shm
run 200 ns
exit
