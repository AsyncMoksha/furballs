//
//  BattleScene.m
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//



#import "BattleScene.h"
#import "WorldMapScene.h"
#import "Unit.h"
#import "GameManager.h"
#import "AppDelegate.h"
#import "PauseLayer.h"


//Scene Implementation
@implementation BattleScene
@synthesize layer = _layer;
@synthesize battleLayer = _battleLayer;
@synthesize battleHUDLayer;
@synthesize eventLayer;
@synthesize dialogLayer;
@synthesize levelID;
@synthesize levelStartTime;
@synthesize playerHP;
@synthesize enemyHP;
@synthesize playerCoin;
@synthesize selectableUnits;
@synthesize catUnits;
@synthesize dogUnits;
@synthesize itemList;
@synthesize playerUnits;
@synthesize enemyUnits;
@synthesize items;
@synthesize gameObjects;
@synthesize isGamePaused;
@synthesize isPlayerWin;
@synthesize sceneState;
//@synthesize consoleLayer;
@synthesize playerUnitTag;
@synthesize enemyUnitTag;
@synthesize unitLost;
@synthesize enemyKilled;
@synthesize coinPicked;
/*
@synthesize enemy = _enemy;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;
 */
- (id)init
{
    //consoleLayer = [[ConsoleLayer alloc] init];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CardAtLas.plist"];
    return [self initWithLevelID:-1];
}

//Inits the scene with the level ID
-(id) initWithLevelID:(NSInteger)lid 
{
    self = [super init];
    if (self) {
        
        //Get the game manager singleton object
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        GameManager *gameMan = [appDelegate gameManager];
        
        // Initialize pause state
        self.isGamePaused = true;
        self.isPlayerWin = false;
        self.sceneState = START_STATE;
        
        // Tag management
        enemyUnitTag = [[NSNumber alloc] initWithInt:0];
        enemyUnitTag = [[NSNumber alloc] initWithInt:1000];
        
        // Stats
        unitLost = 0;
        enemyKilled = 0;
        coinPicked = 0;
        
        /* Initialize Game Variables */
        playerHP = 3;
        enemyHP = 20;
        // player coin should reflect on saved state
        //playerCoin = [[currentPlayer coins] intValue];
        if (kDebugCoin) {
            playerCoin = 500;
        } else
            playerCoin = 0;
        
        // For Hud drag and drop
        selectableUnits = [[NSMutableArray alloc] init];
        playerUnits = [[NSMutableArray alloc] init ];
        enemyUnits = [[NSMutableArray alloc] init ];
        gameObjects = [[NSMutableArray alloc] init ];
        itemList = [[NSMutableArray alloc] init ];
        items = [[NSMutableArray alloc] init ];

        self.battleLayer = [BattleLayer nodeWithLevelID:lid];
        [self addChild:_battleLayer];
        
        [self initUnitFromPlist];
        [self initItemFromPlist];
        
        //CCLOG (@"cat unit count %d", [catUnits count]);
        
        self.layer = [BattleGUILayer nodeWithLevelID:lid];
        [self addChild:_layer];
        
        // Add Battle logic layer
         
        
        //CCLayer *battleHud = [BattleHUDLayer node];
        self.battleHUDLayer = [BattleHUDLayer node];
        [self addChild:battleHUDLayer];
        
        [self.battleHUDLayer initUnitBuilderWithArray:
                                    [self getPlayerUnitArray]];
        [self.battleHUDLayer initItemWithArray:itemList];
        //[[self layer] initConsoleWithArray:selectableUnits];
        
        //Init the level data
        [self setLevelID:lid];
        
        //Init the game clock
        //[self setLevelStartTime:[NSDate date]];
        
        /*Event and Dialog*/
        NSString *prefixDialogue = nil;
        if(gameMan.currentCampaign == CTCats){
            prefixDialogue = @"Cat";
        }else{
            prefixDialogue = @"Dog";
        }
        
        self.eventLayer = [[EventLayer alloc] init];
        self.dialogLayer = [[DialogLayer alloc] initWithBMFont:@"AppleLiGothic_Black18.fnt" andDialog:[NSString stringWithFormat:@"%@dialog%d",prefixDialogue,lid]];
        
       // CCLOG([NSString stringWithFormat:@"%@dialog%d",prefixDialogue,lid]);
        [self addChild:eventLayer z:5 tag:BATTLEEVENT_TAG];
        [self addChild:dialogLayer z:6 tag:BATTLEDIALOG_TAG];
        
        //Schedule dialog and event closing
        [self schedule:@selector(detectEventSchedule)];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:BACK_BTN_EFFECT];
        [[SimpleAudioEngine sharedEngine] preloadEffect:BATTLE_SCENE_BGM];
        [[SimpleAudioEngine sharedEngine] preloadEffect:WIN_EFFECT];
        [[SimpleAudioEngine sharedEngine] preloadEffect:LOSE_EFFECT];
        
        
    }
    return self;
}

