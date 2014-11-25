//
//  ItemShopLayer.m
//  PAWS
//
//  Created by Zinan Xing on 10/12/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "ItemShopLayer.h"
#import "WorldMapScene.h"

@implementation ItemShopLayer
@synthesize itemshopMenu;
- (id)init
{
    self = [super initWithColor:ccc4(149, 149, 149, 255)];
    if (self) {
        // Initialization code here.
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"ItemBar1.png" selectedImage:@"ItemBar1.png" target:self selector:@selector(checkSelectedItem:)];
        item1.anchorPoint = ccp(0.5,1);
        
        CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"ItemBar1.png" selectedImage:@"ItemBar1.png" target:self selector:@selector(checkSelectedItem:)];
        item2.anchorPoint = ccp(0.5,1);
        
        CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"ItemBar1.png" selectedImage:@"ItemBar1.png" target:self selector:@selector(checkSelectedItem:)];
        item3.anchorPoint = ccp(0.5,1);
        
        CCMenuItemImage *item4 = [CCMenuItemImage itemFromNormalImage:@"ItemBar1.png" selectedImage:@"ItemBar1.png" target:self selector:@selector(checkSelectedItem:)];
        item4.anchorPoint = ccp(0.5,1);
        
        float beginX = size.width/2;
        float spacing = 8;
        float beginY = size.height*0.88f;
        float boxHeight = item1.contentSize.height;
        item1.position = ccp(beginX,beginY);
        item2.position = ccp(beginX,beginY - boxHeight - spacing);
        item3.position = ccp(beginX,beginY - 2*boxHeight - 2*spacing);
        item4.position = ccp(beginX,beginY - 3*boxHeight - 3*spacing);
        /*
        CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"ItemIcon1.png" selectedImage:@"ItemIcon1.png" target:self selector:@selector(checkSelectedItem:)];
        
        CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"ItemIcon1.png" selectedImage:@"ItemIcon1.png" target:self selector:@selector(checkSelectedItem:)];
        CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"ItemIcon1.png" selectedImage:@"ItemIcon1.png" target:self selector:@selector(checkSelectedItem:)];
        CCMenuItemImage *item4 = [CCMenuItemImage itemFromNormalImage:@"ItemIcon1.png" selectedImage:@"ItemIcon1.png" target:self selector:@selector(checkSelectedItem:)];
        
        CCMenuItemImage *item5 = [CCMenuItemImage itemFromNormalImage:@"ItemIcon1.png" selectedImage:@"ItemIcon1.png" target:self selector:@selector(checkSelectedItem:)];
        CCMenuItemImage *item6 = [CCMenuItemImage itemFromNormalImage:@"ItemIcon1.png" selectedImage:@"ItemIcon1.png" target:self selector:@selector(checkSelectedItem:)];
        CCMenuItemImage *item7 = [CCMenuItemImage itemFromNormalImage:@"ItemIcon1.png" selectedImage:@"ItemIcon1.png" target:self selector:@selector(checkSelectedItem:)];
        CCMenuItemImage *item8 = [CCMenuItemImage itemFromNormalImage:@"ItemIcon1.png" selectedImage:@"ItemIcon1.png" target:self selector:@selector(checkSelectedItem:)];
        
        //Fist Row
        float beginX = -142;
        float spacing = 8;
        float beginY = size.height/2*0.3f;
        float boxWidth = item1.contentSize.width;
        item1.position = ccp(beginX, beginY);
        item2.position = ccp(beginX + boxWidth + spacing,beginY);
        item3.position = ccp(beginX + (boxWidth + spacing)*2,beginY);
        item4.position = ccp(beginX + (boxWidth + spacing)*3,beginY);
        //Second Row
        beginY = -size.height/2*0.3f;
        item5.position = ccp(beginX, beginY);
        item6.position = ccp(beginX + boxWidth + spacing,beginY);
        item7.position = ccp(beginX + (boxWidth + spacing)*2,beginY);
        item8.position = ccp(beginX + (boxWidth + spacing)*3,beginY);
        
        itemshopMenu = [CCMenu menuWithItems:
                                             item1, item2, item3, item4,
                                             item5, item6, item7, item8, nil];
         */
        itemshopMenu = [CCMenu menuWithItems:item1, item2, item3, item4, nil];
        itemshopMenu.position = CGPointZero;
        [self addChild:itemshopMenu z:2];
    }
    
    return self;
}

- (void)checkSelectedItem:(id)sender{
    CCLOG(@"Item is selected");
    id moveDown = [CCMoveBy actionWithDuration:0.3f position:ccp(0,25)];
    [self.itemshopMenu runAction:moveDown];
}


- (void)dealloc{
    [itemshopMenu release];
    itemshopMenu = nil;
}

@end
