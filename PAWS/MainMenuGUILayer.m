//
//  MainMenuGUILayer.m
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "MainMenuGUILayer.h"
#import "FractionScene.h"
#import <Foundation/NSException.h>
#import "SimpleAudioEngine.h"

@implementation MainMenuGUILayer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
         CGSize size = [[CCDirector sharedDirector] winSize];      
         
         
         //Set background into middle of screen
         
         CCSprite *_bg = [CCSprite spriteWithFile:@"MainmenuBG.png"];
         _bg.position = ccp(size.width/2,size.height/2);
        [self addChild:_bg z:0 tag:BGTAG];
        
        //MenuItems
        
        CCMenuItemImage *startBtn = [CCMenuItemImage itemFromNormalImage:@"startBtn_N.png" 
                                                           selectedImage:@"startBtn_A.png"  
                                                                  target:self selector:@selector(startBtnClicked)];
        startBtn.position = ccp(225.0f,50.0f);
        
        CCMenuItemImage *optionBtn = [CCMenuItemImage itemFromNormalImage:@"optionBtn_N.png" 
                                                            selectedImage:@"optionBtn_A.png"  
                                                                   target:self selector:@selector(optionBtnClicked)];
        optionBtn.position = ccp(105.0f,50.0f);
        
        CCMenuItemImage *storeBtn = [CCMenuItemImage itemFromNormalImage:@"storeBtn_N.png" 
                                                           selectedImage:@"storeBtn_A.png"  
                                                                  target:self selector:@selector(storeBtnClicked)];
        storeBtn.position = ccp(345.0f,50.0f);
        
        CCMenu *mainMenu = [CCMenu menuWithItems:startBtn, optionBtn, storeBtn, nil];
        mainMenu.position = CGPointZero;
        [self addChild:mainMenu z:1 tag:MENUTAG];
        
        //Background Music
        //Ref: http://www.raywenderlich.com/352/how-to-make-a-simple-iphone-game-with-cocos2d-tutorial
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        
        //Stop Music
        //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    }
    
    return self;
}

//OnClick Function
-(void)startBtnClicked{
    //Transition to Fraction Scene
    @try {
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[FractionScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}
-(void)optionBtnClicked{
    
}
-(void)storeBtnClicked{
    
}
@end
