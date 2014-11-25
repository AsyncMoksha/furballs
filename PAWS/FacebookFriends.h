//
//  FacebookFriends.h
//  PAWS
//
//  Created by Zinan Xing on 11/17/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "WorldMapScene.h"
#import "SoundEffects.h"
#import "GameManager.h"
#import "AppDelegate.h"
#import "Unit.h"
#import "GhostCat.h"
#import "JumpingCat.h"
#import "ItemClass.h"
#import "FBConnect.h"
#import "FBLabel.h"

#define LABEL_DISTANCE 3;

@interface FacebookFriends : CCLayerColor <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
    AppDelegate *appDelegate;
    GameManager *gameMan;
    UserProfile *currentPlayer;
    CGSize winSize;
    CCNode *unitList;
    CCNode *currentDisplayList;
    CCSprite *topBar;
    float lastLabelPositionY;
    float firstLabelPositionY;
    float labelContentSizeY;
    
    NSArray *friendsList;
	NSInteger indexOfFriendToInvite;
	NSString *subLabelText;
	NSString *messageText;
	NSString *promptText;
}
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) GameManager *gameMan;
@property (nonatomic, retain) UserProfile *currentPlayer;
@property (nonatomic, assign) CGSize winSize;
@property (nonatomic, retain) CCNode *unitList;
@property (nonatomic, retain) CCNode *currentDisplayList;
@property (nonatomic, retain) CCSprite *topBar;
@property (nonatomic, assign) float lastLabelPositionY;
@property (nonatomic, assign) float firstLabelPositionY;
@property (nonatomic, assign) float labelContentSizeY;

@property (nonatomic, retain) NSArray *friendsList;
@property (nonatomic, assign) NSInteger indexOfFriendToInvite;
@property (nonatomic, retain) NSString *subLabelText;
@property (nonatomic, retain) NSString *messageText;
@property (nonatomic, retain) NSString *promptText;


-(void) displayUnits;
- (void)publishStream:(NSString*)friendID;
+(id) node;
+(id) nodeWithFriendsList:(NSArray*)friends;
-(id) initWithFriendsList:(NSArray*)friends;
-(NSString*)loadUnitInfoFromPlistName: (NSString*)nameWithoutType withID:(int) inID;
@end
