//
//  ProjectileObject.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/18/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "ProjectileObject.h"

@implementation ProjectileObject

@synthesize damage;
@synthesize isInRange;
@synthesize shadowSprite;

-(ProjectileObject*) initWithUnit: (Unit*) unit {
    self = [super init];
    if(self) {
        self.position = unit.position;
        self.path = unit.path;
        self.damage = unit.attack;
        self.flipX = unit.isFlipX;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ThrowSprite_cat.png"]];
        self.scale = 0.5f;
        isInRange = NO;
        shadowSprite = [[CCSprite alloc ] initWithSpriteFrameName:@"ThrowSprite_shadow.png"];
        shadowSprite.position = ccp (
                                     unit.position.x,
                                     unit.position.y+10.0f
                                     );
        shadowSprite.scale = 0.5f;
        shadowSprite.position = ccp(
                                    self.position.x, 
                                    self.position.y - 25.0f
                                    );
        //[self addChild:shadowSprite];
    }
    return self;
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
            andListOfEnemyUnits:(NSMutableArray*)listOfEnemyUnits {
    
    //Do something
    CGRect playerRect = [self adjustedBoundingBox];
    BOOL isIntersect = FALSE;
    
    shadowSprite.position = ccp(self.position.x, self.position.y - 25.0f);
    
    for (Unit *enemyUnit in listOfEnemyUnits) {
        
        [enemyUnit updateHPLabel];
        
        CGRect enemyRect = [enemyUnit adjustedBoundingBox];
        
        if (
            CGRectIntersectsRect(playerRect, enemyRect) 
            //&& self.zOrder == enemyUnit.zOrder
            && [enemyUnit state] != RUN
            && [enemyUnit status] != GHOST
            ) {
            isIntersect = TRUE;
            if (
                [enemyUnit state] != DEAD 
                && [enemyUnit state] != JUMP  
                ) {
                [self stopAllActions];
                [self setGameObjectState:REMOVED];
                self.visible = NO;
                enemyUnit.hitPoint -= [self damage];
                if([enemyUnit hitPoint]<=0){ 
                    // if enemy hp goes below 0 remove 
                    [enemyUnit setState:CRY];
                } 
            }
            
        }        
    }
}

-(CGRect)adjustedBoundingBox {
    CGRect unitBoundingBox = CGRectMake(
                                        self.position.x, 
                                        self.position.y-10, 
                                        20.0, 
                                        20.0);
    return unitBoundingBox;
}

-(void) doMoveAction{
    //CCLOG(@"Called doMoveAction");
    CGPoint destination;
    float moveDuration = 0.0f;
    CCAction *moveAction = nil;
    if(![self flipX]){
        //Move Right - > Left
        destination = ccp(-20, self.position.y);
        moveDuration = (self.position.x)/(kProjectileSpeed);
    }else if([self flipX]){
        //Move Left to Right
        CGSize size = [[CCDirector sharedDirector] winSize];
        destination = ccp(size.width+20,self.position.y);
        moveDuration = (size.width - self.position.x) / (kProjectileSpeed);
    }
    moveAction = [CCMoveTo actionWithDuration:moveDuration 
                                     position:destination];
    if(moveAction){
        //CCLOG(@"run move action");
        [moveAction setTag:MOVEACTION];
        [self runAction:moveAction];
    }else{
        CCLOG(@"Error, no move action was generated");
    }
    
    [self runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:360]]];
    
    //[self.shadowSprite runAction:moveAction];
    
}

@end
