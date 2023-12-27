function overwriteFile(blobOfNewContent,currentFileID) {
  var currentFile;
  
  currentFile = DriveApp.getFileById(currentFileID);    
  
  if (currentFile) {//If there is a truthy value for the current file
    Drive.Files.update({
      title: currentFile.getName(), mimeType: currentFile.getMimeType()
    }, currentFile.getId(), blobOfNewContent);
  }
}