//
//  BattleGUILayer.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/5/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "BattleGUILayer.h"
#import "WorldMapScene.h"
#import "BattleScene.h"

#pragma mark -
#pragma mark -
#pragma mark BattleGUILayer class

//GUI-Layer Implementation
@implementation BattleGUILayer

@synthesize isConsoleOpen;
@synthesize isAdded;
@synthesize consoleLayer;

- (id) init
{
    return [self initWithLevelID:-1];
}

//Inits the scene with the level ID
-(id) initWithLevelID:(NSInteger)lid 
{
    if( self = [super init] ){
        
        // Add console code
        isConsoleOpen = NO;
        isAdded = NO;
        consoleLayer = [[ConsoleLayer alloc] init];
        
        //Read the background image filename from the level file
        //Load the list of game objects waiting to be spawed
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        GameManager *gameMan = [appDelegate gameManager];
        NSString *levelFileName = [NSString string];
        if(lid < 0)
            levelFileName = @"levelCat1";
        else {
            //levelFileName = [NSString stringWithFormat:@"level%d", lid]; 
            if ([gameMan currentCampaign] == CTCats) {
                levelFileName = [NSString stringWithFormat:@"levelCat%d", lid];
            } else {
                levelFileName = [NSString stringWithFormat:@"levelDog%d", lid];
            }
        } 
        
        NSString *levelFilePath = [[NSBundle mainBundle] pathForResource:levelFileName ofType:@"plist"];
        NSDictionary *levelContent = [NSMutableDictionary dictionaryWithContentsOfFile:levelFilePath];
        NSString *backgroundFilename = [levelContent objectForKey:@"background"];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *_bg = [CCSprite spriteWithFile:backgroundFilename];
        _bg.position = ccp(size.width/2,size.height/2);
        [self addChild:_bg z:-1 tag:BGTAG];
        
        //MenuItems
        /*
        CCMenuItemImage *backBtn = [
                                    CCMenuItemImage itemFromNormalImage:@"StoreBackBtn_N.png" 
                                    selectedImage:@"StoreBackBtn_A.png"  
                                    
                                    //CCMenuItemImage itemFromNormalImage:@"PauseBtn_N.png" 
                                    //selectedImage:@"PauseBtn_A.png"                                      
                                    target:self selector:@selector(backBtnClicked)
                                    ];
        backBtn.scale=0.5;
        backBtn.position = ccp(
                               size.width - backBtn.contentSize.width/4,
                               backBtn.contentSize.height/4 + 55.0
                               );
        */
        
        
        /*
        CCMenuItemImage *consoleButton = [
                                    CCMenuItemImage itemFromNormalImage:@"console_button.png" 
                                    selectedImage:@"console_button.png"  
                                    
                                    //CCMenuItemImage itemFromNormalImage:@"PauseBtn_N.png" 
                                    //selectedImage:@"PauseBtn_A.png"                                      
                                    target:self 
                                    selector:@selector(consoleClicked)
                                    ];
        consoleButton.position = ccp(
                               size.width 
                                     - backBtn.contentSize.width/2
                                     - consoleButton.contentSize.width/2,
                               consoleButton.contentSize.height/2 + 55.0
                               );
         */
        
        CCMenuItemImage *pauseBtn = [
                                    CCMenuItemImage itemFromNormalImage:@"PauseBtn75_75_Normal.png" 
                                    selectedImage:@"PauseBtn75_75_active.png"  
                                    
                                    //CCMenuItemImage itemFromNormalImage:@"PauseBtn_N.png" 
                                    //selectedImage:@"PauseBtn_A.png"                                      
                                    target:self selector:@selector(pauseBtnClicked)
                                    ];
        pauseBtn.scale=0.4f;
        pauseBtn.position = ccp(size.width - pauseBtn.contentSize.width/2*0.4 - 5, size.height - pauseBtn.contentSize.height/2*0.4 - 5);
        /*
        // Immidiate win
        CCMenuItemImage *winBtn = [
                                   CCMenuItemImage itemFromNormalImage:@"winBtn.jpg" 
                                                         selectedImage:@"winBtn.jpg"  
                                                                target:self 
                                                              selector:@selector(winBtnClicked)
                                     ];
        winBtn.position = ccp(
                                size.width - pauseBtn.contentSize.width/2 -
                                - consoleButton.contentSize.width/2
                                - backBtn.contentSize.width/2 - 130
                                + 20,
                                pauseBtn.contentSize.height/4 + 55.0
                                );
        
        // Immediate Lose Btn:
        CCMenuItemImage *loseBtn = [
                                   CCMenuItemImage itemFromNormalImage:@"loseBtn.jpg" 
                                   selectedImage:@"loseBtn.jpg"  
                                   target:self 
                                   selector:@selector(loseBtnClicked)
                                   ];
        loseBtn.position = ccp(
                              size.width - pauseBtn.contentSize.width/2 -
                              - consoleButton.contentSize.width/2
                              - backBtn.contentSize.width/2 - 130
                              + 20 + 20,
                              pauseBtn.contentSize.height/4 + 55.0
                              );
        loseBtn.scale = 0.11;
        
        */
        
        // Immidiate win
        CCMenuItemImage *winBtn = [
                                   CCMenuItemImage itemFromNormalImage:@"winBtn.jpg" 
                                   selectedImage:@"winBtn.jpg"  
                                   target:self 
                                   selector:@selector(winBtnClicked)
                                   ];
        winBtn.position = ccp(
                              100,
                              pauseBtn.contentSize.height/4 + 55.0
                              );
        
        CCMenu *mainMenu = [CCMenu menuWithItems:
                            pauseBtn,
                            //winBtn,
                            nil];
        
        mainMenu.position = CGPointZero;
        mainMenu.anchorPoint = ccp(0,0);
        [self addChild:mainMenu z:1 tag:MENUTAG];
        
        
    }
    
    //[self scheduleUpdate];
    return self;
}

