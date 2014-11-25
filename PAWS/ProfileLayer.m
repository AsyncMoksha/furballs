//
//  ProfileLayer.m
//  PAWS
//
//  Created by Zinan Xing on 11/17/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "ProfileLayer.h"
#import "WikiLabel.h"
@implementation ProfileLayer
@synthesize appDelegate;
@synthesize gameMan;
@synthesize currentPlayer;
@synthesize winSize;
@synthesize unitList;
@synthesize itemList;
@synthesize achievementList;
@synthesize currentDisplayList;
@synthesize topBar;
@synthesize lastLabelPositionY;
@synthesize firstLabelPositionY;
@synthesize labelContentSizeY;


-(void) dealloc {
    
    [super dealloc];
}

- (id)init
{
    self = [super initWithColor:ccc4(149, 149, 149, 255)];
    if (self) {
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"Wiki_bg.png"];
        bg.anchorPoint = ccp(0,0);
        [self addChild:bg z:0];
        
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        gameMan = [appDelegate gameManager];
        currentPlayer = [gameMan player];
        
        self.isTouchEnabled = YES;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        
        lastLabelPositionY = 0.0;
        firstLabelPositionY = 0.0;
        //[[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
        
        /*
        // Initialize lists
        unitList = [CCNode node];
        itemList = [CCNode node];
        achievementList = [CCNode node];
         */
        
        //Display unit labels when loading
        unitList = [CCNode node];
        NSString *fractionPrefix  = nil;
        NSString *plistResourceName = nil;
        NSString *info = nil;
        if(gameMan.currentCampaign == CTCats){
            fractionPrefix = @"Cat";
            plistResourceName = @"catUnit";
        }else{
            fractionPrefix = @"Dog";
            plistResourceName = @"dogUnit";
        }
        int cardSize = [[currentPlayer cards] count];
        int accumHeight = 0;
        
        for (int i=0; i< cardSize; i++) {
            
            //CCSprite *unitItem = [CCSprite spriteWithFile:[NSString stringWithFormat:@"UnitProfile%d.png", [[card unitType] intValue]]];
            CCLOG(@"Generated card no: %d", i);
            
            info = [self loadUnitInfoFromPlistName: plistResourceName withID: i];
            
            WikiLabel *unitItem = [[WikiLabel alloc] initWithLabelFileName: [NSString stringWithFormat:@"Unit%@Profile%d.png", fractionPrefix,i] andInfo:info];
                
            [unitItem setPosition:ccp(winSize.width / 2, winSize.height - 110.0 - accumHeight)];
            CCLOG(@"Position %f,%f " ,winSize.width / 2, winSize.height - 110.0 - accumHeight );
            //	unitItem.anchorPoint = ccp(0.5,1);
            
            [unitList addChild:unitItem];
            
            accumHeight += unitItem.contentSize.height + 8.0; 
            lastLabelPositionY = winSize.height - 110 - i;
            labelContentSizeY = unitItem.contentSize.height;
            
        }
            
        
        firstLabelPositionY = winSize.height - 55.0 + labelContentSizeY / 2;
        lastLabelPositionY -= labelContentSizeY / 2;
        CGSize paneSize = {winSize.width, winSize.height - (topBar.contentSize.height / 2)};
        [unitList setContentSize:paneSize];
        unitList.position = CGPointZero;
        
        [self addChild: unitList z:2];
        currentDisplayList = unitList;
        
        
        //Tabs:
        
        //Unit Tab:
        CCMenuItemImage *unitTab = [CCMenuItemImage itemFromNormalImage:@"Wiki_unit.png" 
                                                          selectedImage:@"Wiki_unit.png"  
                                                                 target:self selector:@selector(unitTabClicked:)];

        unitTab.position = ccp(unitTab.contentSize.width / 2 + 60, winSize.height - unitTab.contentSize.height / 2- 3.0f );
        //[unitTab setScale:0.7];
        CCSprite *unitOverlay = [CCSprite spriteWithFile:@"Wiki_tab.png"];
        unitOverlay.position = unitTab.position;
        unitOverlay.visible = true;
        [self addChild: unitOverlay z:100 tag:Wiki_unitOverlay];
        
        
        //Item Tab:
        CCMenuItemImage *itemTab = [CCMenuItemImage itemFromNormalImage:@"Wiki_item.png" 
                                                          selectedImage:@"Wiki_item.png"  
                                                                 target:self selector:@selector(itemTabClicked:)];
        //itemTab.scale = 0.7;
        itemTab.position = ccp(unitTab.position.x + 150, winSize.height - itemTab.contentSize.height / 2- 3.0f );
        CCSprite *itemOverlay = [CCSprite spriteWithFile:@"Wiki_tab.png"];
        itemOverlay.position = itemTab.position;
        itemOverlay.visible = false;
        [self addChild: itemOverlay z:100 tag:Wiki_itemOverlay];
        
        //Achievement Tab:
        CCMenuItemImage *achievementTab = [CCMenuItemImage itemFromNormalImage:@"Wiki_tropies.png" 
                                                          selectedImage:@"Wiki_tropies.png"  
                                                                        target:self selector:@selector(achievementTabClicked:)];
        //achievementTab.scale = 0.7;
        achievementTab.position = ccp(itemTab.position.x + 150, winSize.height - achievementTab.contentSize.height / 2- 3.0f );
        CCSprite *achieOverlay = [CCSprite spriteWithFile:@"Wiki_tab.png"];
        achieOverlay.position = achievementTab.position;
        achieOverlay.visible = false;
        [self addChild: achieOverlay z:100 tag:Wiki_achieOverlay];
        
        
        CCMenu *tabMenu = [CCMenu menuWithItems:unitTab, 
                                                   itemTab, 
                                                   achievementTab, 
                                                   nil];
        tabMenu.position = CGPointZero;
        [self addChild:tabMenu z:100];
        
        
        //Buttons:
        
        //BackButton
        CCMenuItemImage *backBtn = [CCMenuItemImage itemFromNormalImage:@"backArrow.png" 
                                                          selectedImage:@"backArrow.png"  
                                                                 target:self selector:@selector(backBtnClicked)];
        
        backBtn.position = ccp(backBtn.contentSize.width/2 + 4.0f, winSize.height - backBtn.contentSize.height/2 - 3.0f );

        CCMenu *guiMenu = [CCMenu menuWithItems:backBtn, nil];
        guiMenu.position = CGPointZero;
        [self addChild:guiMenu z:102];

        /*
        //Bottom Bar
        CCSprite *btmBar = [CCSprite spriteWithFile:@"ProfileLayerBtmBar.png"];
        [btmBar setPosition:ccp(winSize.width / 2, btmBar.contentSize.height / 2)];
        [btmBar setScale: 1.6];
        [self addChild: btmBar z:99];
         */
        
        //Top Bar
        topBar = [CCSprite spriteWithFile:@"Wiki_topbar.png"];
        [topBar setPosition:ccp(winSize.width / 2, winSize.height - (topBar.contentSize.height / 2))];
        //[topBar setScale: 2.4];
        [self addChild: topBar z:99];
    }
    
    return self;
}

