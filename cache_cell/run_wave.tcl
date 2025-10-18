# Open waveform database
database -open waves -shm

# Probe all signals recursively
probe -create -all -depth all

# Run simulation for 200 ns
run 200ns

simvision waves &

# Close the database
database -close waves

# Exit simulation
exit
