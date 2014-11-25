//
//  GhostDog.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/5/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "GhostDog.h"

@implementation GhostDog

-(GhostDog*) initWithUnit: (Unit *) unit {
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
        [self setPosition:[unit position]];;
        [self setFrameName: [NSString stringWithString:[unit frameName]]];
        self.stateTime = 0;
        [self setState: IDLE];
        [self setStatus:GHOST];
        [self setLevelSpeedFactor: [unit levelSpeedFactor]];
    }
    return self;
}

-(CGRect) adjustedBoundingBox {
    int adjustedWidth = 0;
    if ([self isFlipX]) {
        adjustedWidth = 50;
    } else {
        adjustedWidth = -40;
    }
    CGRect unitBoundingBox = CGRectMake(
                                        self.position.x, 
                                        self.position.y, 
                                        kUnitWidth/2+adjustedWidth, 
                                        15.0);
    return unitBoundingBox;
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime 
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits{
    
    //[self printState: [self state]];
    if (self.state == DEAD){
        [self.hpLabel setVisible:NO];
        //[self setFaceTexture:CRY];
        //[self doFadeOut];
        
        return; // Nothing to do if the unit is dead
    }
    
    if ([self state] == RUN) {
        // Just run!
        return;
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
        if(self.isBattleStance){
            //He is in battle stance, so change it back to normal
            [self setNormalStance];
        }else if([self numberOfRunningActions] == 0 
                 && [self isAllPartsStopMoving]){
            //Check self's action to ensure change on normal stance
            //Originally he will continue walking to goal
            [self setState:WALK];
            [self doMoveAction];
            
        } else {
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
            //[self doFadeOut];
            [self setState:DEAD];
        }
        return;
    }
    
    if ([self updateOutOfBound]) {
        return;
    }
    
    // Collision detection
    [self updateHPLabel];
    CGRect playerRect = [self adjustedBoundingBox];
    
    BOOL isIntersect = FALSE;
    
    //Do something
    for (Unit *enemyUnit in listOfEnemyUnits) {
        
        [enemyUnit updateHPLabel];
        
        CGRect enemyRect = [enemyUnit adjustedBoundingBox];
        
        if (
            CGRectIntersectsRect(playerRect, enemyRect)
            && [self state] != DEAD
            && [enemyUnit state] != JUMP
            && [enemyUnit isFlipX] != [self isFlipX]
            ) {
            //CCLOG(@"unit collided");
            isIntersect = TRUE;
            if ([enemyUnit state] != DEAD) {
                [self stopActionByTag:MOVEACTION];
                [enemyUnit stopActionByTag:MOVEACTION];
            }
            
            if ([self coolDown] <= 0 
                && ([enemyUnit state] != DEAD 
                    && [enemyUnit state] != CRY)
                && [self state] != DEAD
                ) { 
                [self stopActionByTag:MOVEACTION];
                [self setState:BATTLE];
                
                //Turn unit back
                
                //CCLOG(@"FLIP!");
                if (
                    [enemyUnit unitID] != 14
                    && [enemyUnit status] != GHOST
                    ) { // Check if he is not stupid
                    if ([enemyUnit isFlipX] != [self isFlipX]) {
                        [enemyUnit stopActionByTag:MOVEACTION];
                        [enemyUnit stopActionByTag:JUMPACTION];
                        [enemyUnit setIsFlipX: [self isFlipX]];
                        [enemyUnit flipBody];
                        [enemyUnit setState:IDLE];
                        [enemyUnit setStatus:RUN];
                        [enemyUnit setFaceTexture:CRY];
                        [enemyUnit setSpeed:10.0];
                        
                        //[enemyUnit animateWalk];
                        //[enemyUnit doMoveAction];
                    }
                    
                    
                }
                
                
            } else if ( [enemyUnit state] == DEAD 
                       || [enemyUnit state] == CRY
                       //&& [self isBattleStance]
                       ) {
                if (
                    [self state] != WALK
                    && [self state] != DEAD
                    ) {
                    [self setNormalStance];
                    [self setState:IDLE];
                    [self setFaceTexture:IDLE];
                }
                
            }
        }        
    }
    
    if (!isIntersect) {
        if(
           [self isBattleStance]
           && [self state] != DEAD
           ){
            //Move action is stopped and all parts are ready
            [self setNormalStance];
            [self setState:WALK];
            [self setFaceTexture:WALK];
        }
        
    }
}

@end
