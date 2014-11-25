//
//  UpgradeScene.m
//  PAWS
//
//  Created by Zinan Xing on 10/13/2011.
//  Copyright Pulse Studio. All rights reserved.
//
//
//  Todo: 
//  -Alert Window (For Coins Insufficency)

#import "UpgradeScene.h"
#import "WorldMapScene.h"
#import "Unit.h"


// Level Labels Positions Definition
#define LEVEL_LABEL_X 115
#define HIT_POINT_LABEL_Y winSize.height - 45
#define ATTACK_LABEL_Y winSize.height - 102
#define ATTACK_SPEED_LABEL_Y winSize.height - 158
#define SPEED_LABEL_Y winSize.height - 213
#define SPAWN_RATE_LABEL_Y winSize.height - 270
#define COINS_LABEL_X winSize.width - 60
#define COINS_LABEL_Y winSize.height - 22

// Level Description Labels Positions Definition
#define LEVEL_DSCP_LABEL_X 153
#define HIT_POINT_DSCP_LABEL_Y _hitPointLevelLabel.position.y - 18 - 10
#define ATTACK_DSCP_LABEL_Y _attackLevelLabel.position.y - 18 - 10
#define ATTACK_SPEED_DSCP_LABEL_Y _attackSpeedLevelLabel.position.y - 18 - 10
#define SPEED_DSCP_LABEL_Y _speedLevelLabel.position.y - 18 - 10
#define SPAWN_RATE_DSCP_LABEL_Y _spawnRateLevelLabel.position.y - 18 - 10

// Buttons Positions Definition
#define ADD_COINS_BUTTON_X winSize.width - 60
#define ADD_COINS_BUTTON_Y winSize.height - 65
#define UPGRADE_BTN_X 235

// Define Total Level Number that can be reached
#define TOTAL_HIT_POINT_LEVEL_NUMBER 4      
#define TOTAL_ATTACK_LEVEL_NUMBER 4         
#define TOTAL_ATTACK_SPEED_LEVEL_NUMBER 4   
#define TOTAL_SPEED_LEVEL_NUMBER 4          
#define TOTAL_SPAWN_RATE_LEVEL_NUMBER 4     


@implementation UpgradeLayer

@synthesize currentHitPointLevel = _currentHitPointLevel;
@synthesize currentAttackLevel = _currentAttackLevel;
@synthesize currentAttackSpeedLevel = _currentAttackSpeedLevel;
@synthesize currentSpeedLevel = _currentSpeedLevel;
@synthesize currentSpawnRateLevel = _currentSpawnRateLevel;
@synthesize currentCoins = _currentCoins;

// Levels in Plist
@synthesize hitPointLevel = _hitPointLevel;
@synthesize attackLevel = _attackLevel;
@synthesize attackSpeedLevel = _attackSpeedLevel;
@synthesize speedLevel = _speedLevel;
@synthesize spawnRateLevel = _spawnRateLevel;
@synthesize levelItemsArray = _levelItemsArray;

@synthesize hitPointLevelLabel = _hitPointLevelLabel;
@synthesize attackLevelLabel = _attackLevelLabel;
@synthesize attackSpeedLevelLabel = _attackSpeedLevelLabel;
@synthesize speedLevelLabel = _speedLevelLabel;
@synthesize spawnRateLevelLabel = _spawnRateLevelLabel;
@synthesize coinsLabel = _coinsLabel;

@synthesize hitPointLevelDescriptionLabel = _hitPointLevelDescriptionLabel;
@synthesize attackLevelDescriptionLabel = _attackLevelDescriptionLabel;
@synthesize attackSpeedLevelDescriptionLabel = _attackSpeedLevelDescriptionLabel;
@synthesize speedLevelDescriptionLabel = _speedLevelDescriptionLabel;
@synthesize spawnRateLevelDescriptionLabel = _spawnRateLevelDescriptionLabel;

@synthesize hitPointLevelDescription = _hitPointLevelDescription;
@synthesize attackLevelDescription = _attackLevelDescription;
@synthesize attackSpeedLevelDescription = _attackSpeedLevelDescription;
@synthesize speedLevelDescription = _speedLevelDescription;
@synthesize spawnRateLevelDescription = _spawnRateLevelDescription;

@synthesize appDelegate = _appDelegate;
@synthesize gameMan = _gameMan;
@synthesize currentPlayer = _currentPlayer;

