//
//  BattleScene.h
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "BattleLayer.h"
#import "BattleGUILayer.h"
#import "BattleHUD.h"
#import "BattleResultLayer.h"
#import "ConsoleLayer.h"
#import "EventLayer.h"
#import "DialogLayer.h"

// Special Cat units
#import "JumpingCat.h"
#import "GhostCat.h"
#import "WitchCat.h"
#import "HealerCat.h"

// Special Dog units
#import "BigDog.h"
#import "GhostDog.h"
#import "PuddleDog.h"
#import "SiberianHuskyDog.h"

#import "SoundEffects.h"

#define LANE_HEIGHT 60
#define HUD_HEIGHT 55
#define kUnitHeight 80
#define kUnitWidth 128
#define kCoinObject 30
#define kPowerupHP 40
#define kPowerupATK 41
#define kPowerupSPD 42

#define kBattleTime 100

//Unit Definition
#define kJumpingCatUnit 1
#define kFluffyCatUnit 2
#define kGhostCatUnit 3
#define kThrowingCatUnit 4
#define kWitchCatUnit 5
#define kHealerCatUnit 6
//Dog
#define kNormalDog 10
#define kFastDog 11
#define kBigDog 12
#define kGhostDog 13
#define kStupidDog 14
#define kPuddle 15
#define kSiberianHusky 16

#define kDebugCoin NO
#define kDebugText NO


enum {BATTLELAYER_TAG, BATTLEHUD_TAG, BATTLEGUI_TAG, BATTLEEVENT_TAG, BATTLEDIALOG_TAG, BATTLEPAUSELAYER_TAG } BATTLE_SCENE_LAYER_TAG;

typedef enum {START_STATE, EVENT_STATE, DIALOG_STATE, BATTLE_STATE,  ENDEVENT_STATE, TRANSITION_STATE} BATTLESCENE_STATE;

@interface BattleScene : CCScene{
    //CCLayer *_layer;
    BattleGUILayer *_layer;
    BattleLayer *_battleLayer;
    BattleHUDLayer *battleHUDLayer;
    EventLayer *eventLayer;
    DialogLayer *dialogLayer;
    
    NSInteger levelID;
    NSDate *levelStartTime;
    
    // Game state
    NSInteger playerHP;
    NSInteger enemyHP;
    NSInteger playerCoin;
    // Selectable Unit for Drag and Drop controller
    NSMutableArray *selectableUnits;
    
    // All units from plist
    NSMutableArray *catUnits;
    NSMutableArray *dogUnits;
    
    // Item from plist
    NSMutableArray *itemList;
    
    // Player & enemy units on the field
    NSMutableArray *playerUnits;
    NSMutableArray *enemyUnits;
    
    // Items
    NSMutableArray   *items;
    
    // Other game objects
    NSMutableArray *gameObjects;
    
    BOOL isGamePaused;
    BOOL isPlayerWin;
    BATTLESCENE_STATE sceneState;
    //ConsoleLayer *consoleLayer;
    
    NSNumber *playerUnitTag;
    NSNumber *enemyUnitTag;
    
    //Stats
    int unitLost;
    int enemyKilled;
    int coinPicked;
}

+(id) nodeWithLevelID:(NSInteger)lid;
-(id) initWithLevelID:(NSInteger)lid; 

-(int) getClockTimeSeconds;
-(int) getClockTimeMiliseconds;

-(void) initUnitFromPlist;
-(NSMutableArray *) getPlayerUnitArray;
-(NSMutableArray *) getEnemyUnitArray;
-(NSMutableArray *) getCatUnitArray;
-(NSMutableArray *) getDogUnitArray;
-(NSMutableArray *) getGameObjectArray;

-(void) initItemFromPlist;

-(void) addPlayerUnitwithUnit: (Unit*) unit;
-(void) addPlayerUnitwithUnit: (Unit*) unit andOnLane: (int) lane;
-(void) addPlayerUnitHPLabel: (Unit*) unit;
-(void) addEnemyUnitHPLabel: (Unit*) unit;
-(void) addEnemyUnitwithUnit: (Unit*) unit;
-(void) addEnemyUnitwithUnit: (Unit*) unit andOnLane: (int) lane;
-(void) addGameObject: (GameObject*) gameObject;

-(void) removePlayerUnit: (Unit*) unit;
-(void) removeEnemyUnit: (Unit*) unit;
-(void) removeGameObject: (GameObject*) gameObject;

-(void) decreasePlayerHP;
-(void) decreaseEnemyHP;
-(void) increaseCoin;
-(void) increaseCoinByAmount: (NSInteger) amount;
-(void) cleanupCoinObject;

-(void) checkBattleResult;
-(void) endBattle;
-(void) loseBattle;
-(void) winBattle;

-(void) showEventByFile:(NSString*)filename withScale:(float)inScale andSecond:(float)inSec;
-(void) detectEventSchedule;
-(void) doPause;
-(void) doPauseWithNoPanel;
-(void) doResume;

-(void) playerWinTransit;   //Added by Melo, for testing use, delete it before release.
-(void) playerLoseTransit;   //Added by Melo, for testing use, delete it before release.

/*
-(void) openConsole;
-(void) closeConsole;
*/

@property (nonatomic,retain) BattleGUILayer *layer;
//@property (nonatomic,retain) CCLayer *layer;
@property (nonatomic, retain) BattleLayer *battleLayer;
@property (nonatomic, retain) BattleHUDLayer *battleHUDLayer;
@property (nonatomic, retain) EventLayer *eventLayer;
@property (nonatomic, retain) DialogLayer *dialogLayer;
@property (nonatomic,assign) NSInteger levelID;
@property (nonatomic, retain) NSDate *levelStartTime;
@property (nonatomic,assign) NSInteger playerHP;
@property (nonatomic,assign) NSInteger enemyHP;
@property (nonatomic,assign) NSInteger playerCoin;
@property (nonatomic, retain) NSMutableArray *selectableUnits;
@property (nonatomic, retain) NSMutableArray *catUnits;
@property (nonatomic, retain) NSMutableArray *dogUnits;
@property (nonatomic, retain) NSMutableArray *itemList;
@property (nonatomic, retain) NSMutableArray *playerUnits;
@property (nonatomic, retain) NSMutableArray *enemyUnits;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *gameObjects;
@property (nonatomic,assign) BOOL isGamePaused;
@property (nonatomic,assign) BOOL isPlayerWin;
@property (nonatomic,assign) BATTLESCENE_STATE sceneState;
//@property (nonatomic, retain) ConsoleLayer *consoleLayer;
@property (nonatomic, retain) NSNumber *playerUnitTag;
@property (nonatomic, retain) NSNumber *enemyUnitTag;

@property (nonatomic, assign) int unitLost;
@property (nonatomic, assign) int enemyKilled;
@property (nonatomic, assign) int coinPicked;
@end
