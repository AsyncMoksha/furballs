//
//  DialogueTest.m
//  PAWS
//
//  Created by Pisit Praiwattana on 10/24/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "DialogueTest.h"
#import "MainMenuScene.h"

@implementation DialogueTest
@synthesize guilayer = _guilayer;
@synthesize layer = _layer;
@synthesize event = _event;
-(id) init{
    self = [super init];
    if(self){
        _guilayer = [[DialogGUILayer alloc] init];
        _layer = [[DialogLayer alloc] initWithBMFont:@"AppleLiGothic_Black18.fnt" andDialog:@"dialog1"];
        _event = [[EventLayer alloc]init];
        [self addChild:_layer z:1 tag:1];
        [self addChild:_guilayer z:2 tag:2];
        [self addChild:_event z:3 tag:3];
    }
    return self;
}
-(void) dealloc{
    //[_guilayer release];
    //_guilayer = nil;
    //[_layer release];
    //_layer = nil;
    [super dealloc];
}
@end

//Dialogue Layer
@implementation DialogGUILayer
-(id) init{
    self = [super init];
    if(self){
        
        //MenuItems
        CCMenuItemImage *openBtn = [CCMenuItemImage itemFromNormalImage:@"TestButton.png" 
                                                          selectedImage:@"TestButton.png"  
                                                                 target:self selector:@selector(opentnClicked)];
        openBtn.position = ccp(100 + openBtn.contentSize.width/2,openBtn.contentSize.height/2 + 5);
        
        CCMenuItemImage *battleBtn = [CCMenuItemImage itemFromNormalImage:@"TestButton2.png" 
                                                          selectedImage:@"TestButton2.png"  
                                                                 target:self selector:@selector(battlebtnClicked)];
        battleBtn.position = ccp(200 + openBtn.contentSize.width/2,openBtn.contentSize.height/2 + 5);
        
        CCMenuItemImage *backBtn = [CCMenuItemImage itemFromNormalImage:@"StoreBackBtn_N.png" 
                                                          selectedImage:@"StoreBackBtn_A.png"  
                                                                 target:self selector:@selector(backBtnClicked)];
        backBtn.position = ccp(300 + backBtn.contentSize.width/2,backBtn.contentSize.height/2);
        
        
        CCMenu *mainMenu = [CCMenu menuWithItems:openBtn, battleBtn, backBtn, nil];
        mainMenu.position = CGPointZero;
        [self addChild:mainMenu z:1];
        
        //Enable touch
        self.isTouchEnabled = true; 
    }
    return self;
}


-(void) opentnClicked{
    //CCLOG(@"Open Dialog!");
    DialogueTest *parentNode = (DialogueTest*)[self parent];
    //[(DialogLayer*)[parentNode getChildByTag:1] openStoryDialog];
    //[parentNode removeChildByTag:212 cleanup:true];
    
    [[parentNode event] popIconInCenterWithFile:@"victory_event.png" withScale:0.75f andSecond:2.0f]; 
    
}
-(void)battlebtnClicked{
    DialogueTest *parentNode = (DialogueTest*)[self parent];
    [[parentNode event] popIconInFromLeftWithFile:@"battle_event.png" withScale:0.75f andSecond:2.0f];
}
-(void) backBtnClicked{
    //Transition to MainMenu Scene
    @try {
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}


-(void) dealloc{

    [super dealloc];
}

@end