-(void) dealloc {
    
    [_hitPointLevelLabel release];
    _hitPointLevelLabel = nil;
    
    [_attackLevelLabel release]; 
    _hitPointLevelLabel = nil;
    
    [_attackSpeedLevelLabel release];
    _attackSpeedLevelLabel = nil;
    
    [_speedLevelLabel release];
    _speedLevelLabel = nil;
    
    [_spawnRateLevelLabel release];
    _spawnRateLevelLabel = nil;
    
    [_coinsLabel release];
    _coinsLabel = nil;
    
    [_hitPointLevelDescriptionLabel release];
    _hitPointLevelDescriptionLabel = nil;
    
    [_attackLevelDescriptionLabel release];
    _attackLevelDescriptionLabel = nil;
    
    [_attackSpeedLevelDescriptionLabel release];
    _attackSpeedLevelDescriptionLabel = nil;
    
    [_speedLevelDescriptionLabel release];
    _speedLevelDescriptionLabel = nil;
    
    [_spawnRateLevelDescriptionLabel release];
    _spawnRateLevelDescriptionLabel = nil;
    
    [_hitPointLevelDescription release];
    _hitPointLevelDescription = nil;
    
    [_attackLevelDescription release];
    _attackLevelDescription = nil;
    
    [_attackSpeedLevelDescription release];
    _attackSpeedLevelDescription = nil;
    
    [_speedLevelDescription release];
    _speedLevelDescription = nil;
    
    [_spawnRateLevelDescription release];
    _spawnRateLevelDescription = nil;

    
}

