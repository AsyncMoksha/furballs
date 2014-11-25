//
//  PauseLayer.m
//  PAWS
//
//  Created by Zinan Xing on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"
#import "BattleScene.h"
#import "MainMenuScene.h"

@implementation PauseLayer
-(id)init{
    if( self = [super init] ){
    
        CGSize size = [[CCDirector sharedDirector] winSize];  

    
        //Create Background
    
        CCSprite *_bg = [CCSprite spriteWithFile:@"PauseLayerBG.png"];
        _bg.position = ccp(size.width/2,size.height/2);
    
        [self addChild:_bg z:0];
    
        //Unpause Button
        CCMenuItemImage *unpauseBtn = [CCMenuItemImage itemFromNormalImage:@"PauseLayer_unpauseBtn.png" 
                                                          selectedImage:@"PauseLayer_unpauseBtn.png"  
                                                                     target:self selector:@selector(unPauseClicked)];
        unpauseBtn.position = ccp(0,40);

        //Surrender
        CCMenuItemImage *surrenderBtn = [CCMenuItemImage itemFromNormalImage:@"PauseLayer_surrenderBtn.png" 
                                                             selectedImage:@"PauseLayer_surrenderBtn.png"  
                                                                    target:self selector:@selector(surrenderClicked)];
        surrenderBtn.position = ccp(0,-5);
        
        //Surrender
        CCMenuItemImage *backBtn = [CCMenuItemImage itemFromNormalImage:@"PauseLayer_backtomainBtn.png" 
                                                               selectedImage:@"PauseLayer_backtomainBtn.png"  
                                                                      target:self selector:@selector(backClicked)];
        backBtn.position = ccp(0,-50);
    
        CCMenu *mainMenu = [CCMenu menuWithItems:unpauseBtn,surrenderBtn,backBtn, nil];
        //mainMenu.position = CGPointZero;
        [self addChild:mainMenu z:1 ];
    
    }
    return self;
}

-(void)unPauseClicked{
    [[SimpleAudioEngine sharedEngine] playEffect:MAIN_MENU_BTN_EFFECT];
    BattleScene *parent = (BattleScene*)[self parent];
    [parent doResume];
}

-(void)surrenderClicked{
    BattleScene *parentScene = (BattleScene*)[self parent];
    [parentScene doResume];
    [parentScene playerLoseTransit];
}

-(void)backClicked{
    //Transition to MainMenu T T"
    @try {
        BattleScene *parent = (BattleScene*)[self parent];
        [parent doResume];
        [[SimpleAudioEngine sharedEngine] playEffect:MAIN_MENU_BTN_EFFECT];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}

-(void)dealloc{
    [super dealloc];
}
@end
