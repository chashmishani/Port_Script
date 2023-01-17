function download() {
	rm -rf Download
	mkdir Download && cd Download
	wget $1;
	cd -
}

function extract() {
	if [ -f *.xz ] ; then
	    echo "xz file found. extracting it..."
	    unxz *.xz
	else
	    echo "No xz file found. Skipping..."
	fi

	if [ -f *.zip ] ; then
	    echo "zip file found. extracting it..."
	    unzip *.zip
	else
	    echo "No zip file found. Skipping..."
	fi

	if [ -f *.gz ] ; then
	    echo "gz file found. extracting it..."
	    gzip -d *.gz
	else
	    echo "No gz file found. Skipping..."
	fi

	if [ -f *.tgz ] ; then
	    echo "tgz file found. extracting it..."
	    tar -xf *.tgz
	else
	    echo "No tgz file found. Skipping..."
	fi

	if [ -f *.tar ] ; then
	    echo "tar file found. extracting it..."
	    tar -xf *.tar
	else
	    echo "No tar file found. Skipping..."
	fi

	if [ -f $1.img ] ; then
	    echo "$1.img found after extraction. skipping rename."
	else
	    if [ -f *.img ] ; then
	        echo "a .img file Found. assuming it $1.img"
	        mv *.img $1.img
	    else
	        echo "No .img found."
	    fi
	fi
}
function main() {
	mkdir IMAGES
	download $SYSTEM
	cd Download
	extract system
	mv system.img ../IMAGES/
	cd ..
	download $VENDOR
	cd Download
	extract vendor
	mv vendor.img ../IMAGES/
	cd ..
	download $BOOT
	cd Download
	extract boot
	mv boot.img ../IMAGES/
	cd ..
	rm -rf Download
	git clone --depth=1 https://github.com/chashmishani/10or_Files.git -b template ROM
	mv IMAGES/* ROM/
	cd ROM && zip $ZIP_NAME *
	curl -sL https://git.io/file-transfer | sh && ./transfer wet $ZIP_NAME.zip >> ~/upload.txt
}
main
