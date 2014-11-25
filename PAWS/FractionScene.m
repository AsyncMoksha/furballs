//
//  FractionSelectionScene.m
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "FractionScene.h"
#import "WorldMapScene.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

//Scene Implementation
@implementation FractionScene
@synthesize layer = _layer;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [[SimpleAudioEngine sharedEngine] preloadEffect:CAT_MEW];
        [[SimpleAudioEngine sharedEngine] preloadEffect:DOG_BARK];
        self.layer = [FractionGUILayer node];
        [self addChild:_layer];
    }
    
    return self;
}
-(void) dealloc{
    //Dealloc our GUI layer
    [_layer release];
    _layer = nil;
    
    [super dealloc];
}
@end

//GUI-Layer Implementation
@implementation FractionGUILayer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        CGSize size = [[CCDirector sharedDirector] winSize];      
        
        
        //Set background into middle of screen
        
        CCSprite *_bg = [CCSprite spriteWithFile:@"FractionBG.png"];
        _bg.position = ccp(size.width/2,size.height/2);
        [self addChild:_bg z:0 tag:BGTAG];
        
        //Cat and Dog Sprite - dog left : cat right
        CCSprite *aCat = [CCSprite spriteWithFile:@"CatSide_sprite.png"];
        aCat.position = ccp(size.width,size.height/2);
        [self addChild:aCat z:3];
        CCSprite *aDog = [CCSprite spriteWithFile:@"DogSide_sprite.png"];
        aDog.position = ccp(0.0f,size.height/2);
        aDog.flipX = true;
        aDog.scale = 1.0f;
        [self addChild:aDog z:2];
        
        //Action Animation on Dog and Cat Sprite 
        [aCat runAction:[CCMoveTo actionWithDuration:0.75f position: ccp(size.width/2 + 190.0f,size.height/2)]];
        [aDog runAction:[CCMoveTo actionWithDuration:0.75f position: ccp(size.width/2 - 200.0f,size.height/2)]];
        
        //MenuItems
        
        CCMenuItemImage *dogBtn = [CCMenuItemImage itemFromNormalImage:@"Fraction_dog.png" 
                                                         selectedImage:@"Fraction_dog.png"  
                                                                target:self selector:@selector(dogBtnClicked)];
        dogBtn.position = ccp(120.0f,60.0f);
        
        CCMenuItemImage *catBtn = [CCMenuItemImage itemFromNormalImage:@"Fraction_cat.png" 
                                                         selectedImage:@"Fraction_cat.png"  
                                                                target:self selector:@selector(catBtnClicked)];
        catBtn.position = ccp(365.0f,60.0f);
        
        CCMenu *mainMenu = [CCMenu menuWithItems:dogBtn, catBtn, nil];
        mainMenu.position = CGPointZero;
        [self addChild:mainMenu z:4 tag:MENUTAG];
        
        
        
    }
    
    return self;
}

//OnClicked Function
-(void) dogBtnClicked{ 
    
    //Get the game manager singleton object
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GameManager *gameMan = [appDelegate gameManager];
    [gameMan setCurrentCampaign:CTDogs];
    
    //Transition to WorldMap Scene
    @try {
        [[SimpleAudioEngine sharedEngine] playEffect:DOG_BARK];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[WorldMapScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
    
}

-(void) catBtnClicked{
    
    //Get the game manager singleton object
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GameManager *gameMan = [appDelegate gameManager];
    [gameMan setCurrentCampaign:CTCats];
    
    //Transition to WorldMap Scene
    @try {
        [[SimpleAudioEngine sharedEngine] playEffect:CAT_MEW];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[WorldMapScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}



@end