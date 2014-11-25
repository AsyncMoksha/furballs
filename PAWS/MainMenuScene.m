//
//  MainMenuScene.m
//  PAWS
//
//  Created by Zinan Xing on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "FractionScene.h"
#import "StoreScene.h"
#import <Foundation/NSException.h>
#import "SimpleAudioEngine.h"
#import "OptionScene.h"
#import "BattleScene.h"
#import "SimpleAudioEngine.h"
#import "DialogueTest.h"

//Scene Implementation
@implementation MainMenuScene
@synthesize layer = _layer;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.layer = [MainMenuGUILayer node];
        [self addChild:_layer];
    }
    
    return self;
}

-(void) dealloc{
    //Dealloc GUILayer
    [_layer release];
    _layer = nil;
    
    [super dealloc];
}
@end

//GUI-Layer Implementation
@implementation MainMenuGUILayer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        CGSize size = [[CCDirector sharedDirector] winSize];      
        
        
        //Set background into middle of screen
        
        CCSprite *_bg = [CCSprite spriteWithFile:@"mainBackground.png"];
        _bg.position = ccp(size.width/2,size.height/2);
        [self addChild:_bg z:0 tag:BGTAG];
        
        //MenuItems
        
        CCMenuItemImage *startBtn = [CCMenuItemImage itemFromNormalImage:@"Mainmenu_start.png" 
                                                           selectedImage:@"Mainmenu_start.png"  
                                                                  target:self selector:@selector(startBtnClicked)];
        startBtn.position = ccp(82.0f,50.0f);
        
        CCMenuItemImage *optionBtn = [CCMenuItemImage itemFromNormalImage:@"Mainmenu_option.png" 
                                                            selectedImage:@"Mainmenu_option.png"  
                                                                   target:self selector:@selector(optionBtnClicked)];
        optionBtn.position = ccp(237.0f,50.0f);
        
        CCMenuItemImage *storeBtn = [CCMenuItemImage itemFromNormalImage:@"Mainmenu_store.png" 
                                                           selectedImage:@"Mainmenu_store.png"  
                                                                  target:self selector:@selector(storeBtnClicked)];
        storeBtn.position = ccp(398.0f,50.0f);
        
        
        
        CCMenu *mainMenu = [CCMenu menuWithItems:startBtn, optionBtn, storeBtn, nil];
        mainMenu.position = CGPointZero;
        [self addChild:mainMenu z:1 tag:MENUTAG];
        
        //Background Music - Borrowed for testing audio
        //Ref: http://www.raywenderlich.com/352/how-to-make-a-simple-iphone-game-with-cocos2d-tutorial
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        //Pisit Original test BG sound
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:NORMAL_BGM];
        [[SimpleAudioEngine sharedEngine] preloadEffect:MAIN_MENU_BTN_EFFECT];
        //Stop Music
        //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
    
    return self;
}

//OnClick Function
-(void)startBtnClicked{
    //Transition to Fraction Scene
    @try {
        [[SimpleAudioEngine sharedEngine] playEffect:MAIN_MENU_BTN_EFFECT];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[FractionScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}
-(void)optionBtnClicked{
    //Transition to Option Scene
    @try {
        [[SimpleAudioEngine sharedEngine] playEffect:MAIN_MENU_BTN_EFFECT];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[OptionScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}
-(void)storeBtnClicked{
    //Transition to Store Scene
    @try {
        [[SimpleAudioEngine sharedEngine] playEffect:MAIN_MENU_BTN_EFFECT];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[[StoreScene alloc] initWithIsFromUpgradeScene: NO]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}

-(void)testBtnClicked{
    //Transition to Store Scene
    @try {
        //[[SimpleAudioEngine sharedEngine] playEffect:@"main-menu-click.wav"];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[DialogueTest node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}

-(void)dealloc{
    
    [super dealloc];
}
@end