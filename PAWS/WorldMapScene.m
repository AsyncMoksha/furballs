//
//  WorldMapScene.m
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "WorldMapScene.h"
#import "MainMenuScene.h"
#import "BattleScene.h"
#import "CCLevelButtonImage.h"
#import "UpgradeScene.h"
#define kScreenScrollSpeed 0.5

//Scene Implementation
@implementation WorldMapScene
@synthesize guiLayer = _guiLayer;
@synthesize levelLayer = _levelLayer;
@synthesize isOpenItemShop;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.guiLayer = [WorldMapGUILayer node];
        self.levelLayer = [WorldMapLevelLayer node];
        self.isOpenItemShop = false;
        
        [self addChild:_levelLayer z:1];
        [self addChild:_guiLayer z:2];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:WORLD_MAP_BGM];
        [[SimpleAudioEngine sharedEngine] preloadEffect:BACK_BTN_EFFECT];
        [[SimpleAudioEngine sharedEngine] preloadEffect:MAIN_MENU_BTN_EFFECT];
        
    }
    
    return self;
}
-(void) dealloc{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    //Release GUI Layer
    [_guiLayer release];
    _guiLayer = nil;
    
    [_levelLayer release];
    _levelLayer = nil;
    
    [super dealloc];
}

@end

//GUI-Layer Implementation
@implementation WorldMapGUILayer
@synthesize mainMenu;
-(id) init
{
    if( self = [super init]){
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:LEVEL_CHOOSING];
        
        CCSprite *bottomMenuBar = [CCSprite spriteWithFile:@"WM_btmBar.png"];
        bottomMenuBar.anchorPoint = ccp(0,0);
        bottomMenuBar.position = ccp(0,0);
        //MenuItems
        
        CCMenuItemImage *backBtn = [CCMenuItemImage itemFromNormalImage:@"WM_back.png" 
                                                          selectedImage:@"WM_back.png"  
                                                                 target:self selector:@selector(backBtnClicked)];
        backBtn.position = ccp(414.0f,16.0f);
        
        //Upgrade window Icon
        CCMenuItemImage *upgradeBtn = [CCMenuItemImage itemFromNormalImage:@"WM_upgrade.png" 
                                                             selectedImage:@"WM_upgrade.png"  
                                                                    target:self selector:@selector(upgradeBtnClicked)];
        upgradeBtn.position = ccp(194.0f,16.0f);
        //[upgradeBtn runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(367.0f,295.0f)]];   //Little Transition in
        
        //Menu window Icon
        CCMenuItemImage *wikiBtn = [CCMenuItemImage itemFromNormalImage:@"WM_wiki.png" 
                                                          selectedImage:@"WM_wiki.png"  
                                                                 target:self selector:@selector(wikiBtnClicked)];
        wikiBtn.position = ccp(294.0f,16.0f);
        //[optionBtn runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(442.0f,295.0f)]];   //Little Transition in
        

        //[coinTabBtn runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(80.0f,296.0f)]];   //Little Transition in
        
        self.mainMenu = [CCMenu menuWithItems:backBtn, upgradeBtn, wikiBtn, nil];
        self.mainMenu.position = CGPointZero;

        [self addChild:mainMenu z:2];
        [self addChild:bottomMenuBar z:1];
        
        //Show petfood of this player
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        GameManager *gameMan = [appDelegate gameManager];
        UserProfile *currentPlayer = [gameMan player]; 
        NSNumber *aNum = currentPlayer.coins;
        NSString *value = [NSString stringWithFormat:@"%d",[aNum intValue]];
        CCLabelBMFont *foodAmount = [CCLabelBMFont labelWithString:value fntFile:@"AppleLiGothic_Black18.fnt"];
        //anchorPoint can be used to align the "label"
        foodAmount.position = ccp(110,16.0f);
        foodAmount.anchorPoint  = ccp(1,0.5);
        
        [self addChild:foodAmount z:2];
        
    }
    return self;
}

