//
//  ItemShopLayer.h
//  PAWS
//
//  Created by Zinan Xing on 10/12/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface ItemShopLayer : CCLayerColor{
    CCMenu *itemshopMenu;
}
@property (nonatomic,retain) CCMenu *itemshopMenu;
@end
