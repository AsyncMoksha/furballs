//
//  BattleResultLayer.m
//  PAWS
//
//  Created by Zinan Xing on 11/10/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "BattleResultLayer.h"
#import "WorldMapScene.h"
#import "UpgradeScene.h"

// Label locations:
// Win Locations:
#define TITLE_LABEL_LOCATION_Y_WIN              300
#define LEVEL_BONUS_LABEL_LOCATION_Y_WIN        250
#define COINS_PICKED_LABEL_LOCATION_Y_WIN       230
#define ENEMY_KILLED_LABEL_LOCATION_Y_WIN       210
#define HIT_POINT_REMAINS_LABEL_LOCATION_Y_WIN  190
#define UNIT_UNLOCK_LABEL_LOCATION_Y_WIN        170
#define ITEM_UNLOCK_LABEL_LOCATION_Y_WIN        150


// Lose Locations:
#define TITLE_LABEL_LOCATION_Y_LOSE          300
#define COINS_PICKED_LABEL_LOCATION_Y_LOSE   250
#define ENEMY_KILLED_LABEL_LOCATION_Y_LOSE   230

// Locations which doesn't matter win or lose
#define TOTAL_SCORE_LABEL_LOCATION_Y    53
#define TOTAL_FOOD_LABEL_LOCATION_Y     53


//Label Box Size
#define LABEL_BOX_SIZE_X        450
#define BODY_LABEL_BOX_SIZE_Y   20

//Label Color
#define LABEL_COLOR ccc3(0,0,0)

@implementation BattleResultLayer
@synthesize appDelegate;
@synthesize gameMan;
@synthesize currentPlayer;
@synthesize unlockedItemName;
@synthesize unlockedUnitName;
@synthesize totalScore;
@synthesize levelCoinsBonus;
@synthesize totalFoodGained;
@synthesize winSize;
@synthesize enemyKilled;
@synthesize coinsPicked;
@synthesize hitPointRemains;
@synthesize isWin;
@synthesize actionFadeIn;
@synthesize totalScoreLabel;
@synthesize scoreCounter;
@synthesize scoreCounterFinish;
@synthesize currentLevelAlreadyBeaten;
@synthesize displaySequence;
@synthesize unlockedItemID;
@synthesize unlockedUnitID;
@synthesize eventLayer;

