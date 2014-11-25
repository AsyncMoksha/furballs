//
//  HealerCat.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/31/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "HealerCat.h"

@implementation HealerCat

@synthesize healCoolDown;
@synthesize healPower;

-(HealerCat*) initWithUnit: (Unit *) unit{
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
        [self setHealPower:kHealPower];
        [self setLevelSpeedFactor: [unit levelSpeedFactor]];
        self.stateTime = 0;
        [self setState: IDLE];
        [self setStatus:NORMAL];
    }
    return self;
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime 
              andListOfAllyUnits:(NSMutableArray *)listOfAllyUnits 
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits{
    
    
    
    if ([self hitPoint] <= 0) {
        [self setState:DEAD];
        [self setFaceTexture:CRY];
        return;
    }
    /*
    if ([self state] == SCARED) {
        [self stopActionByTag:MOVEACTION];
        [self setState:RUN];
        return;
    }
    
    if ([self state] == RUN) {
        // Just run!
        //[self stopActionByTag:MOVEACTION];
        if([self numberOfRunningActions] == 0 
           && [self isAllPartsStopMoving]){
            //Check self's action to ensure change on normal stance
            //Originally he will continue walking to goal
            [self doMoveAction];
        }
        
        if ([self isAllPartsStopMoving]) {
            [self animateWalk];
        }
        return;
    }
    */
    if(self.state == IDLE){
        if(self.isBattleStance){
            //He is in battle stance, so change it back to normal
            [self setNormalStance];
        }else if([self numberOfRunningActions] == 0 
                 && [self isAllPartsStopMoving]){
            //Check self's action to ensure change on normal stance
            //Originally he will continue walking to goal
            [self setState:WALK];
            [self doMoveAction];
            
        }
    }
    
    if ([self updateOutOfBound]) {
        return;
    }
    
    // Collision detection
    [self updateHPLabel];
    CGRect playerBattleRect = [self adjustedBoundingBox];
    
    BOOL isIntersect = FALSE;
    
    for (Unit *allyUnit in listOfAllyUnits) {
        CGRect allyRect = [allyUnit adjustedBoundingBox];
        if (
            CGRectIntersectsRect(playerBattleRect, allyRect) 
            && self.zOrder == allyUnit.zOrder
            && ([allyUnit hitPoint] < [allyUnit maxHitPoint])
            ) {
            
            isIntersect = TRUE;
            if ([allyUnit  state] != DEAD) {
                [self stopActionByTag:MOVEACTION];
            }
            
            if ([self healCoolDown] <= 0 
                && ([allyUnit state] != DEAD && [allyUnit state] != CRY)
                && ([allyUnit hitPoint] < [allyUnit maxHitPoint])
                ) { 
                self.healCoolDown = self.attackSpeed;
                allyUnit.hitPoint = (
                                      allyUnit.hitPoint + self.healPower 
                                      > allyUnit.maxHitPoint
                                      ) ? allyUnit.maxHitPoint: 
                                          allyUnit.hitPoint + self.healPower;
            }
        }
        
    }
    
    //Do something
    for (Unit *enemyUnit in listOfEnemyUnits) {
        
        [enemyUnit updateHPLabel];
        
        CGRect enemyRect = [enemyUnit adjustedBoundingBox];
        
        if (
            CGRectIntersectsRect(playerBattleRect, enemyRect) 
            && self.zOrder == enemyUnit.zOrder
            && [enemyUnit state] != RUN
            ) {
            
            isIntersect = TRUE;
            if ([enemyUnit state] != DEAD) {
                [self stopActionByTag:MOVEACTION];
            }
            
            if ([self coolDown] <= 0 
                && ([enemyUnit state] != DEAD && [enemyUnit state] != CRY)
                ) { 
                [self stopActionByTag:MOVEACTION];
                [self setState:BATTLE];
                //[enemyUnit setState:CRY];
                
                [self updateAttackLogicWithUnit:enemyUnit];
                
                if([enemyUnit hitPoint]<=0){ 
                    // if enemy hp goes below 0 remove 
                    //[self printState: self.state];
                    [enemyUnit setState:CRY];
                    //[listOfEnemyUnits removeObject:enemyUnit];
                    if ([self isBattleStance]) {
                        [self setNormalStance];
                    }
                    [self setState:IDLE];
                    [self setFaceTexture:IDLE];
                }  //End attack
            } else if ( [enemyUnit state] == DEAD 
                       || [enemyUnit state] == CRY
                       //&& [self isBattleStance]
                       ) {
                if ([self state] != WALK) {
                    if ([self isBattleStance]) {
                        [self setNormalStance];
                    }
                    [self setState:IDLE];
                    [self setFaceTexture:IDLE];
                }
                
            }
        }
    }
    
    if (!isIntersect ) {
        if(
           [self isBattleStance]
           && [self state] != DEAD
           && [self numberOfRunningActions] == 0
           ){
            //Move action is stopped and all parts are ready
            [self setNormalStance];
            [self setState:WALK];
            [self setFaceTexture:WALK];
        }
        
    }
    
    if(
       self.numberOfRunningActions == 0 
       || self.state == WALK
       || self.state == IDLE
       ){
        
        if (self.state == DEAD){
            [self.hpLabel setVisible:NO];
            //[self setFaceTexture:CRY];
            //[self doFadeOut];
            
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
        
        if(self.state == IDLE){
            if(self.isBattleStance){
                //He is in battle stance, so change it back to normal
                [self setNormalStance];
            }else if([self numberOfRunningActions] == 0 
                     && [self isAllPartsStopMoving]){
                //Check self's action to ensure change on normal stance
                //Originally he will continue walking to goal
                [self setState:WALK];
                [self doMoveAction];
                
            }
        }
        
        if(self.state == WALK){
            if([self isAllPartsStopMoving]){
                //Continue animate walk if one cycle is ended
                //if ([[self getActionByTag:JUMPACTION] isDone]) {
                [self animateWalk];
                //}
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
        
    }
}

- (void) updateCoolDown {
    if (self.coolDown > 0) {
        self.coolDown--;
    }
    
    if (self.healCoolDown >0) {
        self.healCoolDown--;
    }
    
}



@end
