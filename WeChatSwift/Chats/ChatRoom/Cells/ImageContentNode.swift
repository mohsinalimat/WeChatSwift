//
//  ImageContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ImageContentNode: MessageContentNode {
    
    private let defaultImageSize = CGSize(width: 200, height: 200)
    
    private let imageNode: ASNetworkImageNode = ASNetworkImageNode()
    
    private let imageMsg: ImageMessage
    
    init(message: Message, imageMsg: ImageMessage) {
        self.imageMsg = imageMsg
        super.init(message: message)
        
        imageNode.cornerRadius = 6.0
        imageNode.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        imageNode.cornerRoundingType = .clipping
        addSubnode(imageNode)
        
        if let image = imageMsg.image {
            imageNode.image = image
        } else {
            imageNode.url = imageMsg.url
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let size = imageMsg.size == .zero ? defaultImageSize: imageMsg.size
        let ratio = size.height / size.width
        let ratioLayoutSpec = ASRatioLayoutSpec(ratio: ratio, child: imageNode)
        ratioLayoutSpec.style.maxSize = CGSize(width: Constants.screenWidth * 0.4, height: Constants.screenWidth * 0.4)
        let insets = UIEdgeInsets(top: 0, left: message.isOutgoing ? 0: 5, bottom: 0, right: message.isOutgoing ? 5: 0)
        return ASInsetLayoutSpec(insets: insets, child: ratioLayoutSpec)
    }
    
}