+(id) nodeWithLevelID:(NSInteger)lid
{
    return [[[self alloc] initWithLevelID:lid ] autorelease];
}


-(void) dealloc{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    //Release GUI Layer
    [_layer release];
    _layer = nil;
    //Release Battle Layer
    [_battleLayer release];
    _battleLayer = nil;
    [battleHUDLayer release];
    battleHUDLayer = nil;
    [levelStartTime release];
    levelStartTime = nil;
    //[consoleLayer release];
    //consoleLayer = nil;
    [gameObjects release];
    gameObjects = nil;
    [playerUnits release];
    playerUnits = nil;
    [enemyUnits release];
    enemyUnits = nil;
    [eventLayer release];
    eventLayer = nil;
    [dialogLayer release];
    dialogLayer = nil;
    
    [super dealloc];
}



#pragma mark -
#pragma mark Scene pause and start up event and dialog

-(void)showEventByFile:(NSString*)filename withScale:(float)inScale andSecond:(float)inSec{
    
    //Demo 
    //
    //[self showEventByFile:@"Achievement_FlawlessVictory.png" withScale:1.0f andSecond:3.0f];
    
    [self removeChildByTag:BATTLEEVENT_TAG cleanup:YES];
    
    self.eventLayer = [[EventLayer alloc] init];
    [self addChild:eventLayer z:5 tag:BATTLEEVENT_TAG];
    [self.eventLayer popIconInCenterWithFile:filename withScale:inScale andSecond:inSec];
    
}

-(void) detectEventSchedule{
    if(self.sceneState == START_STATE){
        
        sceneState = DIALOG_STATE;
        [self.dialogLayer openStoryDialog];
        
    }
    if(!self.dialogLayer.isDialogOpened && self.sceneState == DIALOG_STATE){
       
        sceneState = EVENT_STATE;
        [self removeChildByTag:BATTLEDIALOG_TAG cleanup:YES];
        //Conditional here, if the side is cat -> BattleEventCat.png, else BattleEventDong.png
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        GameManager *gameMan = [appDelegate gameManager];
        if(gameMan.currentCampaign == CTCats){
            [self.eventLayer popIconInFromLeftWithFile:@"BattleEventCat.png" withScale:0.75f andSecond:3.0f];
        }else{
            [self.eventLayer popIconInFromLeftWithFile:@"BattleEventDog.png" withScale:0.75f andSecond:3.0f];
        }
        //[[SimpleAudioEngine sharedEngine] playEffect:@"EnterBattleSound.m4a"];
    }
    if(!self.eventLayer.isEventShowed && self.sceneState == EVENT_STATE){
        
        self.sceneState = BATTLE_STATE;
        [self removeChildByTag:BATTLEEVENT_TAG cleanup:YES];
        
        //Play a song
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:BATTLE_SCENE_BGM];
        
        //[self.eventLayer setVisible:false];
        self.isGamePaused = false;

        if( !([self battleLayer].isGameStarted) ){
            //CCLOG(@"Resume Game Battle Logic");
            [self setLevelStartTime:[NSDate date]];
            [[self battleLayer] startScheduleGameLogic];
        }
        [self unschedule:@selector(detectEventSchedule)];
    }
    if(self.sceneState == ENDEVENT_STATE){
        self.sceneState = TRANSITION_STATE;
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [self doPauseWithNoPanel];
        self.eventLayer = [[EventLayer alloc] init];
        [self addChild:eventLayer z:5 tag:BATTLEEVENT_TAG];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        GameManager *gameMan = [appDelegate gameManager];
        
        if(isPlayerWin){
            if(gameMan.currentCampaign == CTCats){
                [self.eventLayer popIconInCenterWithFile:@"WinCatEvent.png" withScale:0.75f andSecond:6.0f]; 
            }else{
                [self.eventLayer popIconInCenterWithFile:@"WinDogEvent.png" withScale:0.75f andSecond:6.0f]; 
            }
            [[SimpleAudioEngine sharedEngine] playEffect:WIN_EFFECT];
        }else{
            if(gameMan.currentCampaign == CTCats){
                [self.eventLayer popIconInCenterWithFile:@"LoseCatEvent.png" withScale:0.75f andSecond:6.0f]; 
            }else{
                [self.eventLayer popIconInCenterWithFile:@"LoseDogEvent.png" withScale:0.75f andSecond:6.0f]; 
            }
            [[SimpleAudioEngine sharedEngine] playEffect:LOSE_EFFECT];
        }
    }
    if(self.sceneState == TRANSITION_STATE && !self.eventLayer.isEventShowed){
        [self unschedule:@selector(detectEventSchedule)];
        if(isPlayerWin){    //Call nodeWithLevelIDAndResults in WinBattleLayer 
            /*
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[WinBattleLayer nodeWithLevelIDAndResults:levelID andTimeLeft:50 andEnemyKilled:30 andUnitLost:20 andCoinsPicked:200]]];
             */
            /*
            int elapseTime = [self getClockTimeSeconds];
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[WinBattleLayer nodeWithLevelIDAndResults:levelID andTimeLeft:kBattleTime-elapseTime andEnemyKilled:enemyKilled andUnitLost:unitLost andCoinsPicked:coinPicked]]];
             */
            [self playerWinTransit];
        }else{
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:
                                                        [BattleResultLayer nodeWithLevelIDAndResults:levelID 
                                                                                      andEnemyKilled:enemyKilled andCoinsPicked:playerCoin
                                                                                            andHitPointRemains: playerHP 
                                                                                            andIsWin:NO]]] ;
        }
    }
}

