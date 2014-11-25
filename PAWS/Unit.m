//
//  Unit.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 9/24/11.
//  Copyright 2011 Pulse. All rights reserved.
//

#import "Unit.h"

@implementation Unit

@synthesize unitTag = _unitTag;
@synthesize unitID = _unitID;
@synthesize hitPoint = _hitPoint;
@synthesize maxHitPoint = _maxHitPoint;
@synthesize attack = _attack;
@synthesize attackRange = _attackRange;
@synthesize attackSpeed = _attackSpeed;
@synthesize speed = _speed;
@synthesize spawnRate = _spawnRate;
@synthesize coolDown = _coolDown;
@synthesize spawnCoolDown = _spawnCoolDown;
@synthesize unitCost = _unitCost;
@synthesize skill;
@synthesize unitName;
//@synthesize spriteName = _spriteName;
@synthesize frameName = _frameName;
@synthesize animationName = _animationName;
@synthesize state;
@synthesize status;
@synthesize itemStatus;
@synthesize walkAnim;
@synthesize attackAnim;
@synthesize cryAnim;
@synthesize hpLabel = _hpLabel;
@synthesize attackLabel = _attackLabel;
@synthesize cooldownLabel = _cooldownLabel;
@synthesize stateTime;

@synthesize headPart;
@synthesize facePart;
@synthesize bodyPart;
@synthesize tailPart;
@synthesize fLeg_LPart;
@synthesize bLeg_LPart;
@synthesize fLeg_RPart;
@synthesize bLeg_RPart;
@synthesize isBattleStance;
@synthesize isFlipX;
@synthesize unitClassName;
@synthesize faceNormalFileName;
@synthesize faceAttackFileName;
@synthesize faceCryFileName;
@synthesize levelSpeedFactor;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark -
#pragma mark Initialize method

/**
 *  Method: initWithDictionary
 *  Input: NSDictionary
 *  Return: Unit object
 *  Detail: This method initialize unit object from dictionary
 */
-(Unit*) initWithDictionary: (NSDictionary *) dictionary 
                 andIsFlipX: (BOOL) isUnitFlip{
    self = [super init];
    if (self) {
        
        // For load sprite & animation
        //_spriteName = [[dictionary objectForKey:@"spriteName"] description];
        _frameName = [[dictionary objectForKey:@"frameName"] description];
        _animationName = [[dictionary objectForKey:@"animationName"] description];
        
        //[self initWithSpriteFrameName:[NSString stringWithFormat:@"%@.png", _frameName]];
        
        [self initWithClassName:[[dictionary objectForKey:@"className"] description] andFlipX:isUnitFlip];
        
        // Unit's animation
        //[self initAnimations];
        
        // Unit's attribute
        _unitID = [[dictionary objectForKey:@"id"] intValue];
        _hitPoint = [[dictionary objectForKey:@"hitPoint"] intValue];
        _maxHitPoint = _hitPoint;
        _attack = [[dictionary objectForKey:@"attack"] intValue];
        _attackRange = [[dictionary objectForKey:@"attackRange"] intValue];
        _attackSpeed = [[dictionary objectForKey:@"attackSpeed"] intValue];
        _speed = [[dictionary objectForKey:@"speed"] intValue];
        _spawnRate = [[dictionary objectForKey:@"spawnRate"] intValue];
        _unitCost = [dictionary objectForKey:@"cost"];
        _coolDown = 0;
        skill = [[dictionary objectForKey:@"skill"] description];
        stateTime = 0;        
        unitName = [[dictionary objectForKey:@"name"] description];
        levelSpeedFactor = [[dictionary objectForKey:@"speedFactor"] floatValue];
        [self setState: IDLE];
        [self setStatus:NORMAL];
        [self setItemStatus:NONE];
    }
    
    return self;
}

-(Unit*) initIconWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        
        // For load sprite & animation
        _frameName = [[dictionary objectForKey:@"frameName"] description];
        _animationName = [[dictionary objectForKey:@"animationName"] description];

        
        // Unit's attribute
        _unitID = [[dictionary objectForKey:@"id"] intValue];
        _hitPoint = [[dictionary objectForKey:@"hitPoint"] intValue];
        _maxHitPoint = _hitPoint;
        _attack = [[dictionary objectForKey:@"attack"] intValue];
        _attackRange = [[dictionary objectForKey:@"attackRange"] intValue];
        _attackSpeed = [[dictionary objectForKey:@"attackSpeed"] intValue];
        _speed = [[dictionary objectForKey:@"speed"] intValue];
        _spawnRate = [[dictionary objectForKey:@"spawnRate"] intValue];
        _unitCost = [dictionary objectForKey:@"cost"];
        _coolDown = 0;
        stateTime = 0;
        unitName = [[dictionary objectForKey:@"name"] description];
        levelSpeedFactor = [[dictionary objectForKey:@"speedFactor"] floatValue];
        //[self setState: IDLE];
        [self setStatus:NORMAL];
        [self setItemStatus:NONE];
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_frameName]];
        
    }
    
    return self;
}

