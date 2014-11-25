//
//  StoreScene.m
//  PAWS
//
//  Created by Zinan Xing on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "StoreScene.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"

static NSString* kFacebookAppId = @"148890798498324";

//Scene Implementation
@implementation StoreScene
@synthesize layer = _layer;


- (id)initWithIsFromUpgradeScene: (BOOL) isFromUpgradeScene {
    
    self = [super init];
    if (self) {
        // Initialization code here.
        self.layer = [[StoreGUILayer alloc]initWithIsFromUpgradeScene: isFromUpgradeScene];
        [self addChild:_layer];
        [[SimpleAudioEngine sharedEngine] preloadEffect:BACK_BTN_EFFECT];
    }
    
    return self;
}

-(void) dealloc{
    //Dealloc the GUI Layer
    [_layer release];
    _layer = nil;
    
    [super dealloc];
}

@end

//GUI-Layer Implementation
@implementation StoreGUILayer
@synthesize isFromUpgradeScene;
@synthesize facebook, permissions, loggedIntoFacebook;
- (id) initWithIsFromUpgradeScene: (BOOL) _isFromUpgradeScene
{
    if( self = [super init] ){
        
        CGSize size = [[CCDirector sharedDirector] winSize];  
        
        isFromUpgradeScene = _isFromUpgradeScene;
        
        //Create Background
        
        CCSprite *_bg = [CCSprite spriteWithFile:@"ShopBg.png"];
        _bg.position = ccp(size.width/2,size.height/2);
        
        [self addChild:_bg z:0 tag:BGTAG];
        
        //Coins Button
        CCMenuItemImage *coins100Btn = [CCMenuItemImage itemFromNormalImage:@"PetFoodStack.png" 
                                                             selectedImage:@"PetFoodStack.png"  
                                                                    target:self selector:@selector(coins100BtnClicked)];
        coins100Btn.position = ccp(260.0f,160.0f);
        
        CCMenuItemImage *backBtn = [CCMenuItemImage itemFromNormalImage:@"StoreBackBtn_N.png" 
                                                           selectedImage:@"StoreBackBtn_A.png"  
                                                                  target:self selector:@selector(backBtnClicked)];
        
        backBtn.position = ccp(backBtn.contentSize.width/2,backBtn.contentSize.height/2 );
        
        
        CCMenu *mainMenu = [CCMenu menuWithItems:backBtn, coins100Btn, nil];
        mainMenu.position = CGPointZero;
        [self addChild:mainMenu z:1 tag:MENUTAG];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        GameManager *gameMan = [appDelegate gameManager];
        [gameMan requestProductInformationWithProductID:@"1000"];
        
        //Setup Facebook  //<--SHAREUX
        [self setPermissions:[NSArray arrayWithObjects:@"publish_stream", @"read_stream", nil]];
        [self setFacebook:[[Facebook alloc] initWithAppId:kFacebookAppId]];
        
        [gameMan setFacebook:facebook];



    }
    return self;
}

//OnClicked function
-(void) backBtnClicked{
    //Transition to MainMenu Scene
    if(!isFromUpgradeScene){
        @try {
            [[SimpleAudioEngine sharedEngine] playEffect:BACK_BTN_EFFECT];
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[MainMenuScene node]]];
        } @catch (NSException *ns){
            NSLog(@"%@",ns 	);
        }
    } else {
        @try {
            [[SimpleAudioEngine sharedEngine] playEffect:BACK_BTN_EFFECT];
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[UpgradeScene node]]];
        } @catch (NSException *ns){
            NSLog(@"%@",ns 	);
        }
    }
}

//OnClicked function
-(void) coins100BtnClicked
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	GameManager *gameMan = [appDelegate gameManager];
    
    //Alert success
    NSString *strTitle = [NSString stringWithString:@"Get This For Free"];
    NSString *strMessage = [NSString stringWithFormat:@"Tell %d of your Facebook friends about Furballs and get this product for free!\n\nTap \"Yes\" and wait for the Facebook login screen to appear.", 3];
    UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"No, I'll buy" otherButtonTitles:nil];
    [uiav addButtonWithTitle:@"Yes"];
    
    [uiav show];
    [uiav release];
    

	/*NSString *strTitle = [NSString stringWithString:@"One Moment Please"];
	NSString *strMessage = [NSString stringWithString:@"Please wait a moment while your purchase is being processed"];
	UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[uiav show];
	[uiav release];
	
	[gameMan purchaseProduct:@"1000"];*/
}

