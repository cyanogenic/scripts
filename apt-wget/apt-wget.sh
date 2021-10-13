#!/bin/bash

source `dirname $0`/apt-wget.conf
NAME="InRelease Release Release.gpg"

# TODO 多线程wget
for distro in $DISTRO
do
	# Release
	mkdir -p $REPO/dists/$distro
	for name in $NAME
	do
		wget -P $REPO/dists/$distro $REPO/dists/$distro/$name
	done

	# Packages
	for component in $COMPONENT
	do
		for arch in $ARCH
		do
			mkdir -p $REPO/dists/$distro/$component/binary-$arch
			wget -P $REPO/dists/$distro/$component/binary-$arch $REPO/dists/$distro/$component/binary-$arch/Packages
			wget -P $REPO/dists/$distro/$component/binary-$arch $REPO/dists/$distro/$component/binary-$arch/Packages.gz
		done
	done
done