-(void) doPause{
    self.isGamePaused = true;
    CCLOG(@"BattleScene isGamePause = %s", self.isGamePaused ? "true" : "false");
    //Pause each unit schedules
    for(Unit *item in enemyUnits){
        [item pauseSchedulerAndActions];
    }
    for(Unit *item in playerUnits){
        [item pauseSchedulerAndActions];
    }
    /*Wait to pause coin object*/
    //TODO HERE:
    
    //Then Pause layers
    [self.battleLayer pauseSchedulerAndActions];
    [self.battleHUDLayer pauseSchedulerAndActions];
    
    //Display Pause Layer
    PauseLayer *pauseLayer = [[PauseLayer alloc] init];
    [self addChild:pauseLayer z:9 tag:BATTLEPAUSELAYER_TAG];
}

-(void) doPauseWithNoPanel{
    self.isGamePaused = true;
    CCLOG(@"BattleScene isGamePause = %s", self.isGamePaused ? "true" : "false");
    //Pause each unit schedules
    for(Unit *item in enemyUnits){
        [item pauseSchedulerAndActions];
    }
    for(Unit *item in playerUnits){
        [item pauseSchedulerAndActions];
    }
    /*Wait to pause coin object*/
    //TODO HERE:
    
    //Then Pause layers
    [self.battleLayer pauseSchedulerAndActions];
    [self.battleHUDLayer pauseSchedulerAndActions];

}
	
-(void) doResume{
    self.isGamePaused = false;
    CCLOG(@"BattleScene isGamePause = %s", self.isGamePaused ? "true" : "false");
    //Pause each unit schedules
    for(Unit *item in enemyUnits){
        [item resumeSchedulerAndActions];
    }
    for(Unit *item in playerUnits){
        [item resumeSchedulerAndActions];
    }
    /*Wait to resume coin object*/
    //TODO HERE:
    
    [self.battleLayer resumeSchedulerAndActions];
    [self.battleHUDLayer resumeSchedulerAndActions];
    
    //Hide Pause Layer
    [self removeChildByTag:BATTLEPAUSELAYER_TAG cleanup:true];
}

#pragma mark -
#pragma mark Level Clock Methods

-(int) getClockTimeSeconds
{
    NSTimeInterval passed = [[NSDate date] timeIntervalSinceDate: [self levelStartTime]]; 
    double intPart;
    modf(passed, &intPart);
    
    return (int)intPart;
}

-(int) getClockTimeMiliseconds
{
    NSTimeInterval passed = [[NSDate date] timeIntervalSinceDate: [self levelStartTime]]; 
    double intPart;
    double fract = modf(passed, &intPart);
    fract *= 100;
    
    return (int)fract;
}