-(void)initAnimations {
    //Generate
    [self setWalkAnim:
     [self loadPlistForAnimationWithName:@"walkingAnim"
                            andClassName:_animationName]];
    
    [self setAttackAnim:
     [self loadPlistForAnimationWithName:@"attackingAnim"
                            andClassName:_animationName]];
    [self setCryAnim:
     [self loadPlistForAnimationWithName:@"cryingAnim"
                            andClassName:_animationName]];
}

-(Unit *) initWithUnit: (Unit *) unit {
    self = [super init];
    if (self) {

        [self initWithClassName:unit.unitClassName andFlipX:unit.isFlipX];
        [self setUnitID: [unit unitID]];
        [self setHitPoint: [unit hitPoint]];
        [self setMaxHitPoint: [unit hitPoint]];
        [self setAttack: [unit attack]];
        [self setAttackRange: [unit attackRange]];
        [self setAttackSpeed: [unit attackSpeed]];
        [self setSpeed: [unit speed]];
        [self setSpawnRate: [unit spawnRate]];
        [self setUnitCost:[unit unitCost]];
        [self setCoolDown: 0];
        [self setSkill: [unit skill]];
        [self setUnitName: [unit unitName]];
        [self setPosition:[unit position]];
        [self setFrameName: [NSString stringWithString:[unit frameName]]];
        [self setLevelSpeedFactor: [unit levelSpeedFactor]];
        self.stateTime = 0;
        [self setState: IDLE];
        [self setStatus:NORMAL];
        [self setItemStatus:NONE];
        [self setPath:unit.path];
    }
    return self;
}

-(void)changeState:(UNIT_STATE)newState {
    //Stop runing actions and assign a new one based on newState
    
    id action = nil;
    //if(self.state == newState){
    //    return;
    //}else{
        [self setState:newState];
        [self stopAllActions];
    //}
    switch (newState) {
        case WALK:
            //CCLOG(@"Unit->Starting the Walk Animation");
            self.state = WALK;
            [self doWalkAction];
            action = [CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:walkAnim]];
            break;
            
        case BATTLE:
            //CCLOG(@"Unit->Changing State to Battle");
            self.state = BATTLE;
            action = [CCAnimate actionWithAnimation:attackAnim];
            break;
            
        case CRY:
            //CCLOG(@"Unit->Changing State to Battle");
            self.state = CRY;
            action = [CCAnimate actionWithAnimation:cryAnim];
            break;
            
        case DEAD:
            //CCLOG(@"Unit->Changing State to Dead");
            self.state = DEAD;
            //action = [CCAnimate actionWithAnimation:cryAnim 
            //                   restoreOriginalFrame:FALSE];
            action = [CCSequence actions:
                      [CCAnimate actionWithAnimation:cryAnim
                                restoreOriginalFrame:NO],
                      [CCDelayTime actionWithDuration:0.5f],
                      [CCFadeOut actionWithDuration:0.5f],
                      nil];
            //[self removeFromParentAndCleanup:YES];
            break;
        case IDLE:
            //CCLOG(@"Unit->Changing State to IDLE");
            break;
        default:
            CCLOG(@"Unhandled state %d", newState);
            break;
    }
    if (action != nil) {
        [self runAction:action];
        //if (self.state == WALK) {
        //    [self doWalkAction];
        //}
    }
}


-(void) doWalkAction{
    //self.flipX = flip;
    CGPoint destination;
    float moveDuration = 0.0f;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if( [self isFlipX] == YES ){
        destination = ccp( winSize.width + self.contentSize.width/2, 
                          self.position.y);
        moveDuration = (winSize.width - self.position.x)
                        / (self.speed * 10.0);
    } else {
        destination = ccp(-self.contentSize.width/2, self.position.y);
        moveDuration = self.position.x / (self.speed * 10.0);
    }
    CCAction *moveAction = [CCMoveTo actionWithDuration:moveDuration 
                                               position:destination];

    [moveAction setTag:1];
    [self runAction:moveAction];
}

-(void) unitMoveEnded {
    [self removeFromParentAndCleanup:YES];
}
 


-(void) unitAnimatedEnd: (id)sender{
    //[self printState:(UNIT_STATE)stateEnd];
    CCLOG(@"Dude T T");
}

