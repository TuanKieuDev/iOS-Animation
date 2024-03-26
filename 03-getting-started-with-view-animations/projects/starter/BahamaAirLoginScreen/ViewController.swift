/// Copyright (c) 2022-present Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

// A delay function
func delay(_ seconds: Double, completion: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
  let bgAnimation = CABasicAnimation(keyPath: "backgroundColor")
  bgAnimation.fromValue = layer.backgroundColor
  bgAnimation.toValue = toColor.cgColor
  bgAnimation.duration = 1.0
  
  layer.add(bgAnimation, forKey: nil)
  
}

func roundCorners(layer: CALayer, toRadius: CGFloat) {
  let cornerAnimation = CABasicAnimation(keyPath: "cornerRadius")
  cornerAnimation.fromValue = layer.cornerRadius
  cornerAnimation.toValue = toRadius
  cornerAnimation.duration = 0.33
  
  layer.add(cornerAnimation, forKey: nil)
}

class ViewController: UIViewController {
  // MARK: IB outlets
  
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!
  
  // MARK: further UI
  
  let spinner = UIActivityIndicatorView(style: .large)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
  
  var statusPosition = CGPoint.zero
  let info = UILabel()
  
  // MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true
    
    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)
    
    status.isHidden = true
    status.center = loginButton.center
    view.addSubview(status)
    
    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    status.addSubview(label)
    
    statusPosition = status.center
    
    
    info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0, width: view.frame.size.width, height: 30)
    info.backgroundColor = .clear
    info.font = UIFont(name: "HelveticaNeue", size: 12.0)
    info.textAlignment = .center
    info.textColor = .white
    info.text = "Tap on a field and enter username and password"
    view.insertSubview(info, belowSubview: loginButton)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
//    username.layer.position.x -= view.bounds.width
//    password.layer.position.x -= view.bounds.width
    
//    heading.center.x  -= view.bounds.width
//    username.center.x -= view.bounds.width
//    password.center.x -= view.bounds.width
    
    
    let formGroup = CAAnimationGroup()
    formGroup.duration = 0.5
    formGroup.fillMode = .backwards
    
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width / 2
    flyRight.toValue = view.bounds.size.width / 2
    flyRight.duration = 0.5
    flyRight.fillMode = .both
    
    flyRight.delegate = self
    flyRight.setValue("form", forKey: "name")
    flyRight.setValue(heading.layer, forKey: "layer")
    
    heading.layer.add(flyRight, forKey: nil)
    
    
    flyRight.beginTime = CACurrentMediaTime() + 0.3
    flyRight.setValue(username.layer, forKey: "layer")
    username.layer.add(flyRight, forKey: nil)
    username.layer.position.x = view.bounds.width / 2
    
    flyRight.beginTime = CACurrentMediaTime() + 0.4
    flyRight.setValue(password.layer, forKey: "layer")
    password.layer.add(flyRight, forKey: nil)
    password.layer.position.x = view.bounds.width / 2
    
    
    
    
    let fadeFieldIn = CABasicAnimation(keyPath: "opacity")
    fadeFieldIn.fromValue = 0.25
    fadeFieldIn.toValue = 1.0

    formGroup.animations = [flyRight, fadeFieldIn]
    heading.layer.add(formGroup, forKey: nil)

    formGroup.delegate = self
    formGroup.setValue("form", forKey: "name")
    formGroup.setValue(username.layer, forKey: "layer")

    formGroup.beginTime = CACurrentMediaTime() + 0.3
    username.layer.add(formGroup, forKey: nil)

    formGroup.setValue(password.layer, forKey: "layer")
    formGroup.beginTime = CACurrentMediaTime() + 0.4
    password.layer.add(formGroup, forKey: nil)
    
//    cloud1.alpha = 0
//    cloud2.alpha = 0
//    cloud3.alpha = 0
//    cloud4.alpha = 0
    
    
    
//    loginButton.center.y += 30.0
//    loginButton.alpha = 0.0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    UIView.animate(withDuration: 1) {
//      self.heading.center.x += self.view.bounds.width
//    }
    