#pragma mark-
#pragma mark Initialize Unit
-(void) initUnitFromPlist {
    // Retrieve data from unit plist in Bundle
    // Now using plist in document folder instead.
    // catUnit.plist
    /*
    NSString* catPlistPath = [[NSBundle mainBundle] pathForResource:@"catUnit" ofType:@"plist"];
    NSMutableDictionary* catDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: catPlistPath];
    catUnits = [[NSMutableArray alloc] initWithArray:[catDictionary objectForKey:@"Unit"]];
    
    // dogUnit.plist
    NSString* dogPlistPath = [[NSBundle mainBundle] pathForResource:@"dogUnit" ofType:@"plist"];
    NSMutableDictionary* dogDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: dogPlistPath];
    dogUnits = [[NSMutableArray alloc] initWithArray:[dogDictionary objectForKey:@"Unit"]];
    */
    // Print out unit attributes
    /*
     for (NSDictionary *element in _catUnits) {
     NSLog(@"Unit");  
     //NSLog(@"%@", [element valueForKey:@"name"]);
     for ( NSString *key in element){
     NSLog(@"%@=%@", key, [element valueForKey:key]);
     }
     NSLog(@"\n");
     }
     */
    
    // Create simple HUD
    // Sending cat units for now.
    //[self initSelectedUnit:_catUnits];
    
    // Test document path
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *catPath = [documentsDirectory 
                         stringByAppendingPathComponent:@"catUnit.plist"]; //3
    NSString *dogPath = [documentsDirectory 
                         stringByAppendingPathComponent:@"dogUnit.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: catPath]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"catUnit"ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: catPath error:&error]; //6
    //CCLOG(error);
    } else {
        if ([fileManager removeItemAtPath: catPath error: NULL]  == YES)
            CCLOG (@"Remove Old Plist File");
        else
            CCLOG (@"Remove failed");
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"catUnit"ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: catPath error:&error]; //6
    }
    if (![fileManager fileExistsAtPath: dogPath]) //4
    {
        //NSString *bundle = [[NSBundle mainBundle] pathForResource:@"dogUnit"ofType:@"plist"]; //5
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"dogUnit"ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: dogPath error:&error]; //6
    } else {
        if ([fileManager removeItemAtPath: dogPath error: NULL]  == YES)
            CCLOG (@"Remove Old Plist File");
        else
            CCLOG (@"Remove failed");
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"dogUnit"ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: dogPath error:&error]; //6
    }
    // catUnit.plist in document folder
    NSMutableDictionary* catDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: catPath];
    catUnits = [[NSMutableArray alloc] initWithArray:[catDictionary objectForKey:@"Unit"]];
    
    // dogUnit.plist in document folder
    NSMutableDictionary* dogDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: dogPath];
    dogUnits = [[NSMutableArray alloc] initWithArray:[dogDictionary objectForKey:@"Unit"]];
    
    [catDictionary release];
    catDictionary = nil;
    [dogDictionary release];
    dogDictionary = nil;
}

#pragma mark-
#pragma mark Initialize Item
-(void) initItemFromPlist {
    NSString* itemPlistPath = [[NSBundle mainBundle] pathForResource:@"simpleItems" ofType:@"plist"];
    NSMutableDictionary* itemDictionary= [[NSMutableDictionary alloc] initWithContentsOfFile: itemPlistPath];
    itemList = [[NSMutableArray alloc] 
                initWithArray:[itemDictionary objectForKey:@"item"]];
}

#pragma mark-
#pragma mark Accessor Unit Array

-(NSMutableArray *) getPlayerUnitArray {
    // This is for sending unit array to hud, battle layer.
    //Get the game manager singleton object
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GameManager *gameMan = [appDelegate gameManager];
    if ([gameMan currentCampaign] == CTCats) {
        return catUnits;
    } else {
        return dogUnits;
    }
    
}

-(NSMutableArray *) getEnemyUnitArray {
    // This is for sending unit array to hud, battle layer.
    // For now only player can choose cat.
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GameManager *gameMan = [appDelegate gameManager];
    if ([gameMan currentCampaign] == CTCats) {
        return dogUnits;
    } else {
        return catUnits;
    }
}

-(NSMutableArray *) getCatUnitArray {
    // This is for sending unit array to hud, battle layer.
    // For now only player can choose cat.
    return catUnits;
}

-(NSMutableArray *) getDogUnitArray {
    // This is for sending unit array to hud, battle layer.
    // For now only player can choose cat.
    return dogUnits;
}

-(NSMutableArray *) getGameObjectArray {
    return gameObjects;
}

#pragma mark-
#pragma mark Add Unit
-(void) addPlayerUnitwithUnit:(Unit *)unit {
    //CCLOG(@"Added!");
    if ( [unit unitID] == kGhostCatUnit) {
        //CCLOG(@"Add ghost cat");
        //Do add ghost cat.
        //GhostCat *ghostCatUnit = (GhostCat *)unit;
        //[ghostCatUnit setIsFlipX:YES];
        //[playerUnits addObject:ghostCatUnit];
    } else {
        [playerUnits addObject:unit];
    }
    
    //CCLOG(@"Player added, player units: %d",  [playerUnits count]);
    //CCLOG(@"enemy units: %d",  [enemyUnits count]);
}