//OnClicked function
-(void) backBtnClicked{
    //Transition to MainMenu Scene
    @try {
        [[SimpleAudioEngine sharedEngine] playEffect:BACK_BTN_EFFECT];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}

-(void) upgradeBtnClicked{
    //Toggle Upgrade Scene or window
    // In fact, this button should pause the current scene and open a upgrade scene since we don't want to load a worldmap data again
    // But for the time-being, let just replace the current scene into new one.
    [[SimpleAudioEngine sharedEngine] playEffect:MAIN_MENU_BTN_EFFECT];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[UpgradeScene scene]]];
    
}

-(void)wikiBtnClicked{
    //Toggle Menu Window, we may have several more option here later on.
    //Like update button, it should only pause a world scene and do something else.
    
    //Debug only - toggle Item shop Layer
    /*
    WorldMapScene *parentScene = (WorldMapScene*)[self parent];
    if(!parentScene.isOpenItemShop){
        [parentScene setIsOpenItemShop:true];
        [self.itemShopLayer openItemShop];
    }else{
        [parentScene setIsOpenItemShop:false];
        [self.itemShopLayer closeItemShop];
    }*/
    [[SimpleAudioEngine sharedEngine] playEffect:MAIN_MENU_BTN_EFFECT];
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.2f scene:[ItemShopScene node]]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.2f scene:[ProfileLayer node]]];
    
}

-(void)coinTabBtnClicked{
    //Normally, it should not be clickable, but if they click, we might have some surprise pop-up !?
}
-(void) dealloc{
    mainMenu = nil;
    [super dealloc];
    
}

@end