// Drag to browse
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}


-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    //store previous touch location
    CGPoint oldLocation = [touch previousLocationInView:touch.view];
    oldLocation = [[CCDirector sharedDirector] convertToGL:oldLocation];
    
    float differenceInY = (location.y - oldLocation.y) ;
    float newPositionY = currentDisplayList.position.y + differenceInY;
    
    // Set the range player can scroll
    if(((-1) * lastLabelPositionY - 30 > newPositionY) && 
       (((winSize.height - topBar.contentSize.height) + ( newPositionY * (-1))) < firstLabelPositionY) ) {
        
        currentDisplayList.position = ccp(currentDisplayList.position.x, newPositionY);
    }
    
    /*
    CCLOG(@"NewPosY = %f",newPositionY);
    if(newPositionY > 0){
        newPositionY = 0;
    }
    */
    //currentDisplayList.position = ccp(currentDisplayList.position.x,newPositionY);
    
    //CCLOG(@"Current Display List Position: x= %f, y= %f", currentDisplayList.position.x , currentDisplayList.position.y );
    //CCLOG(@"First Label Position: %f", firstLabelPositionY);
    //CCLOG(@"Last Label Position: %f", lastLabelPositionY);
       
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

//OnClicked functions:
-(void) unitTabClicked: (id)sender {
    [self displayUnits];
    [[self getChildByTag:Wiki_unitOverlay] setVisible:true];
    [[self getChildByTag:Wiki_itemOverlay] setVisible:false];
    [[self getChildByTag:Wiki_achieOverlay] setVisible:false];
}

