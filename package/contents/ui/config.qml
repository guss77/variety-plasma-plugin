/*
 *	SPDX-FileCopyrightText: 2023 Oded Arbel <oded@geek.co.il>
 *	
 *	SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.0
import QtQuick.Controls 2.0 as QQC2

import org.kde.kirigami 2.5 as Kirigami

Kirigami.FormLayout {
	id: root
	twinFormLayouts: parentLayout
	
	property alias formLayout: root
	
	Row {
		Kirigami.FormData.label: i18nc("@label:notification", "Use the Variety wallpaper application to configure the wallpaper.")
		spacing: Kirigami.Units.smallSpacing
	}
}