//    UIView.animate(withDuration: 0.5, delay: 0.3,
//                   usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0,
//                   options: [],
//                   animations: {
//      self.username.center.x += self.view.bounds.width
//    }, completion: nil)
    
//    UIView.animate(withDuration: 0.5, delay: 0.4,
//                   usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0,
//                   options: [],
//                   animations: {
//      self.password.center.x += self.view.bounds.width
//    }, completion: nil)
    
//    UIView.animate(withDuration: 0.5, delay: 0.5) {
//      self.cloud1.alpha = 1
//    }
//
//    UIView.animate(withDuration: 0.5, delay: 0.7) {
//      self.cloud2.alpha = 1
//    }
//
//    UIView.animate(withDuration: 0.5, delay: 0.9) {
//      self.cloud3.alpha = 1
//    }
//
//    UIView.animate(withDuration: 0.5, delay: 1.1) {
//      self.cloud4.alpha = 1
//    }
    
//    UIView.animate(withDuration: 0.5, delay: 0.5,
//                   usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0,
//                   options: [], animations: {
//      self.loginButton.center.y -= 30.0
//      self.loginButton.alpha = 1.0
//    }, completion: nil)
    
    let blurCloud = CABasicAnimation(keyPath: "opacity")
    blurCloud.fromValue = 0.0
    blurCloud.toValue = 1.0
    blurCloud.duration = 0.5
    blurCloud.fillMode = .backwards
    
    blurCloud.beginTime = CACurrentMediaTime() + 0.5
    cloud1.layer.add(blurCloud, forKey: nil)
    
    blurCloud.beginTime = CACurrentMediaTime() + 0.7
    cloud2.layer.add(blurCloud, forKey: nil)
    
    blurCloud.beginTime = CACurrentMediaTime() + 0.9
    cloud3.layer.add(blurCloud, forKey: nil)
    
    blurCloud.beginTime = CACurrentMediaTime() + 1.1
    cloud4.layer.add(blurCloud, forKey: nil)
    
    
    let groupAnimation = CAAnimationGroup()
    groupAnimation.beginTime = CACurrentMediaTime() + 0.5
    groupAnimation.duration = 0.5
    groupAnimation.fillMode = .backwards
    groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
    
    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 3.5
    scaleDown.toValue = 1.0
    
    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = .pi / 4.0
    rotate.toValue = 0.0
    
    let fade = CABasicAnimation(keyPath: "opacity")
    fade.fromValue = 0.0
    fade.toValue = 1.0
    
    groupAnimation.animations = [scaleDown, rotate, fade]
    loginButton.layer.add(groupAnimation, forKey: nil)
    
//    animateCloud(cloud1)
//    animateCloud(cloud2)
//    animateCloud(cloud3)
//    animateCloud(cloud4)
    
    animateCloud(layer: cloud1.layer)
    animateCloud(layer: cloud2.layer)
    animateCloud(layer: cloud3.layer)
    animateCloud(layer: cloud4.layer)
    
    let flyLeft = CABasicAnimation(keyPath: "position.x")
    flyLeft.fromValue = info.layer.position.x + view.frame.size.width
    flyLeft.toValue = info.layer.position.x
    flyLeft.duration = 5.0
    
    //repeat animations
