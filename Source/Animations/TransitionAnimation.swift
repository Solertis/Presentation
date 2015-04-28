import UIKit

@objc public class TransitionAnimation: NSObject, Animation {

  public var view: UIView
  public var destination: Position
  public var duration: NSTimeInterval
  public var isPlaying = false

  var start: Position?

  var startPoint: CGPoint? {
    var point: CGPoint?
    if let superview = view.superview {
      if start == nil {
        start = view.frame.origin.positionInFrame(superview.bounds)
      }
      point = start!.originInFrame(superview.bounds)
    }

    return point
  }

  var distance: CGFloat {
    var dx: CGFloat = 0.0

    if let superview = view.superview {
      dx = destination.xInFrame(superview.bounds)
      if let startPoint = startPoint {
        dx -= startPoint.x
      }
    }

    return dx
  }

  public init(view: UIView, destination: Position, duration: NSTimeInterval = 0.5) {
    self.view = view
    self.view.setTranslatesAutoresizingMaskIntoConstraints(true)
    self.destination = destination
    self.duration = duration

    super.init()
  }

  private func animate(frame: CGRect) {
    if !isPlaying {
      isPlaying = true

      UIView.animateWithDuration(duration, delay: 0,
        options: .BeginFromCurrentState,
        animations: {
          [unowned self] () -> Void in
          self.view.frame = frame
        }, completion: {
          [unowned self] (done: Bool) -> Void in
          self.isPlaying = false
        })
    }
  }
}

// MARK: TutorialAnimation protocol implementation

extension TransitionAnimation {

  public func rotate() {
    view.rotateAtPosition(destination)
  }

  public func play() {
    if let superview = view.superview {
      var frame = view.frame
      frame.origin = destination.originInFrame(superview.bounds)

      animate(frame)
    }
  }

  public func playBack() {
    if let startPoint = startPoint {
      var frame = view.frame
      frame.origin = startPoint

      animate(frame)
    }
  }

  public func move(offsetRatio: CGFloat) {
    if !isPlaying {
      if let startPoint = startPoint {
        var frame = view.frame

        let ratio = offsetRatio > 0.0 ? offsetRatio : (1.0 + offsetRatio)
        let offset = distance * ratio

        frame.origin.x = startPoint.x + offset

        view.frame = frame
      }
    }
  }
}
