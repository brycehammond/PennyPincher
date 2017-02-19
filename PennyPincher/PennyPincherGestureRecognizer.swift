import UIKit
import UIKit.UIGestureRecognizerSubclass

public class PennyPincherGestureRecognizer: UIGestureRecognizer {
    public var enableMultipleStrokes: Bool = true
    public var allowedTimeBetweenMultipleStrokes: TimeInterval = 0.2
    public var templates = [PennyPincherTemplate]()
    
    private(set) public var result: (template: PennyPincherTemplate, similarity: CGFloat)?
    
    private(set) var pennyPincher = PennyPincher()
    private(set) var points = [CGPoint]()
    private(set) var timer: Timer?
    
    init(contentsOfFile: String, target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        let dictionary = NSDictionary(contentsOfFile: contentsOfFile)
        if let configDictionary = dictionary as? [String : Any] {
            if let multipleStrokes = configDictionary["enableMultipleStrokes"] as? Bool {
                enableMultipleStrokes = multipleStrokes
            }
            
            if let timeBetweenMultipleStrokes = configDictionary["allowedTimeBetweenMultipleStrokes"] as? TimeInterval {
                allowedTimeBetweenMultipleStrokes = timeBetweenMultipleStrokes
            }
        
            if let templateConfigs = configDictionary["templates"] as? [[String : Any]] {
                templates = templateConfigs.map { PennyPincherTemplate(dictionary: $0) }
            }
        }
        
    }
    
    open func saveTo(_ path: String) {
        let configDictionary : [String : Any] = ["enableMultipleStrokes" : enableMultipleStrokes,
                                "allowedTimeBetweenMultipleStrokes" : allowedTimeBetweenMultipleStrokes,
                                "templates" : templates.map { $0.dictionary }]
        if let dictionary = configDictionary as NSDictionary? {
            dictionary.write(toFile: path, atomically: true)
        }
    }
    
    open override func reset() {
        super.reset()
       
        invalidateTimer()
        points.removeAll(keepingCapacity: false)
        result = nil
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        invalidateTimer()
        
        if let touch = touches.first {
            points.append(touch.location(in: view))
        }

        if state == .possible {
            state = .began
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            points.append(touch.location(in: view))
        }
        
        state = .changed
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if enableMultipleStrokes {
            timer = Timer.scheduledTimer(timeInterval: allowedTimeBetweenMultipleStrokes,
                target: self,
                selector: #selector(timerDidFire(_:)),
                userInfo: nil,
                repeats: false)
        } else {
            recognize()
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        points.removeAll(keepingCapacity: false)
        
        state = .cancelled
    }
    
    private func recognize() {
        result = PennyPincher.recognize(points, templates: templates)
        
        state = result != nil ? .ended : .failed
    }
    
    @objc private func timerDidFire(_ timer: Timer) {
        recognize()
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