-(void) itemTabClicked: (id)sender {
    [self displayItems];
    [[self getChildByTag:Wiki_unitOverlay] setVisible:false];
    [[self getChildByTag:Wiki_itemOverlay] setVisible:true];
    [[self getChildByTag:Wiki_achieOverlay] setVisible:false];
}

-(void) achievementTabClicked: (id)sender {
    [self displayAchievements];
    [[self getChildByTag:Wiki_unitOverlay] setVisible:false];
    [[self getChildByTag:Wiki_itemOverlay] setVisible:false];
    [[self getChildByTag:Wiki_achieOverlay] setVisible:true];
}


-(void) backBtnClicked{
    //Transition to MainMenu Scene
    @try {
        [[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInT transitionWithDuration:0.2f scene:[WorldMapScene node]]];
    } @catch (NSException *ns){
        NSLog(@"%@",ns 	);
    }
}

// Tab button functions:
-(void) displayUnits {      
    
//    if(currentDisplayList != unitList) {
        
    [self removeChild:currentDisplayList cleanup:YES];
    
    unitList = [CCNode node];
    NSString *fractionPrefix  = nil;
    NSString *plistResourceName = nil;
    NSString *info = nil;
    
    lastLabelPositionY = 0;
    firstLabelPositionY = 0;
    
    if(gameMan.currentCampaign == CTCats){
        fractionPrefix = @"Cat";
        plistResourceName = @"catUnit";
    }else{
        fractionPrefix = @"Dog";
        plistResourceName = @"dogUnit";
    }
    int cardSize = [[currentPlayer cards] count];
    int accumHeight = 0;
    
    for (int i=0; i< cardSize; i++) {
        
        //CCSprite *unitItem = [CCSprite spriteWithFile:[NSString stringWithFormat:@"UnitProfile%d.png", [[card unitType] intValue]]];
        CCLOG(@"Generated card no: %d", i);
        
        info = [self loadUnitInfoFromPlistName: plistResourceName withID: i];
        
        WikiLabel *unitItem = [[WikiLabel alloc] initWithLabelFileName: [NSString stringWithFormat:@"Unit%@Profile%d.png", fractionPrefix,i] andInfo:info];
        
        [unitItem setPosition:ccp(winSize.width / 2, winSize.height - 110.0 - accumHeight)];
        CCLOG(@"Position %f,%f " ,winSize.width / 2, winSize.height - 110.0 - accumHeight );
        //	unitItem.anchorPoint = ccp(0.5,1);
        
        [unitList addChild:unitItem];
        
        accumHeight += unitItem.contentSize.height + 8.0; 
        lastLabelPositionY = winSize.height - 110 - accumHeight;
        labelContentSizeY = unitItem.contentSize.height;
        
    }
    
    
    firstLabelPositionY = winSize.height - 55.0 + labelContentSizeY / 2;
    lastLabelPositionY -= labelContentSizeY / 2;
    CGSize paneSize = {winSize.width, winSize.height - (topBar.contentSize.height / 2)};
    [unitList setContentSize:paneSize];
    unitList.position = CGPointZero;
    
    [self addChild: unitList z:2];
    currentDisplayList = unitList;
        
//    }
}

-(NSString*)loadUnitInfoFromPlistName: (NSString*)nameWithoutType withID:(int) inID{
    NSString *result = nil;
    
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",nameWithoutType];
    NSString *plistPath;
    
    //Get the path to plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle]
                     pathForResource:nameWithoutType ofType:@"plist"];
    }
    //Read in the plist file
    NSDictionary *plistDictionary =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    //If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", nameWithoutType);
        return nil; // No Plist Dictionary or file found
    }
    
    //Get just the mini-dictionary for this sprite based on spriteName
    NSArray *unitArray =[plistDictionary objectForKey:@"Unit"];
    
    if (unitArray == nil) {
        CCLOG(@"Could not unitArray ");
        return nil;
    }
    
    NSDictionary *unitItem  = [unitArray objectAtIndex:inID];
    
    //Get variable
    NSString *unitName = [unitItem objectForKey:@"name"];
    int HP = [[unitItem objectForKey:@"hitPoint"] intValue];
    int ATK = [[unitItem objectForKey:@"attack"] intValue];
    int SPD = [[unitItem objectForKey:@"speed"] intValue];
    int COST = [[unitItem objectForKey:@"cost"] intValue];
    NSString *Desc = [unitItem objectForKey:@"description"];
    
    result = [NSString stringWithFormat:@"%@\n\nHP: %d  ATK: %d  SPD: %d  COST: %d\n%@",unitName,HP,ATK,SPD,COST,Desc];
    
    return result;
}


