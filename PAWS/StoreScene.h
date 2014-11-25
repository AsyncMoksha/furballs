//
//  StoreScene.h
//  PAWS
//
//  Created by Zinan Xing on 9/21/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Unit.h"
#import "SoundEffects.h"
#import "UpgradeScene.h"
#import "FacebookFriends.h"
#import "FBConnect.h"
#define BGTAG 0
#define MENUTAG 1
@interface StoreGUILayer : CCLayer <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, UIAlertViewDelegate> {
    BOOL isFromUpgradeScene;
    
    //Facebook
	Facebook* facebook;
    NSArray* permissions;
	BOOL loggedIntoFacebook;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, assign) BOOL loggedIntoFacebook;

@property (nonatomic, assign) BOOL isFromUpgradeScene;

-(void) coins100BtnClicked;
-(id) initWithIsFromUpgradeScene: (BOOL) isFromUpgradeScene;

- (void)loginToFacebook;
- (void)logoutOfFacebook;
- (void)publishStream;

@end



@interface StoreScene : CCScene{
    StoreGUILayer *_layer;
    

}
-(id) initWithIsFromUpgradeScene: (BOOL) isFromUpgradeScene;
@property (nonatomic,retain) StoreGUILayer *layer;

@end