- (id)init
{
    self = [super initWithColor : ccc4(255,255,255,255)];
    if (self) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        //        CCSprite *UpgradePic = [CCSprite spriteWithFile:@"UpgradeScene.jpg"];
        //        UpgradePic.position = ccp(winSize.width / 2, winSize.height / 2);
        //        [self addChild:UpgradePic];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect: ERROR_EFFECT];
        
        [self initUnitLevelsFromPlist];
        
        // Set up background
        CCSprite *bg = [CCSprite spriteWithFile:@"UpgradeScene.png"];
        bg.position = ccp(winSize.width/2,winSize.height/2);
        
        [self addChild:bg];
        
        //Labels:
        
        //Display Next HP Level Label
          
        _hitPointLevelLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"HP Level: %d",_currentHitPointLevel]  
                                                dimensions:CGSizeMake(120, 20) alignment:UITextAlignmentLeft 
                                                  fontName:@"Arial" fontSize:12.0] retain];
            

        _hitPointLevelLabel.position = ccp(LEVEL_LABEL_X, HIT_POINT_LABEL_Y);
        _hitPointLevelLabel.color = ccc3(0, 0, 0);
        [self addChild:_hitPointLevelLabel];
        
        
        
        //Display Next Attack Level Label
         
        _attackLevelLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Attack Level: %d",_currentAttackLevel]  
                                                dimensions:CGSizeMake(120, 20) alignment:UITextAlignmentLeft 
                                                  fontName:@"Arial" fontSize:12.0] retain];
            

        _attackLevelLabel.position = ccp(LEVEL_LABEL_X, ATTACK_LABEL_Y);
        _attackLevelLabel.color = ccc3(0, 0, 0);
        [self addChild:_attackLevelLabel];
        
        
        //Display Next Attack Speed Level Label

        _attackSpeedLevelLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Attack Speed Level: %d",_currentAttackSpeedLevel]  
                                              dimensions:CGSizeMake(120, 20) alignment:UITextAlignmentLeft 
                                                fontName:@"Arial" fontSize:12.0] retain];
        
                    _attackSpeedLevelLabel.position = ccp(LEVEL_LABEL_X, ATTACK_SPEED_LABEL_Y);
        _attackSpeedLevelLabel.color = ccc3(0, 0, 0);
        [self addChild:_attackSpeedLevelLabel];
        
        //Display Next Speed Level Label
        _speedLevelLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Speed Level: %d",_currentSpeedLevel]  
                                                   dimensions:CGSizeMake(120, 20) alignment:UITextAlignmentLeft 
                                                     fontName:@"Arial" fontSize:12.0] retain];
            

        _speedLevelLabel.position = ccp(LEVEL_LABEL_X, SPEED_LABEL_Y);
        _speedLevelLabel.color = ccc3(0, 0, 0);
        [self addChild:_speedLevelLabel];
        
        
        //Display Next Spawn Rate Level Label
      
        _spawnRateLevelLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Spawn Rate Level: %d",_currentSpawnRateLevel]  
                                             dimensions:CGSizeMake(120, 20) alignment:UITextAlignmentLeft 
                                               fontName:@"Arial" fontSize:12.0] retain];
            
        _spawnRateLevelLabel.position = ccp(LEVEL_LABEL_X , SPAWN_RATE_LABEL_Y);
        _spawnRateLevelLabel.color = ccc3(0, 0, 0);
        [self addChild:_spawnRateLevelLabel];
        
        
        //Display HP Level Description Label        
        _hitPointLevelDescriptionLabel = [[CCLabelTTF labelWithString:_hitPointLevelDescription  
                                                           dimensions:CGSizeMake(200, 40) 
                                                            alignment:UITextAlignmentLeft 
                                                             fontName:@"Arial" fontSize:11.0] retain];
        
        _hitPointLevelDescriptionLabel.position = ccp(LEVEL_DSCP_LABEL_X, HIT_POINT_DSCP_LABEL_Y);
        _hitPointLevelDescriptionLabel.color = ccc3(0, 0, 0);
        [self addChild:_hitPointLevelDescriptionLabel];
        
        //Display Attack Level Description Label        
        _attackLevelDescriptionLabel = [[CCLabelTTF labelWithString:_attackLevelDescription  
                                                           dimensions:CGSizeMake(200, 40) 
                                                            alignment:UITextAlignmentLeft 
                                                             fontName:@"Arial" fontSize:11.0] retain];
        
        _attackLevelDescriptionLabel.position = ccp(LEVEL_DSCP_LABEL_X, ATTACK_DSCP_LABEL_Y);
        _attackLevelDescriptionLabel.color = ccc3(0, 0, 0);
        [self addChild:_attackLevelDescriptionLabel];
        
        //Display Attack Speed Level Description Label
        _attackSpeedLevelDescriptionLabel = [[CCLabelTTF labelWithString:_attackSpeedLevelDescription  
                                                         dimensions:CGSizeMake(200, 40) 
                                                          alignment:UITextAlignmentLeft 
                                                           fontName:@"Arial" fontSize:11.0] retain];
        
        _attackSpeedLevelDescriptionLabel.position = ccp(LEVEL_DSCP_LABEL_X, ATTACK_SPEED_DSCP_LABEL_Y);
        _attackSpeedLevelDescriptionLabel.color = ccc3(0, 0, 0);
        [self addChild:_attackSpeedLevelDescriptionLabel];
        
        //Display Speed Level Description Label       
        _speedLevelDescriptionLabel = [[CCLabelTTF labelWithString:_speedLevelDescription  
                                                              dimensions:CGSizeMake(200, 40) 
                                                               alignment:UITextAlignmentLeft 
                                                                fontName:@"Arial" fontSize:11.0] retain];
        
        _speedLevelDescriptionLabel.position = ccp(LEVEL_DSCP_LABEL_X, SPEED_DSCP_LABEL_Y);
        _speedLevelDescriptionLabel.color = ccc3(0, 0, 0);
        [self addChild:_speedLevelDescriptionLabel];
        
        //Display Spawn Rate Level Description Label       
        _spawnRateLevelDescriptionLabel = [[CCLabelTTF labelWithString:_spawnRateLevelDescription  
                                                        dimensions:CGSizeMake(200, 40) 
                                                         alignment:UITextAlignmentLeft 
                                                          fontName:@"Arial" fontSize:11.0] retain];
        
        _spawnRateLevelDescriptionLabel.position = ccp(LEVEL_DSCP_LABEL_X, SPAWN_RATE_DSCP_LABEL_Y);
        _spawnRateLevelDescriptionLabel.color = ccc3(0, 0, 0);
        [self addChild:_spawnRateLevelDescriptionLabel];
        
        
        
        //Display Coins Label
        _coinsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Food: %d", _currentCoins] fontName:@"Arial" fontSize:12.0];
        _coinsLabel.position = ccp(COINS_LABEL_X, COINS_LABEL_Y);
        _coinsLabel.color = ccc3(0, 0, 0);
        [self addChild:_coinsLabel];
        
        
        //Buttons:
        
        // Create Upgrade button for HP
        CCMenuItemImage *hitPointUpgradeBtn = [
                                               CCMenuItemImage itemFromNormalImage:@"UpgradeBtn.png"
                                               selectedImage:@"UpgradeBtn.png"
                                               target:self
                                               selector:@selector(hitPointUpgradeBtnClicked)
                                               ];
        hitPointUpgradeBtn.position = ccp(UPGRADE_BTN_X, 
                                          _hitPointLevelLabel.position.y + 2
                                          );
        [hitPointUpgradeBtn setScale:0.95];
        
        // Create Upgrade button for Attack
        CCMenuItemImage *attackUpgradeBtn = [
                                             CCMenuItemImage itemFromNormalImage:@"UpgradeBtn.png"
                                             selectedImage:@"UpgradeBtn.png"
                                             target:self
                                             selector:@selector(attackUpgradeBtnClicked)
                                             ];
        attackUpgradeBtn.position = ccp(UPGRADE_BTN_X, 
                                        _attackLevelLabel.position.y + 2
                                        );
        [attackUpgradeBtn setScale:0.95];
        
        // Create Upgrade button for Attack Speed
        CCMenuItemImage *attackSpeedUpgradeBtn = [
                                                  CCMenuItemImage itemFromNormalImage:@"UpgradeBtn.png"
                                                  selectedImage:@"UpgradeBtn.png"
                                                  target:self
                                                  selector:@selector(attackSpeedUpgradeBtnClicked)
                                                  ];
        attackSpeedUpgradeBtn.position = ccp(UPGRADE_BTN_X, 
                                             _attackSpeedLevelLabel.position.y + 2
                                             );
        [attackSpeedUpgradeBtn setScale:0.95];
        
        // Create Upgrade button for Speed
        CCMenuItemImage *speedUpgradeBtn = [
                                            CCMenuItemImage itemFromNormalImage:@"UpgradeBtn.png"
                                            selectedImage:@"UpgradeBtn.png"
                                            target:self
                                            selector:@selector(speedUpgradeBtnClicked)
                                            ];
        speedUpgradeBtn.position = ccp(UPGRADE_BTN_X, 
                                       _speedLevelLabel.position.y + 2
                                       );
        [speedUpgradeBtn setScale:0.95];
        
        // Create Upgrade button for Spawn Rate
        CCMenuItemImage *spawnRateUpgradeBtn = [
                                                CCMenuItemImage itemFromNormalImage:@"UpgradeBtn.png"
                                                selectedImage:@"UpgradeBtn.png"
                                                target:self
                                                selector:@selector(spawnRateUpgradeBtnClicked)
                                                ];
        spawnRateUpgradeBtn.position = ccp(UPGRADE_BTN_X, 
                                           _spawnRateLevelLabel.position.y + 2
                                           );
        [spawnRateUpgradeBtn setScale:0.95];
        
        
        
        // Create Add Coins button for adding coins (for testing)
        CCMenuItemImage *addCoinsBtn = [
                                        CCMenuItemImage itemFromNormalImage:@"Upgrade_needMore.png"
                                        selectedImage:@"Upgrade_needMore.png"
                                        target:self
                                        selector:@selector(addCoinsBtnClicked)
                                        ];
        addCoinsBtn.position = ccp(ADD_COINS_BUTTON_X, 
                                   ADD_COINS_BUTTON_Y
                                   );
        [spawnRateUpgradeBtn setScale:0.95];
        
        
        // Create back button
        CCMenuItemImage *backBtn = [
                                    CCMenuItemImage itemFromNormalImage:@"Back_button_pink.png" 
                                    selectedImage:@"Back_button_pink.png"  
                                    
                                    //CCMenuItemImage itemFromNormalImage:@"PauseBtn_N.png" 
                                    //selectedImage:@"PauseBtn_A.png"                                      
                                    target:self selector:@selector(backBtnClicked)
                                    ];
        backBtn.position = ccp(
                               winSize.width - backBtn.contentSize.width/2,
                               backBtn.contentSize.height/2
                               );
        [backBtn setScale:0.5];
        
        CCMenu *mainMenu = [CCMenu menuWithItems:
                            backBtn,
                            hitPointUpgradeBtn, 
                            attackUpgradeBtn, 
                            attackSpeedUpgradeBtn, 
                            speedUpgradeBtn, 
                            spawnRateUpgradeBtn,
                            addCoinsBtn,
                            nil
                            ];
        mainMenu.position = CGPointZero;
        [self addChild:mainMenu z:1 tag:0];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:BACK_BTN_EFFECT];
        [[SimpleAudioEngine sharedEngine] preloadEffect:UPGRADE_BTN_EFFECT];
        
        
    }
    
    return self;
}

