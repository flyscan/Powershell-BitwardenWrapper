class Item {
  [System.String] $object
  [System.String] $id
  [System.Object] $organizationId
  [System.String] $folderId
  [System.Int64] $type
  [System.String] $name
  [System.String] $notes
  [System.Boolean] $favorite
  [Login] $login
  [System.String[]] $collectionIds
  [System.DateTime] $revisionDate
  [PasswordHistory[]] $passwordHistory
}