-(void) addPlayerUnitwithUnit:(Unit *)unit andOnLane:(int)lane{
    //CCLOG(@"Added!");
    //CCLOG(@"%@", [unit skill]);
    [unit setLevelSpeedFactor:[self.battleLayer levelSpeedFactor]];
    if ( [unit unitID] == kGhostCatUnit) {
        //CCLOG(@"Add ghost cat");
        //Do add ghost cat.
        GhostCat *ghostCatUnit = [[GhostCat alloc] initWithUnit:unit];
        [ghostCatUnit setIsFlipX:YES];
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [ghostCatUnit setUnitTag:playerUnitTag];
        [self addChild:ghostCatUnit z:lane tag:[playerUnitTag integerValue]];
        [playerUnits addObject:ghostCatUnit];
        // For Debug
        [self addPlayerUnitHPLabel:ghostCatUnit];
    } /*else if ([unit unitID] == kJumpingCatUnit) {
        JumpingCat *jumpingCatUnit = [[JumpingCat alloc] initWithUnit:unit];
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [jumpingCatUnit setUnitTag:playerUnitTag];
        [self addChild:jumpingCatUnit 
                     z:lane 
                   tag:[playerUnitTag integerValue]];
        [playerUnits addObject:jumpingCatUnit];
        // For Debug
        [self addPlayerUnitHPLabel:jumpingCatUnit];
    }*/
    else if ([unit unitID] == kThrowingCatUnit) {
        ThrowingCat *throwingCat = [[ThrowingCat alloc] initWithUnit:unit];
        [throwingCat setIsFlipX:YES];
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [throwingCat setUnitTag:playerUnitTag];
        [self addChild:throwingCat 
                     z:lane 
                   tag:[playerUnitTag integerValue]];
        [playerUnits addObject:throwingCat];
        // For Debug
        [self addPlayerUnitHPLabel:throwingCat];
    } else if ([unit unitID] == kWitchCatUnit) {
        WitchCat *witchCatUnit = [[WitchCat alloc] initWithUnit:unit];
        [witchCatUnit setIsFlipX:YES];
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [witchCatUnit setUnitTag:playerUnitTag];
        [self addChild:witchCatUnit 
                     z:lane 
                   tag:[playerUnitTag integerValue]];
        [playerUnits addObject:witchCatUnit];
        // For Debug
        [self addPlayerUnitHPLabel:witchCatUnit];
    } else if ([unit unitID] == kHealerCatUnit) {
        HealerCat *healerCatUnit = [[HealerCat alloc] initWithUnit:unit];
        [healerCatUnit setIsFlipX:YES];
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [healerCatUnit setUnitTag:playerUnitTag];
        [self addChild:healerCatUnit 
                     z:lane 
                   tag:[enemyUnitTag integerValue]];
        [playerUnits addObject:healerCatUnit];
        // For Debug
        [self addPlayerUnitHPLabel:healerCatUnit];
    } else if ([unit unitID] == kBigDog) {
        BigDog *bigDogUnit= [[BigDog alloc] initWithUnit:unit];
        [bigDogUnit setIsFlipX:YES];
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [bigDogUnit setUnitTag:playerUnitTag];
        [self addChild:bigDogUnit 
                     z:lane 
                   tag:[playerUnitTag integerValue]];
        [playerUnits addObject:bigDogUnit];
        // For Debug
        [self addPlayerUnitHPLabel:bigDogUnit];
    } else if ([unit unitID] == kGhostDog) {
        GhostDog *ghostDogUnit= [[GhostDog alloc] initWithUnit:unit];
        [ghostDogUnit setIsFlipX:YES];
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [ghostDogUnit setUnitTag:playerUnitTag];
        [self addChild:ghostDogUnit 
                     z:lane 
                   tag:[playerUnitTag integerValue]];
        [playerUnits addObject:ghostDogUnit];
        // For Debug
        [self addPlayerUnitHPLabel:ghostDogUnit];
    }  else if ([unit unitID] == kPuddle) {
        PuddleDog *puddleDogUnit= [[PuddleDog alloc] initWithUnit:unit];
        [puddleDogUnit setIsFlipX:YES];
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [puddleDogUnit setUnitTag:playerUnitTag];
        [self addChild:puddleDogUnit 
                     z:lane 
                   tag:[playerUnitTag integerValue]];
        [playerUnits addObject:puddleDogUnit];
        // For Debug
        [self addPlayerUnitHPLabel:puddleDogUnit];
    } else if ([unit unitID] == kSiberianHusky) {
        SiberianHuskyDog *newDogUnit= [[SiberianHuskyDog alloc] 
                                          initWithUnit:unit];
        [newDogUnit setIsFlipX:YES];
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [newDogUnit setUnitTag:playerUnitTag];
        [self addChild:newDogUnit 
                     z:lane 
                   tag:[playerUnitTag integerValue]];
        [playerUnits addObject:newDogUnit];
        // For Debug
        [self addPlayerUnitHPLabel:newDogUnit];
    } else {
        [playerUnits addObject:unit];
        // For Debug
        playerUnitTag = [NSNumber numberWithInt:[playerUnitTag intValue] +1];
        [unit setUnitTag:playerUnitTag];
        [self addChild:unit 
                     z:lane 
                   tag:[playerUnitTag integerValue]];
        [self addPlayerUnitHPLabel:unit];
    }
    CCLOG(@"playerUnitTag is now %d", [enemyUnitTag intValue]);
    //CCLOG(@"Player added, player units: %d",  [playerUnits count]);
    //CCLOG(@"enemy units: %d",  [enemyUnits count]);
}