-(void) initUnitLevelsFromPlist {
    NSError *error;
    
    //Obtain a pointer to the Game Manager object, so you can access the UserProfile object called "player"
    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _gameMan = [_appDelegate gameManager];
    _currentPlayer = [_gameMan player];

    
    /*
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
     NSString *documentsDirectory = [paths objectAtIndex:0]; 
     
     
     NSString *unitLevelsPath = [documentsDirectory 
     stringByAppendingPathComponent:@"unitLevels.plist"]; 
     NSMutableDictionary* unitLevelsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: unitLevelsPath];
     */
    
    
    
    //Read unit levels file from application bundle
    NSString* unitLevelsPath = [[NSBundle mainBundle] pathForResource:@"unitLevels" ofType:@"plist"];
    NSMutableDictionary* unitLevelsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: unitLevelsPath];    
    
    _levelItemsArray = [[NSMutableArray alloc] initWithArray:[unitLevelsDictionary objectForKey:@"unitLevels"]];
    
    _hitPointLevel = [[_levelItemsArray objectAtIndex:0] objectForKey:@"levels"]; 
    _attackLevel = [[_levelItemsArray objectAtIndex:1] objectForKey:@"levels"]; 
    _attackSpeedLevel = [[_levelItemsArray objectAtIndex:2] objectForKey:@"levels"]; 
    _speedLevel = [[_levelItemsArray objectAtIndex:3] objectForKey:@"levels"]; 
    _spawnRateLevel = [[_levelItemsArray objectAtIndex:4] objectForKey:@"levels"]; 
    
    CCLOG(@"%d", [[[_hitPointLevel objectAtIndex:0] objectForKey:@"upgradeCost"] intValue]);
    
    _currentHitPointLevel = [[_currentPlayer hitPointLevel] integerValue];
    _currentAttackLevel = [[_currentPlayer attackDamageLevel] integerValue];
    _currentAttackSpeedLevel = [[_currentPlayer attackSpeedLevel] integerValue];
    _currentSpeedLevel = [[_currentPlayer movementSpeedLevel] integerValue];  
    _currentSpawnRateLevel = [[_currentPlayer spawnRateLevel] integerValue];  
    _currentCoins = [[_currentPlayer coins] integerValue];
    
    _hitPointLevelDescription = [[_hitPointLevel objectAtIndex:_currentHitPointLevel] objectForKey:@"levelDescription"];
    _attackLevelDescription = [[_attackLevel objectAtIndex:_currentAttackLevel] objectForKey:@"levelDescription"];
    _attackSpeedLevelDescription = [[_attackSpeedLevel objectAtIndex:_currentAttackSpeedLevel] objectForKey:@"levelDescription"];
    _speedLevelDescription = [[_speedLevel objectAtIndex:_currentSpeedLevel] objectForKey:@"levelDescription"];
    _spawnRateLevelDescription = [[_hitPointLevel objectAtIndex:_currentSpawnRateLevel] objectForKey:@"levelDescription"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //If plist file not found
    if (![fileManager fileExistsAtPath: unitLevelsPath]) 
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"unitLevels" ofType:@"plist"]; 
        [fileManager copyItemAtPath:bundle toPath: unitLevelsPath error:&error];
    }
    
    // Read property level info from user profile

    
    
    
    /* temporary
     NSMutableDictionary* currentUnitLevelsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: currentUnitLevelsPath];
     _currentHitPointLevel = [[currentUnitLevelsDictionary objectForKey:@"hitPointLevel"] intValue];
     _currentAttackLevel = [[currentUnitLevelsDictionary objectForKey:@"attackLevel"] intValue];    
     _currentAttackSpeedLevel = [[currentUnitLevelsDictionary objectForKey:@"attackSpeedLevel"] intValue];    
     _currentSpeedLevel = [[currentUnitLevelsDictionary objectForKey:@"speedLevel"] intValue];
     
     //dealloc
     [currentUnitLevelsDictionary release];
     currentUnitLevelsDictionary = nil;
     */
}

