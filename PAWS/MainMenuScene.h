//
//  MainMenuScene.h
//  PAWS
//
//  Created by Zinan Xing on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SoundEffects.h"
#define BGTAG 0
#define MENUTAG 1

@interface MainMenuGUILayer : CCLayer{
    
}
@end

@interface MainMenuScene : CCScene{
    MainMenuGUILayer *_layer;
}
@property (nonatomic,retain)  MainMenuGUILayer *layer;

@end
