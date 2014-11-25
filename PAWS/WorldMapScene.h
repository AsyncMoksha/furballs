//
//  WorldMapScene.h
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SoundEffects.h"
#import "ProfileLayer.h"
#import "ItemShopLayer.h"
#import "ItemShopScene.h"

@interface WorldMapGUILayer : CCLayer {
    CCMenu* mainMenu;
}
@property (nonatomic,retain) CCMenu *mainMenu;
@end

@interface WorldMapLevelLayer : CCLayer{
    CCSprite *background;
}

@property (nonatomic,retain) CCSprite *background;

-(void)enterLevel:(id)sender;

@end

@interface WorldMapScene : CCScene{
    WorldMapGUILayer *_guiLayer;
    WorldMapLevelLayer *_levelLayer;
    BOOL isOpenItemShop;
}
@property (nonatomic,retain) WorldMapLevelLayer *levelLayer;
@property (nonatomic,retain) WorldMapGUILayer *guiLayer;
@property (nonatomic,assign) BOOL isOpenItemShop;
@end
