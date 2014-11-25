//
//  FractionGUILayer.m
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "FractionGUILayer.h"
#import "SimpleAudioEngine.h"

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
        
        //Cat and Dog Sprite
        CCSprite *aCat = [CCSprite spriteWithFile:@"Cat.png"];
        aCat.position = ccp(size.width,size.height/2 - 15.0f);
        [self addChild:aCat z:3];
        CCSprite *aDog = [CCSprite spriteWithFile:@"Dog.png"];
        aDog.position = ccp(0.0f,size.height/2 - 30.0f);
        [self addChild:aDog z:2];
        
        //Action Animation on Dog and Cat Sprite 
        [aCat runAction:[CCMoveTo actionWithDuration:0.75f position: ccp(size.width/2 + 130.0f,size.height/2 - 15.0f)]];
        [aDog runAction:[CCMoveTo actionWithDuration:0.75f position: ccp(size.width/2 - 145.0f,size.height/2 - 15.0f)]];
        
        //MenuItems
        
        CCMenuItemImage *dogBtn = [CCMenuItemImage itemFromNormalImage:@"dogsBtn_N.png" 
                                                         selectedImage:@"dogsBtn_A.png"  
                                                                target:self selector:@selector(dogBtnClicked)];
        dogBtn.position = ccp(120.0f,60.0f);
        
        CCMenuItemImage *catBtn = [CCMenuItemImage itemFromNormalImage:@"catsBtn_N.png" 
                                                         selectedImage:@"catsBtn_A.png"  
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
    
}

-(void) catBtnClicked{
    
}
@end