-(void)printState:(UNIT_STATE) aState{
    //IDLE, WALK, BATTLE, CRY, DEAD, FINISHED, JUMP, FLIP, SCARED, RUN 
    switch (aState) {
        case WALK:
            CCLOG(@"Current State is -> WALK");
            break;
            
        case BATTLE:
            CCLOG(@"Current State is -> Battle");
            break;
            
        case DEAD:
            CCLOG(@"Current State is -> Dead");
            break;
        case IDLE:
            CCLOG(@"Current State is -> IDLE");
            break;
        case FLIP:
            CCLOG(@"Current State is -> FLIP");
            break;
        case JUMP:
            CCLOG(@"Current State is -> JUMP");
            break;
        case FINISHED:
            CCLOG(@"Current State is -> JUMP");
            break;
        default:
            CCLOG(@"Unhandled state %d", state);
            break;
    }
}

//Return CCAnimation associated with information saved in an animation plist
//Doesn't include the pre-process of loading sprite into framecache.
//(Pisit copy&paste from book cp3 - Game object and game character class)
-(CCAnimation*) loadPlistForAnimationWithName:(NSString*)animationName 
                                 andClassName:(NSString*)className{
    CCAnimation *animationToReturn = nil;
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    
    //Get the path to plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle]
                     pathForResource:className ofType:@"plist"];
    }
    
    //Read in the plist file
    NSDictionary *plistDictionary =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    //If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // No Plist Dictionary or file found
    }
    
    //Get just the mini-dictionary for this animation based on animationName
    NSDictionary *animationSettings =
    [plistDictionary objectForKey:animationName];
    if (animationSettings == nil) {
        CCLOG(@"Could not locate AnimationWithName:%@",animationName);
        return nil;
    }
    
    //Get the delay value for the animation
    float animationDelay =
    [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelay:animationDelay];
    
    //Add the frames to the animation
    NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName =
        [NSString stringWithFormat:@"%@%@.png",
         animationFramePrefix,frameNumber];

        [animationToReturn addFrame:
         [[CCSpriteFrameCache sharedSpriteFrameCache]
          spriteFrameByName:frameName]];
    }
    
    
    return animationToReturn;
}

-(CGRect) adjustedBoundingBox {
    //float offsetX = kUnitWidth/2;
    //float offsetY = kUnitHeight/2;
    int adjustedWidth = 0;
    if ([self isFlipX]) {
        adjustedWidth = 15;
    } else {
        adjustedWidth = -15;
    }
    CGRect unitBoundingBox = CGRectMake(
                                   self.position.x, 
                                   self.position.y, 
                                   kUnitWidth/2+adjustedWidth, 
                                   15.0);
    return unitBoundingBox;
}

-(CGRect) selectionBoundingBox {
    float offsetX = (self.contentSize.width*0.5f)/2;
    float offsetY = (kUnitHeight*0.75)/2;
    CGRect unitBoundingBox = CGRectMake(
                                        self.position.x - offsetX, 
                                        self.position.y - offsetY, 
                                        (self.contentSize.width*0.5f), 
                                        kUnitHeight * 0.75);
    return unitBoundingBox;
}

#pragma mark -
#pragma mark Update Logic

-(void) updateHPLabel {
    if (self.hpLabel.visible) {
        [self.hpLabel setString: [NSString stringWithFormat:@"HP:%.2f", 
                                  self.hitPoint]];
        if (self.isFlipX) {
            self.hpLabel.position = ccp(
                                        self.position.x-20.0,
                                        self.position.y+55.0
                                        );
        } else {
            self.hpLabel.position = ccp(
                                        self.position.x+10,
                                        self.position.y+55.0
                                        );
        }
        
    }
    
    if (self.attackLabel.visible) {
        [self.attackLabel setString: [NSString stringWithFormat:@"ATK:%.2f", 
                                  self.attack]];
        if (self.isFlipX) {
            self.attackLabel.position = ccp(
                                        self.position.x-20.0,
                                        self.position.y+40.0
                                        );
        } else {
            self.attackLabel.position = ccp(
                                        self.position.x+10.0,
                                        self.position.y+40.0
                                        );
        }
        
    }
    
}



