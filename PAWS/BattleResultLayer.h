//
//  BattleResultLayer.h
//  PAWS
//
//  Created by Zinan Xing on 11/10/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "GameManager.h"
#import "AppDelegate.h"
#import "SoundEffects.h"
#import "EventLayer.h"

// Factors of stats when converting to points
#define ENEMY_KILLED_FACTOR        20  // 1 enemy beaten = 20 points
#define LEVEL_BONUS_FACTOR          1   // 1 levelCoinsBonus = 1 points
#define COINS_PICKED_FACTOR         10
#define HIT_POINT_REMAINS_FACTOR    30
#define SCORE_TO_FOOD_FACTOR        0.1 // 10 score = 1 can of food
#define EVENTLAYER_TAG 10

@interface BattleResultLayer : CCLayer {
    AppDelegate *appDelegate;
    GameManager *gameMan;
    UserProfile *currentPlayer;
    NSString *unlockedUnitName;
    NSString *unlockedItemName;
    NSInteger totalScore;
    NSInteger levelCoinsBonus;
    NSInteger totalFoodGained;
    CGSize winSize;
    NSInteger enemyKilled;
    NSInteger coinsPicked;
    NSInteger hitPointRemains;
    BOOL isWin;
    CCFadeIn *actionFadeIn;
    CCLabelTTF *totalScoreLabel;
    NSInteger scoreCounter;
    BOOL scoreCounterFinish;
    BOOL currentLevelAlreadyBeaten;
    CCSequence *displaySequence;
    NSInteger unlockedItemID;
    NSInteger unlockedUnitID;
    EventLayer *eventLayer;
    
}
+(id) nodeWithLevelIDAndResults:(NSInteger)levelID
                 andEnemyKilled:(NSInteger) enemyKilled
                 andCoinsPicked:(NSInteger) coinsPicked
             andHitPointRemains:(NSInteger) hitPointRemains
                       andIsWin:(Boolean) isWin;

-(id) initWithLevelIDAndResults:(NSInteger)levelID
                 andEnemyKilled:(NSInteger) enemyKilled
                 andCoinsPicked:(NSInteger) coinsPicked
             andHitPointRemains:(NSInteger) hitPointRemains
                       andIsWin:(Boolean) isWin;

-(void)showEventByFile:(NSString*)filename withScale:(float)inScale andSecond:(float)inSec;

-(void) displayLevelBonusLabel;
-(void) displayCoinsPickedLabel;
-(void) displayEnemyKilledLabel;
-(void) displayUnitUnlockLabel;
-(void) displayItemUnlockLabel;
-(void) displayHPRemainsLabel;
-(void) displayTotalScoreLabel;
-(void) displayTotalFoodLabel;

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) GameManager *gameMan;
@property (nonatomic, retain) UserProfile *currentPlayer;
@property (nonatomic, retain) NSString *unlockedUnitName;
@property (nonatomic, retain) NSString *unlockedItemName;
@property (nonatomic, assign) NSInteger totalScore;
@property (nonatomic, assign) NSInteger levelCoinsBonus;
@property (nonatomic, assign) NSInteger totalFoodGained;
@property (nonatomic, assign) CGSize winSize;
@property (nonatomic, assign) NSInteger enemyKilled;
@property (nonatomic, assign) NSInteger hitPointRemains;
@property (nonatomic, assign) NSInteger coinsPicked;
@property (nonatomic, assign) BOOL isWin;
@property (nonatomic, retain) CCFadeIn *actionFadeIn;
@property (nonatomic, retain) CCLabelTTF *totalScoreLabel;
@property (nonatomic, assign) NSInteger scoreCounter;
@property (nonatomic, assign) BOOL scoreCounterFinish;
@property (nonatomic, assign) BOOL currentLevelAlreadyBeaten;
@property (nonatomic, assign) CCSequence *displaySequence;
@property (nonatomic, assign) NSInteger unlockedUnitID;
@property (nonatomic, assign) NSInteger unlockedItemID;
@property (nonatomic, retain) EventLayer *eventLayer;
@end

