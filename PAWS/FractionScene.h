//
//  FractionSelectionScene.h
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SoundEffects.h"
#define BGTAG 0
#define MENUTAG 1

@interface FractionGUILayer : CCLayer{
}
@end

@interface FractionScene : CCScene{
    FractionGUILayer *_layer;
}
@property (nonatomic,retain) FractionGUILayer *layer;
@end
