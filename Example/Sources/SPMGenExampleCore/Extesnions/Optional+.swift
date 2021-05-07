extension Optional {
  public var isNil: Bool {
    self == nil
  }

  public var isNotNil: Bool {
    self != nil
  }

  public func or(_ defaultValue: @autoclosure () -> Wrapped?) -> Wrapped? {
    self ?? defaultValue()
  }

  public func or(_ defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
    self ?? defaultValue()
  }
}
