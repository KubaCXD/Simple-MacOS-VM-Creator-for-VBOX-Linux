#!/bin/bash
clear
echo "		    --Simple MacOS VM Creator for VBOX--"
echo " "
echo "!! MAKE SURE THAT YOU HAVE Oracle Virtual Box Installed Before Using this software !!"
echo " "
echo "To continue press Return ..."
read VBOXMACOSVMPstart
echo "Podany tekst : " $VBOXMACOSVMPstart
clear 
#
#
#
echo "		    --Simple MacOS VM Creator for VBOX--"

while [ 1 == 1 ] ; do 
#
#
	
	echo " "
	echo "		Aby rozpocząć wybierz obecny stan maszyny wirtualnej : "
	echo " "
	echo "1. Nie mam stworzonej maszyny systemu Mac OS X w VirtualBox'ie;"
	echo "2. Mam stworzoną maszynę wirtualną systemu Mac OS, ale system nie uruchamia się;"
	echo " "
	echo "Aby wyjść z aplikacji, wpisz exit "
	echo " "
	echo "Wpisz liczbę 1-2 aby wybrać opcję : "
	read STANVM
	if [ $STANVM == '1' ] ; then
		echo "Wybrano opcję 1"
		clear 
		echo "Narzędzie patch'ujące rozpocznie dane kroki :"
		echo ""
		echo "1. Utworzenie nowej maszyny wirtualnej"
		echo "2. Dodanie podstawowych wartości"
		echo "3. Zaaplikowanie patch'y do wirtualnej maszyny"
		echo "4. Zakończenie automatycznej przcy narzędzia"
		echo "		( zostaną wyświetlone kroki które musi wykonać użytkownik )"
		echo ""
		echo " Przed rozpoczęciem upewnij się że masz dostęp do płytki "
		echo " bądź wirtualnej kopi płytki (ISO) instalacyjnej systemu Mac OS X"
		echo " "
		echo " Przed instalacją użytkownik zostanie poinformowany o wymaganiach"
		echo " systemowych wirtualnej maszyny systemu Mac OS X"
		echo " "
		echo " Aby kontynuować kliknij Return (Enter)"
		echo " Aby wyjść z tego ekranu, wpisz exit i kliknij Return (Enter)"
		read SETUPVM
		SETUPVM='new'
	elif [ $STANVM == '2' ] ; then
		echo "Wybrano opcję 2"
		clear 
		echo "Narzędzie patch'ujące rozpocznie dane kroki :"
		echo ""
		echo "1. Pobranie nazwy maszyny do spatch'owania"
		echo "2. Zaaplikowanie patch'y do wirtualnej maszyny"
		echo "3. Zakończenie automatycznej przcy narzędzia"
		echo "		( zostaną wyświetlone kroki które musi wykonać użytkownik )"
		echo ""
		echo " Przed rozpoczęciem upewnij się że masz dostęp do płytki "
		echo " bądź wirtualnej kopi płytki (ISO) instalacyjnej systemu Mac OS X"
		echo " "
		echo " Przed instalacją użytkownik zostanie poinformowany o wymaganiach"
		echo " systemowych wirtualnej maszyny systemu Mac OS X"
		echo " "
		echo " Aby kontynuować kliknij Return (Enter)"
		echo " Aby wyjść z tego ekranu, wpisz exit i kliknij Return (Enter)"
		read SETUPVM
		SETUPVM='patch'
	elif [ $STANVM == 'exit' ] ; then
		clear
		echo "Dziękuje za użycie programu "
		echo "VrtualBox MacOS Virtual Machine Patcher"
		echo " "
		echo "Exiting... "
		echo " "
		exit
	else 
		echo " "
		echo " "	
		echo "Niepoprawnie sformatowana opcja, aplikacja zostanie zakończona..."
		clear
		echo "	!! Niepoprawnie sformatowana opcja, aplikacja zostanie zakończona !!"
	fi

	if [ $SETUPVM == "exit" ] ; then
		clear
		echo " -- Anulowano --"
	elif [ $SETUPVM == "new" ] ; then #NEW MACHINE MODE
		clear
		echo "Podaj nazwę maszyny wirtualnej (Nie używaj Spacji w nazwie!): "
		read MACHINE_NEW_VMNAME
		echo "Podaj przedzieloną maszynie pamięć RAM (MB) (używaj tylko cyfr) : "
		read MACHINE_NEW_RAM
		echo "Maszyna będzie używała : " $MACHINE_NEW_RAM " MB pamięci RAM."
		echo "Podaj przydzieloną maszynie pamięć VRAM (MB) <min 9 mb, max 256 mb,> :"
		read MACHINE_NEW_VRAM
		echo "Podaj miejscę w którym ma być stworzony wirtualny dysk i jego nazwę : "
		echo "(ex. /home/ubuntu/Dokumenty/Dysk.vdi) !! Dodaj .vdi samodzielnie !!"
		read MACHINE_NEW_DISK_NAME
		echo "Podaj pojemność dysku vdi : " $MACHINE_NEW_DISK_NAME " (MB)"
		read MACHINE_NEW_DISK_SIZE
		echo "System Mac OS wymaga 2 CPU, i obsługę technologi wirtualizacji."
		echo "Jeśli wiesz że twój system spełnia wymagania, kliknij Return (Enter)"
		echo "Aby anulować, wyłącz okno aplikacji"
		read Startnewinstall
		PATCH_STARTED=activated
		PATCH_MODE=new
	elif [ $SETUPVM == "patch" ] ; then
		clear
		echo "Podaj nazwę istniejącej maszyny wirtualnej (Nie używaj Spacji w nazwie!): "
		read MACHINE_PATCH_VMNAME
		echo "System Mac OS wymaga 2 CPU, i obsługę technologi wirtualizacji."
		echo "Jeśli wiesz że twój system spełnia wymagania, kliknij Return (Enter)"
		echo "Aby anulować, wyłącz okno aplikacji"
		read Startnewinstall
		echo "Czy jesteś pewien że chcesz dodać patch na maszynę wirtualną " $MACHINE_PATCH_VMNAME "?"
		echo "Aby anulować, wyłącz okno aplikacji"
		read Startnewinstall
		PATCH_STARTED=activated
		PATCH_MODE=patch_only
	fi

