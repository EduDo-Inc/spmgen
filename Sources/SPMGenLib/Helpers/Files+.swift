import Files

extension Folder {
  func iterateThroughContents(recoursive: Bool = true, _ function: (_Location) throws -> Void)
    rethrows
  {
    try files.forEach(function)
    try subfolders.forEach(function)
    if recoursive {
      try subfolders.forEach {
        try $0.iterateThroughContents(
          recoursive: true,
          function
        )
      }
    }
  }

  func flatMapContents<T>(recoursive: Bool = true, _ function: (_Location) throws -> T) rethrows
    -> [T]
  {
    var mappedObjects = try files.map(function)
    mappedObjects += try subfolders.map(function)
    if recoursive {
      mappedObjects += try subfolders.flatMap {
        try $0.flatMapContents(
          recoursive: true,
          function
        )
      }
    }
    return mappedObjects
  }
}