/*
 -(int) getCostFromLevelArray:(NSMutableArray *) arr
 andLevelNumber: (int) levelNumber
 andKey: (NSString *) key {
 
 return([[[arr objectAtIndex:levelNumber] objectForKey:key] intValue]);
 }
 */

-(void) hitPointUpgradeBtnClicked {
    
    // extracts upgrade cost from plist
    int upgradeCost = [[[_hitPointLevel objectAtIndex:_currentHitPointLevel] objectForKey:@"upgradeCost"] intValue];
    
    if(_currentHitPointLevel >= TOTAL_HIT_POINT_LEVEL_NUMBER ) { 
        [[SimpleAudioEngine sharedEngine] playEffect:ERROR_EFFECT];
        NSString *strTitle = [NSString stringWithString:@"Upgrade Failed"];
        NSString *strMessage = [NSString stringWithString:@"You have reached the highest level."];
        UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [uiav show];
        [uiav release];
        return;
    }
    
    // Check if money is enough
    if(_currentCoins >= upgradeCost) {  // If money is enough then buy it:
        
        // Check if the level number exceeds
        if(_currentHitPointLevel >= TOTAL_HIT_POINT_LEVEL_NUMBER) {
            CCLOG(@"This level is already the highest");
            return;
        }
        [[SimpleAudioEngine sharedEngine] playEffect:UPGRADE_BTN_EFFECT];
        _currentCoins -= upgradeCost; // Reduce money
        [_coinsLabel setString: [NSString stringWithFormat:@"Food: %d", _currentCoins]]; // Refresh Coins Label
        [_currentPlayer setCoins:[NSNumber numberWithInt:_currentCoins]];  // Save money change to User Profile
        
        // Add up one level in user profile
        [_currentPlayer setHitPointLevel:[NSNumber numberWithInt:[self currentHitPointLevel] + 1]]; 
        _currentHitPointLevel += 1;
        
        // Refresh Level label

        [_hitPointLevelLabel setString: [NSString stringWithFormat:@"HP Level: %d", _currentHitPointLevel]];
        CCLOG(@"HP Level changed to: %d", [self currentHitPointLevel]);

        
        // Refresh Level Description Label
        _hitPointLevelDescription = [[_hitPointLevel objectAtIndex:_currentHitPointLevel] objectForKey:@"levelDescription"];
        [_hitPointLevelDescriptionLabel setString:_hitPointLevelDescription];
        
        // Save changes to User Profile
        [_gameMan saveAllChanges];
    } else {
        [self alertFoodInsufficiency];
        
    }
}