-(id) initWithLevelIDAndResults:(NSInteger)levelID
                 andEnemyKilled:(NSInteger) _enemyKilled
                 andCoinsPicked:(NSInteger) _coinsPicked
             andHitPointRemains:(NSInteger) _hitPointRemains
                       andIsWin:(Boolean)_isWin{
    //Init Event Layer
    //self.eventLayer = [[EventLayer alloc] init];
    //[self addChild: self.eventLayer z:200 tag:EVENTLAYER_TAG];
    
    
    winSize = [[CCDirector sharedDirector] winSize];
    
    //Obtain a pointer to the Game Manager object, so you can access the UserProfile object called "player"
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    gameMan = [appDelegate gameManager];
    currentPlayer = [gameMan player];
    
    enemyKilled = _enemyKilled;
    coinsPicked = _coinsPicked;
    hitPointRemains = _hitPointRemains;
    isWin = _isWin;
    
    //Get level plist file path
    NSString *levelFileName;
    if ([gameMan currentCampaign] == CTCats) {
    levelFileName = [NSString stringWithFormat:@"levelCat%d", levelID]; 
    } else {
    levelFileName = [NSString stringWithFormat:@"levelDog%d", levelID]; 
    }

    
   // NSString *levelFileName = [NSString stringWithFormat:@"level%d", levelID]; 
    NSString *levelFilePath = [[NSBundle mainBundle] pathForResource:levelFileName ofType:@"plist"];
    NSDictionary *levelContent = [NSMutableDictionary dictionaryWithContentsOfFile:levelFilePath];

    NSString *plistFileName;
    // For debug purpose
    int mod = 0;
    if ([gameMan currentCampaign] == CTDogs) {
        plistFileName = [NSString stringWithFormat:@"dogUnit"];
        mod = 10;
    } else {
        plistFileName = [NSString stringWithFormat:@"catUnit"];
    }
    
    //Get unlocked unit name
    unlockedUnitID = [[levelContent objectForKey:@"unittounlock"] integerValue];
    NSString *unitFilePath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"];
    NSDictionary *unitDict = [NSMutableDictionary dictionaryWithContentsOfFile:unitFilePath];
    NSArray *catUnits = [[NSMutableArray alloc] initWithArray:[unitDict objectForKey:@"Unit"]];
    NSDictionary *unlockedUnit = [catUnits objectAtIndex:unlockedUnitID];
    unlockedUnitName = [unlockedUnit objectForKey:@"name"];
    
    //Get unlocked item name
    unlockedItemID = [[levelContent objectForKey:@"itemtounlock"] integerValue];
    NSString *itemPlistFilePath = [[NSBundle mainBundle] pathForResource:@"simpleItems" ofType:@"plist"];
    NSDictionary *itemDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:itemPlistFilePath];
    NSArray *itemArray = [[NSMutableArray alloc] initWithArray:[itemDictionary objectForKey:@"item"]];
    NSDictionary *unlockItem = 0;
    for (NSDictionary *dict in itemArray) {
        if ([[dict objectForKey:@"id"] integerValue] == unlockedItemID) {
            unlockItem = dict;
            break;
        }
    }
    //= [itemArray objectAtIndex:unlockedItemID];
    if (unlockedItemID != 0){
        unlockedItemName = [unlockItem objectForKey:@"name"];
    } else {
        unlockedItemName = @"None";
    }
    
    //Get level coins bonus
    levelCoinsBonus = [[levelContent objectForKey:@"moneygained"] integerValue];
    
    //Count score
    if(isWin){
        totalScore = levelCoinsBonus * LEVEL_BONUS_FACTOR 
        + enemyKilled * ENEMY_KILLED_FACTOR
        + coinsPicked * COINS_PICKED_FACTOR
        + hitPointRemains * HIT_POINT_REMAINS_FACTOR;
        
    } else {
        totalScore =  
        + enemyKilled * ENEMY_KILLED_FACTOR
        + coinsPicked * COINS_PICKED_FACTOR;
    }
    
    totalFoodGained = totalScore * SCORE_TO_FOOD_FACTOR;
    currentLevelAlreadyBeaten = NO;
    for(Level *level in [currentPlayer levels]) {
        if([[level levelID] intValue] == levelID) {
            currentLevelAlreadyBeaten = YES;
            break;
        }
    }
    
    if(isWin) { // Only unlock and add food when win
        //Unlock new unit
        if (unlockedUnitID != 0) {
            unlockedUnitID = unlockedUnitID+mod;
            [gameMan unlockCardWithUnitType: unlockedUnitID];
        }
        // Unlock new Item
        
        if (unlockedItemID != 0) {
            [gameMan unlockItemWithItemType:(unlockedItemID)];
        }
/*  ----------------UNCOMMENT BEFORE RELEASE_____________________      
        if(!currentLevelAlreadyBeaten) {   */
             //Add food into user profile
            [currentPlayer setCoins: [NSNumber numberWithInt:
                                      [[currentPlayer coins] integerValue] + totalFoodGained]];
//        }
     
        //Unlock new item
        //[gameMan unlockItemWithItemType: unlockedItemID];
        
        //Set current level completed in user profile
        [gameMan setLevelCompleteForCurrentCampaign: levelID];
        
        // Unlock Achievement -- Fat Cat
        if(levelID == 9 && [gameMan currentCampaign] == CTCats) {
            [gameMan updateAchievementWithID:@"103" withProgress:100.0];
        } 
        
        // Unlock Achievement -- Top Dog        
        if(levelID == 9 && [gameMan currentCampaign] == CTDogs) {
            [gameMan updateAchievementWithID:@"104" withProgress:100.0];
        }
        
        //Unlock Achievement -- Primitive Strike
        if(levelID == 1) {
            [gameMan updateAchievementWithID:@"101" withProgress:100.0];
        }
        
        //Unlock Achievement -- Flawless Victory
        if( hitPointRemains == 3 ) {
            [gameMan updateAchievementWithID:@"102" withProgress:100.0];
        }
    } else {
        
        //Add food into user profile
        [currentPlayer setCoins: [NSNumber numberWithInt:
                                  [[currentPlayer coins] integerValue] + totalFoodGained]];
    }
    
    // Unlock Achievement -- Ballin
    if(coinsPicked >= 25)
        [gameMan updateAchievementWithID:@"105" withProgress:100.0];
    
    //Save all changes
    [gameMan saveAllChanges];

    
    // Some Initializations
    [[SimpleAudioEngine sharedEngine] preloadEffect:BACK_BTN_EFFECT];
    
    CCSprite *bg = [CCSprite spriteWithFile:@"BattleResultBG.png"];
    [bg setAnchorPoint:ccp(0,0)];
    [bg setPosition:ccp(0,0)];
    [self addChild:bg z:0];
    
    self.isTouchEnabled = true;
    
    id actionDelay = [CCDelayTime actionWithDuration:0.8];
    totalScoreLabel = nil;
    scoreCounter = 0;
    scoreCounterFinish = NO;
    
    [self scheduleUpdate];
    
    // LABELS:    
    // Labels for Win
    if(isWin) {
        
        CCLabelTTF *titleLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"You beat this level"] 
                                                   dimensions:CGSizeMake(320, 32) alignment:UITextAlignmentCenter 
                                                     fontName:@"Arial" fontSize:32.0] retain];
        titleLabel.position = ccp(winSize.width/2, 
                                  TITLE_LABEL_LOCATION_Y_WIN);
        titleLabel.color = LABEL_COLOR;
        [self addChild:titleLabel z:2];
        
        // Decide display sequence
        if( unlockedItemID != 0 && unlockedUnitID != 0) {
        displaySequence = [CCSequence actions:actionDelay,
                                       [CCCallFuncN actionWithTarget:self 
                                                            selector:@selector(displayLevelBonusLabel:)],
                                       actionDelay,
                                       [CCCallFuncN actionWithTarget:self 
                                                            selector:@selector(displayCoinsPickedLabel:)],
                                       actionDelay,
                                       [CCCallFuncN actionWithTarget:self 
                                                            selector:@selector(displayEnemyKilledLabel:)],
                                       actionDelay,
                                       [CCCallFuncN actionWithTarget:self 
                                                            selector:@selector(displayHPRemainsLabel:)],
                                       actionDelay,
                                       [CCCallFuncN actionWithTarget:self 
                                                            selector:@selector(displayUnitUnlockLabel:)],
                                       actionDelay,
                                       [CCCallFuncN actionWithTarget:self 
                                                            selector:@selector(displayItemUnlockLabel:)],
                                       actionDelay,
                                       [CCCallFuncN actionWithTarget:self 
                                                            selector:@selector(displayTotalScoreLabel:)],
                                       [CCDelayTime actionWithDuration: 1.3],
                                       [CCCallFuncN actionWithTarget:self 
                                                            selector:@selector(displayTotalFoodLabel:)],
                                       nil];
            
        } else if( unlockedItemID == 0) {
            displaySequence = [CCSequence actions:actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayLevelBonusLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayCoinsPickedLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayEnemyKilledLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayHPRemainsLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayUnitUnlockLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayTotalScoreLabel:)],
                               [CCDelayTime actionWithDuration: 1.3],
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayTotalFoodLabel:)],                              
                               nil];
            
        } else if( unlockedUnitID == 0) {
            displaySequence = [CCSequence actions:actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayLevelBonusLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayCoinsPickedLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayEnemyKilledLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayHPRemainsLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayItemUnlockLabel:)],
                               actionDelay,
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayTotalScoreLabel:)],
                               [CCDelayTime actionWithDuration: 1.3],
                               [CCCallFuncN actionWithTarget:self 
                                                    selector:@selector(displayTotalFoodLabel:)],
                               nil];
        }
        [self runAction: displaySequence];
        
    } else {    // If Lose
        
        // Title label:
        CCLabelTTF *titleLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Maybe Next Time..."] 
                                                   dimensions:CGSizeMake(320, 32) alignment:UITextAlignmentCenter 
                                                     fontName:@"Arial" fontSize:32.0] retain];
        titleLabel.position = ccp(winSize.width/2, 
                                  TITLE_LABEL_LOCATION_Y_LOSE);
        titleLabel.color = LABEL_COLOR;
        [self addChild:titleLabel z:2];
        
        [self runAction: [CCSequence actions: actionDelay,
                                              [CCCallFuncN actionWithTarget:self 
                                                                   selector:@selector(displayCoinsPickedLabel:)],
                                              actionDelay,
                                              [CCCallFuncN actionWithTarget:self 
                                                                   selector:@selector(displayEnemyKilledLabel:)],
                                              actionDelay,
                                              [CCCallFuncN actionWithTarget:self 
                                                                   selector:@selector(displayTotalScoreLabel:)],
                                              [CCDelayTime actionWithDuration: 1.3],
                                              [CCCallFuncN actionWithTarget:self 
                                                                   selector:@selector(displayTotalFoodLabel:)],
                                              nil]];
        
        //[self showEventByFile:@"Achievement_FlawlessVictory.png" withScale:1.0f andSecond:3.0f];
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Event Display Function
-(void)showEventByFile:(NSString*)filename withScale:(float)inScale andSecond:(float)inSec{
    
    //Demo 
    //
    //[self showEventByFile:@"Achievement_FlawlessVictory.png" withScale:1.0f andSecond:3.0f];

    if(self.eventLayer){
        [self.eventLayer popIconInCenterWithFile:filename withScale:inScale andSecond:inSec];
    }
    
}

