//
//  OptionScene.h
//  PAWS
//
//  Created by Zinan Xing on 9/21/54 BE.
//  Copyright Pulse Studio. All rights reserved.
//

#import "cocos2d.h"
#import "MainMenuScene.h"
#import "GameManager.h"
#import "AppDelegate.h"
#import "MenuItemSlider.h"
#import "SimpleAudioEngine.h"
#import "CCMenuCategory.h"
#import "SimpleAudioEngine.h"
#import "SoundEffects.h"

#define BGTAG 0
#define MENUTAG 1

//Layer class
@interface OptionGUILayer :CCLayer <UIAlertViewDelegate> {
    AppDelegate *appDelegate;
    GameManager *gameMan;
    UserProfile *currentPlayer;
    
    MenuItemSlider *musicSlider;
	MenuItemSlider *soundSlider;
	int prevMusicLevel;
	int prevSoundLevel;
}
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) GameManager *gameMan;
@property (nonatomic, retain) UserProfile *currentPlayer;

@property (nonatomic, retain) MenuItemSlider *musicSlider;
@property (nonatomic, retain) MenuItemSlider *soundSlider;
@property int prevMusicLevel;
@property int prevSoundLevel;

- (void) onMusicSlide:(id)sender;
- (void) onSoundSlide:(id)sender;
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


//Scene Class
@interface OptionScene : CCScene{
    OptionGUILayer *_layer;
}
@property (nonatomic,retain) OptionGUILayer *layer;
@end