-(void) attackUpgradeBtnClicked {
    
    // extracts upgrade cost from plist
    int upgradeCost = [[[_attackLevel objectAtIndex:_currentAttackLevel] objectForKey:@"upgradeCost"] intValue];
    
    if(_currentAttackLevel >= TOTAL_ATTACK_LEVEL_NUMBER ) { 
        [[SimpleAudioEngine sharedEngine] playEffect:ERROR_EFFECT];
        NSString *strTitle = [NSString stringWithString:@"Upgrade Failed"];
        NSString *strMessage = [NSString stringWithString:@"You have reached the highest level."];
        UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [uiav show];
        [uiav release];
        return;
    }
    
    // Check if money is enough
    if(_currentCoins >= upgradeCost) {
        
        // Check if the level number exceeds
        if(_currentAttackLevel >= TOTAL_ATTACK_LEVEL_NUMBER) {
            CCLOG(@"This level is already the highest");
            return;
        }
        // If money is enough then buy it:
        [[SimpleAudioEngine sharedEngine] playEffect:UPGRADE_BTN_EFFECT];
        _currentCoins -= upgradeCost; // Reduce money
        [_coinsLabel setString: [NSString stringWithFormat:@"Food: %d", _currentCoins]]; // Refresh Coins Label
        [_currentPlayer setCoins:[NSNumber numberWithInt:_currentCoins]];  // Save money change to User Profile
        
        // Add up one level in user profile
        [_currentPlayer setAttackDamageLevel:[NSNumber numberWithInt:[self currentAttackLevel] + 1]]; 
        _currentAttackLevel += 1;
        
        // Refresh Level label

        [_attackLevelLabel setString: [NSString stringWithFormat:@"Attack Level: %d", _currentAttackLevel]];
        CCLOG(@"Attack Level changed to: %d", [self currentAttackLevel]);

        
        // Refresh Level Description Label
        _attackLevelDescription = [[_attackLevel objectAtIndex:_currentAttackLevel] objectForKey:@"levelDescription"];
        [_attackLevelDescriptionLabel setString:_attackLevelDescription];
        
        // Save changes to User Profile
        [_gameMan saveAllChanges];
    } else {
        [self alertFoodInsufficiency];
    }
}

