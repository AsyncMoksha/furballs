//
//  ItemShopScene.h
//  PAWS
//
//  Created by Zinan Xing on 10/15/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemShopLayer.h"
#import "cocos2d.h"

@interface ItemShopGUILayer : CCLayer 
@end


@interface ItemShopScene : CCScene {
    ItemShopLayer *shopLayer;
    ItemShopGUILayer *shopGUILayer;
    
}
@property (nonatomic,retain) ItemShopLayer *shopLayer;
@property (nonatomic,retain) ItemShopGUILayer *shopGUILayer;
@end
