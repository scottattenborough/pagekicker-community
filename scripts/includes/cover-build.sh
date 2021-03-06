echo "starting cover builder" | tee --append $sfb_log

# cleanup previous images

rm -rf images/*
echo "removed previous images" | tee --append $sfb_log

# creating working directories for cover production

mkdir images/$uuid

cd images/$uuid ; mkdir ebookcover ; echo "created directory images/$uuid/ebookcover" ; cd $scriptpath ; echo "changed directory back to " $scriptpath | tee --append $sfb_log

# get title straight

if [ "$customtitle" = "none" ] ; then 
	
	covertitle=$titleprefix$escapeseed$titlesuffix
	echo "covertitle is" $covertitle
	echo "titleprefix is" $titleprefix
	echo "titlesuffix is" $titlesuffix
	echo "escapeseed is" $escapeseed
	safecovertitle=$(echo "$covertitle" | sed -e 's/[[:space:]]/_/g' -e 's/[[:punct:]]/_/g' | sed -e 's/_$//')
	echo "safecovertitle is" $safecovertitle

else
	
	covertitle=$customtitle

fi

# get editedby straight

echo "editedby is " $editedby

#if [ "$customer_name" = "Guest" ] ; then


#	editedby="PageKicker™"
#	lastname="PageKicker™"
#	echo "use default editedby, which is" $editedby

#else

#	editedby=$customer_name
#	true

#	echo "editedby is customer name, which is" $customer_name

#fi

# decide which cover builder to use

echo "covertype id is " $covertype_id

case $covertype_id in

1)
	echo "building default WordCloud cover"
	
	# creates base canvases

	convert -size 600x800 xc:$newcovercolor  images/$uuid/ebookcover/canvas.png
	convert -size 600x200 xc:$newcovercolor  images/$uuid/ebookcover/topcanvas.png
	convert -size 600x91 xc:$newcovercolor  images/$uuid/ebookcover/bottomcanvas.png
	convert -size 600x200 xc:$newcovercolor  images/$uuid/ebookcover/toplabel.png
	convert -size 600x91 xc:$newcovercolor  images/$uuid/ebookcover/bottomlabel.png

	# build the Word Cloud cover

	echo  "JAVA_BIN is" $JAVA_BIN | tee --append $sfb_log
	$JAVA_BIN -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w 600 -h 800 < tmp/$uuid/cumulative.txt > images/$uuid/ebookcover/$sku"cloud.png" 2> /dev/null

	# build print-size Word Cloud image

	$JAVA_BIN -jar $scriptpath"lib/IBMcloud/ibm-word-cloud.jar" -c $scriptpath"lib/IBMcloud/examples/configuration.txt" -w 2550 -h 3300 < tmp/$uuid/cumulative.txt > images/$uuid/ebookcover/$sku"printcloud.png" 2> /dev/null


	# underlay the Word Cloud cover

	composite -gravity Center images/$uuid/ebookcover/$sku"cloud.png"  images/$uuid/ebookcover/canvas.png images/$uuid/ebookcover/canvas.png

	# build the canvas labels


	# echo "about to build toplabel"

	echo "newcoverfont is" $newcoverfont
	convert -background $newcovercolor -fill "$coverfontcolor" -gravity center -size 600x200 -font "$newcoverfont" caption:"$covertitle" images/$uuid/ebookcover/topcanvas.png +swap -gravity center -composite images/$uuid/ebookcover/toplabel.png

	# echo "about to build bottomlabel"

	convert  -background $newcovercolor  -fill "$coverfontcolor" -gravity center -size 600x91 \
		 -font $newcoverfont  caption:"$editedby" \
		 images/$uuid/ebookcover/bottomcanvas.png  +swap -gravity center -composite images/$uuid/ebookcover/bottomlabel.png

	# lay the labels on top of the target canvas

	composite -geometry +0+0 images/$uuid/ebookcover/toplabel.png images/$uuid/ebookcover/canvas.png images/$uuid/ebookcover/step1.png

	composite  -geometry +0+600 images/$uuid/ebookcover/bottomlabel.png images/$uuid/ebookcover/step1.png images/$uuid/ebookcover/step2.png
	
	composite  -gravity south -geometry +0+0 $userlogo images/$uuid/ebookcover/step2.png images/$uuid/ebookcover/cover.png

	convert images/$uuid/ebookcover/cover.png -border 36 -bordercolor white images/$uuid/ebookcover/bordercover.png
	cp images/$uuid/ebookcover/bordercover.png images/$uuid/ebookcover/$sku"cover.png"
	cp images/$uuid/ebookcover/bordercover.png $mediatargetpath$uuid/cover.png
	cp images/$uuid/ebookcover/bordercover.png $mediatargetpath$uuid/$sku"cover.png"

;;

2)


#	echo "building a cover from a customer-supplied base image" | tee --append $sfb_log
#	echo "specified cover base image is " $coverbase | tee --append $sfb_log
#	echo "specified cover font is" $coverfont| tee --append $sfb_log
#	echo "specified cover color is " $newcovercolor | tee --append $sfb_log
#	cp "$coverbase" "images/$uuid/canvas.png" | tee --append $sfb_log
#	
#	
#	# creates base canvas
#	
#	convert -size 600x800 images/$uuid/canvas.png
#	

#	# build the canvas labels

#	convert -background '#0008' -fill "$newcovercolor" -gravity center -size 600x200 \
#		  caption:"$covertitle" -pointsize 24 -font "$newcoverfont" \
#			  images/$uuid/topcanvas.png +swap -gravity north -composite images/$uuid/canvas.png

#	convert  -background '#0008' -fill "$coverfontcolor}" -gravity center -size 600x80 \
#		 caption:"$edited_by" -pointsize 20 -font "$newcoverfont" \
#		 images/$uuid/bottomcanvas.png  +swap -gravity south -composite images/$uuid/canvas.png

#	# lay the labels on top of the target canvas

#	composite  -gravity south +0+0 assets/PK.png images/$uuid/canvas.png images/$uuid/$sku".png"

;;

*)
	echo "invalid cover type id was " $covertype_id | tee --append $xform_log
	exit 1;;

esac

