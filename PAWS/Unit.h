//
//  Unit.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 9/24/2011.
//  Copyright 2011 Pulse. All rights reserved.
//
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObject.h"
#import "ItemClass.h"
#define kBaseAnimationAtkSpeed 2
#define kBaseAnimationMoveSpeed 5
#define kUnitHeight 80
#define kUnitWidth 128

typedef enum { 
    IDLE, WALK, BATTLE, CRY, DEAD, FINISHED, JUMP, FLIP 
} UNIT_STATE;

typedef enum { 
    NORMAL, GHOST, FEAR, GROWL, RUN
} UNIT_STATUS;

typedef enum {
    NONE, WIND
} ITEM_STATUS;

typedef enum {HEADPART, FACEPART, BODYPART, FLEG_LPART, FLEG_RPART,
    BLEG_LPART,BLEG_RPART, TAILPART} BODY_TAG;

typedef enum {
    WALKFLEG_L, WALKFLEG_R,WALKBLEG_L, WALKBLEG_R, 
    WALKHEAD,WALKTAIL, WALKFACE, MOVEACTION, JUMPACTION, COLLECTACTION
} ACTION_TAG;

@interface Unit : GameObject {
    NSNumber *_unitTag;
    int _unitID;
    float _hitPoint;
    float _maxHitPoint;
    float _attack;
    float _attackSpeed;
    float _attackRange;
    float _speed;
    float _spawnRate;
    float _coolDown;
    float _spawnCoolDown;
    NSNumber *_unitCost;
    NSString *skill;
    NSString *unitName;
    NSString *_spriteName;
    NSString *_frameName;
    NSString *_animationName;
    
    BOOL interChecked;
    
    UNIT_STATE state;
    UNIT_STATUS status;
    ITEM_STATUS itemStatus;
    
    // For walking
    CCAnimation *walkAnim;
    // For attacking
    CCAnimation *attackAnim;
    // For crying (dying animation)
    CCAnimation *cryAnim;
    
    // For debugging
    CCLabelTTF *_hpLabel;
    CCLabelBMFont *_attackLabel;
    CCLabelTTF *_cooldownLabel;
    
    ccTime stateTime;
    
    // New animation part
    CCSprite *headPart;
    CCSprite *facePart;
    CCSprite *bodyPart;
    CCSprite *tailPart;
    //Left and right based on original model faceing to left position
    CCSprite *fLeg_LPart;
    CCSprite *bLeg_LPart;
    CCSprite *fLeg_RPart;
    CCSprite *bLeg_RPart;
    BOOL isBattleStance;
    BOOL isFlipX;
    NSString *unitClassName;
    
    NSString *faceNormalFileName;
    NSString *faceAttackFileName;
    NSString *faceCryFileName;
    
    float levelSpeedFactor;
}
-(void) initAnimations;
-(Unit*) initWithDictionary: (NSDictionary *) dictionary 
                 andIsFlipX: (BOOL) isUnitFlip;
-(Unit*) initIconWithDictionary: (NSDictionary *) dictionary;
-(Unit*) initWithUnit: (Unit *) unit;
-(CCAnimation*) loadPlistForAnimationWithName: (NSString*)animationName andClassName:(NSString*)className;
-(void) changeState: (UNIT_STATE) newState;
-(void) doWalkAction;
-(void)printState:(UNIT_STATE) aState;
-(CGRect)adjustedBoundingBox;
-(CGRect) selectionBoundingBox;
// Update Logic
-(void)updateHPLabel;
-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
             andListOfAllyUnits:(NSMutableArray*)listOfAllyUnits
            andListOfEnemyUnits:(NSMutableArray*)listOfEnemyUnits;
- (void) updateStateWithDeltaTime:(ccTime)deltaTime 
              andListOfEnemyUnits:(NSMutableArray*)listOfEnemyUnits;
- (void) updateStateWithDeltaTime:(ccTime)deltaTime 
              andListOfItems:(NSMutableArray*)listOfItems;
- (void) updateCoolDown;
- (BOOL) updateOutOfBound;
- (void) updateAttackLogicWithUnit: (Unit *) enemyUnit;
// Animaton system
- (id) initWithClassName:(NSString*)className andFlipX:(BOOL)flipBoolean;
- (void) initBodySprite;
- (void) adjustAnchorPoint;
- (void) constructBody;
- (void) flipBody;
-(void)stopAllActions;
-(BOOL)isAllPartsStopMoving;
-(void) animateWalk;
-(void) animateBattle;
-(void) setFaceTexture:(UNIT_STATE) newState;
-(void) setBattleStance;
-(void) setNormalStance;
-(void) animateCry;
-(void) doMoveAction;
-(void) doFadeOut;
-(void) doShadow;




- (CCSprite*)loadPlistForSpriteWithName:(NSString*)spriteName 
                           andClassName:(NSString*)className;



@property (nonatomic, retain) NSNumber *unitTag;
@property (nonatomic, assign) int unitID;
@property (nonatomic, assign) float hitPoint;
@property (nonatomic, assign) float maxHitPoint;
@property (nonatomic, assign) float attack;
@property (nonatomic, assign) float attackSpeed;
@property (nonatomic, assign) float attackRange;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float spawnRate;
@property (nonatomic, assign) float coolDown;
@property (nonatomic, assign) float spawnCoolDown;
@property (nonatomic, retain) NSNumber *unitCost;
@property (nonatomic, retain) NSString *skill;
@property (nonatomic, retain) NSString *unitName;
//@property (nonatomic, retain) NSString *spriteName;
@property (nonatomic, retain) NSString *frameName;
@property (nonatomic, retain) NSString *animationName;
@property (nonatomic, assign) UNIT_STATE state;
@property (nonatomic, assign) UNIT_STATUS status;
@property (nonatomic, assign) ITEM_STATUS itemStatus;
@property (nonatomic, readwrite, retain) CCAnimation *walkAnim;
@property (nonatomic, readwrite, retain) CCAnimation *attackAnim;
@property (nonatomic, readwrite, retain) CCAnimation *cryAnim;
@property (nonatomic, retain) CCLabelTTF *hpLabel;
@property (nonatomic, retain) CCLabelBMFont *attackLabel;
@property (nonatomic, retain) CCLabelTTF *cooldownLabel;
@property (nonatomic, assign) ccTime stateTime;
@property (nonatomic,retain) CCSprite *headPart;
@property (nonatomic,retain) CCSprite *facePart;
@property (nonatomic,retain) CCSprite *bodyPart;
@property (nonatomic,retain) CCSprite *tailPart;
@property (nonatomic,retain) CCSprite *fLeg_LPart;
@property (nonatomic,retain) CCSprite *fLeg_RPart;
@property (nonatomic,retain) CCSprite *bLeg_LPart;
@property (nonatomic,retain) CCSprite *bLeg_RPart;
@property (nonatomic,assign) BOOL isBattleStance;
@property (nonatomic,assign) BOOL isFlipX;
@property (nonatomic,retain) NSString *unitClassName;
@property (nonatomic,retain) NSString *faceNormalFileName;
@property (nonatomic,retain) NSString *faceAttackFileName;
@property (nonatomic,retain) NSString *faceCryFileName;
@property (nonatomic, assign) float levelSpeedFactor;
@end
