//
//  Pisit.m
//  Unit class with Procedural animation based on Sprites assigned as a part
//
//  Created by Pisit Praiwattana on 10/4/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#define kBaseAnimationAtkSpeed 5
#define kBaseAnimationMoveSpeed 5

typedef enum {HEADPART, FACEPART, BODYPART, FLEG_LPART, FLEG_RPART,BLEG_LPART,BLEG_RPART, TAILPART} BODY_TAG;

typedef enum {WALKFLEG_L, WALKFLEG_R,WALKBLEG_L, WALKBLEG_R, WALKHEAD,WALKTAIL, WALKFACE, MOVEACTION} ACTION_TAG;

typedef enum {IDLE, WALK, BATTLE, CRY, DEAD} UNIT_STATE;

@interface Unit_Type2: CCNode {
    CCSprite *headPart;
    CCSprite *facePart;
    CCSprite *bodyPart;
    CCSprite *tailPart;
    //Left and right based on original model faceing to left position
    CCSprite *fLeg_LPart;
    CCSprite *bLeg_LPart;
    CCSprite *fLeg_RPart;
    CCSprite *bLeg_RPart;
    UNIT_STATE state;
    float speed;
    float attackSpeed;
    BOOL isBattleStance;
    BOOL isFlipX;
    NSString *unitClassName;
    
    NSString *faceNormalFileName;
    NSString *faceAttackFileName;
    NSString *faceCryFileName;
}
- (id) initWithClassName:(NSString*)className andFlipX:(BOOL)flipBoolean;
- (void) initBodySprite;
- (void) adjustAnchorPoint;
- (void) constructBody;
- (void) updateStateWithDeltaTime:(ccTime)deltaTime;


- (CCSprite*)loadPlistForSpriteWithName:(NSString*)spriteName 
                           andClassName:(NSString*)className;

@property (nonatomic,retain) CCSprite *headPart;
@property (nonatomic,retain) CCSprite *facePart;
@property (nonatomic,retain) CCSprite *bodyPart;
@property (nonatomic,retain) CCSprite *tailPart;
@property (nonatomic,retain) CCSprite *fLeg_LPart;
@property (nonatomic,retain) CCSprite *fLeg_RPart;
@property (nonatomic,retain) CCSprite *bLeg_LPart;
@property (nonatomic,retain) CCSprite *bLeg_RPart;
@property (nonatomic,assign) UNIT_STATE state;
@property (nonatomic,assign) float speed;
@property (nonatomic,assign) float attackSpeed;
@property (nonatomic,assign) BOOL isBattleStance;
@property (nonatomic,assign) BOOL isFlipX;
@property (nonatomic,retain) NSString *unitClassName;
@property (nonatomic,retain) NSString *faceNormalFileName;
@property (nonatomic,retain) NSString *faceAttackFileName;
@property (nonatomic,retain) NSString *faceCryFileName;
@end