-(void) attackSpeedUpgradeBtnClicked {
    
    // extracts upgrade cost from plist
    int upgradeCost = [[[_attackSpeedLevel objectAtIndex:_currentAttackSpeedLevel] objectForKey:@"upgradeCost"] intValue];
    
    if(_currentAttackSpeedLevel >= TOTAL_ATTACK_SPEED_LEVEL_NUMBER ) { 
        [[SimpleAudioEngine sharedEngine] playEffect:ERROR_EFFECT];
        NSString *strTitle = [NSString stringWithString:@"Upgrade Failed"];
        NSString *strMessage = [NSString stringWithString:@"You have reached the highest level."];
        UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [uiav show];
        [uiav release];
        return;
    }
    
    // Check if money is enough
    if(_currentCoins >= upgradeCost) {
        
        // Check if the level number exceeds
        if(_currentAttackSpeedLevel >= TOTAL_ATTACK_SPEED_LEVEL_NUMBER) {
            CCLOG(@"This level is already the highest");
            return;
        }
        // If money is enough then buy it:
        [[SimpleAudioEngine sharedEngine] playEffect:UPGRADE_BTN_EFFECT];
        _currentCoins -= upgradeCost; // Reduce money
        [_coinsLabel setString: [NSString stringWithFormat:@"Food: %d", _currentCoins]]; // Refresh Coins Label
        [_currentPlayer setCoins:[NSNumber numberWithInt:_currentCoins]];  // Save money change to User Profile
        
        // Add up one level in user profile
        [_currentPlayer setAttackSpeedLevel:[NSNumber numberWithInt:[self currentAttackSpeedLevel] + 1]]; 
        _currentAttackSpeedLevel += 1;
        
        // Refresh Level label

        [_attackSpeedLevelLabel setString: [NSString stringWithFormat:@"Attack Speed Level: %d", _currentAttackSpeedLevel]];
  

        
        // Refresh Level Description Label
        _attackSpeedLevelDescription = [[_attackSpeedLevel objectAtIndex:_currentAttackSpeedLevel] objectForKey:@"levelDescription"];
        [_attackSpeedLevelDescriptionLabel setString:_attackSpeedLevelDescription];
        
        // Save changes to User Profile
        [_gameMan saveAllChanges];
    } else {
        [self alertFoodInsufficiency];
    }
}

-(void) speedUpgradeBtnClicked {
    
    // extracts upgrade cost from plist
    int upgradeCost = [[[_speedLevel objectAtIndex:_currentSpeedLevel] objectForKey:@"upgradeCost"] intValue];
    
    if(_currentSpeedLevel >= TOTAL_SPEED_LEVEL_NUMBER ) { 
        [[SimpleAudioEngine sharedEngine] playEffect:ERROR_EFFECT];
        NSString *strTitle = [NSString stringWithString:@"Upgrade Failed"];
        NSString *strMessage = [NSString stringWithString:@"You have reached the highest level."];
        UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [uiav show];
        [uiav release];
        return;
    }
    
    
    // Check if money is enough
    if(_currentCoins >= upgradeCost) {
        
        // Check if the level number exceeds
        if(_currentSpeedLevel >= TOTAL_SPEED_LEVEL_NUMBER) {
            CCLOG(@"This level is already the highest");
            return;
        }
        // If money is enough then buy it:
        [[SimpleAudioEngine sharedEngine] playEffect:UPGRADE_BTN_EFFECT];
        _currentCoins -= upgradeCost; // Reduce money
        [_coinsLabel setString: [NSString stringWithFormat:@"Food: %d", _currentCoins]]; // Refresh Coins Label
        [_currentPlayer setCoins:[NSNumber numberWithInt:_currentCoins]];  // Save money change to User Profile
        
        // Add up one level in user profile
        [_currentPlayer setMovementSpeedLevel:[NSNumber numberWithInt:[self currentSpeedLevel] + 1]]; 
        _currentSpeedLevel += 1;
        
        // Refresh Level label

        [_speedLevelLabel setString: [NSString stringWithFormat:@"Speed Level: %d", _currentSpeedLevel]];
        CCLOG(@"Speed Level changed to: %d", [self currentSpeedLevel]);

        
        // Refresh Level Description Label
        _speedLevelDescription = [[_speedLevel objectAtIndex:_currentSpeedLevel] objectForKey:@"levelDescription"];
        [_speedLevelDescriptionLabel setString:_speedLevelDescription];
        
        // Save changes to User Profile
        [_gameMan saveAllChanges];
    } else {
        [self alertFoodInsufficiency];
    }
}

