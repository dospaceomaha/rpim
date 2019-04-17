#!/bin/bash

ls /dev/disk/by-id/ | grep usb-TS-RDF5_SD_Transcend_000000000039-0:0 > /dev/null
if [ "$?" -eq 0 ]; then
        printf "connected\n"
        pidof dd > /dev/null
        isrunning="$?"
        printf "$isrunning\n"
        if [ "$isrunning" -eq 1 ]; then
                printf "able to run\n"
                mkdir /media/temp1
                mount /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part1 /media/temp1
                process=$(sed -n '1p' /media/temp1/wi)
                fname=$(sed -n '2p' /media/temp1/wi)
                dos2unix /media/temp1/wi
                if [ "$process" -eq 1 ];then
                        sed -i '1s/.*/0/' /media/temp1/wi
                fi
                #sed -i '3s/.*/$(date)/' /media/temp1/wi
                if [ ! -f /media/temp1/wi ]; then
                        printf "bypass\n"
                        stime=$(date +%s)
                        dd bs=4M if=/home/cit-admin/rpimg/pibackup2.img of=/dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0 status=progress conv=fsync
                        passd=$?
                        dtime=$(date +%s)
                        fintime=$((dtime-stime))
                        if [ "$passd" -eq 0 ] && [ "$fintime" -gt 600 ]; then
                                printf "$(date)\tWrite Completed Successfully in\t$fintime seconds\n" >> /home/cit-admin/rpilog
                        else
                                printf "$(date)\tWrite Completed Unsuccessfully in\t$fintime seconds\n" >> /home/cit-admin/rpilog
                        fi
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part1
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part2
                        udisksctl power-off -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0
                        exit 1
                fi
                umount /media/temp1
                sudo rm -rf /media/temp1

                case "$process" in
                0)
                        printf "case 0\n"
                        stime=$(date +%s)
                        dd bs=4M if=/home/cit-admin/rpimg/"$fname" of=/dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0 status=progress conv=fsync
                        passd=$?
                        dtime=$(date +%s)
                        fintime=$((dtime-stime))
                        if [ "$passd" -eq 0 ] && [ "$fintime" -gt 600 ]; then
                                printf "$(date)\tWrite Completed Successfully in\t$fintime seconds\n" >> /home/cit-admin/rpilog
                        else
                                printf "$(date)\tWrite Completed Unsuccessfully in\t$fintime seconds\n" >> /home/cit-admin/rpilog
                        fi
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part1
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part2
                        udisksctl power-off -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0
                        printf "case 0 end\n"

                ;;
                1)
                        printf "case 1\n"
                        stime=$(date +%s)
                        dd bs=4M of=/home/cit-admin/rpimg/"$fname" if=/dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0 status=progress conv=fsync
                        passd=$?
                        dtime=$(date +%s)
                        fintime=$((dtime-stime))
                        if [ "$passd" -eq 0 ] && [ "$fintime" -gt 150 ]; then
                                printf "$(date)\tRead Completed Successfully in\t$fintime seconds\n" >> /home/cit-admin/rpilog
                        else
                                printf "$(date)\tRead Completed Unsuccessfully in\t$fintime seconds\n" >> /home/cit-admin/rpilog
                        fi
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part1
                        udisksctl unmount -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0-part2
                        udisksctl power-off -b /dev/disk/by-id/usb-TS-RDF5_SD_Transcend_000000000039-0:0
                        printf "case 1 end\n"
                ;;
                        *)
                                exit 1
                ;;
                esac

        else
                exit 1
        fi


else
        exit 1
fi
exit 1