-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
             andListOfAllyUnits:(NSMutableArray *)listOfAllyUnits 
            andListOfEnemyUnits:(NSMutableArray*)listOfEnemyUnits{
    // For overiding purpose
    /*
    if (self.state == DEAD){
        [self.hpLabel setVisible:NO];
        if ([self numberOfRunningActions] == 0) {
                // Unit is dead, remove
            [self setVisible:NO];
        } 
        return; // Nothing to do if the unit is dead
    }
    
    if ((self.state == CRY) && ([self numberOfRunningActions] > 0))
        return; // Currently playing the taking damage animation
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if ( self.position.x >= self.contentSize.width/2 + winSize.width ||
        self.position.x <= -self.contentSize.width/2 ){
        [self setState:FINISHED];
        return;
    }
    
    [self updateHPLabel];
    CGRect playerRect = [self adjustedBoundingBox];
    
    //BOOL isIntersect = FALSE;
    
    //Do something
    for (Unit *enemyUnit in listOfEnemyUnits) {
       
        [enemyUnit updateHPLabel];
        
        CGRect enemyRect = [enemyUnit adjustedBoundingBox];
        
        if (CGRectIntersectsRect(playerRect, enemyRect) ) {
            
            //isIntersect = TRUE;
            if ([self coolDown] <= 0 && [enemyUnit state] != DEAD) { 
                
                [self changeState:BATTLE];
                [enemyUnit changeState:CRY];

                self.coolDown = self.attackSpeed;
                enemyUnit.hitPoint -= self.attack;
                
                if([enemyUnit hitPoint]<=0){ 
                    // if enemy hp goes below 0 remove 
                    [self printState: self.state];
                    [enemyUnit changeState:DEAD];
                    //[listOfEnemyUnits removeObject:enemyUnit];
                    [self changeState:WALK];
                }  //End attack
            } else if ( [enemyUnit state] == DEAD 
                       && [self state] == BATTLE
                       ) {
                [self changeState:WALK];
            }
        }
        
    }
    */
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
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
    CGRect playerRect = [self adjustedBoundingBox];
    
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
                    //&& [enemyUnit state] != JUMP 
                    )
                ) { 
                [self stopActionByTag:MOVEACTION];
                [self setState:BATTLE];
                //[enemyUnit setState:CRY];
                
                [self updateAttackLogicWithUnit:enemyUnit];
                
                
                if([enemyUnit hitPoint]<=0){ 
                    // if enemy hp goes below 0 remove 
                    [enemyUnit setState:CRY];
                    [self setState:IDLE];
                    [self setFaceTexture:IDLE];
                }  //End attack
            } else if ( [enemyUnit state] == DEAD 
                       || [enemyUnit state] == CRY
                       || [enemyUnit hitPoint]<=0
                       //|| [enemyUnit state] == JUMP
                       ) {
                if ([self state] != WALK) {
                    //if ([self isBattleStance]) {
                    //    [self setNormalStance];
                    //}
                    
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

- (void) updateStateWithDeltaTime:(ccTime)deltaTime 
                   andListOfItems:(NSMutableArray*)listOfItems{
    
    CGRect playerRect = [self adjustedBoundingBox];
    for (ItemClass *item in listOfItems) {
        CGRect enemyRect = [item adjustedBoundingBox];
        
        if (
            CGRectIntersectsRect(playerRect, enemyRect) 
            && [item itemID] != ITEM_CATAPULT
            ) {
            //CCLOG(@"Game obtect state %d", item.gameObjectState);            
            if ([self coolDown] <= 0 
                && (
                    [item gameObjectState] != REMOVED 
                    )
                ) { 
                [self stopActionByTag:MOVEACTION];
                //[self setState:BATTLE];
                //[enemyUnit setState:CRY];
                
                //[self updateAttackLogicWithUnit:item];
                [item setGameObjectState:REMOVED];
                /*
                if([enemyUnit hitPoint]<=0){ 
                    // if enemy hp goes below 0 remove 
                    [enemyUnit setState:CRY];
                    [self setState:IDLE];
                    [self setFaceTexture:IDLE];
                }  //End attack
                 */
            } else if ( 
                       [item gameObjectState] == REMOVED 
                       ) {
                if ([self state] != WALK) {
                    
                    [self setState:IDLE];
                    [self setFaceTexture:IDLE];
                }
                
            }
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

- (void) updateCoolDown {
    if (self.coolDown > 0) {
        self.coolDown--;
    }
    
}

- (BOOL) updateOutOfBound {
    CGSize size = [[CCDirector sharedDirector] winSize];
    //If he reach end of scene on the left, he should be terminated !
    if ( self.position.x <= 0 && !self.isFlipX){
        self.hpLabel.visible=NO;
        if (
            [self status] == GHOST
            || [self status] == RUN
            ) {
            [self setState:DEAD];
        } else {
            [self setState:FINISHED];
        }
        [self stopAllActions];
        //CCLOG(@"Goal -> Pisit is Dead (T_Ta)");
        return TRUE;
    } 
    
    //If he reach end of scene on the right, he should be terminated !
    if ( self.position.x >= size.width && self.isFlipX){
        self.hpLabel.visible=NO;
        if (
            [self status] == GHOST
            || [self status] == RUN
            ) {
            [self setState:DEAD];
        } else {
            [self setState:FINISHED];
        }
        [self stopAllActions];
        //CCLOG(@"Goal -> Pisit is Dead (T_Ta)");
        return TRUE;
    } 
    return FALSE;
}

- (void) updateAttackLogicWithUnit: (Unit *) enemyUnit {
    if (
        [enemyUnit status] != GHOST
        ) {
        enemyUnit.hitPoint -= self.attack;
        self.coolDown = self.attackSpeed;
    }
    
    if ( 
        [self unitID] == 14
        && [enemyUnit status] == GHOST
        ) {
        enemyUnit.hitPoint -= self.attack;
        self.coolDown = self.attackSpeed;
    }
}

#pragma mark -
#pragma mark Animation System

-(id) initWithClassName:(NSString*)className andFlipX:(BOOL)flipBoolean{
    if(self = [super init]){
        self.unitClassName = className;
        self.state = IDLE;
        //Default base animation speed to 5 for speed and attackSpeed. 
        //By Formula AnimationFactor = 1*5/speed
        //self.speed = 10;
        //self.attackSpeed = 10;
        self.isBattleStance = FALSE;
        self.isFlipX = flipBoolean;
        
        [self initBodySprite];
        [self adjustAnchorPoint];
        [self constructBody];
    }
    return self;
}

-(void) initBodySprite{
    [self setHeadPart: [self loadPlistForSpriteWithName:@"head" andClassName:unitClassName]];
    [self setFacePart: [self loadPlistForSpriteWithName:@"face" andClassName:unitClassName]];
    [self setBodyPart: [self loadPlistForSpriteWithName:@"body" andClassName:unitClassName]];
    [self setFLeg_LPart: [self loadPlistForSpriteWithName:@"frontLeg_Left" andClassName:unitClassName]];
    [self setBLeg_LPart: [self loadPlistForSpriteWithName:@"backLeg_Left" andClassName:unitClassName]];
    [self setFLeg_RPart: [self loadPlistForSpriteWithName:@"frontLeg_Right" andClassName:unitClassName]];
    [self setBLeg_RPart: [self loadPlistForSpriteWithName:@"backLeg_Right" andClassName:unitClassName]];
    [self setTailPart: [self loadPlistForSpriteWithName:@"tail" andClassName:unitClassName]];
}

-(void) adjustAnchorPoint{
    //adjust appropriate anchorPoint of Leg and tail parts
    self.fLeg_LPart.anchorPoint = ccp(0.5,1);
    self.bLeg_LPart.anchorPoint = ccp(0.5,1);
    self.fLeg_RPart.anchorPoint = ccp(0.5,1);
    self.bLeg_RPart.anchorPoint = ccp(0.5,1);
    if(self.isFlipX){
        self.tailPart.anchorPoint = ccp(1,0.5);
    }else{
        self.tailPart.anchorPoint = ccp(0,0.5);
    }
    
}

-(void) constructBody{
    //CCLOG(@"Constructing Process Begin ===============>");
    if(self.headPart){
        //CCLOG(@"( '-' ) Assemble Pisit Parts !");
        [self addChild:headPart z:7 tag:HEADPART];
    }
    
    if(self.facePart){
        //CCLOG(@"( ,,= .. =,, ) Paint face  !");
        [self addChild:facePart z:8 tag:FACEPART];
    }
    if(self.fLeg_LPart){
        //CCLOG(@"('[]' *)o Assemble Front Leg on Left side !");
        [self addChild:fLeg_LPart z:6 tag:FLEG_LPART];
    }
    if(self.bLeg_LPart){
        //CCLOG(@"('[]' *)o Assemble Back Leg on Left side !");
        [self addChild:bLeg_LPart z:5 tag:BLEG_LPART];
    }
    if(self.bodyPart){
        //CCLOG(@"((>  w   <)) Assemble body !");
        [self addChild:bodyPart z:4 tag:BODYPART];
    }
    if(self.tailPart){
        //CCLOG(@"(=,,= )-o  Assemble Tail part !!! ");
        [self addChild:tailPart z:3 tag:TAILPART];
    }
    if(self.fLeg_RPart){
        //CCLOG(@"o(* '[]') Assemble Front Leg on right side!");
        [self addChild:fLeg_RPart z:2 tag:FLEG_RPART];
    }
    if(self.bLeg_RPart){
        //CCLOG(@"o(* '[]') Assemble Back Leg on right side!");
        [self addChild:bLeg_RPart z:1 tag:BLEG_RPART];
    }
    
    //CCLOG(@"Constructing Process End ( * w * )9 ===============> Ready");
}

-(void) flipBody {
    /*
    [self removeChild:headPart cleanup:NO];
    [self removeChild:facePart cleanup:NO];
    [self removeChild:fLeg_LPart cleanup:NO];
    [self removeChild:bLeg_LPart cleanup:NO];
    [self removeChild:bodyPart cleanup:NO];
    [self removeChild:tailPart cleanup:NO];
    [self removeChild:fLeg_RPart cleanup:NO];
    [self removeChild:bLeg_RPart cleanup:NO];
     */
    [headPart setPosition: ccp( headPart.position.x * -1.0,
                               headPart.position.y)];
    [facePart setPosition: ccp( facePart.position.x * -1.0,
                               facePart.position.y)];
    [fLeg_LPart setPosition: ccp( fLeg_LPart.position.x * -1.0,
                               fLeg_LPart.position.y)];
    [bLeg_LPart setPosition: ccp( bLeg_LPart.position.x * -1.0,
                               bLeg_LPart.position.y)];
    [bodyPart setPosition: ccp( bodyPart.position.x * -1.0,
                               bodyPart.position.y)];
    [tailPart setPosition: ccp( tailPart.position.x * -1.0,
                               tailPart.position.y)];
    [fLeg_RPart setPosition: ccp( fLeg_RPart.position.x * -1.0,
                               fLeg_RPart.position.y)];
    [bLeg_RPart setPosition: ccp( bLeg_RPart.position.x * -1.0,
                               bLeg_RPart.position.y)];
    //[self setIsFlipX: ![self isFlipX]];
    [headPart setFlipX:isFlipX];
    [facePart setFlipX:isFlipX];
    [fLeg_LPart setFlipX:isFlipX];
    [bLeg_LPart setFlipX:isFlipX];
    [bodyPart setFlipX:isFlipX];
    [tailPart setFlipX:isFlipX];
    [fLeg_RPart setFlipX:isFlipX];
    [bLeg_RPart setFlipX:isFlipX];
    [self adjustAnchorPoint];
    [self stopActionByTag:MOVEACTION];
    //[self setState:IDLE];
    //[self constructBody];
    
}

-(void)stopAllActions{
    //Override Method to stop all actions of self and child nodes
    [super stopAllActions];
    [headPart stopAllActions];
    [bodyPart stopAllActions];
    [fLeg_LPart stopAllActions];
    [bLeg_LPart stopAllActions];
    [fLeg_RPart stopAllActions];
    [bLeg_RPart stopAllActions];
    [tailPart stopAllActions];
}

-(BOOL)isAllPartsStopMoving{
    //Check whether all parts (doesn't include self) running action is equal to 0 or not
    return (headPart.numberOfRunningActions == 0 
            && bodyPart.numberOfRunningActions == 0
            && fLeg_LPart.numberOfRunningActions ==0
            && bLeg_LPart.numberOfRunningActions == 0 
            && fLeg_RPart.numberOfRunningActions == 0
            && bLeg_RPart.numberOfRunningActions ==0
            && tailPart.numberOfRunningActions == 0);
}

-(void) animateWalk{
    float direction = 1;
    if(self.isFlipX){
        direction = -1;
    }
    float animFactor = 1*kBaseAnimationMoveSpeed/ (float)self.speed;
    //Create Actions
    /*
    CCAction *walkHeadMove = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:5*direction],
     [CCRotateBy actionWithDuration:0.4*animFactor angle:-10*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:5*direction], nil];
    
    CCAction *walkFaceMove = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:5*direction],
     [CCRotateBy actionWithDuration:0.4*animFactor angle:-10*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:5*direction], nil];
    */
    CCAction *walkFLeg_LAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:10*direction],
     [CCRotateBy actionWithDuration:0.4*animFactor angle:-20*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:10*direction], nil];
    
    CCAction *walkBLeg_LAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-15*direction],
     [CCRotateBy actionWithDuration:0.4*animFactor angle:30*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-15*direction] , nil];
    
    CCAction *walkFLeg_RAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-10*direction],
     [CCRotateBy actionWithDuration:0.4*animFactor angle:20*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-10*direction], nil];
    
    CCAction *walkBLeg_RAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction],
     [CCRotateBy actionWithDuration:0.4*animFactor angle:-30*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction] , nil];
    
    CCAction *walkTailAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction],
     [CCRotateBy actionWithDuration:0.4*animFactor angle:-30*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction] , nil];
    
    //Assign TAGS
    //walkHeadMove.tag = WALKHEAD;
    //walkFaceMove.tag = WALKFACE;
    walkFLeg_LAnim.tag = WALKFLEG_L;
    walkBLeg_LAnim.tag = WALKBLEG_L;
    walkFLeg_RAnim.tag = WALKFLEG_R;
    walkBLeg_RAnim.tag = WALKBLEG_R;
    walkTailAnim.tag = WALKTAIL;
    
    //Run action
    //[headPart runAction:walkHeadMove];
    //[facePart runAction:walkFaceMove];
    [fLeg_LPart runAction:walkFLeg_LAnim];
    [bLeg_LPart runAction:walkBLeg_LAnim];
    [fLeg_RPart runAction:walkFLeg_RAnim];
    [bLeg_RPart runAction:walkBLeg_RAnim];
    [tailPart runAction:walkTailAnim];
    
    //self runAction:
    [self doMoveAction];
}

