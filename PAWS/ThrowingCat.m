//
//  ThrowingCat.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/18/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "ThrowingCat.h"

@implementation ThrowingCat

@synthesize isInRange;

-(ThrowingCat*) initWithUnit: (Unit *) unit {
    self = [super init];
    if (self) {
        
        [self initWithClassName:unit.unitClassName andFlipX:unit.isFlipX];
        [self setUnitID: [unit unitID]];
        [self setHitPoint: [unit hitPoint]];
        [self setMaxHitPoint:[self hitPoint]];
        [self setAttack: [unit attack]];
        [self setAttackRange: [unit attackRange]];
        [self setAttackSpeed: [unit attackSpeed]];
        [self setSpeed: [unit speed]];
        [self setSpawnRate: [unit spawnRate]];
        [self setCoolDown: 0];
        [self setSkill: [unit skill]];
        [self setUnitName: [unit unitName]];
        [self setPosition:[unit position]];
        [self setFrameName: [NSString stringWithString:[unit frameName]]];
        [self setLevelSpeedFactor: [unit levelSpeedFactor]];
        self.stateTime = 0;
        [self setState: IDLE];
        [self setStatus:NORMAL];
        isInRange = NO;
    }
    return self;
}

-(CGRect)adjustedThrowBoundingBox {
    int adjustedWidth = 0;
    CGSize size = [[CCDirector sharedDirector] winSize];
    if ([self isFlipX]) {
        adjustedWidth = self.attackRange / 10.0 * size.width;
    } else {
        adjustedWidth = -25 - (self.attackRange / 10.0 * size.width);
    }
    CGRect unitBoundingBox = CGRectMake(
                                        self.position.x, 
                                        self.position.y, 
                                        kUnitWidth+adjustedWidth, 
                                        15.0);
    return unitBoundingBox;
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits{
    if ([self hitPoint] <= 0) {
        [self setState:DEAD];
        [self stopActionByTag:MOVEACTION];
        [self setFaceTexture:CRY];
        return;
    }
    
    if ([self updateOutOfBound]) {
        return;
    }
    
    // Collision detection
    [self updateHPLabel];
    CGRect playerRect = [self adjustedThrowBoundingBox];
    
    BOOL isIntersect = FALSE;
    
    //Do something
    for (Unit *enemyUnit in listOfEnemyUnits) {
        
        [enemyUnit updateHPLabel];
        
        CGRect enemyRect = [enemyUnit adjustedBoundingBox];
        
        if (
            CGRectIntersectsRect(playerRect, enemyRect) 
            && self.zOrder == enemyUnit.zOrder
            && [enemyUnit state] != RUN
            && [self state]!= RUN
            && [enemyUnit status] != GHOST
            ) {
            
            isIntersect = TRUE;
            if (
                [enemyUnit state] != DEAD 
                && [enemyUnit state] != JUMP  
                ) {
                [self stopActionByTag:MOVEACTION];
            }
            
            if ([self coolDown] <= 0 
                && (
                    [enemyUnit state] != DEAD 
                    && [enemyUnit state] != CRY 
                    )
                ) { 
                isInRange = YES;
                [self stopActionByTag:MOVEACTION];
                [self setState:BATTLE];
                //self.coolDown = [self attackSpeed];
                
                // This unit does not attack just throw
                //[self updateAttackLogicWithUnit:enemyUnit];
                
                
                if([enemyUnit hitPoint]<=0){ 
                    // if enemy hp goes below 0 remove 
                    [enemyUnit setState:CRY];
                    [self setState:IDLE];
                    [self setFaceTexture:IDLE];
                }  //End attack
            } else if ( [enemyUnit state] == DEAD 
                       || [enemyUnit state] == CRY
                       || [enemyUnit hitPoint]<=0
                       ) {
                if ([self state] != WALK) {
                    
                    [self setState:IDLE];
                    [self setFaceTexture:IDLE];
                }
                
            }
        }        
    }
    
    if (!isIntersect) {
        if([self isBattleStance]){
            //Move action is stopped and all parts are ready
            [self setState:IDLE];
            [self setFaceTexture:IDLE];
            isInRange = NO;
        }
        
    }
    
    if ([self numberOfRunningActions] == 0 || [self state] == WALK
        || [self state] == IDLE 
        ) {
        if (self.state == DEAD){
            [self.hpLabel setVisible:NO];
            return; // Nothing to do if the unit is dead
        }
        
        if (self.state == FINISHED) {
            [self.hpLabel setVisible:NO];
            [self setVisible:NO];
            return;
        } 
        
        if(self.state == BATTLE){
            if(self.numberOfRunningActions >0){
                //Still moving so stop move action
                [self stopActionByTag:MOVEACTION];
                return;
            }else if([self isAllPartsStopMoving]){
                //Move action is stopped and all parts are ready
                [self setBattleStance];
                [self animateBattle];
            }
        }
        
        if(self.state == WALK){
            if([self isAllPartsStopMoving]){
                //Continue animate walk if one cycle is ended
                [self animateWalk];
            }
        }
        
        if(self.state == IDLE){
            [self stopActionByTag:MOVEACTION];
            if(self.isBattleStance){
                //He is in battle stance, so change it back to normal
                isInRange = NO;
                [self setNormalStance];
            }else if([self numberOfRunningActions] == 0 
                     && [self isAllPartsStopMoving]){
                //Check self's action to ensure change on normal stance
                //Originally he will continue walking to goal
                
                [self setState:WALK];
                [self doMoveAction];
                
            }
        }
        
        if(self.state == CRY){
            [[self hpLabel] setVisible:NO];
            if([self isAllPartsStopMoving]){
                if(self.isBattleStance){
                    [self setNormalStance];
                }
                [self setFaceTexture:CRY];
                [self doFadeOut];
                [self setState:DEAD];
            }
            return;
        }
        
        if(self.state == FLIP) {
            [self stopActionByTag:MOVEACTION];
            return;
        }
    }

}



@end
