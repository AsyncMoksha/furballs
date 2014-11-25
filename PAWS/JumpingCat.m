//
//  JumpingCat.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/26/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "JumpingCat.h"

@implementation JumpingCat

@synthesize jumpCoolDown;
@synthesize groundPosition;

-(JumpingCat*) initWithUnit: (Unit *) unit{
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
    }
    return self;
}

-(CGRect)adjustedJumpBoundingBox {
    
    int adjustedWidth = 0;
    if ([self isFlipX]) {
        adjustedWidth = 5;
    } else {
        adjustedWidth = -30;
    }
    CGRect unitBoundingBox = CGRectMake(
                                        self.position.x, 
                                        self.position.y, 
                                        kUnitWidth+adjustedWidth, 
                                        15.0);
    return unitBoundingBox;
}

-(void) doJumpAction {
    //CCLOG(@"Called doJumpAction");
    CGPoint destination;
    float moveDuration = 0.0f;
    CCJumpTo *jumpAction = nil;
    if(!self.isFlipX){
        //Move Right - > Left
        destination = ccp(self.position.x - kJumpDistance, self.position.y);
        moveDuration = 1.0f;
    }else{
        //Move Left to Right
        //CGSize size = [[CCDirector sharedDirector] winSize];
        destination = ccp(self.position.x+kJumpDistance ,self.position.y);
        moveDuration = 1.0f;
    }
    jumpAction = [CCJumpTo actionWithDuration:moveDuration position:destination height:kJumpHeight jumps:1];
    if(jumpAction){
        //CCLOG(@"run move action");
        [jumpAction setTag:JUMPACTION];
        [self runAction:jumpAction];
    }else{
        CCLOG(@"Error, no move action was generated");
    }
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime 
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits{
    
    //[self printState:[self state]];
    
    if ([self hitPoint] <= 0) {
        [self stopActionByTag:MOVEACTION];
        [self setState:DEAD];
        [self setFaceTexture:CRY];
        return;
    }
    /*
    if ([self status] == RUN) {
        //[self stopActionByTag:MOVEACTION];
        
    }*/
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
    
    if ([self updateOutOfBound]) {
        return;
    }
    
    // Collision detection
    [self updateHPLabel];
    CGRect playerRect = [self adjustedJumpBoundingBox];
    CGRect playerBattleRect = [self adjustedBoundingBox];
    
    BOOL isIntersect = FALSE;
    
    //Do something
    for (Unit *enemyUnit in listOfEnemyUnits) {
        
        [enemyUnit updateHPLabel];
        
        CGRect enemyRect = [enemyUnit adjustedBoundingBox];
        
        if (
            CGRectIntersectsRect(playerRect, enemyRect)
            && [self state] != DEAD
            && [self state] != BATTLE
            && [enemyUnit status] != GHOST
            ) {
            //CCLOG(@"unit collided");
            //isIntersect = TRUE;
            if (
                [enemyUnit state] != DEAD
                //&& [self state] != JUMP
                ) {
                
                [self stopActionByTag:MOVEACTION];
            }
            
            if ([self jumpCoolDown] <= 0 
                && ([enemyUnit state] != DEAD 
                    && [enemyUnit state] != CRY)
                && [self state] != DEAD
                ) { 
                
                self.jumpCoolDown = self.attackSpeed;
                [self setGroundPosition: self.position.y];
                [self setState:JUMP];
                //[self doJumpAction];
                
                
            } /*else if ( [enemyUnit state] == DEAD 
                       || [enemyUnit state] == CRY
                       //&& [self isBattleStance]
                       ) {
                if (
                    [self state] != WALK
                    && [self state] != DEAD
                    ) {
                    if ([self isBattleStance]) {
                        [self setNormalStance];
                    }
                    [self setState:IDLE];
                    [self setFaceTexture:IDLE];
                }
                
            } */
             
        }
        
        if (
            CGRectIntersectsRect(playerBattleRect, enemyRect) 
            && self.zOrder == enemyUnit.zOrder
            && [self state] != JUMP 
            && [enemyUnit state] != RUN
            && [enemyUnit status] != GHOST
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
       self.numberOfRunningActions == 0 || self.state == WALK 
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
    
    if(self.state == WALK){
        if([self isAllPartsStopMoving]){
            //Continue animate walk if one cycle is ended
            //if ([[self getActionByTag:JUMPACTION] isDone]) {
            [self animateWalk];
            //}
        }
    }
    
    if(self.state == JUMP){
        //if ([[self getActionByTag:JUMPACTION] isDone]) {
        // CCLOG(@"===== Jump is done ====");
        //[self setState:IDLE];
        [self doJumpAction];
        [self setState:IDLE];
        //}
        //return;
    }
    
    if(self.state == IDLE){
        [self stopActionByTag:MOVEACTION];
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
    
    if (self.jumpCoolDown >0) {
        self.jumpCoolDown--;
    }
    
}
@end