#pragma mark -
#pragma mark Display Functions

-(void) displayLevelBonusLabel: (id) sender {
    //Level coins bonus label
    CCLabelTTF *levelBonusLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level Bonus Food: %d", levelCoinsBonus] 
                                                    dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentLeft 
                                                      fontName:@"Arial" fontSize:16.0] retain];
    levelBonusLabel.position = ccp(winSize.width/2, 
                                   LEVEL_BONUS_LABEL_LOCATION_Y_WIN);
    levelBonusLabel.color = LABEL_COLOR;
    [self addChild:levelBonusLabel z:2];
    
}

-(void) displayCoinsPickedLabel: (id) sender {
    if(isWin) {
        //Coins picked label
        CCLabelTTF *coinsPickedLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Collected Coins: %d", coinsPicked] 
                                                         dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentLeft 
                                                           fontName:@"Arial" fontSize:16.0] retain];
        coinsPickedLabel.position = ccp(winSize.width/2, 
                                        COINS_PICKED_LABEL_LOCATION_Y_WIN);
        coinsPickedLabel.color = LABEL_COLOR;
        [self addChild:coinsPickedLabel z:2];
    } else {
        //Coins picked label
        CCLabelTTF *coinsPickedLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Collected Coins: %d", coinsPicked] 
                                                         dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentLeft 
                                                           fontName:@"Arial" fontSize:16.0] retain];
        coinsPickedLabel.position = ccp(winSize.width/2, 
                                        COINS_PICKED_LABEL_LOCATION_Y_LOSE);
        coinsPickedLabel.color = LABEL_COLOR;
        [self addChild:coinsPickedLabel z:2];
    }
}

