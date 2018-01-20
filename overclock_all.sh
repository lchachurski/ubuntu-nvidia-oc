#!/bin/sh
#
# Setup for 13x nvidia 1070 cards for ethereum mining

sudo nvidia-xconfig --enable-all-gpus
sudo nvidia-xconfig --cool-bits=31
sudo nvidia-xconfig --allow-empty-initial-configuration

# we're setting persistence mode first as it takes a lot of time
# count in minutes with 13 GPUs
sudo nvidia-smi -i 0 -pm 1
sudo nvidia-smi -i 1 -pm 1
sudo nvidia-smi -i 2 -pm 1
sudo nvidia-smi -i 3 -pm 1
sudo nvidia-smi -i 4 -pm 1
sudo nvidia-smi -i 5 -pm 1
sudo nvidia-smi -i 6 -pm 1
sudo nvidia-smi -i 7 -pm 1
sudo nvidia-smi -i 8 -pm 1
sudo nvidia-smi -i 9 -pm 1
sudo nvidia-smi -i 10 -pm 1
sudo nvidia-smi -i 11 -pm 1
sudo nvidia-smi -i 12 -pm 1

# GPUs
sudo /usr/bin/miner/overclock_one -g 0 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 1 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 2 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 3 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 4 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 5 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 6 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 7 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 8 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 9 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 10 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 11 -p 130 -m 1450 -c 100 -f 75
sudo /usr/bin/miner/overclock_one -g 12 -p 130 -m 1450 -c 100 -f 75
