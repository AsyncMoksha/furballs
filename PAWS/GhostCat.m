//
//  GhostCat.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/23/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "GhostCat.h"

@implementation GhostCat

-(GhostCat*) initWithUnit: (Unit *) unit{
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
        [self setLevelSpeedFactor: [unit levelSpeedFactor]];
        self.stateTime = 0;
        [self setState: IDLE];
        [self setStatus:GHOST];
    }
    return self;
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfAllyUnits:(NSMutableArray *)listOfAllyUnits andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits{
    
    
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
            [self.hpLabel setVisible:NO];
            [self setBattleStance];
            [self animateBattle];
            [self doFadeOut];
            [self setState:DEAD];
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
            [self doFadeOut];
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
    
    //NSMutableArray *enemyToBeFlipped = [[NSMutableArray alloc] init ];
    
    //Do something
    for (Unit *enemyUnit in listOfEnemyUnits) {
        
        [enemyUnit updateHPLabel];
        
        CGRect enemyRect = [enemyUnit adjustedBoundingBox];
        
        if (
            CGRectIntersectsRect(playerRect, enemyRect)
            && [self state] != DEAD
            ) {
            CCLOG(@"unit collided");
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
                //[enemyUnit stopActionByTag:MOVEACTION];
                
                //Convert into ally unit
                
                //CCLOG(@"FLIP!");
                if ([enemyUnit unitID] != 14) { // Check if he is not stupid
                    //[listOfEnemyUnits removeObject:enemyUnit];
                    //[listOfAllyUnits addObject:enemyUnit];
                    //[enemyToBeFlipped addObject:enemyUnit];
                    [enemyUnit setState:FLIP];
                    [enemyUnit setIsFlipX:YES];
                    [enemyUnit flipBody];
                } else {
                    [self setState:DEAD];
                    return;
                }
                
                //[enemyUnit setState:FLIP];
                //return;
                
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
    /*
    for (Unit *unit in enemyToBeFlipped) {
        [listOfEnemyUnits removeObject:unit];
        [listOfAllyUnits addObject:unit];
    }
    */
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
