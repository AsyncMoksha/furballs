//
//  OptionScene.m
//  PAWS
//
//  Created by Zinan Xing on 9/21/54 BE.
//  Copyright Pulse Studio. All rights reserved.
//

#import "OptionScene.h"

//Scene Implementation
@implementation OptionScene
@synthesize layer = _layer;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.layer = [OptionGUILayer node];
        [self addChild:_layer];
    }
    
    return self;
}
-(void) dealloc{
    //Dealloc our GUI layer
    [_layer release];
    _layer = nil;
    
    [super dealloc];
}
@end




//GUI-Layer Implementation
@implementation OptionGUILayer

@synthesize appDelegate;
@synthesize gameMan;
@synthesize currentPlayer;

@synthesize soundSlider;
@synthesize musicSlider;
@synthesize prevMusicLevel, prevSoundLevel;

-(void) initWithButtonsAndScrollBars {
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    //Obtain a pointer to the Game Manager object, so you can access the UserProfile object called "player"
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    gameMan = [appDelegate gameManager];
    currentPlayer = [gameMan player];
    [[SimpleAudioEngine sharedEngine] preloadEffect:BACK_BTN_EFFECT];
    
    // Menu Sliders:
    SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
    
    // Music slider
    self.musicSlider = [MenuItemSlider itemFromTrackImage: @"slider_bar.png" knobImage: @"slider_knob.png" target:self selector: @selector(onMusicSlide:)];
    self.musicSlider.minValue = 0;
    self.musicSlider.maxValue = 100;
    self.musicSlider.value = floor(sae.backgroundMusicVolume * 100);
    self.musicSlider.position = ccp(screenSize.width/2 + 73, screenSize.height/2 + 60);
    
    // SoundFx slider
    self.soundSlider = [MenuItemSlider itemFromTrackImage: @"slider_bar.png" knobImage: @"slider_knob.png" target:self selector: @selector(onSoundSlide:)];
    self.soundSlider.minValue = 0;
    self.soundSlider.maxValue = 100;
    self.soundSlider.value = floor(sae.effectsVolume * 100);
    self.soundSlider.position = ccp(screenSize.width/2 + 73, screenSize.height/2 - 10);
    
    
    //Menu Buttons:
    //Delete Save Button
    CCMenuItemImage *deleteSaveBtn = [CCMenuItemImage itemFromNormalImage:@"DeleteSaveSprite.png" 
                                                            selectedImage:@"DeleteSaveSprite.png"  
                                                                   target:self selector:@selector(deleteSaveBtnClicked)];
    deleteSaveBtn.position = ccp(180,80);
    
    //Back Button
    CCMenuItemImage *backBtn = [CCMenuItemImage itemFromNormalImage:@"Back_button.png" 
                                                      selectedImage:@"Back_button_pink.png"  
                                                             target:self selector:@selector(backBtnClicked)];
    backBtn.position = ccp(backBtn.contentSize.width/2 + 260,
                           backBtn.contentSize.height/2 + 3);
    
    
    //Main Menu
    CCMenu *mainMenu = [CCMenu menuWithItems:deleteSaveBtn, 
                                             musicSlider,
                                             soundSlider,
                                             backBtn,
                                             nil];
    mainMenu.position = CGPointZero;
    [self addChild:mainMenu 
                 z:1 
               tag:MENUTAG];
    
    
    return;
    
}

- (void)onMusicSlide:(id)sender
{
    MenuItemSlider* slider = (MenuItemSlider*)sender;
	[SimpleAudioEngine sharedEngine].backgroundMusicVolume = (slider.value / 100.0);
}

- (void)onSoundSlide:(id)sender
{
    MenuItemSlider* slider = (MenuItemSlider*)sender;
	[SimpleAudioEngine sharedEngine].effectsVolume = (slider.value / 100.0);
}

- (id) init
{
    if( self = [super init] ){
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];  
        
        //Create Background
        CCSprite *_bg = [CCSprite spriteWithFile:@"OptionBG.png"];
        _bg.position = ccp(screenSize.width/2,screenSize.height/2);
        
        [self addChild:_bg z:0 tag:BGTAG];
        self.isTouchEnabled = YES;
        
        [self initWithButtonsAndScrollBars];
        

    }
    return self;
}

-(void) deleteSaveBtnClicked {
    
    CCLOG(@"Delte Save Btn clicked");
    NSString *strTitle = [NSString stringWithString:@"Are you sure?"];
    NSString *strMessage = [NSString stringWithString:@"This operation cannot be un-done."];
    UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:self cancelButtonTitle:@"Not Actually" otherButtonTitles:@"Pretty Sure",nil];
    CCLOG(@"%@", uiav.title);
    [uiav show];
    [uiav release];
    
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Pretty Sure"])
    {
        CCLOG(@"Deleted save");
        UserProfile *newCatsProfile = [gameMan createNewUserProfileWithPlayerName:@"cats" andCampaignType:CTCats];
        [gameMan setCats:newCatsProfile];
        
        UserProfile *newDogsProfile = [gameMan createNewUserProfileWithPlayerName:@"dogs" andCampaignType:CTDogs];
        [gameMan setDogs:newDogsProfile];   
    }
    else if([title isEqualToString:@"Not Actually"]){
        return;
    }
    
}

@end