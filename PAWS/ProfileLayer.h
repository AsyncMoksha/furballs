//
//  ProfileLayer.h
//  PAWS
//
//  Created by Zinan Xing on 11/17/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "WorldMapScene.h"
#import "SoundEffects.h"
#import "GameManager.h"
#import "AppDelegate.h"
#import "Unit.h"
#import "GhostCat.h"
#import "JumpingCat.h"
#import "ItemClass.h"

#define LABEL_DISTANCE 3;
typedef enum {Wiki_unitOverlay, Wiki_itemOverlay, Wiki_achieOverlay } Wiki_tags;

@interface ProfileLayer : CCLayerColor {
    AppDelegate *appDelegate;
    GameManager *gameMan;
    UserProfile *currentPlayer;
    CGSize winSize;
    CCNode *unitList;
    CCNode *itemList;
    CCNode *achievementList;
    CCNode *currentDisplayList;
    CCSprite *topBar;
    float lastLabelPositionY;
    float firstLabelPositionY;
    float labelContentSizeY;
}
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) GameManager *gameMan;
@property (nonatomic, retain) UserProfile *currentPlayer;
@property (nonatomic, assign) CGSize winSize;
@property (nonatomic, retain) CCNode *unitList;
@property (nonatomic, retain) CCNode *itemList;
@property (nonatomic, retain) CCNode *achievementList;
@property (nonatomic, retain) CCNode *currentDisplayList;
@property (nonatomic, retain) CCSprite *topBar;
@property (nonatomic, assign) float lastLabelPositionY;
@property (nonatomic, assign) float firstLabelPositionY;
@property (nonatomic, assign) float labelContentSizeY;


-(void) displayUnits;
-(void) displayItems;
-(void) displayAchievements;
+(id) node;
-(NSString*)loadUnitInfoFromPlistName: (NSString*)nameWithoutType withID:(int) inID;
@end
