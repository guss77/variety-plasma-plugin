/*
 *	SPDX-FileCopyrightText: 2023 Oded Arbel <oded@geek.co.il>
 *	
 *	SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Window 2.15

import org.kde.plasma.wallpapers.image 2.0 as Wallpaper
import org.kde.plasma.core 2.0 as PlasmaCore

QQC2.StackView {
	id: root
	
	readonly property int fillMode: wallpaper.configuration.FillMode
	readonly property string configImage: wallpaper.configuration.Image
	readonly property size sourceSize: Qt.size(root.width * Screen.devicePixelRatio, root.height * Screen.devicePixelRatio)
	property Item pendingImage
	property bool doesSkipAnimation: true
	
	VarietyCurrentWallpaper {
		id: currentWallpaper
		onResolved: {
			console.log("variety-plasma: resolved new image");
			wallpaper.configuration.Image = path;
			root.loadImage();
		}
	}
	
	onFillModeChanged: Qt.callLater(root.loadImage)
	onSourceSizeChanged: Qt.callLater(root.loadImage)
	onConfigImageChanged: Qt.callLater(root.loadImage) // fired from KConfig when using DesktopContainment.writeConfig()
	
	function loadImage() {
		let path = wallpaper.configuration.Image;
		if (!path)
			path = currentWallpaper.path;
		console.log("variety-plasma: loaded image " + path);
		if (path == "unknown")
			return;
		if (root.pendingImage) {
			root.pendingImage.statusChanged.disconnect(replaceWhenLoaded);
			root.pendingImage.destroy();
			root.pendingImage = null;
		}
		
		root.doesSkipAnimation = true; //root.empty
		root.pendingImage = imageComponent.createObject(root, {
			"source": path,
			"fillMode": root.fillMode,
			"opacity": root.doesSkipAnimation ? 1 : 0,
			"sourceSize": root.sourceSize,
			"width": root.width,
			"height": root.height,
		});
		root.pendingImage.statusChanged.connect(root.replaceWhenLoaded);
		root.replaceWhenLoaded();
	}
	
	function replaceWhenLoaded() {
		if (root.pendingImage.status === Image.Loading) {
			return;
		}
		root.pendingImage.statusChanged.disconnect(root.replaceWhenLoaded);
		root.replace(root.pendingImage, {}, root.doesSkipAnimation ? QQC2.StackView.Immediate : QQC2.StackView.Transition);
		root.pendingImage = null;
	}
	
	//public API, the C++ part will look for those
	function setUrl(url) {
		wallpaper.configuration.Image = url;
		loadImage();
	}
	
	function action_next() {
		console.log("variety-plasma: switching to next Variety wallpaper");
		currentWallpaper.goNext();
	}
	
	function action_previous() {
		console.log("variety-plasma: switching to next Variety wallpaper");
		currentWallpaper.goPrevious();
	}
	
	Component {
		id: imageComponent
		
		Image {
			asynchronous: true
			cache: false
			autoTransform: true
			smooth: true
			
			QQC2.StackView.onActivated: {
				console.log("variety-plasma: repainting wallpaper");
				wallpaper.repaintNeeded();
			}
			QQC2.StackView.onRemoved: destroy()
		}
	}
	
	Rectangle {
		id: backgroundColor
		anchors.fill: parent
		color: wallpaper.configuration.Color
		Behavior on color {
			ColorAnimation { duration: PlasmaCore.Units.longDuration }
		}
	}
	
	Component.onCompleted: {
		// In case plasmashell crashes when the config dialog is opened
		wallpaper.configuration.PreviewImage = "null";
		wallpaper.loading = true; // delays ksplash until the wallpaper has been loaded
		
		console.log("variety-plasma: Current wallpaper: " + currentWallpaper.path);
		console.log("variety-plasma: background color: " + wallpaper.configuration.Color);
		
		wallpaper.setAction("next", i18nc("@action:inmenu switch to next variety wallpaper", "Next Variety wallpaper"), "go-next");
		wallpaper.setAction("previous", i18nc("@action:inmenu switch to previous variety wallpaper", "Previous Variety wallpaper"), "go-previous");
	}
	
}