-(void) displayItems {      

    [self removeChild:currentDisplayList cleanup:YES];
    
    itemList = [CCNode node];
    lastLabelPositionY = 0;
    firstLabelPositionY = 0;
    
    //Display unit labels when loading
    
    NSString *fractionPrefix  = nil;
    if(gameMan.currentCampaign == CTCats)
        fractionPrefix = @"Cat";
    else
        fractionPrefix = @"Dog";
    
    
    int itemSize = [[currentPlayer items] count];
    int accumHeight = 0;
    
    for (int i=0; i< itemSize; i++) {
        
        //CCSprite *unitItem = [CCSprite spriteWithFile:[NSString stringWithFormat:@"UnitProfile%d.png", [[card unitType] intValue]]];
        CCLOG(@"Generated item no: %d", i);
        
        WikiLabel *item = [[WikiLabel alloc] initWithLabelFileName: [NSString stringWithFormat:@"ItemProfile%d.png", fractionPrefix,i] andInfo:@"Meaw~. Item"];
        
        [itemList setPosition:ccp(winSize.width / 2, winSize.height - 110.0 - accumHeight)];
        CCLOG(@"Position %f,%f " ,winSize.width / 2, winSize.height - 110.0 - accumHeight );
        //	unitItem.anchorPoint = ccp(0.5,1);
        
        [itemList addChild:item];
        
        accumHeight += item.contentSize.height + 8.0; 
        lastLabelPositionY = winSize.height - 110 - accumHeight;
        labelContentSizeY = item.contentSize.height;
        
    }
    
    
    firstLabelPositionY = winSize.height - 55.0 + labelContentSizeY / 2;
    lastLabelPositionY -= labelContentSizeY / 2;
    CGSize paneSize = {winSize.width, winSize.height - (topBar.contentSize.height / 2)};
    [itemList setContentSize:paneSize];
    itemList.position = CGPointZero;
    
    [self addChild: itemList z:2];
    currentDisplayList = itemList;
    
}

-(void) displayAchievements {      
    
//    if(currentDisplayList != achievementList) {
        
        [self removeChild:currentDisplayList cleanup:YES];
        
        int i = 0;
        achievementList = [CCNode node];
        lastLabelPositionY = 0;
        firstLabelPositionY = 0;
        
        for (Achievement *achievement in [currentPlayer achievements]) {
            CCLOG(@"%d", [[achievement achievementPercentCompleted] intValue]);
            if([[achievement achievementPercentCompleted] intValue] == 100){
                CCSprite *achievementItem = [CCSprite spriteWithFile:[NSString stringWithFormat:@"AchievementProfile%d.png", [[achievement achievementID] intValue]]];
                [achievementItem setPosition:ccp(winSize.width / 2, winSize.height - 55 - i)];
                achievementItem.anchorPoint = ccp(0.5,1);
                
                [achievementList addChild:achievementItem];
                
                i += achievementItem.contentSize.height + 8;   
                lastLabelPositionY = winSize.height - 55 - i;
                labelContentSizeY = achievementItem.contentSize.height;
            }
        }
        firstLabelPositionY = winSize.height - 55.0 + labelContentSizeY / 2;
        lastLabelPositionY -= labelContentSizeY / 2;
        CGSize paneSize = {winSize.width, winSize.height - (topBar.contentSize.height / 2)};
        [achievementList setContentSize:paneSize];
        achievementList.position = CGPointZero;
        
        [self addChild: achievementList z:2];
        currentDisplayList = achievementList;
//    }
    /*
     
     lastLabelPositionY = 0;
     firstLabelPositionY = 0;
     
     
     lastLabelPositionY += i;
     labelContentSizeY = unitItem.contentSize.height;
     
     }
     firstLabelPositionY = winSize.height - 55.0 + labelContentSizeY / 2;
     lastLabelPositionY -= labelContentSizeY / 2;
     */
}
+(id) node {
    return [[[self alloc] init] autorelease];
}

@end
