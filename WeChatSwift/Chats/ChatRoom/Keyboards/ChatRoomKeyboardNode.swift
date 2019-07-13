//
//  ChatRoomKeyboardNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomKeyboardNode: ASDisplayNode {
    
    private var lastKeyboardOffsetY: CGFloat = 0.0
    
    private let toolBar = ChatRoomToolBarNode()
    
    private let emotionPanel = ChatRoomEmotionPanelNode(expressions: Expression.all)
    
    private let toolsPanel = ChatRoomToolPanelNode(tools: ChatRoomTool.allCases)
    
    override init() {
        super.init()
        
        addSubnode(toolBar)
        addSubnode(emotionPanel)
        addSubnode(toolsPanel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func didLoad() {
        super.didLoad()
        
        toolBar.frame = bounds
        toolBar.backgroundColor = UIColor(hexString: "#F5F6F7")
        emotionPanel.frame = CGRect(x: 0, y: Constants.screenHeight, width: Constants.screenWidth, height: 216)
        toolsPanel.frame = CGRect(x: 0, y: Constants.screenHeight, width: Constants.screenWidth, height: 216)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        switch toolBar.keyboard {
        case .emotion:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.toolsPanel.isHidden = true
                self.emotionPanel.isHidden = false
                self.lastKeyboardOffsetY = self.frame.origin.y
                
                self.frame = CGRect(x: 0, y: self.supernode!.frame.height - self.bounds.height, width: Constants.screenWidth, height: self.bounds.height)
                
            }, completion: nil)
        case .tools:
            print("....")
        case .none:
            guard let beginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
                let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                    return
            }
            let superNodeHeight = supernode?.bounds.height ?? Constants.screenHeight
            let targetY = endFrame.origin.y - toolBar.bounds.height - (Constants.screenHeight - superNodeHeight)
            UIView.animate(withDuration: 0.25) {
                if beginFrame.size.height >= 0 && beginFrame.origin.y - endFrame.origin.y > 0 {
                    self.lastKeyboardOffsetY = self.frame.origin.y
                    self.frame.origin = CGPoint(x: 0, y: targetY)
                } else if endFrame.origin.y == Constants.screenHeight && beginFrame.origin.y != endFrame.origin.y && duration > 0 {
                    
                }
            }
            
        default:
            break
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: toolBar)
    }
}