#pragma mark -
#pragma mark Facebook Methods

- (void)loginToFacebook //<--SHAREUX
{
	[facebook authorize:permissions delegate:self];
}

- (void)logoutOfFacebook
{
	[facebook logout:self];
}

/**
 * Open an inline dialog that allows the logged in user to publish a story to his or
 * her wall.
 */
- (void)publishStream 
{
	
	/*SBJSON *jsonWriter = [[SBJSON new] autorelease];
	 
	 NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
	 @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
	 
	 NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	 NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
	 @"a long run", @"name",
	 @"The Facebook Running app", @"caption",
	 @"it is fun", @"description",
	 @"http://itsti.me/", @"href", nil];
	 NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	 NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
	 @"Share on Facebook",  @"user_message_prompt",
	 actionLinksStr, @"action_links",
	 attachmentStr, @"attachment",
	 nil];*/
	
	/*NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"Post a challenge on your wall",  @"user_message_prompt",
     @"Does anyone care to challenge me?", @"message",
     @"http://joecrotchett.com/images/icon.png", @"picture",
     @"http://joecrotchett.com", @"link",
     @"Grab the game here for free", @"name",
     @"This game actually makes you more wise!", @"description",
     // @"1057556440", @"target_id",
     nil];*/
	
	
	//[facebook dialog:@"feed"
	//		andParams:params
	//	  andDelegate:self];
	
	//[facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/feed/",@"1057556440"] andParams:params andHttpMethod:@"POST" andDelegate:self];
	
	/*	[facebook requestWithGraphPath:@"me/friends/feed"
     andParams:params  
     andHttpMethod:@"POST" 
     andDelegate:self];*/
}


#pragma mark -
#pragma mark Facebook Delegates 
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	
	[self setLoggedIntoFacebook:YES];
	[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	
}


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
	
	if ([result isKindOfClass:[NSDictionary class]]) 
	{
		NSLog(@"count : %d ", [result count]);
		NSArray* resultArray = [result allObjects];
		
		NSLog(@"count : %d ", [result count]);
		result = [resultArray objectAtIndex:0];
		
		for(NSDictionary *dict in result)
		{
			NSLog(@"%@: %@ ", [dict objectForKey:@"name"], [dict objectForKey:@"id"]);
		}		
	}
	    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.2f scene:[FacebookFriends nodeWithFriendsList:result]]];
	
/*	FacebookFriendsViewController *fbfvc = [[FacebookFriendsViewController alloc] initWithNibName:@"FacebookFriendsView_iPhone" bundle:nil withFriendsList:result  withSubLabelText:@"Tap To Share Quotiac" withMessageText:msgText withPromptText:promptText];
	[self.navigationController pushViewController:fbfvc animated:YES];
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Return To Puzzle Pack" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = newBackButton;
	
	[newBackButton release];
	[fbfvc release]; */
    
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


#pragma mark -
#pragma mark Alert View Delegate
- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if([[alertView title] isEqualToString:@"Get This For Free"])
	{
		if(buttonIndex == 1)
		{
            [self performSelector:@selector(loginToFacebook) withObject:nil afterDelay:2];
        }
        
        else
        {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            GameManager *gameMan = [appDelegate gameManager];
            
            //FIRST, CHECK IF PUCHASES ARE ENABLED!!
            if(![gameMan canPurchaseProducts])
            {
                [[SimpleAudioEngine sharedEngine] playEffect:ERROR_EFFECT];
                NSString *strTitle = [NSString stringWithString:@"Purchases Are Disabled"];
                NSString *strMessage = [NSString stringWithString:@"We're unable to complete the purchase since you currently have In-App Purchases disabled.  You can enable In-App Purchases in the Settings application of your device, under the Restrictions menu."];
                UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [uiav show];
                [uiav release];
                return;
            }
            
            NSString *strTitle = [NSString stringWithString:@"One Moment Please"];
            NSString *strMessage = [NSString stringWithString:@"Please wait a moment while your purchase is being processed"];
            UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [uiav show];
            [uiav release];
            
            [gameMan purchaseProduct:@"1000"];
        }
    }
	
}
@end
