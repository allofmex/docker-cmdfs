#!/bin/sh
# downscale using imagemagicks convert
# since this is only one line, we would be able to
# use the convert in cmdfs command straigt without 
# wrapping script too
convert - -resize '1920x1080>' -quality 75 -
exit $?

