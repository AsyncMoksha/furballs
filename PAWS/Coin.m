//
//  Coin.m
//  PAWS
//
//  Created by Zinan Xing on 10/16/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Coin.h"

@implementation Coin 

@synthesize amount;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        //self = (Coin *) [[CCSprite alloc] initWithFile:@"DummyUnit.png"];
        amount = kCoinAmount;
    }
    
    return self;
}

-(Coin*) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    //self = [[Coin alloc] initWithFile:@"DummyUnit.png"];
    //[self initWithSpriteFrameName:@"Coin1.png"];
    if (self) 
    {
        //self = [[Coin alloc] initWithFile:@"DummyUnit.png"];
        [self setDropPosition:[dictionary objectForKey:@"Position"]];
        [self setPath:[dictionary objectForKey:@"Path"]];
        [self setTime:[dictionary objectForKey:@"Time"]];
        [self setType:[dictionary objectForKey:@"Type"]];
        [self setGameObjectState:DROPPED];
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Coin_icon_76.png"]];
        CGSize size = [[CCDirector sharedDirector] winSize];
        float xPos = [[self dropPosition] floatValue];
        self.position = ccp(xPos, size.height - self.contentSize.height);
        
        amount = kCoinAmount;
    }
    
    return self;
}

-(Coin*) initWithRandomPositionWithTime: (int) interval {
    self = [super init];
    //self = [[Coin alloc] initWithFile:@"DummyUnit.png"];
    //[self initWithSpriteFrameName:@"Coin1.png"];
    if (self) 
    {
        int randomPath = (arc4random() % 3) + 1;
        float position = (arc4random() % 480);
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.position = ccp(position, size.height - self.contentSize.height);
        [self setPath:[NSNumber numberWithInt:randomPath]];
        [self setTime:[NSNumber numberWithInt:interval]];
        [self setType:[NSNumber numberWithInt:kCoinObject]];
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Coin_icon_76.png"]];
        amount = kCoinAmount;
    }
    
    return self;
}

-(CGRect) adjustedBoundingBox {
    //float offsetX = kUnitWidth/2;
    //float offsetY = kUnitHeight/2;
    CGRect unitBoundingBox = CGRectMake(
                                        self.position.x, 
                                        self.position.y-10, 
                                        40.0, 
                                        40.0);
    return unitBoundingBox;
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
           andListOfPlayerUnits:(NSMutableArray*)listOfPlayerUnits
            andListOfEnemyUnits:(NSMutableArray*)listOfEnemyUnits {
    
    if ([self gameObjectState] != DROPPED) {
        //Someone picked it up
        // Do nothing
        return;
    }
    
    CGRect coinRect = [self adjustedBoundingBox];
    for (Unit *unit in listOfPlayerUnits) {
        CGRect unitRect = [unit adjustedBoundingBox];
        
        if (CGRectIntersectsRect(coinRect, unitRect)) {
            [self setGameObjectState:COLLECTED];
            return;
        }
    }
    
    // Enemy's just passing by.
    /*
    for (Unit *unit in listOfEnemyUnits) {
        CGRect unitRect = [unit adjustedBoundingBox];
        
        if (CGRectIntersectsRect(coinRect, unitRect)) {
            [self setGameObjectState:REMOVED];
            return;
        }
    }
     */
}

-(void) doCollectAction {
    CGPoint destination;
    float moveDuration = 0.31417f;
    CCAction *moveAction = nil;
    
    destination = ccp(400,309);
    moveAction = [CCMoveTo actionWithDuration:moveDuration 
                                     position:destination];
    [moveAction setTag:COLLECTACTION];
    [self runAction:moveAction];
}

@end