-(void) animateBattle{
    float direction = 1;
    if(self.isFlipX){
        direction = -1;
    }
    //float animFactor = 1*kBaseAnimationAtkSpeed/(float)self.attackSpeed;
    float animFactor = self.attackSpeed/kBaseAnimationAtkSpeed;
    CCAction *battleHeadAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-30*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction] , nil];
    
    CCAction *battleFaceAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-30*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction] , nil];
    
    CCAction *battleFLeg_LdAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.3*animFactor angle:120*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-150*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:30*direction] , nil];
    
    CCAction *battleFLeg_RdAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.4*animFactor angle:120*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-150*direction],
     [CCRotateBy actionWithDuration:0.3*animFactor angle:30*direction] , nil];
    
    [headPart runAction:battleHeadAnim];
    [facePart runAction:battleFaceAnim];
    [fLeg_LPart runAction:battleFLeg_LdAnim];
    [fLeg_RPart runAction:battleFLeg_RdAnim];
}

-(void) setFaceTexture:(UNIT_STATE) newState{
    
    CCTexture2D *newTex = nil;
    NSString *faceName = nil;
    
    if(newState == IDLE){
        faceName = faceNormalFileName;
    }else if(newState == BATTLE){
        faceName = faceAttackFileName;
    }else if(newState == CRY){
        faceName = faceCryFileName;
    }
    if(faceName){
        CCSpriteFrame *tmpFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:faceName];
        newTex = [tmpFrame texture];
        if(newTex){
            CGRect rect = CGRectZero;
            rect = tmpFrame.rect;
            [facePart setTexture:newTex];
            [facePart setTextureRect:rect];
        }
    }
}