-(void) addPlayerUnitHPLabel:(Unit *)unit {
    unit.hpLabel = [CCLabelBMFont labelWithString: [NSString stringWithFormat:@"HP:%.2f", unit.hitPoint] 
                                           fntFile:@"AppleLiGothicBrown18.fnt"];
    [unit.hpLabel setAnchorPoint:ccp(0,1)];
    unit.hpLabel.position = ccp(
                                unit.position.x-5.0,
                                unit.position.y+15.0
                                );
    
    unit.attackLabel = [CCLabelBMFont labelWithString: [NSString stringWithFormat:@"ATK:%.2f", unit.attack] 
                                              fntFile:@"AppleLiGothicBrown18.fnt"];
    [unit.attackLabel setAnchorPoint:ccp(0,1)];
    unit.attackLabel.position = ccp(
                                unit.position.x+5.0,
                                unit.position.y+15.0
                                );
    
    if (kDebugText) {
        [self addChild:unit.hpLabel z:5];
        [self addChild:unit.attackLabel z:5];
    }
    
}

-(void) addEnemyUnitHPLabel:(Unit *)unit {
    /*
     unit.hpLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"HP:%d", unit.hitPoint] fontName:@"Arial" fontSize:14.0];
     unit.hpLabel.color = ccc3(255, 255,255);
     unit.hpLabel.position = ccp(
     unit.position.x-5.0,
     unit.position.y+15.0
     );
     */
    unit.hpLabel = [CCLabelBMFont labelWithString: [NSString stringWithFormat:@"HP:%d", unit.hitPoint] 
                                          fntFile:@"AppleLiGothicBrown18.fnt"];
    [unit.hpLabel setAnchorPoint:ccp(0,1)];
    unit.hpLabel.position = ccp(
                                unit.position.x-5.0,
                                unit.position.y+15.0
                                );
    unit.attackLabel = [CCLabelBMFont labelWithString: [NSString stringWithFormat:@"ATK:%.2f", unit.attack] 
                                              fntFile:@"AppleLiGothicBrown18.fnt"];
    [unit.attackLabel setAnchorPoint:ccp(0,1)];
    unit.attackLabel.position = ccp(
                                    unit.position.x+5.0,
                                    unit.position.y+15.0
                                    );
    
    if (kDebugText) {
        [self addChild:unit.hpLabel z:5];
        [self addChild:unit.attackLabel z:5];
    }
}

