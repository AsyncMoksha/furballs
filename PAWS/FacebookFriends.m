//
//  FacebookFriends.m
//  PAWS
//
//  Created by Zinan Xing on 11/17/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "FacebookFriends.h"

@implementation FacebookFriends

@synthesize appDelegate;
@synthesize gameMan;
@synthesize currentPlayer;
@synthesize winSize;
@synthesize unitList;
@synthesize currentDisplayList;
@synthesize topBar;
@synthesize lastLabelPositionY;
@synthesize firstLabelPositionY;
@synthesize labelContentSizeY;

@synthesize friendsList;
@synthesize indexOfFriendToInvite;
@synthesize subLabelText;
@synthesize messageText;
@synthesize promptText;


-(void) dealloc {
    
    [super dealloc];
}

- (id) init
{
    return [self initWithFriendsList:nil];
}

//Inits the scene with the level ID
-(id) initWithFriendsList:(NSArray*)friends 
{
    self = [super initWithColor:ccc4(149, 149, 149, 255)];
    if (self) {
        
        [self setFriendsList:friends];
        
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
        
        CCMenu *fbMenu = [CCMenu menuWithItems: nil];
        
        for (int i=0; i< [friends count]; i++) {
            
            //CCSprite *unitItem = [CCSprite spriteWithFile:[NSString stringWithFormat:@"UnitProfile%d.png", [[card unitType] intValue]]];
            CCLOG(@"Generated card no: %d", i);
            
            //info = [self loadUnitInfoFromPlistName: plistResourceName withID: i];
            
            NSDictionary *facebookFriend = [friends objectAtIndex:i];
            NSString *friendName = [facebookFriend objectForKey:@"name"];
            /*
            FBLabel *unitItem = [[FBLabel alloc] initWithLabelFileName: [NSString stringWithFormat:@"Facebook_Label.png", fractionPrefix,i] andInfo:friendName];
            
            [unitItem setPosition:ccp(winSize.width / 2, winSize.height - 110.0 - accumHeight)];
            CCLOG(@"Position %f,%f " ,winSize.width / 2, winSize.height - 110.0 - accumHeight );
            //	unitItem.anchorPoint = ccp(0.5,1);
            */
            CCMenuItemImage *fbItemImage = [CCMenuItemImage itemFromNormalImage:@"Facebook_Label.png" selectedImage:@"Facebook_Label.png" target:self selector:@selector(fbItemSelected:)];
            fbItemImage.tag = i;
            
            CCLabelTTF *_info = [CCLabelTTF labelWithString:friendName fontName:@"Arial" fontSize:16.0];
            if(_info){
                //_info.anchorPoint = ccp(0,0.5);
                _info.position = ccp(180,60);
                [fbItemImage addChild:_info z:2];
            }
            
            [fbMenu addChild:fbItemImage];
            
            [fbItemImage setPosition:ccp(winSize.width / 2, winSize.height - 110.0 - accumHeight)];
            /*
            labelContentSizeY = unitItem.contentSize.height;
            
            [unitList addChild:unitItem];
            
            accumHeight += unitItem.contentSize.height + 8.0; 
            lastLabelPositionY = winSize.height - 110 - accumHeight;
            labelContentSizeY = unitItem.contentSize.height;
             */
            
            labelContentSizeY = fbItemImage.contentSize.height;
            
            
            accumHeight += fbItemImage.contentSize.height + 8.0; 
            lastLabelPositionY = winSize.height - 110 - accumHeight;
            labelContentSizeY = fbItemImage.contentSize.height;
            
        }
        
        
        firstLabelPositionY = winSize.height - 55.0 + labelContentSizeY / 2;
        lastLabelPositionY -= labelContentSizeY / 2;
        CGSize paneSize = {winSize.width, winSize.height - (topBar.contentSize.height / 2)};
       // [unitList setContentSize:paneSize];
       // unitList.position = CGPointZero;
        [fbMenu setContentSize:paneSize];
        fbMenu.position = CGPointZero;
        
        //[self addChild: unitList z:2];
        [self addChild:fbMenu z:2];
        //currentDisplayList = unitList;
        currentDisplayList = fbMenu;
        
        
        //Buttons:
        
        //BackButton
        CCMenuItemImage *backBtn = [CCMenuItemImage itemFromNormalImage:@"backArrow.png" 
                                                          selectedImage:@"backArrow.png"  
                                                                 target:self selector:@selector(backBtnClicked)];
        
        backBtn.position = ccp(backBtn.contentSize.width/2 + 4.0f, winSize.height - backBtn.contentSize.height/2 - 3.0f );
        
        CCMenu *guiMenu = [CCMenu menuWithItems:backBtn, nil];
        guiMenu.position = CGPointZero;
        [self addChild:guiMenu z:102];
        
        //Top Bar
        topBar = [CCSprite spriteWithFile:@"Wiki_topbar.png"];
        [topBar setPosition:ccp(winSize.width / 2, winSize.height - (topBar.contentSize.height / 2))];
        //[topBar setScale: 2.4];
        [self addChild: topBar z:99];
    }
    
    return self;
}

-(void) fbItemSelected: (id) sender {
    //CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    //CCLOG(@"Friend Selected:%d ", toggleItem.selectedItem.tag); 
    //CCLOG(@"%d", toggleItem.selectedIndex);
    CCMenuItemImage *toggledItem = (CCMenuItemImage *)sender;
    CCLOG(@"Friend Clicked: %d", toggledItem.tag);
    
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
        
        FBLabel *unitItem = [[FBLabel alloc] initWithLabelFileName: [NSString stringWithFormat:@"Unit%@Profile%d.png", fractionPrefix,i] andInfo:info];
        
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


+(id) node {
    return [self nodeWithFriendsList:nil];
}

+(id) nodeWithFriendsList:(NSArray*)friends
{
    return [[[self alloc] initWithFriendsList:friends] autorelease];
}


- (void)publishStream:(NSString*)friendID
{	
	NSMutableDictionary* params;
	if(messageText != nil)
		params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  @"Post this on your friend's wall?",  @"user_message_prompt",
                  [self messageText] , @"message",
                  @"http://furballsgame.com/images/icon.png", @"picture",
                  @"http://itunes.com/apps/furballs", @"link",
                  @"Grab the game here for free", @"name",
                  @"This game is so fun!", @"description",
                  nil];
	else
		params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Post this on your friend's wall?",  @"user_message_prompt",
				  [self messageText], @"message",
				  @"http://furballsgame.com/images/icon.png", @"picture",
                  @"http://itunes.com/apps/furballs", @"link",
                  @"Grab the game here for free", @"name",
                  @"This game is so fun!", @"description",
                  nil];

	
	Facebook *facebookMan = [gameMan facebook];
	
	[facebookMan requestWithGraphPath:[NSString stringWithFormat:@"%@/feed/",friendID] andParams:params andHttpMethod:@"POST" andDelegate:self];
}

#pragma mark -
#pragma mark Facebook Delegates 

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
};

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on the format of the API response.
 * If you need access to the raw response, use
 * (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	if([result isKindOfClass:[NSDictionary class]])
		NSLog(@"%d", [result count]);
};

/**
 * Called when an error prevents the Facebook API request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	//[self.label setText:[error localizedDescription]];
	NSLog(@"Facebook Error: %@", [error localizedDescription]);
};


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
	//[self.label setText:@"publish successfully"];
}




@end