//    flyLeft.repeatCount = 4
//    flyLeft.autoreverses = true
//    flyLeft.speed = 2.0
    info.layer.add(flyLeft, forKey: "infoappear")
    
    let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
    fadeLabelIn.fromValue = 0.2
    fadeLabelIn.toValue = 1.0
    fadeLabelIn.duration = 4.5
    info.layer.add(fadeLabelIn, forKey: "fadein")
    
    username.delegate = self
    password.delegate = self
  }
  
  func showMessage(index: Int) {
    label.text = messages[index]
    UIView.transition(with: status, duration: 0.33,
                      options: [.curveEaseOut, .transitionFlipFromBottom],
                      animations: {
                          self.status.isHidden = false
                      },
                      completion: { _ in
                        delay(2.0) {
                          if index < self.messages.count - 1 {
                            self.removeMessage(index: index)
                          } else {
                            self.resetForm()
                          }
                        }
                      }
    )
  }
  
  func removeMessage(index: Int) {
    UIView.animate(withDuration: 0.33, delay: 0.0, options: [],
      animations: {
        self.status.center.x += self.view.frame.size.width
      },
      completion: { _ in
        self.status.isHidden = true
        self.status.center = self.statusPosition
        self.showMessage(index: index + 1)
      }
    )
  }
  
  
  func resetForm() {
    UIView.transition(with: status, duration: 0.2,
                      options: [.curveEaseOut, .transitionFlipFromTop],
                      animations: {
                          self.status.isHidden = true
                          self.statusPosition = self.status.center
                      },
                      completion: { _ in
                        // nothing
                      }
    )
    
    UIView.animate(withDuration: 0.33,
                   delay: 0.0,
                   animations: {
      self.spinner.center = CGPoint(x: -20, y: 16)
      self.spinner.alpha = 0.0
//      self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
      self.loginButton.bounds.size.width -= 80
      self.loginButton.center.y -= 60
    },
                   completion: { _ in
      let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35,
      alpha: 1.0)
        tintBackgroundColor(layer: self.loginButton.layer, toColor:
      tintColor)
      self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
      roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
      self.loginButton.layer.cornerRadius = 10.0
    })
  }
  
  func animateCloud(layer: CALayer) {
//    let cloudSpeed = 60 / view.frame.size.width
//    let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
//
//    UIView.animate(withDuration: TimeInterval(duration), delay: 0.0,
//                   options: .curveLinear,
//                   animations: {
//                      cloud.frame.origin.x = self.view.frame.size.width
//                    },
//                   completion: { _ in
//                      cloud.frame.origin.x = -cloud.frame.size.width
//                      self.animateCloud(cloud)
//                    }
//    )
    
    //challenge chap 11
    
    //1
      let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
      let duration: TimeInterval = Double(
        view.layer.frame.size.width - layer.frame.origin.x)
        * cloudSpeed
    //2
      let cloudMove = CABasicAnimation(keyPath: "position.x")
      cloudMove.duration = duration
      cloudMove.toValue = self.view.bounds.width +
        layer.bounds.width / 2
      cloudMove.delegate = self
      cloudMove.setValue("cloud", forKey: "name")
      cloudMove.setValue(layer, forKey: "layer")
      layer.add(cloudMove, forKey: nil)
  }
  
  
  // MARK: further methods
  
  @IBAction func login() {
    view.endEditing(true)
    
    UIView.animate(withDuration: 1.5, delay: 0.0,
                   usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0,
                   options: [], animations: {
                      self.loginButton.bounds.size.width += 80.0 //increase button's width by 80
                   },
                   completion: { _ in
                     self.showMessage(index: 0)
                   }
    )
    
    UIView.animate(withDuration: 0.33, delay: 0.0,
                   usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0,
                   options: [],
                   animations: {
      self.loginButton.center.y += 60.0 // increase button's vertical position by 60
//      self.loginButton.backgroundColor =
//      UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
      self.spinner.center = CGPoint(
        x: 40.0,
        y: self.loginButton.frame.size.height/2
      )
      self.spinner.alpha = 1.0
    }, completion: nil)
    
    let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
    tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
    loginButton.layer.backgroundColor = tintColor.cgColor
    
    roundCorners(layer: loginButton.layer, toRadius: 25.0)
    self.loginButton.layer.cornerRadius = 25
  }
  
  // MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField?.becomeFirstResponder()
    return true
  }
}

extension ViewController: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    print("animation did finish")
    guard let name = anim.value(forKey: "name") as? String else {
      return
    }
    if name == "form" {
      let layer = anim.value(forKey: "layer") as? CALayer
      anim.setValue(nil, forKey: "layer")
      let pulse = CABasicAnimation(keyPath: "transform.scale")
      pulse.fromValue = 1.25
      pulse.toValue = 1.0
      pulse.duration = 0.25
      layer?.add(pulse, forKey: nil)
    }
  }
}

extension ViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    guard let runningAnimations = info.layer.animationKeys() else {
      return
    }
    print(runningAnimations)
    info.layer.removeAnimation(forKey: "infoappear")
  }
}
