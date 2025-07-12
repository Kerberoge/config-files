#!/bin/bash

# This script makes it possible to uninstall Windows builtin apps, such as the legacy
# Edge stub that for some reason hasn't been removed from Windows till today.

read -p 'Is the Windows partition mounted on /mnt? (y/n) ' userResponse

if [[ $userResponse != "y" && $userResponse != "yes" ]]; then
	echo "Please mount your Windows partition on /mnt and rerun this script when you're done."
	exit 1
fi

sqlite3 /mnt/ProgramData/Microsoft/Windows/AppRepository/StateRepository-Machine.srd <<EOF
-- Delete the TRG_AFTER_UPDATE_Package_SRJournal trigger (this is needed if you want to edit the Package table)
DROP TRIGGER TRG_AFTER_UPDATE_Package_SRJournal;

-- Modify desired values
UPDATE Package
SET IsInbox=0
WHERE PackageFullName NOT LIKE 'windows.immersivecontrolpanel%'
	AND PackageFullName NOT LIKE 'Microsoft.Windows.CloudExperienceHost%'
	AND PackageFullName NOT LIKE 'Microsoft.AAD.BrokerPlugin%'
	AND PackageFullName NOT LIKE 'Microsoft.Windows.StartMenuExperienceHost%'
	AND PackageFullName NOT LIKE 'Microsoft.Windows.ShellExperienceHost%'
	AND PackageFullName NOT LIKE 'Microsoft.Windows.SecHealthUI%'
	AND PackageFullName NOT LIKE 'MicrosoftWindows.Client.CBS%'
	AND PackageFullName NOT LIKE 'Microsoft.Windows.Search%';

-- Recreate the trigger
CREATE TRIGGER TRG_AFTER_UPDATE_Package_SRJournal
AFTER UPDATE
ON Package

FOR EACH ROW WHEN is_srjournal_enabled()
BEGIN
	UPDATE Sequence
	SET LastValue=LastValue+1
	WHERE Id=2;

	INSERT INTO SRJournal(_Revision, _WorkId, ObjectType, Action, ObjectId, PackageIdentity, WhenOccurred, SequenceId)
	SELECT 1, workid(), 1, 2, NEW._PackageID, pi._PackageIdentityID, now(), s.LastValue
	FROM Sequence AS s
	CROSS JOIN PackageIdentity AS pi
	WHERE s.Id=2 AND pi.PackageFullName=NEW.PackageFullName;
END;
EOF