-(void) setBattleStance{
    if(!isBattleStance){
        float direction = 1;
        if(self.isFlipX){
            direction = -1;
        }
        
        //Change face to Attack
        [self setFaceTexture:BATTLE];
        CCAction *battleStance = [CCRotateBy actionWithDuration:0.3 angle:10*direction];
        CCAction *battlebLeg_LStance = [CCRotateBy actionWithDuration:0.3 angle:-10*direction];
        CCAction *battlebLeg_RStance = [CCRotateBy actionWithDuration:0.3 angle:-10*direction];
        
        [bLeg_LPart runAction:battlebLeg_LStance];
        [bLeg_RPart runAction:battlebLeg_RStance];
        [self runAction:battleStance];
        
        self.isBattleStance = TRUE;
    }  
}

-(void) setNormalStance{
    if(
       isBattleStance 
       && [self numberOfRunningActions] == 0
       ){
        float direction = 1;
        if(self.isFlipX){
            direction = -1;
        }
        
        //Change face to Normal
        [self setFaceTexture:IDLE];
        CCAction *normalStance = [CCRotateBy actionWithDuration:0.3 angle:-10*direction];
        CCAction *normalBLeg_LStance = [CCRotateBy actionWithDuration:0.3 angle:10*direction];
        CCAction *normalBLeg_RStance = [CCRotateBy actionWithDuration:0.3 angle:10*direction];
        
        [bLeg_LPart runAction:normalBLeg_LStance];
        [bLeg_RPart runAction:normalBLeg_RStance];
        [self runAction: normalStance];
        self.isBattleStance = FALSE;
    }
}