#if [ $VBOXMACOSVMPstart == '1' ] ; then
#	echo "Zmienna VBOXMACOSVMPstart jest równa 1"
#fi

if [ $PATCH_STARTED == 'activated' ] ; then
	
	if [ $PATCH_MODE == 'new' ] ; then
		clear
		echo "Adding Virtual Machine..."
		VBoxManage createvm --name $MACHINE_NEW_VMNAME --ostype MacOS1013_64 --register
		echo "Adding System Settings..."
		VBoxManage modifyvm $MACHINE_NEW_VMNAME --cpus 2 --memory $MACHINE_NEW_RAM --vram $MACHINE_NEW_VRAM
		echo "Creating SATA controller..."
		VBoxManage storagectl $MACHINE_NEW_VMNAME --name "SATA Controller" --add sata --bootable on
		echo "Creating Virtual Hard Disk..."
		VBoxManage createhd --filename $MACHINE_NEW_DISK_NAME --size $MACHINE_NEW_DISK_SIZE
		echo "Attaching Virtual Hard Disk to Virtual Machine..."
		VBoxManage storageattach $MACHINE_NEW_VMNAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $MACHINE_NEW_DISK_NAME
		echo "Patching Virtual Machine : " $MACHINE_NEW_VMNAME
		VBoxManage modifyvm $MACHINE_NEW_VMNAME --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
		VBoxManage setextradata $MACHINE_NEW_VMNAME "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3"
		VBoxManage setextradata $MACHINE_NEW_VMNAME "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
		VBoxManage setextradata $MACHINE_NEW_VMNAME "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
		VBoxManage setextradata $MACHINE_NEW_VMNAME "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
		VBoxManage setextradata $MACHINE_NEW_VMNAME "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1
		echo "Virtual Machine Pached : " $MACHINE_NEW_VMNAME
		echo "Deactivating program... "
		PATCH_STARTED='deactivated'
		SETUPVM=none
		STANVM=null
		echo "Done!"
		echo "Kliknij Return (Enter) aby kontynuować."
		
		#while [ 1 == 1 ] ; do
		#	clear
		#	echo "Aby zakończyć pracę patchera, wyłącz to okno."
		#done

	elif [ $PATCH_MODE == 'patch_only' ] ; then
		echo "Patching Virtual Machine : " $MACHINE_PATCH_VMNAME
		VBoxManage modifyvm $MACHINE_PATCH_VMNAME --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
		VBoxManage setextradata $MACHINE_PATCH_VMNAME "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3"
		VBoxManage setextradata $MACHINE_PATCH_VMNAME "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
		VBoxManage setextradata $MACHINE_PATCH_VMNAME "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
		VBoxManage setextradata $MACHINE_PATCH_VMNAME "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
		VBoxManage setextradata $MACHINE_PATCH_VMNAME "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1
		echo "Virtual Machine Pached : " $MACHINE_PATCH_VMNAME
		echo "Deactivating program... "
		PATCH_STARTED='deactivated'
		SETUPVM=none
		STANVM=null
		echo "Done!"
		echo "Kliknij Return (Enter) aby kontynuować."
	fi
fi

done # Koniec pętli while
