//
//  BattleLayer.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 9/25/11.
//  Copyright 2011 Pulse. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import "Unit.h"
#import "GameObject.h"
#import "ItemClass.h"
#import "Coin.h"
#import "ProjectileObject.h"
#import "ThrowingCat.h"
#import "SoundEffects.h"
#import "Catapult.h"

#define kCoinRate 10

@interface BattleLayer : CCLayer {
    Unit *_selSprite;
    
    // Selectable Unit
    NSMutableArray *_selectableUnits;
    
    // Units on the field
    NSMutableArray *_playerUnits;
    NSMutableArray *_enemyUnits;
    NSMutableArray *gameObjectsWaitingToSpawn;
    
    // To keep track of projectile objects.
    NSMutableArray *projectileObjects;
    
    // All units from plist
    NSMutableArray *_catUnits;
    NSMutableArray *_dogUnits;
    
    //Test animation
    CCSprite *_enemy;
    CCAction *_walkAction;
    CCAction *_moveAction;
    BOOL _moving;
    int gameTime;
    int levelTime;
    CCLabelTTF *clock;
    
    /*For game event to detect gamestart*/
    BOOL isGameStarted;
    
    // Speed factor for current level
    float levelSpeedFactor;
}

+(id) nodeWithLevelID:(NSInteger)lid;
-(id) initWithLevelID:(NSInteger)lid; 

- (void) startScheduleGameLogic;
//- (void) initUnit;
//- (void) initSelectedUnit: (NSMutableArray*)unitArray;
- (void)addEnemyToLane:(NSInteger)lane andWithUnit:(GameObject *) unit;
- (void)addObjectToLane:(NSInteger)lane andWithObject:(GameObject *) object;
- (void) addEnemy;
- (void) generateCoin;

@property (nonatomic, retain) CCSprite *enemy;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) NSMutableArray *selectableUnits;
@property (nonatomic, retain) NSMutableArray *gameObjectsWaitingToSpawn;
@property (nonatomic, retain) NSMutableArray *projectileObjects;
@property (nonatomic, assign) int gameTime;
@property (nonatomic, assign) int levelTime;
@property (nonatomic, retain) CCLabelTTF *clock;
@property (nonatomic, assign) BOOL isGameStarted;
@property (nonatomic, assign) float levelSpeedFactor;
@end