-(void) spawnRateUpgradeBtnClicked {
    
    // extracts upgrade cost from plist
    int upgradeCost = [[[_spawnRateLevel objectAtIndex:_currentSpawnRateLevel] objectForKey:@"upgradeCost"] intValue];
    
    
    if(_currentSpawnRateLevel >= TOTAL_SPAWN_RATE_LEVEL_NUMBER ) { 
        [[SimpleAudioEngine sharedEngine] playEffect:ERROR_EFFECT];
        NSString *strTitle = [NSString stringWithString:@"Upgrade Failed"];
        NSString *strMessage = [NSString stringWithString:@"You have reached the highest level."];
        UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [uiav show];
        [uiav release];
        return;
    }
    
    // Check if money is enough
    if(_currentCoins >= upgradeCost) {
        
        // Check if the level number exceeds
        if(_currentSpawnRateLevel >= TOTAL_SPAWN_RATE_LEVEL_NUMBER) {
            CCLOG(@"This level is already the highest");
            return;
        }
        // If money is enough then buy it:
        [[SimpleAudioEngine sharedEngine] playEffect:UPGRADE_BTN_EFFECT];
        _currentCoins -= upgradeCost; // Reduce money
        [_coinsLabel setString: [NSString stringWithFormat:@"Food: %d", _currentCoins]]; // Refresh Coins Label
        [_currentPlayer setCoins:[NSNumber numberWithInt:_currentCoins]];  // Save money change to User Profile
        
        // Add up one level in user profile
        [_currentPlayer setSpawnRateLevel:[NSNumber numberWithInt:[self currentSpawnRateLevel] + 1]]; 
        _currentSpawnRateLevel += 1;
        
        // Refresh Level label
        [_spawnRateLevelLabel setString: [NSString stringWithFormat:@"Spawn Rate Level: %d", _currentSpawnRateLevel]];

        
        // Refresh Level Description Label
        _spawnRateLevelDescription = [[_spawnRateLevel objectAtIndex:_currentSpawnRateLevel] objectForKey:@"levelDescription"];
        [_spawnRateLevelDescriptionLabel setString:_spawnRateLevelDescription];
        
        // Save changes to User Profile
        [_gameMan saveAllChanges];
    } else {
        [self alertFoodInsufficiency];
    }
}

-(void) addCoinsBtnClicked {
    _currentCoins += 1000;
    [_coinsLabel setString: [NSString stringWithFormat:@"Food: %d", _currentCoins]];
    [_currentPlayer setCoins:[NSNumber numberWithInt:_currentCoins]];  // Save money change to User Profile
    [_gameMan saveAllChanges];
}


-(void) backBtnClicked{
    //Transition to WorldMap Scene : For testing back and forth
    @try {
        [[SimpleAudioEngine sharedEngine] playEffect:BACK_BTN_EFFECT];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[WorldMapScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}

-(void) alertFoodInsufficiency {
 
    [[SimpleAudioEngine sharedEngine] playEffect:ERROR_EFFECT];
    NSString *strTitle = [NSString stringWithString:@"No Enough Food"];
    NSString *strMessage = [NSString stringWithString:@"You need more food to upgrade to the next level. You can either buy food in the store or earn food by playing more levels."];
    UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Buy Food",nil];
    CCLOG(@"%@", uiav.title);
    [uiav show];
    [uiav release];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Buy Food"])
    {
        @try {
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[[StoreScene alloc]initWithIsFromUpgradeScene:YES]]];
        } @catch (NSException *ns){
            NSLog(@"%@",ns 	);
        }
    }
    else if([title isEqualToString:@"Ok"]){
        return;
    }
    
}


@end


@implementation UpgradeScene
@synthesize UpgradeLayer = _UpgradeLayer;

-(id) init {
    if((self = [super init])) {
        self.UpgradeLayer = [UpgradeLayer node];
        [self addChild:_UpgradeLayer];
    }
    return self;
}

+(CCScene *) scene {
    
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    UpgradeLayer *layer = [UpgradeLayer node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
    
}

@end