-(void) animateCry{
    
    float scaleFactor =  3;
    CCAction *cryHeadAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*scaleFactor angle:15],
     [CCRotateBy actionWithDuration:0.3*scaleFactor angle:-30], nil];
    
    CCAction *cryFaceAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*scaleFactor angle:15],
     [CCRotateBy actionWithDuration:0.3*scaleFactor angle:-30], nil];
    
    CCAction *cryTailAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*scaleFactor angle:15],
     [CCRotateBy actionWithDuration:0.3*scaleFactor angle:-30], nil];
    
    [headPart runAction:cryHeadAnim];
    [facePart runAction:cryFaceAnim];
    [tailPart runAction:cryTailAnim];
    
    
}

-(void) doMoveAction{
    //CCLOG(@"Called doMoveAction");
    CGPoint destination;
    float moveDuration = 0.0f;
    CCAction *moveAction = nil;
    if(![self isFlipX]){
        //Move Right - > Left
        destination = ccp(-20, self.position.y);
        moveDuration = (self.position.x)/(self.speed * self.levelSpeedFactor);
    }else if([self isFlipX]){
        //Move Left to Right
        CGSize size = [[CCDirector sharedDirector] winSize];
        destination = ccp(size.width+20,self.position.y);
        moveDuration = (size.width - self.position.x) / (
                                                         self.speed 
                                                         * self.levelSpeedFactor
                                                         );
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
    
    //[self animateWalk];
}

-(void) doFadeOut{
    //http://www.adamtong.co.uk/index.php/cocos2d/cocos2d-snippets-01-fading-a-cclayer/
    //Snippet to add fade to CCNode without SIGBERT !!!
    
    
    //Temporary Manually Apply
    
    CCAction *headOut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *faceOut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *bodyOut = [CCFadeOut actionWithDuration:1.8f];
    CCAction *fLeg_LOut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *bLeg_LOut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *fLeg_ROut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *bLeg_ROut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *tailOut = [CCFadeOut actionWithDuration:2.0f];
    
    [headPart runAction:headOut];
    [facePart runAction:faceOut];
    [bodyPart runAction:bodyOut];
    [fLeg_LPart runAction:fLeg_LOut];
    [bLeg_LPart runAction:bLeg_LOut];
    [fLeg_RPart runAction:fLeg_ROut];
    [bLeg_RPart runAction:bLeg_ROut];
    [tailPart runAction:tailOut];
     
    
}

-(void) doShadow{
    [headPart setOpacity:128];
    [facePart setOpacity:128];
    [bodyPart setOpacity:128];
    [fLeg_LPart setOpacity:128];
    [bLeg_LPart setOpacity:128];
    [fLeg_RPart setOpacity:128];
    [bLeg_RPart setOpacity:128];
    [tailPart setOpacity:128];
}



/**
 * Return CCSprite associated with information saved in unitData plist
 * Doesn't include the pre-process of loading sprite into framecache.
 * @param spriteName : A name of sprite object to load from plist
 * @param className : A name of plist name to load
 * @return associated CCSpite, or nil if there is an error.
 * Note: This method will internally set some class variable for some
 * unique part. 
 * i.e. Face which require switchable texture
 * so faceAttackFileName, faceNormalFileName, faceCryFileName will be set
 */
-(CCSprite*)loadPlistForSpriteWithName:(NSString*)spriteName 
                          andClassName:(NSString*)className{
    
    CCSprite *spriteToReturn = nil;
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    
    //Get the path to plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle]
                     pathForResource:className ofType:@"plist"];
    }
    //Read in the plist file
    NSDictionary *plistDictionary =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    //If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // No Plist Dictionary or file found
    }
    
    //Get just the mini-dictionary for this sprite based on spriteName
    NSDictionary *spriteSettings =
    [plistDictionary objectForKey:spriteName];
    if (spriteSettings == nil) {
        CCLOG(@"Could not locate SpriteWithName:%@",spriteName);
        return nil;
    }
    NSString *aSpriteName = [spriteSettings objectForKey:@"fileName"];
    float xPos = [[spriteSettings objectForKey:@"posX"] floatValue];
    float yPos = [[spriteSettings objectForKey:@"posY"] floatValue];
    //CCLOG(@"Sprite name is %@",aSpriteName);
    //Be careful, assume sprite is already loaded in sprite frame
    spriteToReturn = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:aSpriteName]];
    
    //Default sprite is normal facing to the left direction
    float flipFactor = 1;
    if(self.isFlipX){
        //Since the unit is flip to face a right direction
        //Invert X position and flip inside sprite
        flipFactor = -1;    
        spriteToReturn.flipX = YES;
    }else{
        spriteToReturn.flipX = NO;
    }
    spriteToReturn.position = ccp(xPos*flipFactor, yPos);
    
    //For Specific clss name with load extra information
    if([spriteName isEqualToString:@"face"]){
        self.faceNormalFileName = [spriteSettings objectForKey:@"normalFileName"];
        self.faceAttackFileName = [spriteSettings objectForKey:@"attackFileName"];
        self.faceCryFileName    = [spriteSettings objectForKey:@"cryFileName"];
        
    }
    
    //Specific sprite has an extra property 
    return spriteToReturn;
}



- (void) dealloc {
    //[_spriteName release];
    //_spriteName = nil;
    [_animationName release];
    _animationName = nil;
    [self.walkAnim release];
    self.walkAnim = nil;
    [self.attackAnim release];
    self.attackAnim = nil;
    [self.cryAnim release];
    self.cryAnim = nil;
    [super dealloc];
}

@end