-(void) displayEnemyKilledLabel:(id) sender {
    if(isWin) {
        //Enemy killed label
        CCLabelTTF *enemyKilledLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Beaten Enemies: %d", enemyKilled] 
                                                         dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentLeft 
                                                           fontName:@"Arial" fontSize:16.0] retain];
        enemyKilledLabel.position = ccp(winSize.width/2, 
                                        ENEMY_KILLED_LABEL_LOCATION_Y_WIN);
        enemyKilledLabel.color = LABEL_COLOR;
        [self addChild:enemyKilledLabel z:2];
    } else {
        //Enemy killed label
        CCLabelTTF *enemyKilledLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Beaten Enemies: %d", enemyKilled] 
                                                         dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentLeft 
                                                           fontName:@"Arial" fontSize:16.0] retain];
        enemyKilledLabel.position = ccp(winSize.width/2, 
                                        ENEMY_KILLED_LABEL_LOCATION_Y_LOSE);
        enemyKilledLabel.color = LABEL_COLOR;
        [self addChild:enemyKilledLabel z:2];
    }
}

-(void) displayHPRemainsLabel: (id) sender {
    // HP remains Label
    CCLabelTTF *hitPointRemainsLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Remaining Lives: %d", hitPointRemains] 
                                                         dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentLeft 
                                                           fontName:@"Arial" fontSize:16.0] retain];
    hitPointRemainsLabel.position = ccp(winSize.width/2, 
                                        HIT_POINT_REMAINS_LABEL_LOCATION_Y_WIN);
    hitPointRemainsLabel.color = LABEL_COLOR;
    [self addChild:hitPointRemainsLabel z:2];

}

-(void) displayUnitUnlockLabel:(id) sender {
    //Unit Unlock label:
    CCLabelTTF *unitUnlockLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Unit Unlocked: %@", unlockedUnitName] 
                                                    dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentLeft 
                                                      fontName:@"Arial" fontSize:16.0] retain];
    unitUnlockLabel.position = ccp(winSize.width/2, 
                                   UNIT_UNLOCK_LABEL_LOCATION_Y_WIN);
    unitUnlockLabel.color = LABEL_COLOR;
    [self addChild:unitUnlockLabel z:2];
}