//Level-Layer Implementation
@implementation WorldMapLevelLayer
@synthesize background;
- (id) init
{
    if( self = [super init] ){
        //Create Background
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        //background = [CCSprite spriteWithFile:@"WorldMap1.png"];
        //background = [CCSprite spriteWithFile:@"WorldMapMarked72Dpi.png"];
        background = [CCSprite spriteWithFile:@"WorldMap_1pointO.png"];
        
        background.anchorPoint = ccp(0,0);
        //_bg.position = ccp(size.width/2,size.height/2);
        [self addChild:background z:0];
        
        //Levels
        //Part 1 =================
        //P1-Cat House
        //CCMenuItemImage *level1 = [CCMenuItemImage itemFromNormalImage:@"NoticeIcon_N.png" 
        //                                                  selectedImage:@"NoticeIcon_A.png"  
        //                                                         target:self selector:@selector(enterLevel_one)];
        //level1.position = ccp(82.0f,150.0f);
        
        //Get the game manager singleton object
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        GameManager *gameMan = [appDelegate gameManager];
        //UserProfile *currentPlayer = [gameMan player]; 
        
        NSArray *levelCompleteArray = [[NSArray alloc] initWithArray:[gameMan getCompletedLevelsForCurrentCampign]];
        
        NSMutableArray *levelButtonArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *levelSelectedButtonArray = [[NSMutableArray alloc] init];
        
        BOOL isCleared = NO;
        BOOL isNotMatched = NO;
        int lastLevelComplete = 0;
        
        for (int i= 1; i <= 15; i++) {
            isCleared = NO;
            for (Level *level in levelCompleteArray) {
                // Check completed for levels
                
                if ([[level levelID] intValue] == i) {
                    isCleared = YES;
                    CCLOG(@"Level %d is cleared", i);
                    isNotMatched = NO;
                    break;
                } else {
                    isNotMatched = YES;
                } 
                lastLevelComplete = i;
                
            }
            CCLOG(@"total level complete=%d", [levelCompleteArray count]);
            if (isCleared ) {
                if ([gameMan currentCampaign]== CTCats) {
                    [levelButtonArray addObject:@"EnterLevelCat_Clear.png"];
                    [levelSelectedButtonArray addObject:@"EnterLevelCat_A.png"];
                } else {
                    [levelButtonArray addObject:@"EnterLevelDog_Clear.png"];
                    [levelSelectedButtonArray addObject:@"EnterLevelDog_A.png"];
                }
                CCLOG(@"i=%d", i);
                CCLOG(@"Add cleared level button to position %d", i);
            } else if ( (i == [levelCompleteArray count]+1) 
                       && i <= 15
                       && !isCleared
                       ) {
                if ([gameMan currentCampaign]== CTCats) {
                    [levelButtonArray addObject:@"EnterLevelCat_N.png"];
                    [levelSelectedButtonArray addObject:@"EnterLevelCat_A.png"];
                } else {
                    [levelButtonArray addObject:@"EnterLevelDog_N.png"];
                    [levelSelectedButtonArray addObject:@"EnterLevelDog_A.png"];
                }
                CCLOG(@"i=%d", i);
                CCLOG(@"Add new level button to position %d", i);
            } else {
                
                [levelButtonArray addObject:@"LevelLocked.png"];
                [levelSelectedButtonArray addObject:@"LevelLocked_A.png"];
                CCLOG(@"i=%d", i);
                CCLOG(@"Add locked level button to position %d", i);
            }
            
            
        }
        CGSize winSize = [CCDirector sharedDirector].winSize;
        if ([gameMan currentCampaign] == CTCats) {
            // Do adjust level selection scene
            if (
                [levelCompleteArray count] >= 3 
                && [levelCompleteArray count] < 6 
                ) {
                self.position = ccp(-winSize.width, self.position.y);
            } else if ([levelCompleteArray count] >= 6) {
                self.position = ccp(-2*winSize.width, self.position.y);
            }
            
        } else {
            if (
                [levelCompleteArray count] >= 3
                && [levelCompleteArray count] < 6 
                ) {
                self.position = ccp(-winSize.width, self.position.y);
            } else if ([levelCompleteArray count] >= 6) {
                self.position = ccp(0.0f, self.position.y);
            } else {
                 self.position = ccp(-2*winSize.width, self.position.y);
            }
        }
        
        //NSString *normalIcon = [NSString stringWithFormat:@"EnterLevelCat_N.png"];
        
        //NSString *activeIcon = [NSString stringWithFormat:@"EnterLevelCat_A.png"];
        
        
        CCLevelButtonImage *level1;
        if ([gameMan currentCampaign] == CTCats) {
            
            level1 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:0] description]
                                      selectedImage:[[levelSelectedButtonArray objectAtIndex:0] description]  
                                             target:self selector:@selector(enterLevel:)];
            [level1 setLevelID:1];
        } else {
            
            level1 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:8] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:8] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level1 setLevelID:9];
        }
        
        [level1 setPosition:ccp(82.0f,150.0f)];

        //P1-Church
        
        CCLevelButtonImage *level2;
        //[level2 setLevelID:2];
        if ([gameMan currentCampaign] == CTCats) {
            
            level2 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:1] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:1] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level2 setLevelID:2];
        } else {
            
            level2 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:7] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:7] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level2 setLevelID:8];
        }
        level2.position = ccp(227.0f,175.0f);
         
        
        //P1-Graveyard
        CCLevelButtonImage *level3;
        
        //[level3 setLevelID:2];
        if ([gameMan currentCampaign] == CTCats) {
            
            level3 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:1] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:1] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level3 setLevelID:2];
        } else {
            
            level3 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:7] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:7] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level3 setLevelID:8];
        }
        level3.position = ccp(138.0f,226.0f);
         
        
        //P1-Airship
        CCLevelButtonImage *level4;
        //[level4 setLevelID:3];
        if ([gameMan currentCampaign] == CTCats) {
            
            level4 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:2] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:2] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level4 setLevelID:3];
        } else {
            
            level4 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:6] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:6] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level4 setLevelID:7];
        }
        level4.position = ccp(380.0f,264.0f);
         
         
        //P1-Restaurant
        CCLevelButtonImage *level5;
        //[level5 setLevelID:3];
        if ([gameMan currentCampaign] == CTCats) {
            
            level5 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:2] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:2] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level5 setLevelID:3];
        } else {
            
            level5 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:6] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:6] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level5 setLevelID:7];
        }
        level5.position = ccp(423.0f,128.0f);
         
        
        //Levels
        //Part 2 =================
        //P2-Jail
        CCLevelButtonImage *level6;
        //[level6 setLevelID:4];
        if ([gameMan currentCampaign] == CTCats) {
            
            level6 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:3] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:3] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level6 setLevelID:4];
        } else {
            
            level6 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:5] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:5] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level6 setLevelID:6];
        }
        level6.position = ccp(608.0f,132.0f);
        //P2-Court
        CCLevelButtonImage *level7;
        //[level7 setLevelID:4];
        if ([gameMan currentCampaign] == CTCats) {
            
            level7 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:3] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:3] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level7 setLevelID:4];
        } else {
            
            level7 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:5] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:5] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level7 setLevelID:6];
        }
        level7.position = ccp(662.0f,76.0f);
        //P2-Inn
        CCLevelButtonImage *level8;
        //[level8 setLevelID:5];
        if ([gameMan currentCampaign] == CTCats) {
            
            level8 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:4] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:4] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level8 setLevelID:5];
        } else {
            
            level8 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:4] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:4] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level8 setLevelID:5];
        }
        level8.position = ccp(770.0f,290.0f);
        //P2-HighTown
        CCLevelButtonImage *level9;
        //[level9 setLevelID:5];
        if ([gameMan currentCampaign] == CTCats) {
            
            level9 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:4] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:4] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level9 setLevelID:5];
        } else {
            
            level9 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:4] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:4] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level9 setLevelID:5];
        }
        level9.position = ccp(880.0f,290.0f);
        //P2-CrossRoad
        CCLevelButtonImage *level10;
        //[level10 setLevelID:6];
        if ([gameMan currentCampaign] == CTCats) {
            
            level10 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:5] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:5] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level10 setLevelID:6];
        } else {
            
            level10 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:3] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:3] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level10 setLevelID:4];
        }
        level10.position = ccp(880.0f,140.0f);
        
        //Levels
        //Part 3 =================
        //P3-Hospital
        CCLevelButtonImage *level11;
        //[level11 setLevelID:7];
        if ([gameMan currentCampaign] == CTCats) {
            
            level11 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:6] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:6] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level11 setLevelID:7];
        } else {
            
            level11 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:2] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:2] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level11 setLevelID:3];
        }
        level11.position = ccp(991.0f,206.0f);
        //P3-Abandon playground
        CCLevelButtonImage *level12;
        //[level12 setLevelID:7];
        if ([gameMan currentCampaign] == CTCats) {
            
            level12 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:6] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:6] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level12 setLevelID:7];
        } else {
            
            level12 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:2] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:2] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level12 setLevelID:3];
        }
        level12.position = ccp(1038.0f,117.0f);
        //P3-Amusement park
        CCLevelButtonImage *level13;
        //[level13 setLevelID:8];
        if ([gameMan currentCampaign] == CTCats) {
            
            level13 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:7] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:7] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level13 setLevelID:8];
        } else {
            
            level13 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:1] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:1] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level13 setLevelID:2];
        }
        level13.position = ccp(1257.0f,170.0f);
        //P3-Wheel of fortune
        CCLevelButtonImage *level14;
        
        //[level14 setLevelID:8];
        if ([gameMan currentCampaign] == CTCats) {
            
            level14 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:8] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:8] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level14 setLevelID:9];
        } else {
            
            level14 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:0] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:0] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level14 setLevelID:1];
        }
        level14.position = ccp(1378.0f,260.0f);
        //P3-Dog Apartment
        CCLevelButtonImage *level15;
        //[level15 setLevelID:9];
        if ([gameMan currentCampaign] == CTCats) {
            
            level15 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:8] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:8] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level15 setLevelID:9];
        } else {
            
            level15 = [CCLevelButtonImage itemFromNormalImage:[[levelButtonArray objectAtIndex:0] description]
                                               selectedImage:[[levelSelectedButtonArray objectAtIndex:0] description]  
                                                      target:self selector:@selector(enterLevel:)];
            [level15 setLevelID:1];
        }
        level15.position = ccp(1191.0f,302.0f);
        
        //Try blinking effect
        //id moveUp = [ CCMoveTo actionWithDuration:0.5f position:ccp(290.0f,155.0f)];
        //id moveDown = [ CCMoveTo actionWithDuration:0.5f position:ccp(290.0f,150.0f)];
        //[level1 runAction:[CCRepeatForever actionWithAction:[CCSequence actions:moveUp,moveDown, nil]]];
        
        
        
        CCMenu *levelMenu = [CCMenu menuWithItems:
                            //level1, level2, level3, level4, level5,
                             level1, level2, level5,
                            //level6, level7, level8, level9, level10,
                             level6, level8, level10,
                            //level11, level12, level13, level14, level15,
                             level11, level13, level14,
                             nil];

        levelMenu.position = CGPointZero;
        
        
        [self addChild:levelMenu z:2];
        
        
        
    }
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    return self;
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    //CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    //retval.x = MIN(retval.x, 0);
    //retval.x = MAX(retval.x, 0);
    //retval.x = MAX(retval.x, -background.contentSize.width+winSize.width); 
    retval.y = self.position.y;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation{    

    //CGPoint oldPos = self.position;
    CGPoint newPos = ccpAdd(self.position, translation);
    
    self.position = [self boundLayerPos:newPos];  
    //self.position = newPos;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float xPos = floorf((self.position.x / winSize.width)) * winSize.width;
    //CCLOG(@"Now position.x is %f", self.position.x );
    if (-self.position.x <= (winSize.width/2.0) - 30) {
        xPos = (floorf(self.position.x / winSize.width) + 1) * winSize.width;
        [self runAction: [CCMoveTo actionWithDuration:kScreenScrollSpeed 
                                             position:[self boundLayerPos:
                                                       ccp(
                                                           0.0,
                                                           self.position.y
                                                           )]]];
    } else if ( 
               -self.position.x > (winSize.width/2.0) - 30
               && -self.position.x <= winSize.width + (winSize.width/2.0) 
               + 30
               ) {
        xPos = (floorf(self.position.x / winSize.width) + 1) * winSize.width;
        [self runAction: [CCMoveTo actionWithDuration:kScreenScrollSpeed 
                                             position:[self boundLayerPos:
                                                       ccp(
                                                           -winSize.width,
                                                           self.position.y
                                                           )]]];
        
    
    } else if ( 
               (
                -self.position.x > winSize.width + (winSize.width/2.0) -30
               && -self.position.x <= 2 * winSize.width + (winSize.width/2.0) 
                + 30
                )
               || -self.position.x >= 3 * winSize.width
               ) {
        // move to nextscreen
        xPos = (floorf(self.position.x / winSize.width) + 1) * winSize.width;
        [self runAction: [CCMoveTo actionWithDuration:kScreenScrollSpeed 
                                             position:[self boundLayerPos:
                                                       ccp(
                                                           -2*winSize.width,
                                                           self.position.y
                                                           )]]];
    } 
    /*
    float scrollDuration = 0.2;
    [self stopAllActions];
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:scrollDuration position:[self boundLayerPos:newPos]];            
    [self runAction:[CCEaseOut actionWithAction:moveTo rate:0.5]]; 
     */
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    //CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    //[self selectSpriteForTouch:touchLocation];      
    return TRUE;    
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    //CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    CGPoint translation =  ccpSub(touchLocation, oldTouchLocation);    
    [self panForTranslation:translation];    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    //For debug, print out touch position
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CCLOG(@"Touch Position is %@",NSStringFromCGPoint(touchLocation));
}


//!!!DEPRECATED METHOD ON 10/07/2011 - Replaced with enterLevel: method
//On-click Funtion  
-(void) enterLevel_one{
    //Transition to Battle Scene and set parameter to level one <-- How ?
    WorldMapScene *parentScene = (WorldMapScene*)[self parent];
    if(!parentScene.isOpenItemShop)
    {
        @try {
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[BattleScene nodeWithLevelID:1]]];
        } @catch (NSException *ns){
            NSLog(@"%@",ns 	);
        }
    }
}

//same as enterLevel_one method, except it loads the level id from the sender object (CCLevelButtonImage)
-(void)enterLevel:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:LEVEL_CHOOSING];
    CCLevelButtonImage *buttonClicked = (CCLevelButtonImage *)sender;
    NSInteger levelToLoad = [buttonClicked levelID];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[BattleScene nodeWithLevelID:levelToLoad]]];
    CCLOG(@"Load level %d", levelToLoad);
}

-(void) dealloc{
    [background release];
    background = nil;
    [super dealloc];
}

@end