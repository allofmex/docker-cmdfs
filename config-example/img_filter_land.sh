#!/bin/bash
#use imagemagicks identify to detect aspect-ratio
ORIENT=$(identify -format "w=%w;h=%h" "$INPUT_FILE")
eval $ORIENT
if [ "$w" -ge "$h" ]
then
  # landscape orientation
  # you can downscale with imagemagick uncommenting next line
  #convert - -resize '1920x1080>' -quality 75 -

  # but in our example case the photo was already downscaled
  # in first step, so we just output it here as it is
  cat <&0
  exit 0
else
  # portrait orientation
  # we exit not 0 so cmdfs will not show this file
  exit -1
fi

