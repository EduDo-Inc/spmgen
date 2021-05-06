struct _Error: Swift.Error {
  let localizedDescription: String

  init(_ description: String) {
    self.localizedDescription = "💥 Error: ".appending(description)
  }
}
