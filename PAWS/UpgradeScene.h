//
//  UpgradeScene.h
//  PAWS
//
//  Created by Zinan Xing on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameManager.h"
#import "AppDelegate.h"
#import "SoundEffects.h"
#import "StoreScene.h"
/*
//Global variables for storing updating modifications (temporary)
extern float hitPointModification;
extern float attackModification;
extern float attackSpeedModification;
extern float speedModification;
*/
@interface UpgradeLayer : CCLayerColor <UIAlertViewDelegate>{
    int _currentHitPointLevel;
    int _currentAttackLevel;
    int _currentAttackSpeedLevel;
    int _currentSpeedLevel;
    int _currentSpawnRateLevel;
    int _currentCoins;
    
    NSMutableArray *_levelItemsArray;
    NSMutableArray *_hitPointLevel;
    NSMutableArray *_attackLevel;
    NSMutableArray *_attackSpeedLevel;
    NSMutableArray *_speedLevel;
    NSMutableArray *_spawnRateLevel;
    
    CCLabelTTF *_hitPointLevelLabel;
    CCLabelTTF *_attackLevelLabel;
    CCLabelTTF *_attackSpeedLevelLabel;
    CCLabelTTF *_speedLevelLabel;
    CCLabelTTF *_spawnRateLevelLabel;
    CCLabelTTF *_coinsLabel;
    
    CCLabelTTF *_hitPointLevelDescriptionLabel;
    CCLabelTTF *_attackLevelDescriptionLabel;
    CCLabelTTF *_attackSpeedLevelDescriptionLabel;
    CCLabelTTF *_speedLevelDescriptionLabel;
    CCLabelTTF *_spawnRateLevelDescriptionLabel;
    
    NSString *_hitPointLevelDescription;
    NSString *_attackLevelDescription;
    NSString *_attackSpeedLevelDescription;
    NSString *_speedLevelDescription;
    NSString *_spawnRateLevelDescription;
    
    AppDelegate *_appDelegate;
    GameManager *_gameMan;
    UserProfile *_currentPlayer;
    
}
@property (nonatomic, assign) int currentHitPointLevel;
@property (nonatomic, assign) int currentAttackLevel;
@property (nonatomic, assign) int currentAttackSpeedLevel;
@property (nonatomic, assign) int currentSpeedLevel;
@property (nonatomic, assign) int currentSpawnRateLevel;
@property (nonatomic, assign) int currentCoins;

@property (nonatomic, assign) NSMutableArray *hitPointLevel;
@property (nonatomic, assign) NSMutableArray *attackLevel;;
@property (nonatomic, assign) NSMutableArray *attackSpeedLevel;;
@property (nonatomic, assign) NSMutableArray *speedLevel;
@property (nonatomic, assign) NSMutableArray *spawnRateLevel;
@property (nonatomic, assign) NSMutableArray *levelItemsArray;

@property (nonatomic, assign) CCLabelTTF *hitPointLevelLabel;
@property (nonatomic, assign) CCLabelTTF *attackLevelLabel;
@property (nonatomic, assign) CCLabelTTF *attackSpeedLevelLabel;
@property (nonatomic, assign) CCLabelTTF *speedLevelLabel;
@property (nonatomic, assign) CCLabelTTF *spawnRateLevelLabel;
@property (nonatomic, assign) CCLabelTTF *coinsLabel;

@property (nonatomic, assign) CCLabelTTF *hitPointLevelDescriptionLabel;
@property (nonatomic, assign) CCLabelTTF *attackLevelDescriptionLabel;
@property (nonatomic, assign) CCLabelTTF *attackSpeedLevelDescriptionLabel;
@property (nonatomic, assign) CCLabelTTF *speedLevelDescriptionLabel;
@property (nonatomic, assign) CCLabelTTF *spawnRateLevelDescriptionLabel;

@property (nonatomic, assign) NSString *hitPointLevelDescription;
@property (nonatomic, assign) NSString *attackLevelDescription;
@property (nonatomic, assign) NSString *attackSpeedLevelDescription;
@property (nonatomic, assign) NSString *speedLevelDescription;
@property (nonatomic, assign) NSString *spawnRateLevelDescription;


@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) GameManager *gameMan;
@property (nonatomic, retain) UserProfile *currentPlayer;

-(void) initUnitLevelsFromPlist;
-(void) alertFoodInsufficiency;
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
/*
-(int) getCostFromLevelArray:(NSMutableArray *) dict
              andLevelNumber: (int) levelNumber
                      andKey: (NSString *) key;
*/

//-(int) getCostFromLevelArray:(NSMutableArray *) dict
//              andLevelNumber: (int) levelNumber
//                      andKey: (NSString *) key;


/*
-(void) updateHitPointModification;
-(void) updateAttackModification;
-(void) updateAttackSpeedModification;
-(void) updateSpeedModification;
*/
@end


@interface UpgradeScene : CCScene {
    UpgradeLayer *_UpgradeLayer;
}
+(CCScene *) scene;
@property (nonatomic,retain) UpgradeLayer *UpgradeLayer;
@end

