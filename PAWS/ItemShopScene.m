//
//  ItemShopScene.m
//  PAWS
//
//  Created by Zinan Xing on 10/15/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "ItemShopScene.h"
#import "WorldMapScene.h"
@implementation ItemShopScene
@synthesize shopLayer;
@synthesize shopGUILayer;
-(id) init{
    self = [super init];
    if(self){
        shopLayer = [[ItemShopLayer alloc] init];
        shopGUILayer = [ItemShopGUILayer node];
        [self addChild:shopLayer z:1];
        [self addChild:shopGUILayer z:2];
    }
    return self;
}
-(void) dealloc{
    //CCTransition did clean up by calling remove all child - so no manual dealloc or it will be SIGBERT
    shopLayer = nil;
    shopGUILayer = nil;
    [super dealloc];
}
@end


@implementation ItemShopGUILayer
-(id)init{
    self = [super init];
    if(self){
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *topBar = [CCSprite spriteWithFile:@"ItemShopTBar.png"];
        CCSprite *btmBar = [CCSprite spriteWithFile:@"ItemShopBBar.png"];
        
        topBar.anchorPoint = ccp(0,0.5);
        topBar.position = ccp(0, size.height - topBar.contentSize.height/2);
        btmBar.anchorPoint = ccp(0,0.5);
        btmBar.position = ccp(0, btmBar.contentSize.height/2);
        
        [self addChild:topBar z:1];
        [self addChild:btmBar z:1];
        
        //BackButton
        CCMenuItemImage *backBtn = [CCMenuItemImage itemFromNormalImage:@"ItemShopBackBtn.png" 
                                                          selectedImage:@"ItemShopBackBtn.png"  
                                                                 target:self selector:@selector(backBtnClicked)];
        backBtn.position = ccp(size.width - backBtn.contentSize.width/2 - 15.0f, backBtn.contentSize.height/2 + 5.0f);
        
        //BackButton
        CCMenuItemImage *upBtn = [CCMenuItemImage itemFromNormalImage:@"UpArrow.png" 
                                                          selectedImage:@"UpArrow.png"  
                                                                 target:self selector:@selector(upBtnClicked)];
        upBtn.position = ccp(size.width/2, backBtn.contentSize.height/2 + 5.0f);
        
        //BackButton
        CCMenuItemImage *downBtn = [CCMenuItemImage itemFromNormalImage:@"DownArrow.png" 
                                                          selectedImage:@"DownArrow.png"  
                                                                 target:self selector:@selector(downBtnClicked)];
        downBtn.position = ccp(size.width/2 + backBtn.contentSize.width/2 + 30.0f, backBtn.contentSize.height/2 + 5.0f);
        
        CCMenu *guiMenu = [CCMenu menuWithItems:backBtn, upBtn, downBtn, nil];
        guiMenu.position = CGPointZero;
        [self addChild:guiMenu z:2];
    }
    return self;
}

//OnClicked function
-(void) backBtnClicked{
    //Transition to MainMenu Scene
    @try {
        [[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInT transitionWithDuration:0.2f scene:[WorldMapScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}

//OnClicked function
-(void) upBtnClicked{
    ItemShopScene *parent = (ItemShopScene*)[self parent];
    id moveUp = [CCMoveBy actionWithDuration:0.3f position:ccp(0,-40)];
    [parent.shopLayer.itemshopMenu runAction:moveUp];
}

//OnClicked function
-(void) downBtnClicked{
    ItemShopScene *parent = (ItemShopScene*)[self parent];
    id moveDown = [CCMoveBy actionWithDuration:0.3f position:ccp(0,40)];
    [parent.shopLayer.itemshopMenu runAction:moveDown];
}
@end