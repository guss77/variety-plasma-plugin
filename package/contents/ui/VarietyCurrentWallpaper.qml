import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item {
	id: currentWallpaper
	property string path: "unknown"
	
	signal resolved()
	
	PlasmaCore.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: {
			var exitCode = data["exit code"]
			var exitStatus = data["exit status"]
			var stdout = data["stdout"]
			var stderr = data["stderr"]
			exited(exitCode, exitStatus, stdout, stderr)
			disconnectSource(sourceName) // cmd finished
		}
		function exec(cmd) {
			connectSource(cmd)
		}
		signal exited(int exitCode, int exitStatus, string stdout, string stderr)
	}
	
	Connections {
		target: executable
		function onExited(exitCode, exitStatus, stdout, stderr) {
			path = stdout.replace('\n', ' ').trim();
			if (!path) {
				console.log("variety-plasma: empty input, trying to re-resolve");
				executable.exec('variety --show-current 2>/dev/null');
				return;
			}
			console.log("variety-plasma: current Variety wallpaper is " + path);
			currentWallpaper.resolved();
		}
	}
	
	Component.onCompleted: {
		console.log("variety-plasma: resolving current Variety wallpaper...");
		executable.exec('variety --show-current 2>/dev/null')
	}
	
	function goNext() {
		executable.exec('variety --next 2>/dev/null');
	}
	
	function goPrevious() {
		executable.exec('variety --previous 2>/dev/null');
	}
}
