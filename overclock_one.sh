#!/bin/bash
# Usual ubuntu x11 path, BUT it might differ
X11PATH=/etc/X11

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -g|--gpu)
    GPU="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--power)
    POWER="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--memory)
    MEMORY="$2"
    FAKESERVER=1
    shift # past argument
    shift # past value
    ;;
    -c|--core)
    CORE="$2"
    FAKESERVER=1
    shift # past argument
    shift # past value
    ;;
    -a|--autofan)
    AUTOFAN="$2"
    FAKESERVER=1
    shift # past argument
    shift # past value
    ;;
    -f|--fan)
    FAN="$2"
    FAKESERVER=1
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -z "$GPU" ]]; then
    echo "Missing -g or --gpu param"
    exit
fi

if [[ ! -z "$POWER" ]]; then
    echo "Setting max power to ---> ${POWER} WATT"
    sudo nvidia-smi -i ${GPU} -pl ${POWER}
fi

if [[ ! -z "$FAKESERVER" ]]; then
    echo "Starting fake server for nvidia-settings to work"
    LINE=$[$GPU + 1] # output lines numbers starts from 1 so we need to shift GPU number
    PCIID=`lspci  | sed -n -e '/VGA compatib.*NVIDIA/s/^\(..\):\(..\).\(.\).*/printf "PCI:%d:%d:%d" 0x\1 0x\2 0x\3;/p' | sed -n "${LINE} p"`
    PCIBUSID=$(eval $PCIID)

    CFG=`mktemp /tmp/xorg-XXXXXXXX.conf`
    sudo sed -e s,@GPU_BUS_ID@,${PCIBUSID},    \
        -e s,@SET_GPU_DIR@,${X11PATH}, \
        ${X11PATH}/xorg.conf >> ${CFG}

    # todo: put it as param as well
    MODECMD="-a [gpu:${GPU}]/GPUPowerMizerMode=2"
fi

if [[ ! -z "$AUTOFAN" ]]; then
    echo "Setting fan speed to ---> Auto"
    AUTOFANCMD="-a [gpu:${GPU}]/GPUFanControlState=0"
fi

if [[ ! -z "$FAN" ]]; then
    echo "Setting fan speed to ----> ${FAN}"
    FANCMD="-a [gpu:${GPU}]/GPUFanControlState=1 -a [fan:${GPU}]/GPUTargetFanSpeed=${FAN}"
fi

if [[ ! -z "$MEMORY" ]]; then
    echo "Setting memory to ----> ${MEMORY} Mhz"
    MEMORYCMD="-a [gpu:${GPU}]/GPUMemoryTransferRateOffset[3]=${MEMORY}"
fi

if [[ ! -z "$CORE" ]]; then
    echo "Setting core to ----> ${CORE} Mhz"
    CORECMD="-a [gpu:${GPU}]/GPUGraphicsClockOffset[3]=${CORE}"
fi

if [[ ! -z "$FAKESERVER" ]]; then
    CMD="/usr/bin/nvidia-settings $MODECMD $AUTOFANCMD $FANCMD $MEMORYCMD $CORECMD"
    sudo xinit ${CMD} --  :0 -once -config ${CFG}
    
    rm -f ${CFG}
fi