-(void) addEnemyUnitwithUnit:(Unit *)unit {
    //CCLOG(@"Added!");
    [enemyUnits addObject:unit];
}
-(void) addEnemyUnitwithUnit:(Unit *)unit andOnLane:(int)lane {
    [unit setLevelSpeedFactor:[self.battleLayer levelSpeedFactor]];
    if ( [unit unitID] == kGhostCatUnit) {
        //CCLOG(@"Add ghost cat");
        //Do add ghost cat.
        GhostCat *ghostCatUnit = [[GhostCat alloc] initWithUnit:unit];
        [ghostCatUnit setIsFlipX:NO];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [ghostCatUnit setUnitTag:enemyUnitTag];
        [self addChild:ghostCatUnit z:lane tag:[enemyUnitTag integerValue]];        [enemyUnits addObject:ghostCatUnit];
        // For Debug
        [self addEnemyUnitHPLabel:ghostCatUnit];
    } /*else if ([unit unitID] == kJumpingCatUnit) {
        JumpingCat *jumpingCatUnit = [[JumpingCat alloc] initWithUnit:unit];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [jumpingCatUnit setUnitTag:enemyUnitTag];
        [self addChild:jumpingCatUnit z:lane tag:[enemyUnitTag integerValue]];
        [enemyUnits addObject:jumpingCatUnit];
        // For Debug
        [self addEnemyUnitHPLabel:jumpingCatUnit];
    } */
    else if ([unit unitID] == kThrowingCatUnit) {
        ThrowingCat *throwingCat = [[ThrowingCat alloc] initWithUnit:unit];
        [throwingCat setIsFlipX:NO];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [throwingCat setUnitTag:enemyUnitTag];
        [self addChild:throwingCat 
                     z:lane 
                   tag:[enemyUnitTag integerValue]];
        [enemyUnits addObject:throwingCat];
        // For Debug
        [self addEnemyUnitHPLabel:throwingCat];
    } else if ([unit unitID] == kWitchCatUnit) {
        WitchCat *witchCatUnit = [[WitchCat alloc] initWithUnit:unit];
        [witchCatUnit setIsFlipX:NO];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [witchCatUnit setUnitTag:enemyUnitTag];
        [self addChild:witchCatUnit 
                     z:lane 
                   tag:[enemyUnitTag integerValue]];
        [enemyUnits addObject:witchCatUnit];
        // For Debug
        [self addEnemyUnitHPLabel:witchCatUnit];
    } else if ([unit unitID] == kHealerCatUnit) {
        HealerCat *healerCatUnit = [[HealerCat alloc] initWithUnit:unit];
        [healerCatUnit setIsFlipX:NO];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [healerCatUnit setUnitTag:enemyUnitTag];
        [self addChild:healerCatUnit z:lane tag:[enemyUnitTag integerValue]];
        [enemyUnits addObject:healerCatUnit];
        // For Debug
        [self addEnemyUnitHPLabel:healerCatUnit];
    } else if ([unit unitID] == kBigDog) {
        BigDog *bigDogUnit= [[BigDog alloc] initWithUnit:unit];
        [bigDogUnit setIsFlipX:NO];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [bigDogUnit setUnitTag:enemyUnitTag];
        [self addChild:bigDogUnit 
                     z:lane 
                   tag:[enemyUnitTag integerValue]];
        [enemyUnits addObject:bigDogUnit];
        // For Debug
        [self addPlayerUnitHPLabel:bigDogUnit];
    } else if ([unit unitID] == kGhostDog) {
        GhostDog *ghostDogUnit= [[GhostDog alloc] initWithUnit:unit];
        [ghostDogUnit setIsFlipX:NO];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [ghostDogUnit setUnitTag:enemyUnitTag];
        [self addChild:ghostDogUnit 
                     z:lane 
                   tag:[enemyUnitTag integerValue]];
        [enemyUnits addObject:ghostDogUnit];
        // For Debug
        [self addPlayerUnitHPLabel:ghostDogUnit];
    } else if ([unit unitID] == kPuddle) {
        PuddleDog *puddleDogUnit= [[PuddleDog alloc] initWithUnit:unit];
        [puddleDogUnit setIsFlipX:NO];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [puddleDogUnit setUnitTag:enemyUnitTag];
        [self addChild:puddleDogUnit 
                     z:lane 
                   tag:[enemyUnitTag integerValue]];
        [enemyUnits addObject:puddleDogUnit];
        // For Debug
        [self addEnemyUnitHPLabel:puddleDogUnit];
    } else if ([unit unitID] == kSiberianHusky) {
        SiberianHuskyDog *newDogUnit= [[SiberianHuskyDog alloc] 
                                       initWithUnit:unit];
        [newDogUnit setIsFlipX:NO];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [newDogUnit setUnitTag:enemyUnitTag];
        [self addChild:newDogUnit 
                     z:lane 
                   tag:[enemyUnitTag integerValue]];
        [enemyUnits addObject:newDogUnit];
        // For Debug
        [self addPlayerUnitHPLabel:newDogUnit];
    } else {
        [enemyUnits addObject:unit];
        enemyUnitTag = [NSNumber numberWithInt:[enemyUnitTag intValue] +1];
        [unit setUnitTag:enemyUnitTag];
        [self addChild:unit z:lane tag:[enemyUnitTag integerValue]];
        // For Debug
        [self addEnemyUnitHPLabel:unit];
    }
    
    //CCLOG(@"enemyUnitTag is now %d", [enemyUnitTag intValue]);
}

-(void) addGameObject: (GameObject*) gameObject{
    //CCLOG(@"Added!");
    [gameObjects addObject:gameObject];
    //CCLOG(@"Game Object added, game objects: %d",  [gameObjects count]);
}

#pragma mark-
#pragma mark Remove Unit
-(void) removePlayerUnit: (Unit*) unit {
    if ([unit state] == DEAD) {
        //unit lost
        unitLost++;
    }
    [playerUnits removeObject:unit];
    [self removeChild:unit.hpLabel cleanup:YES];
    [self removeChild:unit.attackLabel cleanup:YES];
    [self removeChildByTag:[[unit unitTag] integerValue] cleanup:YES];
    CCLOG(@"Remove unitTag %d", [[unit unitTag] intValue]);
    //[self removeChild:unit cleanup:YES];
    //CCLOG(@"Player removed, player units: %d",  [playerUnits count]);
    //CCLOG(@"enemy units: %d",  [enemyUnits count]);
}

-(void) removeEnemyUnit:(Unit *)unit {
    if ([unit state] == DEAD) {
        //unit lost
        enemyKilled++;
    }
    [enemyUnits removeObject:unit];
    [self removeChild:unit.hpLabel cleanup:YES];
    [self removeChild:unit.attackLabel cleanup:YES];
    [self removeChildByTag:[[unit unitTag] integerValue] cleanup:YES];
    CCLOG(@"Remove unitTag %d", [[unit unitTag] intValue]);
    //[self removeChild:unit cleanup:YES];
    //CCLOG(@"Enemy removed, enemy units: %d",  [enemyUnits count]);
    //CCLOG(@"player units: %d",  [playerUnits count]);
}

-(void) removeGameObject: (GameObject*) gameObject{
    //CCLOG(@"Added!");
    [gameObjects removeObject:gameObject];
    //CCLOG(@"Game Object added, game objects: %d",  [gameObjects count]);
}