-(void) displayItemUnlockLabel:(id) sender {
    // Item Unlock Label
    CCLabelTTF *itemUnlockLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Item Unlocked: %@", unlockedItemName] 
                                                    dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentLeft 
                                                      fontName:@"Arial" fontSize:16.0] retain];
    if(unlockedUnitID != 0) {
        itemUnlockLabel.position = ccp(winSize.width/2, 
                                       ITEM_UNLOCK_LABEL_LOCATION_Y_WIN);
    } else {
        itemUnlockLabel.position = ccp(winSize.width/2, 
                                       UNIT_UNLOCK_LABEL_LOCATION_Y_WIN);
    }
    
    itemUnlockLabel.color = LABEL_COLOR;
    [self addChild:itemUnlockLabel z:2];
}

-(void) displayTotalScoreLabel:(id)sender {

    //Total Score label
    totalScoreLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d", totalScore] 
                                                    dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentLeft 
                                                      fontName:@"Arial" fontSize:16.0] retain];
    totalScoreLabel.position = ccp(winSize.width/2, 
                                   TOTAL_SCORE_LABEL_LOCATION_Y);
    totalScoreLabel.color = LABEL_COLOR;
    
    [self addChild:totalScoreLabel z:2];
}

-(void) displayTotalFoodLabel:(id)sender {
    //Total Food Label
//    if(!currentLevelAlreadyBeaten) {
        CCLabelTTF *totalFoodLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total Food Gained: %d", totalFoodGained] 
                                                       dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentRight
                                                         fontName:@"Arial" fontSize:16.0] retain];
        totalFoodLabel.position = ccp(winSize.width/2, 
                                      TOTAL_FOOD_LABEL_LOCATION_Y);
        totalFoodLabel.color = LABEL_COLOR;
        
        [self addChild:totalFoodLabel z:2];
//    } else {   --- uncomment before release -----
    /*
        CCLabelTTF *totalFoodLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total Food Gained: 0"] 
                                                       dimensions:CGSizeMake(LABEL_BOX_SIZE_X, BODY_LABEL_BOX_SIZE_Y) alignment:UITextAlignmentRight
                                                         fontName:@"Arial" fontSize:16.0] retain];
        totalFoodLabel.position = ccp(winSize.width/2, 
                                      TOTAL_FOOD_LABEL_LOCATION_Y);
        totalFoodLabel.color = LABEL_COLOR;
        
        [self addChild:totalFoodLabel z:2];
     */
//    }

}


+(id) nodeWithLevelIDAndResults:(NSInteger)levelID 
                 andEnemyKilled:(NSInteger)enemyKilled 
                 andCoinsPicked:(NSInteger)coinsPicked
             andHitPointRemains:(NSInteger) hitPointRemains
                       andIsWin:(Boolean)isWin{
    
    return [[[self alloc]       initWithLevelIDAndResults:(NSInteger)levelID
                                           andEnemyKilled:(NSInteger) enemyKilled
                                           andCoinsPicked:(NSInteger) coinsPicked
                                       andHitPointRemains:(NSInteger) hitPointRemains
                                                 andIsWin:(Boolean) isWin] autorelease];
}

- (void)update:(ccTime)dt {
    if(totalScoreLabel != nil && !scoreCounterFinish) {
        int counterIncrement = totalScore * dt;
        scoreCounter += counterIncrement;
        
        if(totalScore - scoreCounter > 100) {
            [totalScoreLabel setString:[NSString stringWithFormat:@"Score: %d", scoreCounter]];
            
        } else {
            scoreCounterFinish = YES;
            [totalScoreLabel setString:[NSString stringWithFormat:@"Score: %d", totalScore]];
        }
        
        
    }
}

-(void) registerWithTouchDispatcher
{
    //Override to register this CCLayer to globalTouch Dispatcher
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

/**
 *  ccTouchBegan
 *  Keep track of touch at starting point.
 */
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    //Return true to claim this touch
    CCLOG(@"Touched");
    return TRUE;    
}
/**
 *  ccTouchEnded
 *  After player release his/her finger read next message
 */
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CCLOG(@"Touched Ended");
    if(scoreCounterFinish) {
        @try {
            [[SimpleAudioEngine sharedEngine] playEffect:BACK_BTN_EFFECT];
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[UpgradeScene scene]]];
          //[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[WorldMapScene node]]];
        } @catch (NSException *ns){
            NSLog(@"%@",ns 	);
        }
    }
}


//Back btn OnClicked function
-(void) backBtnClicked{
    //Transition to WorldMap Scene : For testing back and forth
    
    @try {
        [[SimpleAudioEngine sharedEngine] playEffect:BACK_BTN_EFFECT];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[UpgradeScene scene]]];
        //[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[WorldMapScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}

-(void)dealloc{
    [self.eventLayer release];
    self.eventLayer = nil;
    [super dealloc];
}

@end