+(id) nodeWithLevelID:(NSInteger)lid
{
    return [[[self alloc] initWithLevelID:lid ] autorelease];
}

//OnClicked function
#pragma mark -
#pragma mark Pause Button Click
-(void) pauseBtnClicked{
    CCLOG(@"I clicked Pause, set Battle Scene isGamePaused");
    BattleScene *parentScene = (BattleScene*)[self parent];
    if(!parentScene.isGamePaused){
        [parentScene doPause];
    }else{
        [parentScene doResume];
    }
}

-(void) winBtnClicked {
    BattleScene *parentScene = (BattleScene*)[self parent];
    [parentScene playerWinTransit];
}
/*
-(void) loseBtnClicked {
    BattleScene *parentScene = (BattleScene*)[self parent];
    [parentScene playerLoseTransit];
}

-(void) backBtnClicked{
    //Transition to WorldMap Scene : For testing back and forth
    
    @try {
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[WorldMapScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}
*/
-(void) consoleClicked{
    //BattleScene *parentScene = (BattleScene *) [self parent];
    if (isConsoleOpen) {
        isConsoleOpen = NO;
        CCLOG(@"Console Closed.");
        [[self parent] removeChild:consoleLayer cleanup:NO];
        //[parentScene closeConsole];
    } else {
        isConsoleOpen = YES;
        CCLOG(@"Console Opened.");
        BattleScene *parentScene = (BattleScene*) [self parent];
        /*
        NSMutableArray *allUnitArray = [[NSMutableArray alloc] init];
        [allUnitArray addObjectsFromArray:
         [parentScene getPlayerUnitArray]];
        [allUnitArray addObjectsFromArray:
         [parentScene getEnemyUnitArray]];
        [consoleLayer openConsoleWithArray: allUnitArray];
         */
        [consoleLayer openConsoleWithArrays:
          [parentScene getPlayerUnitArray] 
                            andWithDogArray:[parentScene getEnemyUnitArray]
         ];
        [[self parent] addChild:consoleLayer];
        //[parentScene openConsole];
    }
}

- (void) initConsoleWithArray:(NSMutableArray *)array {
    [consoleLayer openConsoleWithArray:array];
}

- (void)update:(ccTime)dt {
    if (isConsoleOpen && !isAdded ) {
        //BattleScene *parentScene = (BattleScene*) [self parent];
        //CCLOG(@"COUNT %d", [[parentScene getPlayerUnitArray] count]);
        isAdded = YES;
    } 
}
-(void) dealloc{
    [super dealloc];
}
@end