#pragma mark-
#pragma mark HP management

-(void) decreasePlayerHP {
    playerHP--;
}

-(void) decreaseEnemyHP {
    enemyHP--;
}


#pragma mark-
#pragma mark Coin

-(void) increaseCoin {
    playerCoin++;
    coinPicked++;
}

-(void) increaseCoinByAmount: (NSInteger) amount {
    //Get the game manager singleton object
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GameManager *gameMan = [appDelegate gameManager];
    UserProfile *currentPlayer = [gameMan player]; 
    if (amount > 0) {
        // S/W security :P
        playerCoin += amount;
        coinPicked += amount;
        [currentPlayer setCoins: [[NSNumber alloc] initWithInt:playerCoin]];
        [[self battleHUDLayer] updateCoin];
        CCLOG(@"Now player has %d coins", playerCoin);
    }
    
}

-(void) cleanupCoinObject {
    
    NSMutableArray *coinToBeDelete = [[NSMutableArray alloc] init ];
    for (Coin *coin in gameObjects) {
        if (
            (
             [coin gameObjectState] == COLLECTED
            || [coin gameObjectState] == REMOVED
             )
            && (coin.position.x == 400.0f
            && coin.position.y == 309.0f)
            //&& [coin numberOfRunningActions] == 0
            //)
            ) {
            [self increaseCoinByAmount:coin.amount];
            [coinToBeDelete addObject:coin];
            [self removeChild:coin cleanup:YES];
        }
    }
    
    for (Coin *coin in coinToBeDelete) {
        [gameObjects removeObject:coin];
    }
    [coinToBeDelete release];
    coinToBeDelete = nil;
}

#pragma mark-
#pragma mark End game logic

-(void) checkBattleResult {
    int time = [self getClockTimeSeconds];
    if(playerHP <= 0) {
        [self loseBattle];
    } else if(enemyHP <= 0) {
        //[self winBattle];
        self.isPlayerWin = true;
        [self endBattle];
    } else if ( playerHP > 0 && time >= _battleLayer.levelTime ) {
        self.isPlayerWin = true;
        [self endBattle];
    }/*else if( playerHP > enemyHP && time >= kBattleTime) {
        //[self winBattle];
        self.isPlayerWin = true;
        [self endBattle];
    } else if ( playerHP <= enemyHP && time >= kBattleTime ) {
        //[self loseBattle];
        self.isPlayerWin = false;
        [self endBattle];
    }*/
}

-(void) endBattle{
    self.sceneState = ENDEVENT_STATE;
    [self schedule:@selector(detectEventSchedule)];
}

-(void) loseBattle {
    //Originately isPlayerWin = false;
    /*
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[LoseBattleScene scene]]] ;*/
    self.sceneState = ENDEVENT_STATE;
    [self schedule:@selector(detectEventSchedule)];
}

-(void) winBattle {
    //Save the level progress
    /*
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GameManager *gameMan = [appDelegate gameManager];
    [gameMan setLevelCompleteForCurrentUser:[self levelID]];
    */
    
    /*Warning Temporary insert end event and end dialog*/
    self.isPlayerWin = true;
    self.sceneState = ENDEVENT_STATE;
    [self schedule:@selector(detectEventSchedule)];
    
    
    //Navigate to next scene
    /*  
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[WinBattleLayer nodeWithLevelID:levelID]]] ;*/
}

/*
-(void) openConsole {
    CCLOG(@"COUNT %d", [selectableUnits count]);
    //[consoleLayer openConsoleWithArray:selectableUnits];
    
    //[self addChild:consoleLayer];
}

-(void) closeConsole {
    //[self removeChild:consoleLayer cleanup:NO];
}
 */

//Added by Melo, for testing use, delete it before release.
-(void) playerWinTransit {
    // Set level complete 
    //Get the game manager singleton object
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //GameManager *gameMan = [appDelegate gameManager];
    //UserProfile *currentPlayer = [gameMan player];
    
    //[gameMan setLevelCompleteForCurrentCampaign:[self levelID]];

    //int elapseTime = [self getClockTimeSeconds];

    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[BattleResultLayer nodeWithLevelIDAndResults:levelID andEnemyKilled:enemyKilled andCoinsPicked:playerCoin andHitPointRemains:playerHP andIsWin:YES]]];
} 

-(void) playerLoseTransit {
    // Set level complete 
    //Get the game manager singleton object
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //GameManager *gameMan = [appDelegate gameManager];
    //UserProfile *currentPlayer = [gameMan player];
    
    //[gameMan setLevelCompleteForCurrentCampaign:[self levelID]];
    
    //int elapseTime = [self getClockTimeSeconds];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[BattleResultLayer nodeWithLevelIDAndResults:levelID andEnemyKilled:enemyKilled andCoinsPicked:playerCoin andHitPointRemains:playerHP  andIsWin:NO]]];
} 



@end
